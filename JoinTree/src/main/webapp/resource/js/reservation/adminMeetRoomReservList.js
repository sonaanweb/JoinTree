// 경영지원팀 예약 페이지
$(document).ready(function () {
	// 검색
	$('#searchButton').on('click', function () {
	    var revStatus = $("input[name='revStatus']:checked").val();
	    var revStartTime = $("input[name='revStartTime']").val();
	    var revEndTime = $("input[name='revEndTime']").val();
	    var empName = $("input[name='empName']").val();
	
	    searchReservation(revStatus, revStartTime, revEndTime, empName);
	    console.log(empName);
	});
	
	
	// 검색했을 시 버튼 다시 활성화
    $('#reservationbody').on('click', '.cancel-btn', function () {
        var revNo = $(this).data('revno');
    });
    
    function searchReservation(revStatus, revStartTime, revEndTime, empName) {
        $.ajax({
            type: "GET",
            url: "/JoinTree/reservation/search",
            data: {
                "revStatus": revStatus,
                "revStartTime": revStartTime,
                "revEndTime": revEndTime,
                "empName": empName
            },
            contentType: "application/json",
            success: function (response) {
                // 검색 결과를 화면에 업데이트하는 부분
                var tbody = $('#reservationbody');
                
                tbody.empty(); // 기존 내용 지우기
				                
                // 검색 결과 데이터를 순회하며 행을 추가
                for (var i = 0; i < response.length; i++) {
                    var reservation = response[i];
                    var row = '<tr>' +
                        '<td>' + reservation.revNo + '</td>' +
                        '<td>' + reservation.empName + '(' + reservation.empNo + ')</td>' +
                        '<td>' + reservation.roomName + '</td>' +
                        '<td>' + reservation.revStartTime.toString().substring(0, 10) +
						   ' ' + reservation.revStartTime.toString().substring(11, 16) +
						 ' ~ ' + reservation.revEndTime.toString().substring(11, 16) + '</td>' +
                        '<td>' + reservation.revReason + '</td>' +
                        '<td>' + reservation.createdate.substring(0, 10) + '</td>' +
                        '<td>' + getStatusText(reservation.revStatus) + '</td>' +
                        '<td>' + reservation.updateName + '(' + reservation.updateId + ')</td>';
                    
                    // 취소 버튼 또는 상태 텍스트 추가
                    if (reservation.revStatus === 'A0301') {
                        row += '<td><button class="btn btn-success btn-sm cancel-btn" data-revno="' + reservation.revNo + '">취소</button></td>';
                    } else {
                        row += '<td></td>';
                    }
                    
                    row += '</tr>';
                    
                    tbody.append(row);
                }
                
                if (revStatus === null && revStartTime === "" && revEndTime === "" && empName == "") {
                    // 검색 결과 데이터를 활용하여 전체 목록을 업데이트하는 로직
                    for (var i = 0; i < response.length; i++) {
                        var reservation = response[i];
                        var row = '<tr>' +
                            '<td><button class="btn btn-success btn-sm cancel-btn" data-revno="' + reservation.revNo + '">취소</button></td>' +
                            '</tr>';
                        tbody.append(row);
                    }
                }
            },

            error: function (error) {
                console.log(error);
                alert("검색 실패");
            }
        });
    }
    
    // 상태코드 텍스트 변환
    function getStatusText(statusCode) {
    if (statusCode === 'A0301') return '<span class="badge badge-success">예약완료</span>';
    if (statusCode === 'A0302') return '<span class="badge badge-secondary">예약취소</span>';
    if (statusCode === 'A0303') return '<span class="badge badge-dark">사용완료</span>';
    return '';
}

    // 예약 취소 
     $('#reservationbody').on('click', '.cancel-btn', function () {
            var revNo = $(this).data('revno');
            
            Swal.fire({
                title: '예약 취소 확인',
                html: '예약을 취소하시겠습니까? <br>(확인 버튼을 누르면 예약이 취소됩니다)',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#8BC541',
                cancelButtonColor: '#888',
                confirmButtonText: '확인',
                cancelButtonText: '취소'
            }).then((result) => {
                if (result.isConfirmed) {
                    // 확인 버튼 클릭 -> 서버에 요청 보냄
                    $.ajax({
                        type: 'POST',
                        url: '/JoinTree/cancelReserved',
                        data: JSON.stringify({ 'revNo': revNo }),
                        contentType: 'application/json',
                        success: function (response) {
                            if (response === '예약취소 완료') {
                                var empNo = $('#empNo').data('empno'); // empNo 가져오기
                                var empName = $('#empName').data('empname'); // 세션에서 empName 가져오기
                                // 해당 예약 번호에 대한 취소 버튼을 없애기
                                $('#reservationbody tr').each(function () {
                                    var rowRevNo = $(this).find('td:first-child').text();
                                    if (rowRevNo === revNo.toString()) {
                                        $(this).find('td:last-child').empty();
                                        $(this).find('td:nth-child(7)').html(getStatusText('A0302')); // 취소 상태 뱃지
                                        $(this).find('td:nth-child(8)').text(empName + '(' + empNo + ')');
                                    }
                                });
                                // SweetAlert로 예약 취소 결과 표시
                                Swal.fire({
                                    icon: 'success',
                                    title: '예약 취소 정상 처리 되었습니다.',
                                    showConfirmButton: false,
                                    timer: 1500
                                });
                            } else {
                                // SweetAlert로 예약 취소 실패 메시지 표시
                                Swal.fire({
                                    icon: 'error',
                                    title: '예약 취소 실패',
                                    text: '경영지원팀이 아니면 다른 사용자의 예약은 취소할 수 없습니다.',
                                });
                            }
                        },
                        error: function (error) {
                            console.log(error);
                            alert('예약 취소 실패');
                        }
                    });
                }
            });
        });
})
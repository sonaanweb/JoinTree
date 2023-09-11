// 회의실 예약 확인
$(document).ready(function () {
    var empNo = $("#empNo").data("empno");

    // 예약 취소 버튼 클릭 시 모달 표시
    $('.cancel-btn').on('click', function () {
        var revNo = $(this).data('revno');
        Swal.fire({
            title: '예약 취소 확인',
            html: '예약을 취소하시겠습니까?<br>(확인버튼을 누르면 예약이 취소됩니다)',
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#8BC541',
			cancelButtonColor: '#888',
            confirmButtonText: '확인',
            cancelButtonText: '취소'
        }).then((result) => {
            if (result.isConfirmed) {
                cancelReserv(revNo);
            }
        });
    });

    // 예약 취소 메서드
    function cancelReserv(revNo) {
        $.ajax({
            type: "POST",
            url: "/JoinTree/cancelReserved",
            data: JSON.stringify({ "revNo": revNo }),
            contentType: "application/json",
            success: function (response) {
                if (response === '예약취소 완료') {
                    // 해당 예약 번호에 대한 취소 버튼을 없애기
                    $('#reservationbody tr').each(function () {
                        var rowRevNo = $(this).find('td:first-child').text();
                        if (rowRevNo === revNo.toString()) {
                            $(this).find('td:last-child').empty();
                            $(this).find('td:nth-child(6)').html(getStatusText('A0302')); // 취소 상태 뱃지
                        }
                    });
					Swal.fire({
						icon: 'success',
						title: '예약이 취소되었습니다',
						showConfirmButton: false,
						timer: 1000
						})
                } else {
                  Swal.fire(
					'Error',
					'예약 취소 실패',
					'error'
				)
                }
            },
            error: function (error) {
                console.log(error);
                // console 쪽 화면 오류 메세지X
            }
        });
    }
    
    // 예약일자 검색 버튼 클릭 시
    $('#searchButton').on('click', function () {
        var revStartTime = $('#revStartTime').val();
        var revEndTime = $('#revEndTime').val();

        // 검색했을 시 버튼 다시 활성화
        $('#reservationbody').on('click', '.cancel-btn', function () {
            var revNo = $(this).data('revno');
            
            Swal.fire({
	            title: '예약 취소 확인',
	            text: '예약을 취소하시겠습니까?',
	            icon: 'question',
	            showCancelButton: true,
	            confirmButtonColor: '#8BC541',
				cancelButtonColor: '#888',
	            confirmButtonText: '확인',
	            cancelButtonText: '취소'
            }).then((result) => {
                if (result.isConfirmed) {
                    cancelReserv(revNo);
                }
            });
        });

        // 예약 시작일과 종료일을 서버로 전송
        $.ajax({
            type: "GET",
            url: "/JoinTree/reservation/empSearch",
            data: {
                "empNo": empNo,
                "revStartTime": revStartTime,
                "revEndTime": revEndTime
            },
            success: function (response) {
                // 검색 결과를 화면에 업데이트하는 부분
                var tbody = $('#reservationbody');
                tbody.empty(); // 기존 내용 지우기

                // 검색 결과 데이터를 순회하며 행을 추가
                for (var i = 0; i < response.length; i++) {
                    var reservation = response[i];

                    var row = '<tr>' +
                        '<td>' + reservation.revNo + '</td>' +
                        '<td>' + reservation.roomName + '</td>' +
						'<td>' + reservation.revStartTime.toString().substring(0, 10) +
						   ' ' + reservation.revStartTime.toString().substring(11, 16) +
						 ' ~ ' + reservation.revEndTime.toString().substring(11, 16) + '</td>' +
						'<td>' + reservation.revReason + '</td>' +
                        '<td>' + reservation.createdate.substring(0, 10) + '</td>' +
                        '<td>' + getStatusText(reservation.revStatus) + '</td>'
                        +'<td>';
                    
                    if (reservation.revStatus === 'A0301') {
                        row += '<button class="btn btn-success btn-sm cancel-btn" data-revno="' + reservation.revNo + '">예약취소</button>';
                    } 
                    
                    row += '</td>' +
                        '</tr>';

                    tbody.append(row);
                }
            },
            error: function (error) {
                console.log(error);
                
            }
        });
    });

    // 상태코드 텍스트 변환
    function getStatusText(statusCode) {
    if (statusCode === 'A0301') return '<span class="badge badge-success">예약완료</span>';
    if (statusCode === 'A0302') return '<span class="badge badge-secondary">예약취소</span>';
    if (statusCode === 'A0303') return '<span class="badge badge-dark">사용완료</span>';
    return '';
	}
});
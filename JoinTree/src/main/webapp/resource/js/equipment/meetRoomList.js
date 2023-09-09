// 회의실 관리


// 검색 ------------------------------------------
$('#searchButton').on('click', function () {
	var roomName = $("#searchRoomName").val();
	
    searchMeetRoom(roomName);
    console.log(roomName);
});

function searchMeetRoom(roomName) {
    $.ajax({
        type: "GET",
        url: "/JoinTree/equipment/searchMeetRoom",
        data: {
            "roomName": roomName
        },
        contentType: "application/json",
        success: function (response) {
            // 검색 결과를 화면에 업데이트하는 부분
            var tbody = $('#meetRoomList');
            tbody.empty(); // 기존 내용 지우기
            console.log("response:",response);
            // 검색 결과 데이터를 순회하며 행을 추가
            for (var i = 0; i < response.length; i++) {
			    var meetingRoom = response[i];
			    console.log("mettingROOM:",meetingRoom);
			 
			    var row = '<tr>' +
			        '<td class="roomNo">' + meetingRoom.roomNo + '</td>' +
			        '<td class="equipCategory">' + meetingRoom.equipCategory + '</td>' +
			        '<td class="roomName">' + meetingRoom.roomName + '</td>' +
			        '<td class="roomCapacity">' + meetingRoom.roomCapacity + '명</td>' +
			        '<td class="roomStatus">' + getStatusText(meetingRoom.roomStatus) + '</td>' +
			        '<td class="createdate">' + meetingRoom.createdate + '</td>' +
			        '<td>' +
			        '<button class="editButton btn btn-success btn-sm" data-room-no="' + meetingRoom.roomNo + '">수정</button>'  +
			        ' <button class="deleteButton btn btn-secondary btn-sm" data-room-no="' + meetingRoom.roomNo + '">삭제</button>' +
			        '</td>' +
			        '</tr>';
			
			    tbody.append(row);
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
    if (statusCode === '1') return '사용가능';
    if (statusCode === '0') return '사용불가';
    return '';
}

// ------------------------------------------------------------------
// 추가 모달창 스크립트
$('#addModal').on('show.bs.modal', function (event) {
    //열리기 전 값 초기화 show.bs.modal (모달창이 보여지기 직전에 발생하는 event)
    $("#modalAddRoomName").val("");
    $("#modalAddRoomCapacity").val("1");
    $("#modalAddRoomStatus").val("1");
    $("#rn_add_check").text(""); // 유효성 검사 메시지 초기화
    $("#rn_img_check").text("");
    
    // 이미지 미리보기 초기화
    $("#modalAddImagePreview").css("display", "block"); // 이미지 미리보기
    $("#modalAddImagePreview").attr("src", "/JoinTree/roomImg/no_img.jpg"); // 디폴트 이미지 경로
    $("#modalAddRoomImage").val(""); // 이미지 업로드 입력 필드 초기화
});

$("#modalAddRoomImage").on("change", function () { // 이미지 업로드 변경시 업데이트 및 유효성 검사
    var fileInput = $(this)[0]; //this = modalAddRoomImage, [0] = 첫번째 파일
    var file = fileInput.files[0];
    
    if (file) {
        var fileName = file.name;
        var fileExtension = fileName.split('.').pop().toLowerCase();
        
        // image/jpeg/png만 받을 것 그 외 업로드 하면 애초에 받아지지 않음(초기화)
        if (fileExtension !== 'jpg' && fileExtension !== 'jpeg' && fileExtension !== 'png') {
            $("#rn_img_check").text(" jpg/png 파일만 업로드 가능합니다.");
            $("#rn_img_check").css("color", "red");
            fileInput.value = ""; // 파일 입력 필드 비우고
        } else {          
            $("#rn_img_check").text(""); // 오류 메시지 제거하고 업로드
            readURL(this, "#modalAddImagePreview");
        }
    }
});

//이미지 업로드 미리보기 함수
function readURL(input, previewSelector) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();

        reader.onload = function (e) {
            $(previewSelector).attr('src', e.target.result);
            $(previewSelector).css("display", "block");
        }

        reader.readAsDataURL(input.files[0]);
    }
}

// 추가 버튼 클릭
 $('#modalBtn').click(function() {
	    const roomName = $('#modalAddRoomName').val();
	    const roomCapacity = $('#modalAddRoomCapacity').val();
	    const roomStatus = $('#modalAddRoomStatus').val();
	    
	    if (roomName.trim() === '') {
	        $("#rn_add_check").text("공백은 입력할 수 없습니다.");
	        $("#rn_add_check").css("color", "red");
	        $("#modalAddRoomName").focus();
	        return;
	    }
	    
	    const meetingRoom = {
	        roomName: roomName,
	        roomCapacity: roomCapacity,
	        roomStatus: roomStatus,
	      
	    };
	    
	    // 이미지 선택 여부 확인
	    const imageInput = $("#modalAddRoomImage")[0];
	    if (imageInput.files.length > 0) {
	        meetingRoom.multipartFile = imageInput.files[0];
	    } else {
	        meetingRoom.multipartFile = null;
	    }
	    
	    var meetingRoomJSON = JSON.stringify(meetingRoom);

	    // FormData 생성
	    var formData = new FormData();
	    formData.append("roomName", roomName);
	    formData.append("roomCapacity", roomCapacity);
	    formData.append("roomStatus", roomStatus);
	    formData.append("meetingRoom", meetingRoomJSON);
	    if (meetingRoom.multipartFile) {
	        formData.append("multipartFile", meetingRoom.multipartFile); // 이미지 파일을 추가
	    }
	    console.log("폼데이터:",formData);

	    // 중복 검사 Ajax 요청
	    $.ajax({
	        url: '/JoinTree/cntRoomName',
	        type: 'post',
	        data: roomName,
	        contentType: 'application/json',
	        success: function(cnt) {
	            if (cnt > 0) {
	                $("#rn_add_check").text("이미 존재하는 이름입니다.");
	                $("#rn_add_check").css("color", "red");
	                $("#modalAddRoomName").focus();
	            } else {
	                // 중복 검사 통과
	                $.ajax({
					    url: '/JoinTree/addMeetRoom',
					    type: 'post',
					    data: formData,
					    contentType: false,
					    processData: false,
					    success: function(response) {
	                        if (response.status === "success") {
								Swal.fire({
									icon: 'success',
									title: '회의실이 추가되었습니다.',
									showConfirmButton: false,
									timer: 1000	
								}).then(() => {
                            	$('#addModal').modal('hide');
                           		location.reload();
                        	});
	                        } else {
							Swal.fire(
								'Error',
								'회의실 추가 실패',
								'error'
								)
	                        }
	                    },
	                    error: function() {
	                        console.log('ajax 실패');
	                    }
	                });
	            }
	        },
	        error: function() {
	            console.log('ajax 실패');
	        }
	    });
	});
 
// ------------ 수정 시작
$(document).ready(function() {
    let originalRoomName; // 기존 이름 저장 - 중복검사 피하기 위함

    $(document).on('click', '.editButton', function() { // 클릭했을 때 정보들
        $('#updateModal').modal('show');
        const roomNo = $(this).data('room-no');
        originalRoomName = $(this).closest('tr').find('.roomName').text();
        
        console.log("회의실 기존 이름:", originalRoomName);

        $.ajax({
            url: '/JoinTree/modifyMeetRoom',
            type: 'get',
            data: { roomNo: roomNo },
            success: function(meetroom) {
                $('#modalRoomNo').val(meetroom.roomNo);
                $('#modalCate').val(meetroom.equipCategory);
                $('#modalRoomName').val(meetroom.roomName);
                $('#modalRoomCapacity').val(meetroom.roomCapacity);
                $('#modalRoomStatus').val(meetroom.roomStatus);
                console.log("회의실", meetroom);

                // 기존 이미지 미리보기 설정
                if (meetroom.meetRoomFile) {
                    var imageUrl = '/JoinTree/roomImg/' + meetroom.meetRoomFile;
                    console.log("회의실 파일", meetroom.meetRoomFile);
                    $("#modalUpdateImagePreview").attr("src", imageUrl);
                    $("#modalUpdateImagePreview").css("display", "block");
                } else {
                    // 이미지가 없는 경우 디폴트 이미지 표시
                    var defaultImageUrl = '/JoinTree/roomImg/no_img.jpg';
                    $("#modalUpdateImagePreview").attr("src", defaultImageUrl);
                    $("#modalUpdateImagePreview").css("display", "block");
                }
            },
            error: function() {
                console.log('ajax실패');
            }
        });

        // 모달창 닫을때 메시지 rn_check 초기화
        $("#updateModal").on("hidden.bs.modal", function () {
            $("#rn_check").text("");
            $("#modalUpdateRoomImage").val("");
            $("#img_check").text("");
        });
    });

    // 이미지 업로드 입력 변경 이벤트 처리
    $("#modalUpdateRoomImage").on("change", function () {
	 	var fileInput = $(this)[0];
	    var file = fileInput.files[0];
	
	    if (file) {
	        var fileName = file.name;
	        var fileExtension = fileName.split('.').pop().toLowerCase();
	
	        if (fileExtension !== 'jpg' && fileExtension !== 'jpeg' && fileExtension !== 'png') {
				console.log("이미지 확장자 오류");
	            $("#img_check").text(" jpg/png 파일만 업로드 가능합니다.");
	            $("#img_check").css("color", "red");
	            fileInput.value = ""; // 파일 입력 필드 비우기
	        } else {
				 console.log("이미지 유효성 검사 통과");
	            $("#img_check").text(""); // 오류 메시지 제거
	            readURL(this, "#modalUpdateImagePreview");
	        }
	    }
	});

    // 이미지 업로드 미리보기 함수
    function readURL(input, previewSelector) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();

            reader.onload = function (e) {
                $(previewSelector).attr('src', e.target.result);
                $(previewSelector).css("display", "block");
            }

            reader.readAsDataURL(input.files[0]);
        }
    }

  	// 회의실 중복 검사 함수
	function checkName(roomName, callback) {
    $.ajax({
        url: '/JoinTree/cntRoomName',
        type: 'post',
        contentType: 'application/json',
        data: roomName, // 데이터를 객체로 전달
        success: function(cnt) {
            callback(cnt);
        },
        error: function() {
            console.log('ajax 실패');
        }
    });
}

// 수정 폼 제출 시 이벤트
$('#updateForm').submit(function(event) {
    event.preventDefault();

    const roomName = $('#modalRoomName').val();
    const roomCapacity = $('#modalRoomCapacity').val();
    const roomStatus = $('#modalRoomStatus').val();
    const roomNo = $('#modalRoomNo').val();

    // 회의실명 공백 막고 -> 원래 이름과 같을 시 중복 검사 X
    if (roomName.trim() === "") {
        $("#rn_check").text("공백은 입력할 수 없습니다.");
        $("#rn_check").css("color", "red");
        $("#modalRoomName").focus();
    } else if (roomName === originalRoomName) {
        // 중복 확인을 하지 않고 수정 요청을 보냅니다.
        $.ajax({
            url: '/JoinTree/equipment/modifyMeetRoom',
            type: 'post',
            data: new FormData($('#updateForm')[0]), // 폼 데이터 직렬화
            contentType: false,
            processData: false,
            success: function(response) {
                if (response === "success") {
                    Swal.fire({
					icon: 'success',
					title: '수정이 완료되었습니다.',
					showConfirmButton: false,
					timer: 1000	
					}).then(() => {
                	$('#updateModal').modal('hide');
               		location.reload();
                 });
                } else {
                    Swal.fire(
					'Error',
					'회의실 수정 실패',
					'error'
					)
                }
            },
            error: function() {
                console.log('ajax 실패');
            }
        });
    } else {
        // 중복 검사를 위한 함수 호출
        checkName(roomName, function(cnt) {
            if (cnt > 0) {
                $("#rn_check").text("이미 존재하는 이름입니다.");
                $("#rn_check").css("color", "red");
                $("#modalRoomName").focus();
            } else {
                // 중복이 아닌 경우 폼 데이터를 FormData 객체에 추가
                const formData = new FormData($('#updateForm')[0]);
                formData.append("roomNo", roomNo);
                originalRoomName = roomName;

                $.ajax({
                    url: '/JoinTree/equipment/modifyMeetRoom',
                    type: 'post',
                    data: formData,
                    contentType: false,
                    processData: false,
                    success: function(response) {
                        if (response === "success") {
                            Swal.fire({
							icon: 'success',
							title: '수정이 완료되었습니다.',
							showConfirmButton: false,
							timer: 1000	
							}).then(() => {
		                	$('#updateModal').modal('hide');
		               		location.reload();
		                 });
		                } else {
		                    Swal.fire(
							'Error',
							'회의실 수정 실패',
							'error'
							)
		                }
                    },
                    error: function() {
                        console.log('ajax 실패');
                    }
                });
            }
        });
    }
});


    // 수정 모달창 닫을 때 초기화
    $("#updateModal").on("hidden.bs.modal", function () {
        // 이미지 업데이트 프리뷰 초기화
        $("#modalUpdateImagePreview").css("display", "none");
        $("#modalUpdateImagePreview").attr("src", "");
    });
});

	//삭제 버튼 클릭 시
	$(document).on('click', '.deleteButton', function(event) {
    event.preventDefault(); // 기본 폼 제출 동작 막기

    const row = $(this).closest('tr'); // 해당 행
    const roomNo = $(this).data('room-no');
    const roomName = row.find('.roomName').text(); // 해당 회의실 이름 가져오기

    const msg = `
        삭제된 회의실은 복구할 수 없습니다.<br>
        <strong>'${roomName}'</strong> 회의실을 삭제하시겠습니까?
    `;
    
    Swal.fire({
        title: '회의실 삭제 확인',
        html: msg,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#8BC541',
        cancelButtonColor:  '#888',
        confirmButtonText: '삭제',
        cancelButtonText: '취소'
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                url: '/JoinTree/deleteMeetRoom',
                type: 'post',
                data: { roomNo: roomNo },
                success: function(result) {
                    if (result === "success") {
                        // 삭제 성공 시
                        Swal.fire({
                            title: '성공',
                            text: '회의실이 삭제되었습니다.',
                            icon: 'success'
                        }).then(() => {
                            // 해당 행 비우기 (바로 반영)
                            row.empty();
                        });
                    } else {
                        // 삭제 실패 시 처리
                        Swal.fire({
                            title: 'Error',
                            text: '회의실 삭제에 실패했습니다.',
                            icon: 'error'
                        });
                    }
                },
                error: function() {
                    console.log('ajax 실패');
                }
            });
        }
    });
})
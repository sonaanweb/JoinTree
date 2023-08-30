<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>[경영지원]회의실 관리</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
<style>
</style>
</head>
<body>
	<!-- header -->
	<jsp:include page="/WEB-INF/view/inc/header.jsp"/> 
		<div class="container-fluid page-body-wrapper">
		<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
			<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
<!-- 		<div>
	 		<label for="searchInput">회의실 검색:</label>
		    <input type="text" id="roomName" name="roomName">
		    <button id="searchButton">검색</button>
			</div> -->
			<!-- 관리 회의실 리스트 -->
			<button type="button" class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#addModal">추가</button>
			<table class="table">
			    <thead>
			        <tr>
			            <td>회의실 번호</td>
			            <td>카테고리</td>
			            <td>회의실이름</td>
			            <td>수용인원</td>
			            <td>사용여부</td>
			            <td rowspan="1">추가일</td>
			            <td></td>
			        </tr>
			    </thead>
			    <tbody id="meetRoomList">
			        <c:forEach var="m" items="${meetRoomList}">
			            <tr>
			                <td class="roomNo">${m.roomNo}</td>
			                <td class="equipCategory">${m.equipCategory}</td>
			                <td class="roomName">${m.roomName}</td>
			                <td class="roomCapacity">${m.roomCapacity}명</td>
			                <td class="roomStatus">
			                    <c:choose>
			                        <c:when test="${m.roomStatus == 1}">사용가능</c:when>
			                        <c:when test="${m.roomStatus == 0}">사용불가</c:when>
			                    </c:choose>
			                </td>
			                <td class="createdate">${m.createdate}</td>
			                <td>
			                    <button class="editButton" data-bs-toggle="modal" data-bs-target="#updateModal" data-room-no="${m.roomNo}">수정</button>
			                	<button class="deleteButton" data-room-no="${m.roomNo}">삭제</button>
			                </td>
			            </tr>
			        </c:forEach>
			    </tbody>
			</table>
			<!-- 추가 모달창 -->
			<div class="modal fade" id="addModal" tabindex="-1" aria-labelledby="addModalLabel" aria-hidden="true">
			    <div class="modal-dialog">
			        <div class="modal-content">
			            <div class="modal-header">
			                <h5 class="modal-title" id="addModalLabel">회의실 추가</h5>
			            </div>
			            <div class="modal-body">
			                <form id="addForm">
			                <input type="hidden" id="modalAddCate" name="equipCategory">
			                <input type="hidden" name="empNo" value="${empNo}"> <!-- testId -->
			                    <div class="mb-3">
			                        <label for="modalAddRoomName" class="col-form-label">이름</label>
			                        <input type="text" class="form-control" name="roomName" id="modalAddRoomName" placeholder="회의실 이름을 입력하세요">
			                        <div class="check" id="rn_add_check"></div><!-- 회의실명 중복, 공백일 시 -->
			                    </div>
			                    <div class="mb-3">
			                        <label for="modalAddRoomCapacity" class="form-label">수용 인원</label>
			                        <input type="number" class="form-control" id="modalAddRoomCapacity" name="roomCapacity" min="1">
			                    </div>
			                    <div class="mb-3">
			                        <label for="modalAddRoomStatus" class="col-form-label">사용여부</label>
			                        <select name="roomStatus" id="modalAddRoomStatus">
			                            <option value="1">사용가능</option>
			                            <option value="0">사용불가</option>
			                        </select>
			                    </div>
			                    <button type="button" class="btn btn-primary" id="modalBtn">추가</button>
			                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
			                </form>
			            </div>
			        </div>
			    </div>
			</div>
			<!-- 수정 모달창 -->
			<div class="modal fade" id="updateModal" tabindex="-1" aria-labelledby="updateModalLabel" aria-hidden="true">
			    <div class="modal-dialog">
			        <div class="modal-content">
			            <div class="modal-header">
			                <h5 class="modal-title" id="updateModalLabel">회의실 수정</h5>
			            </div>
			            <div class="modal-body">
			                <form id="updateForm">
			                    <!-- hidden : roomNo, Category -->		                    
			                    <input type="hidden" id="modalRoomNo" name="roomNo">
			                    <input type="hidden" id="modalCate" name="equipCategory">
			                    <div class="mb-3">
			                        <label for="modalRoomName" class="form-label">회의실 이름</label>
			                        <input type="text" class="form-control" id="modalRoomName" name="roomName">
			                        <div class="check" id="rn_check"></div><!-- 회의실명 중복, 공백일 시 -->
			                    </div>
			                    <div class="mb-3">
			                        <label for="modalRoomCapacity" class="form-label">수용 인원</label>
			                        <input type="number" class="form-control" id="modalRoomCapacity" name="roomCapacity" min="1">
			                    </div>
			                    <div class="mb-3">
			                        <label for="modalRoomStatus" class="form-label">사용 여부</label>
			                        <select class="form-control" id="modalRoomStatus" name="roomStatus">
			                            <option value="1">사용가능</option>
			                            <option value="0">사용불가</option>
			                        </select>
			                    </div>
			                    <button type="submit" class="btn btn-primary" id="modalBtn">수정</button>
								<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>		                
			                </form>
			            </div>
			        </div>
			    </div>
			</div>
	<!-- 컨텐츠 끝 -->
		</div>
	</div><!-- 컨텐츠전체 끝 -->
<!-- footer -->
<jsp:include page="/WEB-INF/view/inc/footer.jsp"/>

<script>
// 검색버튼 클릭시
/* $('#searchButton').on('click', function () {
    var roomName = $("#roomName").val();
    searchMeetRoom(roomName);
});

function searchMeetRoom(roomName) {
    $.ajax({
        type: 'GET',
        url: '/JoinTree/equipment/searchMeetRoom',
        data: { "roomName": roomName },
        contentType: "application/json",
        success: function (meetRoomList) {
            var tbody = $('#meetRoomList');
            tbody.empty();

            $.each(meetRoomList, function (index, meetingRoom) {
                var row = '<tr>' +
                    '<td>' + meetingRoom.roomNo + '</td>' +
                    '<td>' + meetingRoom.equipCategory + '</td>' +
                    '<td>' + meetingRoom.roomName + '</td>' +
                    '<td>' + meetingRoom.roomCapacity + '명</td>' +
                    '<td>' + (meetingRoom.roomStatus === 1 ? '사용가능' : '사용불가') + '</td>' +
                    '<td>' + meetingRoom.createdate + '</td>' +
                    '<td>' +
                    '<button class="editButton" data-bs-toggle="modal" data-bs-target="#updateModal" data-room-no="' + meetingRoom.roomNo + '">수정</button>' +
                    '<button class="deleteButton" data-room-no="' + meetingRoom.roomNo + '">삭제</button>' +
                    '</td>' +
                    '</tr>';
                tbody.append(row);
            });
        },
        error: function () {
            console.log('검색 실패');
        }
    });
}
 */

// 추가 모달창 스크립트
$('#addModal').on('show.bs.modal', function (event) {
    //열리기 전 값 초기화 show.bs.modal (모달창이 보여지기 직전에 발생하는 event)
    $("#modalAddRoomName").val("");
    $("#modalAddRoomCapacity").val("1");
    $("#modalAddRoomStatus").val("1");
    $("#rn_add_check").text(""); // 유효성 검사 메시지 초기화
});

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
                    // 유효성 검사 통과시
                    // 폼의 액션 속성과 매서드 속성을 변경. 폼을 /addMeetRoom URL로 보내는 POST 요청
                    $('#addForm').attr('action', '/JoinTree/addMeetRoom');
                    $('#addForm').attr('method', 'post'); // 폼 제출 방식
                    $('#addForm')[0].submit();
                    alert('회의실이 추가되었습니다.');
                }
            },
            error: function() {
                console.log('ajax실패');
            }
        });
    });

// 수정 모달창 스크립트
$(document).ready(function() {
	let originalRoomName; // 기존 이름 저장 - 중복검사 피하기 위함
	
    $('.editButton').click(function() {
        const roomNo = $(this).data('room-no'); // 버튼의 data-room-no 속성값 가져오기
        originalRoomName = $(this).closest('tr').find('.roomName').text(); // 기존 회의실 이름 저장
        
        $.ajax({
            url: '/JoinTree/modifyMeetRoom',
            type: 'post',
            data: { roomNo: roomNo }, // 가져온 roomNo 전달
            success: function(meetroom) {
                $('#modalRoomNo').val(meetroom.roomNo);
                $('#modalCate').val(meetroom.equipCategory);
                $('#modalRoomName').val(meetroom.roomName);
                $('#modalRoomCapacity').val(meetroom.roomCapacity);
                $('#modalRoomStatus').val(meetroom.roomStatus);
            },
            error: function() {
                console.log('ajax실패');
            }
        });
        $("#updateModal").modal("show");
        
        // 모달창 닫을때 메시지 rn_check 초기화
        $("#updateModal").on("hidden.bs.modal", function () {
            $("#rn_check").text("");
        });
    });

	// 수정 폼 제출 시 이벤트
	$('#updateForm').submit(function(event) {
        event.preventDefault();
        
        const roomName = $('#modalRoomName').val();
        
	// 회의실명이 공백이거나 중복일 경우 막음. 수정하지 않았을 때는 통과
        if (roomName.trim() === "") {
        	 $("#rn_check").text("공백은 입력할 수 없습니다.");
             $("#rn_check").css("color", "red");
             $("#modalRoomName").focus();
        } else if (roomName === originalRoomName){
            $('#updateForm').attr('action', '/JoinTree/equipment/modifyMeetRoom');
            $('#updateForm').attr('method', 'post');
            $('#updateForm')[0].submit();
            alert('수정이 완료되었습니다.');
        } else { // 둘 다 통과시
            $.ajax({
                url: '/JoinTree/cntRoomName',
                type: 'post',
                data: roomName,
                contentType: 'application/json',
                success: function(cnt) {
                    if (cnt > 0) {
	                   	 $("#rn_check").text("이미 존재하는 이름입니다.");
	                     $("#rn_check").css("color", "red");
	                     $("#modalRoomName").focus();
                    } else {
                        // 유효성 검사 통과시
	                    $('#updateForm').attr('action', '/JoinTree/equipment/modifyMeetRoom');
	                    $('#updateForm').attr('method', 'post'); // 폼 제출 방식
	                    $('#updateForm')[0].submit();
	                    alert('수정이 완료되었습니다.');
                    }
                },
                error: function() {
                    console.log('ajax실패');
                }
            });
        }
    });
});

	//삭제 버튼 클릭 시
	$('.deleteButton').click(function(event) {
	    event.preventDefault(); // 기본 폼 제출 동작 막기
	
	    const row = $(this).closest('tr'); // 해당 행
	    const roomNo = $(this).data('room-no');
	    const roomName = row.find('.roomName').text(); // 해당 회의실 이름 가져오기
	
	    const msg = "삭제된 회의실은 복구할 수 없습니다.\n'" + roomName + "' 회의실을 삭제하시겠습니까?";
	    if (confirm(msg)) {
	        deleteMeetRoom(row, roomNo);
	    }
	});
	
	function deleteMeetRoom(row, roomNo) {
	    $.ajax({
	        url: '/JoinTree/deleteMeetRoom',
	        type: 'post',
	        data: { roomNo: roomNo },
	        success: function(result) {
	            if (result === "success") {
	                // 삭제 성공 시
	                alert('회의실이 삭제되었습니다.');
	                // 해당 행 비우기 (바로 반영)
	                row.empty();
	            } else {
	                // 삭제 실패 시 처리
	                alert('회의실 삭제에 실패했습니다.');
	            }
	        },
	        error: function() {
	            console.log('ajax 실패');
	        }
	    });
	}

</script>
</body>
</html>
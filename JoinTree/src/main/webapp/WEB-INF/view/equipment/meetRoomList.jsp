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
</head>
<body>
<!-- 관리 회의실 리스트 -->
<a href="/equipment/addMeetRoom">추가</a>
<table>
    <thead>
        <tr>
            <td>회의실 번호</td>
            <td>기자재카테고리</td>
            <td>회의실이름</td>
            <td>수용인원</td>
            <td>사용여부</td>
            <td>수정</td>
        </tr>
    </thead>
    <tbody>
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
                <td>
                    <button class="editButton" data-bs-toggle="modal" data-bs-target="#updateModal" data-room-no="${m.roomNo}" data-equip-category="${m.equipCategory}" data-room-name="${m.roomName}" data-room-capacity="${m.roomCapacity}" data-room-status="${m.roomStatus}">수정</button>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>
<!-- 수정 모달창 -->
<div class="modal fade" id="updateModal" tabindex="-1" aria-labelledby="updateModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="updateModalLabel">회의실 수정</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
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
                        <input type="number" class="form-control" id="modalRoomCapacity" name="roomCapacity">
                    </div>
                    <div class="mb-3">
                        <label for="modalRoomStatus" class="form-label">사용 여부</label>
                        <select class="form-control" id="modalRoomStatus" name="roomStatus">
                            <option value="1">사용가능</option>
                            <option value="0">사용불가</option>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-primary">수정</button>
                </form>
            </div>
        </div>
    </div>
</div>
<script>
    $(document).ready(function () {
        $(".editButton").click(function () {
            const roomNo = $(this).data("room-no");
            const equipCategory = $(this).data("equip-category");
            const roomName = $(this).data("room-name");
            const roomCapacity = $(this).data("room-capacity");
            const roomStatus = $(this).data("room-status");

            $("#modalRoomNo").val(roomNo);
            $("#modalCate").val(equipCategory);

            // 모달 창 내의 input 요소에 값 설정
            $("#modalRoomName").val(roomName);
            $("#modalRoomCapacity").val(roomCapacity);
            $("#modalRoomStatus").val(roomStatus);

            // 모달 창 열기
            $("#updateModal").modal("show");
           
            // 메시지 rn_check 초기화
            $("#updateModal").on("hidden.bs.modal", function () {
                $("#rn_check").text("");
            });

            // 폼 제출 이벤트 핸들러
            $("#updateForm").submit(function (event) {
                event.preventDefault();

                // 공백 검사
                if ($("#modalRoomName").val().trim() === '') {
                    $("#rn_check").text("공백은 입력 불가능합니다");
                    $("#rn_check").css("color", "red");
                    $("#modalRoomName").focus();
                    return; // 검사 통과하지 않으면 중단
                }

                const roomName = $("#modalRoomName").val().trim();
                $.post("/equipment/cntRoomName", { roomName: roomName }, function (data) {
                    if (data > 0) {
                        $("#rn_check").text("이미 사용 중인 회의실 이름입니다.");
                        $("#rn_check").css("color", "red");
                        $("#modalRoomName").focus();
                    } else {
                        const formData = $("#updateForm").serialize();
                        const url = "/equipment/meetRoomList"; // 수정 처리url
                        
                        $.ajax({
                            type: "POST", //HTTP 요청 방식(서버에 데이터를 넘기는 방식)
                            url: url,
                            data: formData, 
                            success: function (data) { //success = 콜백함수
                                // 회의실 수정 성공
                                alert("수정이 완료되었습니다.");
                                location.reload(); // 새로고침
                            },
                            error: function () { //error = 콜백함수
                                // 실패 시엔 alert창만 띄우고 새로고침 되지 않음
                                alert("수정에 실패하였습니다.");
                            }
                        });
                    }
                });
            });
        });
    });
</script>
</body>
</html>
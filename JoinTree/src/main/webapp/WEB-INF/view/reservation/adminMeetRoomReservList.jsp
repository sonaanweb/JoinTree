<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
<title>[경영지원팀]사원 회의실 예약 현황</title>
</head>
<body>
<!-- header -->
<jsp:include page="/WEB-INF/view/inc/header.jsp"/> 
<div class="container-fluid page-body-wrapper">
    <jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
    <div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
		<h4>경영지원팀 예약관리</h4>
<!--<div>검색 필터 들어갈 곳</div> -->
        <table class="table">
            <thead>
                <tr>
                    <td>예약번호</td>
                    <td>예약자</td>
                    <td>회의실 이름</td>
                    <td>예약일시</td>
                    <td>예약 내용</td>
                    <td>예약 신청일</td>
                    <td>상태</td>
                    <td>최종수정자</td>
                    <td></td>
                </tr>
            </thead>
            <tbody id="reservationbody">
                <c:forEach var="r" items="${empAllMeetReserved}">
                    <tr>
                        <td>${r.revNo}</td>
                        <td>${r.empName}(${r.empNo})</td>
                        <td>${r.roomName}</td>
                        <td>${r.revStartTime.substring(0,16)} ~ ${r.revEndTime.substring(10,16)}</td>
                        <td>${r.revReason}</td>
                        <td>${r.createdate.substring(0,10)}</td>
                        <td>
                            <c:choose>
                                <c:when test="${r.revStatus == 'A0302'}">예약완료</c:when>
                                <c:when test="${r.revStatus == 'A0303'}">예약취소</c:when>
                                <c:when test="${r.revStatus == 'A0304'}">사용완료</c:when>
                            </c:choose>
                        </td>
                        <td>${r.empName}(${r.empNo})</td>
                        <!-- 예약 완료인 상태에만 취소 버튼 활성화 / 사용완료 상태는 취소 버튼 X-->
                        <c:choose>
                            <c:when test="${r.revStatus == 'A0302'}">
                                <td><button class="btn btn-sm btn-primary cancel-btn" data-revno="${r.revNo}">취소</button></td>
                            </c:when>
                            <c:otherwise>
                                <td></td>
                            </c:otherwise>
                        </c:choose>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <!-- 예약 취소 확인 모달창 -->
        <div class="modal fade" id="cancelModal" tabindex="-1" aria-labelledby="cancelConfirmationModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="cancelConfirmationModalLabel">예약 취소 확인</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
		            <div class="modal-body">
		                <!-- 기본 모달 내용(취소 버튼) -->
		                <p id="modalMessage">예약을 취소하시겠습니까?<br>(확인 버튼을 누르면 예약이 취소됩니다.)</p>
		            </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" id="confirmButton" data-bs-dismiss="modal">확인</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- 모달창 end -->
        <!-- 취소 결과 모달창 start-->
		<div class="modal fade" id="notiModal" tabindex="-1" aria-labelledby="notiModal" aria-hidden="true">
		    <div class="modal-dialog">
		        <div class="modal-content">
		            <div class="modal-header">
		                <h5 class="modal-title" id="notiModal">알림</h5>
		                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
		            </div>
		            <div class="modal-body">
		                <p id="notiMessage"></p>
		            </div>
		            <div class="modal-footer">
		                <button type="button" class="btn btn-primary" data-bs-dismiss="modal">확인</button>
		            </div>
		        </div>
		    </div>
		</div>
    <!-- 컨텐츠 끝 -->
    </div>
</div>
<!-- 컨텐츠전체 끝 -->
<!-- footer -->
<jsp:include page="/WEB-INF/view/inc/footer.jsp"/>
</body>
<!-- 스크립트 부분 -->
<script>
$(document).ready(function () {
    // 예약 취소 버튼 클릭 시 모달 표시
    $('.cancel-btn').on('click', function () {
        var revNo = $(this).data('revno');
        $('#cancelModal').modal('show');

        // 확인 버튼 클릭 이벤트 핸들러
        $('#confirmButton').off('click').on('click', function () {
            cancelReserv(revNo);
        });
    });

    // 예약 취소
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
                            $(this).find('td:nth-child(7)').text('예약취소');
                        }
                    });


                    // 취소 결과 모달창
                    $('#notiMessage').text('예약 취소 정상처리 되었습니다.');
                    $('#notiModal').modal('show');
                } else {
                    $('#notiMessage').text('예약 취소 실패');
                    $('#notiModal').modal('show');
                }
            },
            error: function (error) {
                console.log(error);
                alert("예약 취소 실패");
            }
        });
    }
});
</script>
</body>
</html>
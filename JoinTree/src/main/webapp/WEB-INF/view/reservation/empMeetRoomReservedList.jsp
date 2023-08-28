<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약한 회의실 조회</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<!-- header -->
<jsp:include page="/WEB-INF/view/inc/header.jsp"/> 
	<div class="container-fluid page-body-wrapper">
	<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
		<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->

			<table class="table">
			    <thead>
			        <tr>
			            <td>예약번호</td>
			            <td>회의실 이름</td>
			            <td>예약 시간</td>
			            <td>사유</td>
			            <td>예약 신청일</td>
			            <td>상태</td>
			            <td></td>
			        </tr>
			    </thead>
				<tbody id="reservationbody">
				    <c:forEach var="r" items="${empMeetReserved}">
				            <tr>
				                <td>${r.revNo}</td>
				                <td>${r.roomName}</td>
				                <td>${r.revStartTime} ~ ${r.revEndTime}</td>
				                <td>${r.revReason}</td>
				                <td>${r.createdate}</td>
				                <td>
				                <c:choose>
			                        <c:when test="${r.revStatus == 'A0302'}">예약완료</c:when>
			                        <c:when test="${r.revStatus == 'A0303'}">예약취소</c:when>
			                    </c:choose>
			                    </td>
				                <!-- 예약 완료인 상태에만 취소 버튼 활성화 -->
				                <c:choose>
								    <c:when test="${r.revStatus == 'A0302'}">
								        <td><button class="btn btn-sm btn-primary" onclick="cancelReserv(${r.revNo})">예약취소</button></td>
								    </c:when>
								    <c:otherwise>
								        <td></td>
								    </c:otherwise>
								</c:choose>
				            </tr>
				    </c:forEach>
				</tbody>
			</table>
	<!-- 컨텐츠 끝 -->
		</div>
	</div><!-- 컨텐츠전체 끝 -->
<!-- footer -->
<jsp:include page="/WEB-INF/view/inc/footer.jsp"/>
</body>
<script>
    function cancelReserv(revNo) {
        $.ajax({
            type: "POST",
            url: "/JoinTree/cancelReserved",
            data: JSON.stringify({ "revNo": revNo }),
            contentType: "application/json",
            success: function (response) {
                alert(response);
                if (response === '예약취소 완료') {
                    // 예약 상태 업데이트 ---- 비동기 화면
                    $('#reservationbody tr').each(function () {
                        var rowRevNo = $(this).find('td:first-child').text();
                        if (rowRevNo === revNo.toString()) {
                            $(this).find('td:nth-child(6)').text('예약취소');
                            $(this).find('td:last-child').empty(); // 취소 버튼 숨기기
                        }
                    });
                }
            },
            error: function (error) {
                console.log(error);
                alert("예약 취소 실패");
            }
        });
    }
</script>
</html>
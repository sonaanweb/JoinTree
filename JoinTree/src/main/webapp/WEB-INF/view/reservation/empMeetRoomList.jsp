<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회의실 목록(사원)- 클릭하면 해당 회의실 캘린더로 넘어가게 할 예정</title>
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
				<!-- 회의실 이름을 클릭하면 해당 회의실 캘린더로 이동합니다 -->
			            <td>회의실이름</td>
			            <td>수용인원</td>
			        </tr>
			    </thead>
				<tbody>
				    <c:forEach var="m" items="${meetRoomList}">
				        <c:if test="${m.roomStatus == 1}"> <!-- 사용 가능한 회의실만 표시 -->
				            <tr>
				                <td class="roomName">
				                    <a href="/JoinTree/reservation/meetRoomReserv?roomNo=${m.roomNo}&roomName=${m.roomName}">
				                    ${m.roomName}
				                    </a>
				                </td>
				                <td class="roomCapacity">${m.roomCapacity}명</td>
				            </tr>
				        </c:if>
				    </c:forEach>
				</tbody>
			</table>
	<!-- 컨텐츠 끝 -->
		</div>
	</div><!-- 컨텐츠전체 끝 -->
<!-- footer -->
<jsp:include page="/WEB-INF/view/inc/footer.jsp"/>
</body>
</html>
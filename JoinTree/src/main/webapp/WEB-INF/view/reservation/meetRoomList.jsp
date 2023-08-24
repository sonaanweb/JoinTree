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
	                    <a href="/reservation/meetRoomReserv?roomNo=${m.roomNo}">
	                    ${m.roomName}
	                    </a>
	                </td>
	                <td class="roomCapacity">${m.roomCapacity}명</td>
	            </tr>
	        </c:if>
	    </c:forEach>
	</tbody>
</table>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>[경영지원]회의실 관리</title>
</head>
<body>
<!--------- 관리 회의실 리스트 ---------->
	<table>
		<thead><!-- 열 제목 -->
			<tr>
				<td>회의실 번호</td>
				<td>equipCategory</td>
				<td>회의실명</td>
				<td>수용인원</td>
				<td>사용여부</td>
			</tr>
		</thead>
		<tbody><!-- 리스트 -->
		<c:forEach var="m" items="${resultList}"><!-- items 이름 수정 필요 -->
			<tr>
				<td>${m.roomNo}</td>
                <td>${m.equipCategory}</td>
                <td>${m.roomName}</td>
                <td>${m.roomCapacity}</td>
                <td>${m.ynStatus}</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
</body>
</html>
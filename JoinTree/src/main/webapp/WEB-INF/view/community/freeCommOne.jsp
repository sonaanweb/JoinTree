<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>freeCommOne</title>
	</head>
	<body>
		<a href="/community/freeCommList">이전</a>
		
		<h1>상세정보</h1>
		<%-- ${loginAccount.empNo} --%>
		
		<table border="1">
			<tr>
				<th>제목</th>
				<td>${comm.boardTitle}</td>
			</tr>
			<tr>
				<th>내용</th>
				<td>${comm.boardContent}</td>
			</tr>
			<tr>
				<th>작성자</th>
				<td>${comm.empNo}</td>
			</tr>
			<tr>
				<th>작성일자</th>
				<td>${comm.createdate}</td>
			</tr>
			<tr>
				<th>수정일자</th>
				<td>${comm.updatedate}</td>
			</tr>
			<tr>
			<th>첨부파일</th>
				<td>
					<img src="${pageContext.request.contextPath}/commImg/${boardFile.boardSaveFilename}" style="width: 300px; height: auto;">
					<c:forEach var="f" items="${boardfiles}">
					<a href="/upload/${f.saveFilename}">${f.originFilename}</a><br>
					</c:forEach>
					
			    	<c:choose>
				        <c:when test="${empty empInfo.empSaveImgName or empInfo.empSaveImgName == '이미지 없음'}">
				            이미지 없음
				        </c:when>
				        <c:otherwise>
				            <img src="${pageContext.request.contextPath}/commImg/${boardFile.boardSaveFilename}"><br>
				        </c:otherwise>
				    </c:choose>
				</td>
			</tr>
		</table>
		<!-- 자신이 작성한 게시글일 경우에만 수정, 삭제 버튼 노출 -->
		<c:if test="${loginAccount.empNo eq comm.empNo}">
			<a href="/community/freeCommList/modifyFreeComm?boardNo=${comm.boardNo}">수정</a>
			<a href="/community/freeCommList/removeFreeComm?boardNo=${comm.boardNo}">삭제</a>
		</c:if>
	</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>freeCommOne</title>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
		<script>
			$(document).ready(function() {
				const urlParams = new URL(location.href).searchParams;
				const msg = urlParams.get("msg");
					if (msg != null) {
						alert(msg);
					}
					
				// 새로고침 시 메시지 알림창 출력하지 않음
		        // urlParams.delete("msg");
		        //const newUrl = `${location.pathname}?${urlParams.toString()}`;
		        //history.replaceState({}, document.title, newUrl);
			});
		</script>
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
				<td>${comm.empName}</td>
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
			    	<c:choose>
				        <c:when test="${boardFile.boardSaveFilename eq null or boardFile.boardSaveFilename == '이미지 없음'}">
				            이미지 없음
				        </c:when>
				        <c:otherwise>
				            <img src="${pageContext.request.contextPath}/commImg/${boardFile.boardSaveFilename}" style="width: 300px; height: auto;"><br>
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
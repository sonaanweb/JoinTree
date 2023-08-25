<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<!DOCTYPE html>
<html>
 	<!-- head, body 사용 안함 // 다른 부분도 템플릿 바꾸기 -->
	<!-- header -->
	<jsp:include page="/WEB-INF/view/inc/header.jsp"/> 
		<script>
			$(document).ready(function() {
				const urlParams = new URL(location.href).searchParams;
				const msg = urlParams.get("msg");
					if (msg != null) {
						alert(msg);
					}
			});
		</script>

		<div class="container-fluid page-body-wrapper">
		<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
			<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
	
				<a href="/home">홈</a>
			
				<h1>자유 게시판</h1>
				<%-- ${commList} --%>
				
				<div>
					<a href="/community/freeCommList/addFreeComm">게시글 작성</a>
				</div>
				
				<!-- 상단고정 게시글  -->
				<table border="1">
					<tr>
						<th>No</th>
						<th>제목</th>
						<th>작성자</th>
						<th>작성일</th>
						<th>조회수</th>
					</tr>
					<c:forEach var="p" items="${pinnedCommList}">
						<tr>
							<td>${p.boardNo}</td>
							<td>
								<a href="/community/freeCommList/freeCommOne?boardNo=${p.boardNo}">${p.boardTitle}</a>
							</td>
							<td>
								${p.empName}
							</td>
							<td>${p.createdate}</td>
							<td>${p.boardCount}</td>
						</tr>
					</c:forEach>
				</table>
				
				<!-- 전체 게시글  -->
				<table border="1">
					<tr>
						<th>No</th>
						<th>제목</th>
						<th>작성자</th>
						<th>작성일</th>
						<th>조회수</th>
					</tr>
					<c:forEach var="c" items="${commList}">
						<tr>
							<td>${c.boardNo}</td>
							<td>
								<a href="/community/freeCommList/freeCommOne?boardNo=${c.boardNo}">${c.boardTitle}</a>
							</td>
							<td>
								${c.empName}
								<%-- <a href="/board/boardOne?boardNo=${b.boardNo}">${b.boardTitle}</a> --%>
							</td>
							<td>${c.createdate}</td>
							<td>${c.boardCount}</td>
						</tr>
					</c:forEach>
				</table>
		
		</div>
	</div>
</html>
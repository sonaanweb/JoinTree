<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<!DOCTYPE html>
<html>
	<!-- header -->
	<jsp:include page="/WEB-INF/view/inc/header.jsp"/> 
		<script>
	/* 		$(document).ready(function() {
				const urlParams = new URL(location.href).searchParams;
				const msg = urlParams.get("msg");
					if (msg != null) {
						alert(msg);
					}
			}); */
		</script>
		
		<div class="container-fluid page-body-wrapper">
		<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
			<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->

				<h1>중고장터 게시판</h1>
			
				<!-- 검색창 -->
				<!-- 제목 / 내용 검색 -->
			   	<form action="/JoinTree/community/secondhandCommList" method="GET">
			        <select name="searchOption" id="searchOption">
			            <option value="">선택하세요</option>
			            <option value="board_title">제목</option>
			            <option value="board_content">내용</option>
			        </select>
			        <input type="text" name="searchText" id="searchText" placeholder="검색어를 입력하세요." value="${param.searchText}">
			        <button type="submit">검색</button>
			    </form>
				
				<div>
					<a href="/JoinTree/community/secondhandCommList/addSecondhandComm">게시글 작성</a>
				</div>
				
				<!-- 전체 게시글 -->
				<table border="1">
					<thead> <!-- 상단고정 게시글 -->
						<tr>
							<th>No</th>
							<th>제목</th>
							<th>작성자</th>
							<th>작성일</th>
							<th>조회수</th>
						</tr>
						<c:forEach var="p" items="${pinnedCommList}">
							<tr>
								<td width="10%">${p.boardNo}</td>
								<td width="40%">
									<a href="/JoinTree/community/secondhandCommList/secondhandCommOne?boardNo=${p.boardNo}">
										<c:choose>
						                    <c:when test="${p.commentCnt != 0}">
						                        <span style="color:red;">[공지] ${p.boardTitle} [${p.commentCnt}]</span>
						                    </c:when>
						                    <c:otherwise>
						                        <span style="color:red;">[공지] ${p.boardTitle}</span>
						                    </c:otherwise>
			                			</c:choose>
									</a>
								</td>
								<td width="20%">
									${p.empName}
								</td>
								<td width="15%">${p.createdate}</td>
								<td width="15%">${p.boardCount}</td>
							</tr>
						</c:forEach>
					</thead>
					<tbody>
						<c:forEach var="c" items="${commList}">
							<tr>
								<td width="10%">${c.boardNo}</td>
								<td width="40%">
									<a href="/JoinTree/community/secondhandCommList/secondhandCommOne?boardNo=${c.boardNo}">
										<c:choose>
						                    <c:when test="${c.commentCnt != 0}">
						                        ${c.boardTitle} [${c.commentCnt}]
						                    </c:when>
						                    <c:otherwise>
						                        ${c.boardTitle}
						                    </c:otherwise>
				                		</c:choose>
									</a>
								</td>
								<td width="20%">
									${c.empName}
									<%-- <a href="/board/boardOne?boardNo=${b.boardNo}">${b.boardTitle}</a> --%>
								</td>
								<td width="15%">${c.createdate}</td>
								<td width="15%">${c.boardCount}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
				
				<!-- 페이지 내비게이션 -->
				<div id="pagination">
					<c:if test="${startPage > 1}">
	        			<a href="/JoinTree/community/secondhandCommList?currentPage=${startPage - 10}&category=${category}&searchOption=${param.searchOption}&searchText=${param.searchText}">[이전]</a>
	    			</c:if>
				
				    <c:forEach var="pageNumber" begin="${startPage}" end="${endPage}">
				        <c:choose>
				            <c:when test="${pageNumber == currentPage}">
				                <span class="page-number">${pageNumber}</span>
				            </c:when>
				            <c:otherwise>
				                <a href="/JoinTree/community/secondhandCommList?currentPage=${pageNumber}&category=${category}&searchOption=${param.searchOption}&searchText=${param.searchText}">${pageNumber}</a>
				            </c:otherwise>
				        </c:choose>
				    </c:forEach>
				    
				     <c:if test="${endPage < lastPage}">
	        			<a href="/JoinTree/community/secondhandCommList?currentPage=${endPage + 1}&category=${category}&searchOption=${param.searchOption}&searchText=${param.searchText}">[다음]</a>
	    			</c:if>
				</div>
				
			</div>
		</div>
</html>
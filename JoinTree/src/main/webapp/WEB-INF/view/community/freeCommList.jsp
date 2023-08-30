<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<!-- header -->
	<jsp:include page="/WEB-INF/view/inc/header.jsp"/> 
		<script>
			$(document).ready(function() {
				const urlParams = new URL(location.href).searchParams;
				const msg = urlParams.get("msg");
					if (msg != null) {
						alert(msg);
					}
				
				/*
				const searchOptionInput = $("#searchOption");
			    const searchTextInput = $("#searchText");
			    const searchButton = $("#searchBtn");
			    const searchResults = $("#searchResults");

			    searchButton.click(function(event) {
			        event.preventDefault();

			        const searchOption = searchOptionInput.val();
			        const searchText = searchTextInput.val();

			        updateURLParameter("searchOption", searchOption);
			        updateURLParameter("searchText", searchText);

			        performSearch(searchOption, searchText);
			    });

			    function updateURLParameter(param, value) {
			        const urlParams = new URLSearchParams(window.location.search);
			        urlParams.set(param, value);
			        const newUrl = `${window.location.pathname}?${urlParams.toString()}`;
			        history.pushState(null, null, newUrl);
			    }

			    function performSearch(searchOption, searchText) {
			        $.ajax({
			            url: `/JoinTree/community/freeCommListData?searchOption=${searchOption}&searchText=${searchText}`,
			            method: "GET",
			            dataType: "json", // 요청하는 데이터의 형식을 JSON으로 지정
			            success: function(response) {
			            	alert("검색 완료");
			                // JSON 데이터를 처리하고 화면 업데이트
			                updateSearchResults(response);
			                // console.log(response)
			            },
			            error: function() {
			                alert("검색 실패");
			            }
			        });
			    }

			    function updateSearchResults(data) {
			        const searchResultsContainer = $("#searchResults");

			        // 기존 내용 지우기
			        searchResultsContainer.empty();

			        // 테이블 생성
			        const table = $("<table border='1'></table>");
			        searchResultsContainer.append(table);

			        // 테이블 헤더 생성
			        const tableHeader = $("<tr></tr>");
			        tableHeader.append("<th>No</th>");
			        tableHeader.append("<th>제목</th>");
			        tableHeader.append("<th>작성자</th>");
			        tableHeader.append("<th>작성일</th>");
			        tableHeader.append("<th>조회수</th>");
			        tableHeader.append("<th>내용</th>"); // 새로운 열 추가
			        table.append(tableHeader);

			        // JSON 데이터를 순회하면서 테이블 행 생성
			        $.each(data, function(index, item) {
			            const row = $("<tr></tr>");

			            row.append(`<td>${item.boardNo}</td>`);
			            row.append(`<td><a href="/JoinTree/community/freeCommList/freeCommOne?boardNo=${item.boardNo}">${item.boardTitle}</a></td>`);
			            row.append(`<td>${item.empName}</td>`);
			            row.append(`<td>${item.createdate}</td>`);
			            row.append(`<td>${item.boardCount}</td>`);
			            row.append(`<td>${item.content}</td>`); // 내용 열 추가

			            table.append(row);
			        });
			    }
			    */
			
			});
		</script>

		<div class="container-fluid page-body-wrapper">
		<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
			<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
	
				<a href="/JoinTree/home">홈</a>
			
				<h1>자유 게시판</h1>
				<%-- ${commList} --%>
				
				<!-- 검색창 -->
				<!-- 제목 / 내용 검색 -->
			   	<form action="/JoinTree/community/freeCommList" method="GET">
			        <select name="searchOption" id="searchOption">
			            <option value="">선택하세요</option>
			            <option value="board_title">제목</option>
			            <option value="board_content">내용</option>
			        </select>
			        <input type="text" name="searchText" id="searchText" placeholder="검색어를 입력하세요." value="${param.searchText}">
			        <button type="submit">검색</button>
			    </form>


				
<!-- 								
				검색창
				<div>
				    <select id="searchOption">
				        <option value="">선택하세요</option>
				        <option value="board_title">제목</option>
				        <option value="board_content">내용</option>
				    </select>
				    <input type="text" id="searchText" placeholder="검색어를 입력하세요.">
				    <button id="searchBtn">검색</button>
				</div>
				
				검색 결과를 표시할 부분
				<div id="searchResults"></div>  
				 -->
				
				<div>
					<a href="/JoinTree/community/freeCommList/addFreeComm">게시글 작성</a>
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
							<td width="10%">${p.boardNo}</td>
							<td width="40%">
								<a href="/JoinTree/community/freeCommList/freeCommOne?boardNo=${p.boardNo}">
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
				</table>
					
				
				
				<!-- 전체 게시글  -->
				<table id="commListTable" border="1">
					<!-- <tr>
						<th>No</th>
						<th>제목</th>
						<th>작성자</th>
						<th>작성일</th>
						<th>조회수</th>
					</tr> -->
					<c:forEach var="c" items="${commList}">
						<tr>
							<td width="10%">${c.boardNo}</td>
							<td width="40%">
								<a href="/JoinTree/community/freeCommList/freeCommOne?boardNo=${c.boardNo}">
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
				</table>
			
			<!-- 페이지 내비게이션 -->
			<div id="pagination">
				<c:if test="${startPage > 1}">
        			<a href="/JoinTree/community/freeCommList?currentPage=${startPage - 1}&category=${category}&searchOption=${param.searchOption}&searchText=${param.searchText}">[이전]</a>
    			</c:if>
			
			    <c:forEach var="pageNumber" begin="${startPage}" end="${endPage}">
			        <c:choose>
			            <c:when test="${pageNumber == currentPage}">
			                <span class="page-number">${pageNumber}</span>
			            </c:when>
			            <c:otherwise>
			                <a href="/JoinTree/community/freeCommList?currentPage=${pageNumber}&category=${category}&searchOption=${param.searchOption}&searchText=${param.searchText}">${pageNumber}</a>
			            </c:otherwise>
			        </c:choose>
			    </c:forEach>
			    
			     <c:if test="${endPage < lastPage}">
        			<a href="/JoinTree/community/freeCommList?currentPage=${endPage + 1}&category=${category}&searchOption=${param.searchOption}&searchText=${param.searchText}">[다음]</a>
    			</c:if>
			</div>
		
		</div>
	</div>
</html>
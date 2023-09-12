<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<link rel="stylesheet" type="text/css" href="/JoinTree/resource/css/custom.css">
	<!-- 게시글 검색 폼 -->
	<div class="col-lg-12 text-right">
		<form class="form-inline justify-content-end">
			<div class="form-group">
				<input type="hidden" id="boardCategory" name="boardCategory" value="${boardCategory}">
				<select id="searchBoard" name="searchBoard" class="form-control">
					<option value="board_title">제목</option>
		            <option value="board_content">내용</option>
		            <option value="board_title_content">제목+내용</option>
				</select>
			</div>
			<div class="form-group">
				<input type="text" id="searchText" name="searchText" class="form-control" placeholder="검색어를 입력하세요">
			</div>
			<div class="form-group">
				<button type="button" id="searchBoardListBtn" class="btn btn-success btn-sm">검색</button>
			</div>
		</form>
	</div>
	<br>
	<!-- 게시글 출력 -->
	<div class="col-lg-12 grid-margin stretch-card">
		<div class="card">
			<div class="card-body">
				<!-- 게시판 카테고리명 -->
				<h3 class="font-weight-bold">${boardCategoryName}</h3>
				<hr>
				<!-- 게시글 작성 버튼 분기(대표, 인사, 경영지원만 공지 작성 가능) -->
				<c:choose>
				    <c:when test="${dept == 'D0201' or dept == 'D0202' or empNo == 11111111}">
				        <div class="text-right">
				        	<a href="/JoinTree/board/addBoardForm?boardCategory=${boardCategory}" class="btn btn-success btn-sm">글작성</a>
				        </div>
				    </c:when>
				</c:choose>
				<br>
				<table id="boardListTable" class="table table-bordered">
					<thead id="pinnedList">
						<tr class="no-click" >
							<th class="font-weight-bold text-center" width="7%">번호</th>
							<th class="font-weight-bold text-center" width="55%">제목</th>
							<th class="font-weight-bold text-center">공지부서</th>
							<th class="font-weight-bold text-center">작성일</th>
							<th class="font-weight-bold text-center" width="7%">조회수</th>
						</tr>
					</thead>
					<tbody id="boardList">
					
					</tbody>
				</table>
				<br>
				<!-- 페이지 네비게이션 -->
				<div id="pagination" class="paging center pagination">
					
				</div>
			
			</div>
		</div>
	</div>		
	
	<!-- script -->
	<script src="/JoinTree/resource/js/board/boardList.js"></script>
	
	
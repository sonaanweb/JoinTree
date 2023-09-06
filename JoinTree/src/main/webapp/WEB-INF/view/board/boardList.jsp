<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	
	<!-- 게시판 카테고리명 -->
	<h3 class="col-lg-12">${boardCategoryName}</h3>
	
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
				<input type="text" id="searchText" name="searchText" class="form-control">
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
						<tr class="no-click">
							<th class="font-weight-bold">번호</th>
							<th class="font-weight-bold">제목</th>
							<th class="font-weight-bold">공지부서</th>
							<th class="font-weight-bold">작성일</th>
							<th class="font-weight-bold">조회수</th>
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
	

	<script>
		$(document).ready(function(){
			
			// 게시글 등록 성공 후 msg
			const urlParams = new URL(location.href).searchParams;
			const msg = urlParams.get("msg");
			
			if (msg != null) {
				
				alert(msg);
				
				// 쿼리 매개변수 "msg"를 제거하고 URL을 업데이트
		        urlParams.delete("msg");
		        const newUrl = `${location.pathname}?${urlParams.toString()}`;
		        history.replaceState({}, document.title, newUrl);
			}
			
			// 페이지 로드 시 검색조건 초기화
			searchBoardPinnedListResults();
			searchBoardListResults();
		});
		
		// 페이지 네비게이션 수정 함수
		function updatePagination(data){
			let pagination = $('#pagination');
			pagination.empty();
			
			// 이전 페이지 버튼
			if(data.startPage > 1){
				let prevButton = $('<button type="button" class="page-link">').text('이전');
	            prevButton.click(function() {
	                goToPage(data.startPage - 1);
	            });
	            pagination.append(prevButton);
			}
			
			// 페이지 버튼 생성
			for(let i = data.startPage; i <= data.endPage; i++){
				const page = i;
				let pageButton = $('<button type="button" class="page-link">').text(i);
		        pageButton.click(function(){
		        	goToPage(page);
		        });
		        pagination.append(pageButton);
			}
			
			// 다음 페이지 버튼
			if(data.endPage < data.lastPage){
				let nextButton = $('<button type="button" class="page-link">').text('다음');
	            nextButton.click(function() {
	                goToPage(data.endPage + 1);
	            });
	            pagination.append(nextButton);
			}
		}
		
		// 상단공지 목록 테이블(boardList) 데이터 수정 함수
		function updateBoardPinnedListTableWithData(data){
			
			// 테이블의 tbody를 선택하고 초기화
		    let thead = $('#pinnedList');
			
		 	// data의 길이만큼 테이블 행 추가
		    for (let i = 0; i < data.length; i++) {
		        let pinned = data[i];
		        let row = $('<tr class="text-danger font-weight-bold">');
		        row.append($('<td>').text(pinned.boardNo)); // 글 번호
		        row.append($('<td>').text('[필독]'+' '+pinned.boardTitle)); // 제목
		        row.append($('<td>').text(pinned.dept)); // 공지부서
		        
		        let dateOnly = pinned.createdate.split("T")[0]; // 날짜 값만 저장
		        row.append($('<td>').text(dateOnly)); // 작성일
		        
		        row.append($('<td>').text(pinned.boardCount)); // 조회수
		        thead.append(row);
		    }
		}
		
		// 공지 목록 테이블(boardList) 데이터 수정 함수
		function updateBoardListTableWithData(data){
			
			// 테이블의 tbody를 선택하고 초기화
		    let tbody = $('#boardList');
		    tbody.empty();
		    
		    // data의 길이만큼 테이블 행 추가
		    for (let i = 0; i < data.length; i++) {
		        let notice = data[i];
		        let row = $('<tr>');
		        row.append($('<td>').text(notice.boardNo)); // 글 번호
		        row.append($('<td>').text(notice.boardTitle)); // 제목
		        row.append($('<td>').text(notice.dept)); // 공지부서
		        
		        let dateOnly = notice.createdate.split("T")[0]; // 날짜 값만 저장
		        row.append($('<td>').text(dateOnly)); // 작성일
		        row.append($('<td>').text(notice.boardCount)); // 조회수
		        tbody.append(row);
		    }
		}
		
		// 상단공지 조회 결과 값 함수
		function searchBoardPinnedListResults(){
			
			// 데이터 조회
			$.ajax({
				url: '/JoinTree/board/getBoardPinnedList',
				type: 'GET',
				data:{
					boardCategory: $('#boardCategory').val()
				},
				success: function(data){
					console.log(data);
					
					updateBoardPinnedListTableWithData(data);
				},
				error: function(){
					console.log('error');
				}
			});
		}
		
		// 검색 조건별 결과 값 함수
		function searchBoardListResults(page=1){
			
			// 데이터 조회
			$.ajax({
				url: '/JoinTree/board/getBoardList',
				type: 'GET',
				data:{
					boardCategory: $('#boardCategory').val(),
					searchBoard: $('#searchBoard').val(),
					searchText: $('#searchText').val(),
					currentPage: page,
					rowPerPage: 10
				},
				success: function(data){
					console.log(data);
					
					let BoardList = data.getBoardList; // 게시글 목록
					updateBoardListTableWithData(BoardList); // 테이블 데이터 수정 함수
					updatePagination(data); // 페이지 네비게이션 데이터 수정 함수
				},
				error: function(){
					console.log('error');
				}
			});
		}
		
		// 페이지 이동 함수
		function goToPage(page){
			// 검색 및 페이지 데이터 수정 함수
		  	searchBoardListResults(page);
	    }
		
		// 검색 버튼 클릭 이벤트
		$('#searchBoardListBtn').click(function(){
			searchBoardListResults();
		});
		
		// 게시글 상세 페이지 이동
		$('#boardListTable').on('click', 'tr:not(.no-click)', function(){ // 첫 번째 tr을 제외한 tr 클릭 이벤트
			let boardNo = $(this).find('td:eq(0)').text(); // boardNo 값 저장
			let boardOneUrl = '/JoinTree/board/boardOne?boardNo=' + boardNo; // 상세페이지 url
			
			window.location.href = boardOneUrl; // 상세 페이지 이동
		});
	</script>
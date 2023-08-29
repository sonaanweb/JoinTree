<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!-- header -->
<jsp:include page="/WEB-INF/view/inc/header.jsp"/>
<div class="container-fluid page-body-wrapper">
	<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
		<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
		
		<!-- 검색별 조회 -->
		<div class="col-lg-12 grid-margin stretch-card">
			<div class="card">
				<div class="card-body">
					<form id="searchDocListForm">
						<input type="hidden" id="listId" name="listId" value="${listId}">
						<div>
							<div>
								<label>기안자</label>
								<input type="text" id="searchWriter" name="writer">
							</div>
							<div>
								<label>제목</label>
								<input type="text" id="searchDocTitle" name="docTitle">
							</div>
							<div>
								<label>조회일</label>
								<input type="date" id="searchStartDate" name="startDate"> &#126; 
								<input type="date" id="searchEndDate" name="endDate">
							</div>
							<div>
								<button type="button" id="searchDocListBtn">검색</button>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
		
		<!-- 검색별 문서 목록 출력 -->
		<div class="col-lg-12 grid-margin stretch-card">
			<div class="card">
				<div class="card-body">
					<table class="table">
						<thead>
							<tr>
								<th>기안일</th>
								<th>기안양식</th>
								<th>제목</th>
								<th>기안자</th>
								<th>상태</th>
								<th colspan="2">&nbsp;</th>
							</tr>
						</thead>
						<tbody id="docList">
						
						</tbody>
					</table>
					
					<!-- 페이지 네비게이션 -->
					<div id="pagination">
					
					</div>
					
				</div>
			</div>
		</div>
	
	</div>
</div>
<script>
	
	$(document).ready(function(){
		
		// 페이지 로드 시 검색조건 초기화
		docListResults();
	});
	
	// 페이지 네비게이션 수정 함수
	function updatePagination(data){
		let pagination = $('#pagination');
		pagination.empty();
		
		// 이전 페이지 버튼
		if(data.startPage > 1){
			let prevButton = $('<button type="button" class="page-btn">').text('이전');
            prevButton.click(function() {
                goToPage(data.startPage - 1);
            });
            pagination.append(prevButton);
		}
		
		// 페이지 버튼 생성
		for(let i = data.startPage; i <= data.endPage; i++){
			const page = i;
			let pageButton = $('<button type="button" class="page-btn">').text(i);
	        pageButton.click(function(){
	        	goToPage(page);
	        });
	        pagination.append(pageButton);
		}
		
		// 다음 페이지 버튼
		if(data.endPage < data.lastPage){
			let nextButton = $('<button type="button" class="page-btn">').text('다음');
            nextButton.click(function() {
                goToPage(data.endPage + 1);
            });
            pagination.append(nextButton);
		}
	}
	
	// 문서함별 사원 목록 테이블(docList) 테이터 수정 함수
	function updateDocListTableData(data){
		
		// 테이블의 tbody를 선택하고 초기화
	    let tbody = $('#docList');
	    tbody.empty();
	    
	    // data의 길이만큼 테이블 행 추가
	    for (let i = 0; i < data.length; i++) {
	        let doc = data[i];
	        let row = $('<tr>');
	        let dateOnly = doc.createdate.split("T")[0];
	        row.append($('<td>').text(dateOnly)); // 기안일
	        row.append($('<td>').text(doc.category)); // 기안 양식
	        row.append($('<td>').text(doc.docTitle)); // 부서명
	        row.append($('<td>').text(doc.empNo + " " + doc.writer)); // 기안자(사번 + 이름)
	        row.append($('<td>').text(doc.docStatus)); // 상태
	        tbody.append(row);
	    }
	}
	
	// 검색 조건별 결과 값 함수
	function docListResults(page=1){
		
		// 데이터 조회
		$.ajax({
			url: '/JoinTree/getDocumentList',
			type: 'GET',
			data: {
				listId: $('#listId').val(), // 문서함 id
				writer: $('#searchWriter').val(), // 기안자
				docTitle: $('#searchDocTitle').val(), // 문서제목
				startDate: $('#searchStartDate').val(), // 조회 시작일
				endDate: $('#searchEndDate').val(), // 조회 종료일
				currentPage: page,
				rowPerPage: 10
			},
			success: function(data){
				console.log(data);
				
				let docList = data.searchDocListbyPage; // 문서 목록
				updateDocListTableData(docList); // 테이블 데이터 수정 함수
				updatePagination(data); // 페이지 네비게이션 데이터 수정 함수
			},
			error: function(error){
				console.error(error);
			}
		});
	}
	
	// 페이지 이동 함수
	function goToPage(page){
		// 검색 및 페이지 데이터 수정 함수
	  	docListResults(page);
    }
	
	// 검색 버튼 클릭 이벤트
	$('#searchDocListBtn').click(function(){
		docListResults();
	});
	
</script>
</html>
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
								<th>문서번호</th>
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

	<!-- 문서 상세정보 모달창 -->
	<div class="modal" id="docOneModal">
		<div class="modal-dialog modal-xl">
			<div class="modal-content" id="docOneModalContent">
				
				<!-- Modal Header -->
				<div class="modal-header">
					<h4 class="modal-title"></h4>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
				</div>
				
				<!-- Modal body -->
				<div class="modal-body">
					
					<!-- 결재 문서 상세조회 폼 -->
					<div id="documentOneForm">
					
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
	        row.append($('<td>').text(doc.docNo)); // 문서번호
	        
	        let dateOnly = doc.createdate.split("T")[0]; // 기안일 날짜 값만 저장
	        row.append($('<td>').text(dateOnly)); // 기안일
	        
	        row.append($('<td>').text(doc.category)); // 기안 양식
	        row.append($('<td>').text(doc.docTitle)); // 부서명
	        row.append($('<td>').text(doc.empNo + " " + doc.writer)); // 기안자(사번 + 이름)
	        row.append($('<td>').text(doc.docStatus)); // 상태
	        
	        // 문서 카테고리 숨김 요소로 추가
	        let docCode = $('<input id="docCode">').attr('type', 'hidden').val(doc.docCode);
	        row.append(docCode);
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
				let docCode = docList.docCode; // 문서 카테고리
				
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
	
	// 결재자 서명 경로 설정 함수
	function setDocStamp(docStampId, docStampValue){
		let docStampSrc = $(docStampId);
		if(docStampValue){
			docStampSrc.attr('src', '${pageContext.request.contextPath}/empImg/' + docStampValue);	
		} else{
			docStampSrc.hide();
		}
	}
	
	
	
	// 문서별 상세문서 양식 모달창 업데이트
	async function updateDocumentOneForm(documentCode) {
	    return new Promise((resolve, reject) => {
	        $.ajax({
	            type: 'GET',
	            url: '/JoinTree/document/getDocumentOneForm',
	            data: {
	                docCode: documentCode
	            },
	            success: function (data) {
	                $('#documentOneForm').html(data);
	                resolve(); // 업데이트 완료 후 프로미스 resolve 호출
	            }
	        });
	    });
	}
	
	// 문서결재 상세정보 조회
	async function getDocOne(documentNo, documentCode) {
	    return new Promise((resolve, reject) => {
	        // 상세 정보 가져오기
	        $.ajax({
	            url: '/JoinTree/getDocumentOne',
	            type: 'GET',
	            data: {
	                docNo: documentNo,
	                docCode: documentCode
	            },
	            success: function (data) {
	                
	            	// 결재문서 상세정보 값 변수에 저장
					let docNo = data.docNo; // 문서번호
					let createdate = data.createdate.split("T")[0]; // 기안일
					let writer = data.writer; // 기안자
					let docStamp1 = data.docStamp1; // 기안자 서명
					let docStamp2= data.docStamp2; // 결제자1 서명
					let docStamp3 = data.docStamp3; // 결제자2 서명
					let reference = data.reference; // 참조자
					let receiverTeam = data.receiverTeam; // 수신팀
					let docTitle = data.docTitle; // 문서 제목
					let docContent = data.docContent; // 문서 내용
					let dept = data.dept; // 기안부서
					let position = data.position; // 기안자 직급
					let docSaveFileName = data.docSaveFileName; // 첨부파일
					let signer1Name = data.signer1Name; // 결제자1 사원명
					let signer1Position = data.signer1Position; // 결제자1 직급
					let signer2Name = data.signer2Name; // 결제자2 사원명
					let signer2Position = data.signer2Position; // 결제자2 직급
					
					// 사원 상세정보 값 설정
					$('#docNo').text(docNo);
					$('#createdate').text(createdate);
					$('.writer').text(writer);
					$('#reference').text(reference);
					$('#receiverTeam').text(receiverTeam);
					$('#docTitle').text(docTitle);
					$('#docContent').text(docContent);
					$('#dept').text(dept);
					$('#position').text(position);
					$('#signer1Name').text(signer1Name);
					$('#signer1Position').text(signer1Position);
					$('#signer2Name').text(signer2Name);
					$('#signer2Position').text(signer2Position);
					
					// 서명 경로 설정(setDocStamp : 결재자 서명 경로 설정 함수)
					setDocStamp('#docStamp1', docStamp1); // 기안자 서명 경로 설정
					setDocStamp('#docStamp2', docStamp2); // 결재자2 서명 경로 설정
					setDocStamp('#docStamp3', docStamp3); // 결재자3 서명 경로 설정
					
					// 첨부파일 경로 설정
					let docSaveFileNameHref = $('#docSaveFileName');
					docSaveFileNameHref.attr('href', '${pageContext.request.contextPath}/docFile/' + docSaveFileName); // 파일 경로설정
					docSaveFileNameHref.download = docSaveFileName; // 다운로드할 파일 이름
	            	
	                resolve(); // 호출 완료 후 프로미스 resolve 호출
	            },
	            error: function () {
	                console.log('error');
	                reject(); // 에러 발생 시 프로미스 reject 호출
	            }
	        });
	    });
	}

	// 문서결재 상세폼
	$('#docList').on('click', 'tr', async function () {
	    try {
	        let documentNo = $(this).find('td:eq(0)').text(); // docNo 값
	        let documentCode = $('#docCode').val(); // docCode 값
	
	        await updateDocumentOneForm(documentCode); // 상세 문서양식 폼
	        await getDocOne(documentNo, documentCode); // 문서 상세내용 조회
	
	        // 모든 비동기 작업이 완료된 후에 모달창을 열어줌
	        $('#docOneModal').modal('show');
	    } catch (error) {
	        console.error(error);
	    }
	});

</script>
</html>
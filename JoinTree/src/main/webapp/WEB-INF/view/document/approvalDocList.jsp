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
						<input type="hidden" id="listId" name="listId" value="approvalDocList">
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
					
					<!-- 결재, 반려 버튼 -->
					<div>
						<button type="button" id="ApprovalBtn">결재</button>
						<button type="button" id="rejectBtn">반려</button>
					</div>
					
				</div>
				
			</div>
		</div>
	</div>
<script src="/JoinTree/resource/js/docListAndOne.js"></script>	
<script>
	// docList tr click 이벤트 : docOneModal 열기
	$('#docList').on('click', 'tr', async function () {
	    let documentNo = $(this).find('td:eq(0)').text();
	    let documentCode = $(this).data('docCode');
	    console.log(documentCode+"<-- documentCode");
	
	    try {
	        await updateDocumentOneForm(documentCode); // 상세 문서양식 폼 업데이트 비동기 처리
	        await getDocOne(documentNo, documentCode); // 문서 상세내용 조회 비동기 처리
	
	        // 모든 비동기 작업이 완료된 후에 모달창을 열어줌
	        $('#docOneModal').modal('show');
	    } catch (error) {
	        console.error(error);
	    }
	});
</script>
</html>
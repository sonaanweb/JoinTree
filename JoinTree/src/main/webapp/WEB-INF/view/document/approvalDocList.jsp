<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<style>
	.selected-page {
	    font-weight: bold;
	    background-color: #D4F4FA;
	    pointer-events: none; /* 버튼 클릭 불가 */
	}
	.selectde-tr:hover {
		cursor: pointer;
		background-color: #F9F9F9;
	}
</style>
<!-- header -->
<jsp:include page="/WEB-INF/view/inc/header.jsp"/>
<div class="container-fluid page-body-wrapper">
	<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
		<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
		
		<!-- 검색별 조회 -->
		<div class="col-lg-12 grid-margin stretch-card">
			<div class="card">
				<div class="card-body">
					<h3 class="font-weight-bold">결재함</h3>
					<hr>
					<form id="searchDocListForm">
						<input type="hidden" id="listId" name="listId" value="approvalDocList">
						<div class="col form-row">
							<div class="col-md-4">
								<div class="form-group row">
									<label for="searchWriter" class="col-form-label"><strong>기안자</strong></label>
									<div class="col-sm-9">
										<input type="text" id="searchWriter" name="writer" class="form-control">		
									</div>
								</div>
							</div>
							<div class="col-md-4">
								<div class="form-group row">
									<label for="searchDocTitle" class="col-form-label"><strong>제목</strong></label>
									<div class="col-sm-9">
										<input type="text" id="searchDocTitle" name="docTitle" class="form-control">		
									</div>
								</div>
							</div>
							<div class="col-md-4">
								<div class="form-group row">
									<label for="searchStartDate" class="col-form-label"><strong>조회일</strong></label>
									<div class="col-sm-5">
										<input type="date" id="searchStartDate" name="startDate" class="form-control">		
									</div>
									<span>&#126;</span>
									<div class="col-sm-5">
										<input type="date" id="searchEndDate" name="endDate" class="form-control">		
									</div>
								</div>
							</div>	
						</div>
						<!-- 검색 버튼 -->
						<div class="text-center">
							<button type="button" id="searchDocListBtn" class="btn btn-dark btn-md">검색</button>
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
								<th class="font-weight-bold text-center" width="7%">문서번호</th>
								<th class="font-weight-bold text-center">기안일</th>
								<th class="font-weight-bold text-center">기안양식</th>
								<th class="font-weight-bold" width="60%">제목</th>
								<th class="font-weight-bold">기안자</th>
								<th class="font-weight-bold text-center">상태</th>
							</tr>
						</thead>
						<tbody id="docList">
						
						</tbody>
					</table>
					
					<!-- 페이지 네비게이션 -->
					<div id="pagination" class="paging center pagination">
					
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
					<button type="button" class="btn btn-close" data-bs-dismiss="modal" aria-label="Close">
						<span>x</span>
					</button>
				</div>
				
				<!-- Modal body -->
				<div class="modal-body">
					<div class="col-lg-12 grid-margin stretch-card">
						<div class="card">
							<div class="card-body">
							
								<!-- 결재 문서 상세조회 폼 -->
								<div id="documentOneForm">
								
								
								</div>
							
							</div>
						</div>
					</div>		
					<!-- 결재, 반려 버튼 -->
					<div id="approvalAndRejectBtn" class="text-center">
						<button type="button" id="approvalBtn" class="btn btn-dark btn-md">결재</button>
						<button type="button" id="rejectBtn" class="btn btn-dark btn-md">반려</button>
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
		
 
  	 // 'approvalBtn' 버튼 클릭 이벤트 핸들러 내부에서
	 $('#approvalBtn').click(function() {
	   
	    if (confirm("결재를 진행하시겠습니까?")) {
	
	        // 현재 선택된 문서 번호 가져오기
	        let documentNo = $('#docNo').text();
	
	        // 상태 정보를 서버로 전송하는 코드
	        $.ajax({
	            url: '/JoinTree/document/approveDocument',
	            type: 'POST',
	            data: {
	                docNo: documentNo 
	            },
	            success: function(response) {
	                if (response === 'success') {
	                    // 성공한 경우 처리
	                    alert("결재 성공");
	                    location.reload(); // 현재 메인 페이지 새로고침
	                } else {
	                    // 실패한 경우 처리
	                    alert("결재 실패. 서명을 먼저 등록해주세요.");
	                }
	            },
	            error: function(error) {
	                alert("서버 오류 발생. 관리자에게 문의해주세요.");
	            }
	        });
	    }
	});
   
    // 반려 버튼
	$('#rejectBtn').click(function() {
    if (confirm("문서를 반려하시겠습니까?")) {
        let documentNo = $('#docNo').text();

        $.ajax({
            url: '/JoinTree/document/reject',
            type: 'POST',
            data: {
                docNo: documentNo 
            },
            success: function(response) {
                if (response === 'success') {
                    alert("문서 반려 완료");
                    location.reload(); // 현재 메인 페이지 새로고침
                } else {
                    alert("문서 반려 실패");
                }
            },
            error: function(error) {
                alert("서버 오류 발생. 관리자에게 문의해주세요.");
            }
        });
    }
});
</script>
</html>
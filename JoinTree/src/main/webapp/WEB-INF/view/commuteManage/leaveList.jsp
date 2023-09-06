<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<style>
	.selected-page {
	    font-weight: bold;
	    background-color: #D4F4FA;
	    pointer-events: none; /* 버튼 클릭 불가 */
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
						<h3 class="font-weight-bold">연가 관리</h3>
						<hr>
						<!-- 연가 목록 검색 폼 -->
						<form id="searchAnnualLeaveListForm">
							<div class="col form-row">
								<div class="col-md-4">
									<div class="form-group row">
										<label for="searchEmpNo" class="col-form-label" style="margin-right: 25px"><strong>사번</strong></label>
										<div class="col-sm-9">
											<input type="text" id="searchEmpNo" name="empNo" class="form-control">
										</div>
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group row">
										<label for="searchEmpName" class="col-form-label"><strong>사원명</strong></label>
										<div class="col-sm-9">
											<input type="text" id="searchEmpName" name="empName" class="form-control">
										</div>
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group row">
										<label for="searchActive" class="col-form-label"><strong>재직상태</strong></label>
										<div class="col-sm-9">
											<select id="searchActive" name="active" class="form-control">
												<option value="">선택하세요</option>
												<c:forEach var="a" items="${activeCodeList}">
													<option value="${a.code}">${a.codeName}</option>
												</c:forEach>
											</select>
										</div>
									</div>
								</div>
							</div>	
							<div class="col form-row">
								<div class="col-md-4">
									<div class="form-group row">
										<label for="searchLeaveType" class="col-form-label"><strong>연가구분</strong></label>
										<div class="col-sm-9">
											<select id="searchLeaveType" name="leaveType" class="form-control">
												<option value="">선택하세요</option>
												<c:forEach var="l" items="${leaveCodeList}">
													<option value="${l.code}">${l.codeName}</option>
												</c:forEach>
											</select>
										</div>
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group row">
										<label for="searchYear" class="col-form-label" style="margin-right: 15px"><strong>연도</strong></label>
										<div class="col-sm-9">
											<select id="searchYear" name="year" class="form-control">
												<option value="">선택하세요</option>
												<!-- 나머지 옵션 동적으로 생성 -->
											</select>
										</div>
									</div>
								</div>
								<div class="col-md-4">
									<div class="form-group row">
										<label for="searchStartDate" class="col-form-label" style="margin-right: 15px"><strong>조회일</strong></label>
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
							
							<div class="center">
								<button type="button" id="searchLeaveRecodeListBtn" class="btn btn-dark">검색</button>
							</div>
						</form>
						
					</div>
				</div>
			</div>		
			
			<!-- 검색별 연가 목록 출력 -->
			<div class="col-lg-12 grid-margin stretch-card">
				<div class="card">
					<div class="card-body">
						<table class="table">
							<thead>
								<tr>
									<th class="font-weight-bold">사번</th>
									<th class="font-weight-bold">부서명</th>
									<th class="font-weight-bold">사원명</th>
									<th class="font-weight-bold">연가구분</th>
									<th class="font-weight-bold">시작일</th>
									<th class="font-weight-bold">종료일</th>
									<th class="font-weight-bold">휴가일수</th>
									<th class="font-weight-bold">상태</th>
								</tr>
							</thead>
							<tbody id="leaveRecodeList">
							
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
	
	<script>
		$(document).ready(function(){
			// 페이지 로드 시 검색조건 초기화
			searchLeaveRecodeListResults();
		});
		
		let currentYear = new Date().getFullYear(); // 현재 년도
		let companyFoundationYear = 2022; // 회사 창립일
		
		let yearSelect = $('#searchYear');
		
		// yearSelect 옵션 생성 및 추가
		for (let year = currentYear; year >= companyFoundationYear; year--) {
				
			let $option = $('<option>', {
				value: year,
				text: year + "년"
			});
			yearSelect.append($option);
		}
		
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
		        
				// 현재 페이지일 때 'selected-page' 클래스 추가
		        if (page === data.currentPage) {
		        	pageButton.addClass('selected-page');
   					pageButton.prop('disabled', true); // 현재 페이지 버튼 비활성화
		        } 
				
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
		
		// 검색별 연가 목록 테이블(annualLeaveList) 데이터 수정 함수
		function updateLeaveRecodeListTableWithData(data){
			
			// 테이블의 tbody를 선택하고 초기화
		    let tbody = $('#leaveRecodeList');
		    tbody.empty();
		    
		    // data의 길이만큼 테이블 행 추가
		    for (let i = 0; i < data.length; i++) {
		        let leave = data[i];
		        let row = $('<tr>');
		        row.append($('<td>').text(leave.empNo)); // 사번
		        row.append($('<td>').text(leave.dept)); // 부서명
		        row.append($('<td>').text(leave.empName)); // 사원명
		        row.append($('<td>').text(leave.leaveType)); // 연가 구분
		        row.append($('<td>').text(leave.startDate)); // 시작일
		        row.append($('<td>').text(leave.endDate)); // 종료일
		        row.append($('<td>').text(leave.leavePeriodDate)); // 휴가일수
		        row.append($('<td>').text(leave.active)); // 사원 활성화 상태
		        tbody.append(row);
		    }
		}
		
		// 검색 조건별 결과 값 함수
		function searchLeaveRecodeListResults(page=1){
			
			// 데이터 조회
			$.ajax({
				url: '/JoinTree/commuteManage/searchLeaveRecodeList',
				type: 'GET',
				data:{
					empNo: $('#searchEmpNo').val(), // 사번
					empName: $('#searchEmpName').val(), // 사원명
					leaveType: $('#searchLeaveType').val(), // 휴가구분
					year: $('#searchYear').val(),// 조회 연도
					startDate: $('#searchStartDate').val(), // 조회 시작일
					endDate: $('#searchEndDate').val(),// 조회 마지막일
					active:	$('#searchActive').val(), // 사원 활성화 상태
					currentPage: page,
					rowPerPage: 10
				},
				success: function(data){
					console.log(data);
					
					let leaveRecodeList = data.searchLeaveRecodeListByPage; // 연가 목록
					updateLeaveRecodeListTableWithData(leaveRecodeList); // 테이블 데이터 수정 함수
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
		  	searchLeaveRecodeListResults(page);
	    }
		
		// 검색 버튼 클릭 이벤트
		$('#searchLeaveRecodeListBtn').click(function(){
			searchLeaveRecodeListResults();
		});
	</script>	
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<!-- header -->
<jsp:include page="/WEB-INF/view/inc/header.jsp"/>
	<div class="container-fluid page-body-wrapper">
	<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
		<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
			
			<h3 class="col-lg-12 grid-margin">연차 목록</h3>
	
			<!-- 검색별 조회 -->
			<div class="col-lg-12 grid-margin stretch-card">
				<div class="card">
					<div class="card-body">
						
						<!-- 연차 목록 조회 폼 -->
						<form id="searchAnnualLeaveListForm">
							<div class="form-row">
								<div class="col-md-4">
									<div class="form-group row">
										<label for="searchEmpNo" class="col-form-label"><strong>사번</strong></label>
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
										<label for="searchDept" class="col-form-label"><strong>부서</strong></label>
										<div class="col-sm-9">
											<select id="searchDept" name="dept" class="form-control">
												<option value="">선택하세요</option>
												<c:forEach var="d" items="${deptCodeList}">
													<option value="${d.code}">${d.codeName}</option>
												</c:forEach>
											</select>
										</div>
									</div>
								</div>
							</div>
							<div class="center">
								<button type="button" id="searchAnnualLeaveListBtn" class="btn btn-dark">검색</button>
							</div>
						</form>
					</div>
				</div>
			</div>
			
			<!-- 검색별 연차 목록 출력-->
			<div class="col-lg-12 grid-margin stretch-card">
				<div class="card">
					<div class="card-body">
						<table class="table">
							<thead>
								<tr>
									<th>사번</th>
									<th>부서</th>
									<th>사원명</th>
									<th>사용가능 연차</th>
								</tr>
							</thead>
							<tbody id="annualLeaveList">
						
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
			searchAnnualLeaveListResults();
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
		
		// 검색별 연차 목록 테이블(annualLeaveList) 데이터 수정 함수
		function updateAnnualLeaveListTableWithData(data){
			
			// 테이블의 tbody를 선택하고 초기화
		    let tbody = $('#annualLeaveList');
		    tbody.empty();
		    
		    // data의 길이만큼 테이블 행 추가
		    for (let i = 0; i < data.length; i++) {
		        let annual = data[i];
		        let row = $('<tr>');
		        row.append($('<td>').text(annual.empNo));
		        row.append($('<td>').text(annual.dept));
		        row.append($('<td>').text(annual.empName));
		        row.append($('<td>').text(annual.annualCount));
		        tbody.append(row);
		    }
		}
		
		// 검색 조건별 결과 값 함수
		function searchAnnualLeaveListResults(page=1){
			
			// 데이터 조회
			$.ajax({
				url: '/JoinTree/commuteManage/searchAnnualLeaveList',
				type: 'GET',
				data:{
					empNo: $('#searchEmpNo').val(),
					empName: $('#searchEmpName').val(),
					dept: $('#searchDept').val(),
					currentPage: page,
					rowPerPage: 10
				},
				success: function(data){
					console.log(data);
					
					let annualLeaveList = data.searchAnnualLeaveListByPage; // 연차 목록
					updateAnnualLeaveListTableWithData(annualLeaveList); // 테이블 데이터 수정 함수
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
		  	searchAnnualLeaveListResults(page);
	    }
		
		// 검색 버튼 클릭 이벤트
		$('#searchAnnualLeaveListBtn').click(function(){
			searchAnnualLeaveListResults();
		});
	</script>	
</html>
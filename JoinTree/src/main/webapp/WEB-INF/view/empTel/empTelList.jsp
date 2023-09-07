<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<!-- header -->
	<jsp:include page="/WEB-INF/view/inc/header.jsp"/> 


	<div class="container-fluid page-body-wrapper">
		<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
		<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
		
			<!-- 검색폼 -->
			<div class="col-lg-12 grid-margin stretch-card">
				<div class="card">
					<div class="card-body">
						<form>
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
													<div>
												</div>
												
											</div>
								
							</div>
							<div class="center">
								<button type="button" id="searchEmpListBtn" class="btn btn-dark">검색</button>
								</div>
						</form>
					</div>
				</div>
			</div>
							
									<div class="col-lg-12 grid-margin stretch-card">
										<div class="card">
											<div class="card-body">
												<table class="table">
													<thead>
														<tr>
															<th>사번</th>
															<th>사원명</th>
															<th>부서</th>
															<th>직급</th>
															<th>연락처</th>
															<th>내선번호</th>
														</tr>
													</thead>
													<tbody id="empTelList">
													
													</tbody>
												</table>	
												<!-- 페이지 네비게이션 -->
												<div class="paging center pagination margin-top20" id="pagination">
								
												</div>
											</div>
										</div>
									</div>
			
			
			
		</div>
	</div>
                      
	
	<!-- footer -->
	<jsp:include page="/WEB-INF/view/inc/footer.jsp"/>	
	
<script>
$(document).ready(function() {
	searchEmpTelListResults();
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
	
	// 검색별 사원 목록 테이블(empInfoList) 데이터 수정 함수
	function updateTableWithData(data) {
	    // data는 서버에서 반환된 JSON 데이터
	    // data 객체 속성에 접근하여 값 추출
	    let empList = data.searchEmpListByPage;
	    
	    // 테이블의 tbody를 선택하고 초기화
	    let tbody = $('#empTelList');
	    tbody.empty();

	    // data의 길이만큼 테이블 행을 추가
	    for (let i = 0; i < empList.length; i++) {
	        let emp = empList[i];
	        let row = $('<tr>');
	        row.append($('<td>').text(emp.empNo));
	        row.append($('<td>').text(emp.empName));
	        row.append($('<td>').text(emp.dept));
	        row.append($('<td>').text(emp.position));
	        row.append($('<td>').text(emp.empPhone));
	        row.append($('<td>').text(emp.empExtensionNo));
	        tbody.append(row);
	    }
	}
	
	// 검색 조건별 결과 값 함수
	function searchEmpTelListResults(page =1){
		
		// 검색 조건
		let searchEmpList = {
			empNo: $('#searchEmpNo').val(),
			empName: $('#searchEmpName').val(),
			dept: $('#searchDept').val(),
		};
		
		// 데이터 조회
		$.ajax({
			url: '/JoinTree/empManage/searchEmpList',
			type: 'GET',
			data: {
				empNo: $('#searchEmpNo').val(),
				empName: $('#searchEmpName').val(),
				dept: $('#searchDept').val(),
				currentPage: page, // 현재페이지
				rowPerPage: 10 // 한 페이지당 행의 수
			},
			success: function(data){
				console.log(data);
		        updateTableWithData(data); // 테이블 데이터 수정 함수
		        updatePagination(data); // 페이지 네비게이션 데이터 수정 함수
			},
			error: function(){
				console.log("AJAX 요청 중 오류가 발생했습니다.");
			}
		});
	}
	
	// 페이지 이동 함수
	function goToPage(page){
		// 검색 및 페이지 데이터 수정 함수
	  	searchEmpTelListResults(page);
    } 
	
	// 검색 버튼 클릭 이벤트
	$('#searchEmpListBtn').click(function(){
		searchEmpTelListResults();
	});
	



</script>
</html>
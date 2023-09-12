<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<link rel="stylesheet" type="text/css" href="/JoinTree/resource/css/custom.css">
<!-- header -->
<jsp:include page="/WEB-INF/view/inc/header.jsp"/>
	<div class="container-fluid page-body-wrapper">
	<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
		<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
			
			<!-- 검색별 조회 -->
			<div class="col-lg-12 grid-margin stretch-card">
				<div class="card">
					<div class="card-body">
						<h3 class="font-weight-bold">연차 관리</h3>
						<hr>
						<!-- 연차 목록 조회 폼 -->
						<form id="searchAnnualLeaveListForm">
							<div class="col form-row">
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
								<button type="button" id="searchAnnualLeaveListBtn" class="btn btn-dark btn-md">검색</button>
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
									<th class="font-weight-bold text-center" width="20%">사번</th>
									<th class="font-weight-bold text-center" width="20%">부서</th>
									<th class="font-weight-bold text-center" width="20%">사원명</th>
									<th class="font-weight-bold text-center" width="20%">잔여연차</th>
									<th class="font-weight-bold text-center" width="20%">연차발생 알림</th>
								</tr>
							</thead>
							<tbody id="annualLeaveList">
						
							</tbody>
						</table>
						<br>
						<!-- 페이지 네비게이션 -->
						<div id="pagination" class="paging center pagination">
								
						</div>
						
					</div>
				</div>
			</div>			
			
		</div>
	</div>
	
	<!-- 연차관리 모달창 -->
	<jsp:include page="./annualLeaveModal.jsp"></jsp:include>
	
	<!-- footer -->
	<jsp:include page="/WEB-INF/view/inc/footer.jsp"/>
	
	<!-- script -->
	<script src="/JoinTree/resource/js/commuteManage/annualLeaveList.js"></script>	
</html>
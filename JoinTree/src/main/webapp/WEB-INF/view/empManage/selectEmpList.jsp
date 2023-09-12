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
			
			<!-- 사원등록 모달창 버튼 -->
			<div class="col-lg-12 text-right">
				<button type="button" id="addEmpModalBtn" class="btn btn-dark" 
						data-bs-toggle="modal" data-bs-target="#addEmpModal">사원등록</button>
			</div>
			<br>
			<!-- 검색별 조회 -->
			<div class="col-lg-12 grid-margin stretch-card">
				<div class="card">
					<div class="card-body">
						<h3 class="font-weight-bold">사원 수&nbsp;&#58;&nbsp; ${empCnt}명</h3>
						<hr>
						<!-- 사원 목록 검색 폼 -->
						<form id="searchEmpListForm">
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
										<label for="searchStartEmpHireDate" class="col-form-label" style="margin-right: 10px"><strong>입사일</strong></label>
										<div class="col-sm-5">
											<input type="date" id="searchStartEmpHireDate" name="startEmpHireDate" class="form-control"> 
										</div>
										<span>&#126;</span>
										<div class="col-sm-5">	 
											<input type="date" id="searchEndEmpHireDate" name="endEmpHireDate" class="form-control">
										</div>
									</div>
								</div>
							</div>
							<div class="col form-row">
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
								<div class="col-md-4">
									<div class="form-group row">
										<label for="searchPosition" class="col-form-label" style="margin-right: 15px"><strong>직급</strong></label>
										<div class="col-sm-9">
											<select id="searchPosition" name="position" class="form-control">
												<option value="">선택하세요</option>
												<c:forEach var="p" items="${positionCodeList}">
													<option value="${p.code}">${p.codeName}</option>
												</c:forEach>
											</select>
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
							<!-- 검색 버튼 -->
							<div class="center">
								<button type="button" id="searchEmpListBtn" class="btn btn-dark">검색</button>
							</div>
						</form>
						
					</div>
				</div>
			</div>			
			
			<!-- 검색별 사원 목록 출력 -->
			<div class="col-lg-12 grid-margin stretch-card">
				<div class="card">
					<div class="card-body">
						<table class="table">
							<thead>
								<tr>
									<th class="font-weight-bold">사번</th>
									<th class="font-weight-bold">사원명</th>
									<th class="font-weight-bold">입사일</th>
									<th class="font-weight-bold">부서</th>
									<th class="font-weight-bold">직급</th>
									<th class="font-weight-bold">재직상태</th>
								</tr>
							</thead>
							<tbody id="empInfoList">
							
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
	
	<!-- 사원 등록 모달창 -->
	<jsp:include page="./addEmpForm.jsp"></jsp:include>
	
	<!-- 사원 상세정보, 수정 모달창 -->
	<div class="modal" id="empOneModal">
		<div class="modal-dialog modal-xl">
			<div class="modal-content" id="empOneModalContent">
			
			<!-- 사원 상세 정보 조회 -->
			<jsp:include page="./selectEmpOne.jsp"></jsp:include>

			<!-- 사원 정보 수정 -->
			<jsp:include page="./modifyEmpForm.jsp"></jsp:include>
			
			</div>
		</div>
	</div>
	
	<!-- footer -->
	<jsp:include page="/WEB-INF/view/inc/footer.jsp"/>
	
	<!-- script -->
	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script src="/JoinTree/resource/js/empManage/selectEmpList.js"></script>			
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="modal" id="addEmpModal">
	<div class="modal-dialog">
		<div class="modal-content">
		
			<!-- Modal Header -->
			<div class="modal-header d-flex align-items-center">
				<h4 class="modal-title">사원 등록</h4>
				<button type="button" class="btn btn-close" data-bs-dismiss="modal" aria-label="Close" id="addEmpModalClose">
					<span>x</span>
				</button>
			</div>
			<!-- Modal body -->
			<div class="modal-body">
				<div class="col card" style="padding-top: 35px; padding-bottom: 35px;">
					<form id="addEmpForm" method="post">
						<div class="col">
							<div class="form-group row">
								<label for="empName" class="col-form-label font-weight-bold" style="margin-right: 15px">사원명</label>
								<div class="col-sm-9">
									<input type="text" id="empName" name="empName" class="form-control">
								</div>
							</div>
						</div>
						<div class="col">
							<div class="form-group row">
								<label for="empJuminNo1" class="col-form-label font-weight-bold">주민번호</label>
								<div class="col-sm-4">
									<input type="text" id="empJuminNo1" name="empJuminNo1" class="form-control"> 
								</div>
								<span>&#45;</span>
								<div class="col-sm-5">	 
									<input type="text" id="empJuminNo2" name="empJuminNo2" class="form-control">
								</div>
							</div>
						</div>
						<div class="col">
							<div class="form-group row">
								<label for="empPhone1" class="col-form-label font-weight-bold" style="margin-right: 15px">연락처</label>
								<div class="col-sm-3">
									<input type="text" id="empPhone1" name="empPhone1" class="form-control">
								</div>
								<span>&#45;</span>
								<div class="col-sm-3">
									<input type="text" id="empPhone2" name="empPhone2" class="form-control">
								</div>  
								<span>&#45;</span>
								<div class="col-sm-3">
									<input type="text" id="empPhone3" name="empPhone3" class="form-control">
								</div> 
							</div>
						</div>
						<div class="col">
							<div class="form-group row">
								<label for="postCodeBtn" class="col-form-label font-weight-bold" style="margin-right: 25px">주소</label>
								<div class="col-sm-3">
									<input type="button" onclick="sample6_execDaumPostcode()" id="postCodeBtn" value="우편번호 찾기" class="btn btn-dark btn-sm">
								</div>
								<div class="form-group row" style="margin-left: 70px; margin-right: 30px;">
									<input type="text" name="postCode" id="sample6_postcode" placeholder="우편번호" class="form-control w-50" readonly="readonly">
									<input type="text" name="add1" id="sample6_address" placeholder="주소" class="form-control" readonly="readonly">
									<input type="text" name="add2" id="sample6_detailAddress" placeholder="상세주소" class="form-control">
									<input type="text" name="add3" id="sample6_extraAddress" placeholder="참고항목" class="form-control">
								</div>
							</div>
						</div>
						<div class="col">
							<div class="form-group row">
							<label class="col-form-label font-weight-bold" style="margin-right: 25px">부서</label>
								<div class="col-sm-5">
									<select id="deptCategory" name="dept" class="form-control">
										<option value="">선택하세요</option>
										<c:forEach var="d" items="${deptCodeList}">
											<option value="${d.code}">${d.codeName}</option>
										</c:forEach>
									</select>
								</div>
							</div>
						</div>
						<div class="col">
							<div class="form-group row">
								<label for="positionCategory" class="col-form-label font-weight-bold" style="margin-right: 25px">직급</label>
								<div class="col-sm-5">
									<select id="positionCategory" name="position" class="form-control">
										<option value="">선택하세요</option>
										<c:forEach var="p" items="${positionCodeList}">
											<option value="${p.code}">${p.codeName}</option>
										</c:forEach>
									</select>
								</div>
							</div>
						</div>
						<div class="col">
							<div class="form-group row">
								<label for="empExtensionNo" class="col-form-label font-weight-bold">내선번호</label>
								<div class="col-sm-5">
									<input type="text" id="empExtensionNo" name="empExtensionNo" class="form-control">
								</div>
							</div>
						</div>
						<div class="col">
							<div class="form-group row">
								<label for="empHireDate" class="col-form-label font-weight-bold" style="margin-right: 15px">입사일</label>
								<div class="col-sm-5">
									<input type="date" id="empHireDate" name="empHireDate" class="form-control">
								</div>
							</div>
						</div>
						<br>
						<div class="text-center">
							<button type="button" id="addEmpBtn" class="btn btn-dark btn-md">등록</button>
						</div>
					</form>
				</div>
					
			</div>
		</div>
	</div>
</div>
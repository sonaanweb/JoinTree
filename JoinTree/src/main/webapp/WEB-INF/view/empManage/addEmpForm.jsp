<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="modal" id="addEmpModal">
	<div class="modal-dialog">
		<div class="modal-content">
		
			<!-- Modal Header -->
			<div class="modal-header">
				<h4 class="modal-title">사원 등록</h4>
				<button type="button" class="btn-close" data-bs-dismiss="modal" id="addEmpModalClose"></button>
			</div>
		
			<!-- Modal body -->
			<div class="modal-body">
				<form id="addEmpForm" method="post">
					<div>
						<div>사원명</div>
						<input type="text" id="empName" name="empName">
					</div>
					<div>
						<div>주민번호</div>
						<input type="text" id="empJuminNo1" name="empJuminNo1"> &#45; 
						<input type="text" id="empJuminNo2" name="empJuminNo2">
					</div>
					<div>
						<div>연락처</div>
						<input type="text" id="empPhone1" name="empPhone1"> &#45; 
						<input type="text" id="empPhone2" name="empPhone2"> &#45; 
						<input type="text" id="empPhone3" name="empPhone3">
					</div>
					<div>
						<div>주소</div>
						<div>
							<input type="text" name="postCode" id="sample6_postcode" placeholder="우편번호" readonly="readonly">
						</div>
						<div>
							<input type="button" onclick="sample6_execDaumPostcode()" id="postCodeBtn" value="우편번호 찾기" class="btn btn-primary">
						</div>
						<div>
							<input type="text" name="add1" id="sample6_address" placeholder="주소" class="form-control" readonly="readonly">
							<input type="text" name="add2" id="sample6_detailAddress" placeholder="상세주소" class="form-control">
							<input type="text" name="add3" id="sample6_extraAddress" placeholder="참고항목" class="form-control">
						</div>
					</div>
					<div>
						<div>부서</div>
						<select id="deptCategory" name="dept">
							<option value="">선택하세요</option>
							<c:forEach var="d" items="${deptCodeList}">
								<option value="${d.code}">${d.codeName}</option>
							</c:forEach>
						</select>
					</div>
					<div>
						<div>직급</div>
						<select id="positionCategory" name="position">
							<option value="">선택하세요</option>
							<c:forEach var="p" items="${positionCodeList}">
								<option value="${p.code}">${p.codeName}</option>
							</c:forEach>
						</select>
					</div>
					<div>
						<div>내선번호</div>
						<input type="text" id="empExtensionNo" name="empExtensionNo">
					</div>
					<div>
						<div>입사일</div>
						<input type="date" id="empHireDate" name="empHireDate">
					</div>
					<div class="text-center">
						<button type="button" id="addEmpBtn">등록</button>
					</div>
				</form>
			</div>
		</div>
	</div>
</div>
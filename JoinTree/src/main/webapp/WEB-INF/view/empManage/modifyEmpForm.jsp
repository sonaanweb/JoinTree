<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div id="modifyEmpFormModalContent">
	<!-- Modal Header -->
	<div class="modal-header d-flex align-items-center">
		<h4 class="modal-title">사원 정보 수정</h4>
		<button type="button" class="btn btn-close" data-bs-dismiss="modal" aria-label="Close" id="empOneModalClose">
			<span>x</span>
		</button>
	</div>
	
	<!-- Modal body -->
	 <div class="modal-body">
		<div class="col card" style="padding-top: 35px; padding-bottom: 35px;">
			<!-- 사원 정보 수정 폼 -->
			<form id="modifyEmpForm" method="post">
				<div class="col" style="margin-bottom: 15px;">
					<table class="table">
						<tr>
							<td rowspan="4" style="width: 20%">
								<img src="" class="empImgOne" style="width: 200px; height: 170px;">
							</td>
							<td class="font-weight-bold" style="width: 10%">사번</td>
							<td style="width: 35%">
								<span class="empNoOne"></span>
								<input type="hidden" id="modifyEmpNo" name="empNoOne">
							</td>
							<td class="font-weight-bold" style="width: 10%">부서</td>
							<td>
								<input type="hidden" id="departBeforeNo" name="departBeforeNoOne">
								<select id="modifyDept" class="form-control">
									<c:forEach var="d" items="${deptCodeList}">
										<option value="${d.code}">${d.codeName}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<td class="font-weight-bold">사원명</td>
							<td><span class="empNameOne"></span></td>
							
							<td class="font-weight-bold">직급</td>
							<td>
								<input type="hidden" id="positionBeforeLevel" name="positionBeforeLevelOne">
								<select id="modifyPosition" class="form-control">
									<c:forEach var="p" items="${positionCodeList}">
										<option value="${p.code}">${p.codeName}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<td class="font-weight-bold">주민번호</td>
							<td><span class="empJuminNoOne"></span></td>
							
							<td class="font-weight-bold">내선번호</td>
							<td>
								<input type="text" id="modifyEmpExtensionNo" name="empExtensionNoOne" class="form-control">
							</td>
						</tr>
						<tr>
							<td class="font-weight-bold">연락처</td>
							<td><span class="empPhoneOne"></span></td>
							
							<td class="font-weight-bold">입사일</td>
							<td>
								<input type="date" id="modifyEmpHireDate" name="empHireDateOne" class="form-control">
							</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td class="font-weight-bold">주소</td>
							<td><span class="empoAddressOne"></span></td>
							
							<td class="font-weight-bold">퇴사일</td>
							<td>
								<input type="date" id="modifyEmpLastDate" name="empLastDateOne" class="form-control">
							</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td class="font-weight-bold">재직상태</td>
							<td>
								<select id="modifyEmpAtive" class="form-control">
									<c:forEach var="a" items="${activeCodeList}">
										<option value="${a.code}">${a.codeName}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
					</table>
					<br>
					<!-- 확인, 취소 버튼 -->
					<div class="text-center">
						<button type="button" id="modifyEmpConfirmBtn" class="btn btn-dark btn-md">확인</button>
						<button type="button" id="modifyEmpCancelBtn" class="btn btn-dark btn-md">취소</button>
					</div>
				</div>
			</form>
		</div>
		
	</div>	
</div>

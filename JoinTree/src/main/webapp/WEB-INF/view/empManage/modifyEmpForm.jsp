<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div id="modifyEmpFormModalContent">
	<!-- Modal Header -->
	<div class="modal-header">
		<h4 class="modal-title">사원 정보 수정</h4>
		<button type="button" class="btn-close" data-bs-dismiss="modal" id="empOneModalClose"></button>
	</div>
	
	<!-- 사원 정보 수정 폼 -->
	<form id="modifyEmpForm" method="post">
		<div>
			<div>
				<img src="" class="empImgOne" style="width: 200px; height: 170px;">
			</div>
		</div>
		<div>
			<div>사번</div>
			<div>
				<span class="empNoOne"></span>
				<input type="hidden" id="modifyEmpNo" name="empNoOne">
			</div>
		</div>
		<div>
			<div>사원명</div>
			<div>
				<span class="empNameOne"></span>
			</div>
		</div>
		<div>
			<div>주민번호</div>
			<div>
				<span class="empJuminNoOne"></span> 
			</div>  
		</div>
		<div>
			<div>연락처</div>
			<div>
				<span class="empPhoneOne"></span>
			</div>
		</div>
		<div>
			<div>주소</div>
			<div>
				<span class="empoAddressOne"></span>
			</div>
		</div>
		<div>
			<div>부서</div>
			<input type="hidden" id="departBeforeNo" name="departBeforeNoOne">
			<select id="modifyDept">
				<c:forEach var="d" items="${deptCodeList}">
					<option value="${d.code}">${d.codeName}</option>
				</c:forEach>
			</select>
		</div>
		<div>
			<div>직급</div>
			<input type="hidden" id="positionBeforeLevel" name="positionBeforeLevelOne">
			<select id="modifyPosition">
				<c:forEach var="p" items="${positionCodeList}">
					<option value="${p.code}">${p.codeName}</option>
				</c:forEach>
			</select>
		</div>
		<div>
			<div>재직상태</div>
			<select id="modifyEmpAtive">
				<c:forEach var="a" items="${activeCodeList}">
					<option value="${a.code}">${a.codeName}</option>
				</c:forEach>
			</select>
		</div>
		<div>
			<div>내선번호</div>
			<input type="text" id="modifyEmpExtensionNo" name="empExtensionNoOne">
		</div>
		<div>
			<div>입사일</div>
			<input type="date" id="modifyEmpHireDate" name="empHireDateOne">
		</div>
		<div>
			<div>퇴사일</div>
			<input type="date" id="modifyEmpLastDate" name="empLastDateOne">
		</div>
		<div class="text-center">
			<button type="button" id="modifyEmpConfirmBtn">확인</button>
			<button type="button" id="modifyEmpCancelBtn">취소</button>
		</div>
	</form>

	
</div>

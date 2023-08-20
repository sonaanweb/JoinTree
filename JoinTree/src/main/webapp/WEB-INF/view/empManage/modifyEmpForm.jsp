<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form id="modifyEmpForm" method="post">
		<div>
			<div class="empImgOne">
				<img alt="" src="#">
			</div>
		</div>
		<div>
			<div>사번</div>
			<div>
				<span class="empNo"></span>
				<input type="hidden" id="modifyEmpNo">
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
			<input type="hidden" id="departBeforeNo">
			<select id="modifyDeptCategory">
				<c:forEach var="d" items="${deptCodeList}">
					<option value="${d.code}">${d.codeName}</option>
				</c:forEach>
			</select>
		</div>
		<div>
			<div>직급</div>
			<input type="hidden" id="positionBeforeLevel">
			<select id="modifyPositionCategory">
				<c:forEach var="p" items="${positionCodeList}">
					<option value="${p.code}">${p.codeName}</option>
				</c:forEach>
			</select>
		</div>
		<div>
			<div>재직상태</div>
			<select id="modifyEmpAtiveCategory">
				<c:forEach var="a" items="${activeCodeList}">
					<option value="${a.code}">${a.codeName}</option>
				</c:forEach>
			</select>
		</div>
		<div>
			<div>내선번호</div>
			<input type="text" id="modifyEmpExtensionNo">
		</div>
		<div>
			<div>입사일</div>
			<input type="date" id="modifyEmpHireDate">
		</div>
		<div>
			<div>퇴사일</div>
			<input type="date" id="modifyEmpLastDate">
		</div>
		<div class="text-center">
			<button type="button" id="modifyEmpConfirmBtn">확인</button>
			<button type="button" id="modifyEmpCancelBtn">취소</button>
		</div>
	</form>
</body>
</html>
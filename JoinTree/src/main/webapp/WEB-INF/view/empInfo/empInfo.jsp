<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<!-- header -->
	<jsp:include page="/WEB-INF/view/inc/header.jsp"/> 
	<script src="/JoinTree/resource/js/empInfo/empInfo.js"></script>
	    
		<div class="container-fluid page-body-wrapper">
		<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
			<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
			
			<div class="col-lg-12 grid-margin stretch-card">
              	<div class="card">
                <div class="card-body">
				<div class="col d-flex align-items-center">
					<h3>나의 정보</h3>
				</div><br>
		
	<%-- 			현재 사용자 : ${empName}
				현재 로그인 아이디: ${loginAccount.empNo}
				싸인이름: ${signImg} --%>
				
				<table class="table" >
					<tr>
						<th>사원이미지</th>
						<td>
							<c:choose>
								<c:when test="${empty empInfo.empSaveImgName or empInfo.empSaveImgName eq '이미지 없음'}">
									사진을 등록해주세요.<br>
								</c:when>
								<c:otherwise>
									<img src="${pageContext.request.contextPath}/empImg/${empInfo.empSaveImgName}" alt="employee image" style="max-width: 300px; max-height: 300px;"><br>
								</c:otherwise>
							</c:choose>				
						</td>
					</tr>
					<tr>
						<th>사번</th>
						<td><span id="empNo" data-empno="${empInfo.empNo}">${empInfo.empNo}</span></td>
					</tr>
					<tr>
						<th>이름</th>
						<td>${empInfo.empName}</td>
					</tr>
					<tr>
						<th>주소</th>
						<td>${empInfo.empAddress}</td>
					</tr>
					<tr>
						<th>주민등록번호</th>
						<td>${empInfo.empJuminNo}</td>
					</tr>
					<tr>
						<th>연락처</th>
						<td>${empInfo.empPhone}</td>
					</tr>
					<tr>
						<th>내선번호</th>
						<td>${empInfo.empExtensionNo}</td>
					</tr>
					<tr>
						<th>부서</th>
						<td>${empInfo.dept}</td>
					</tr>
					<tr>
						<th>직급</th>
						<td>${empInfo.position}</td>
					</tr>
					<tr>
						<th>입사일</th>
						<td>${empInfo.empHireDate} (근속일수: ${getWorkDays.workDays}일 / ${getWorkDays.workYears}년 ${getWorkDays.workMonths} 개월)</td>
					</tr>
					<tr>
						<th>정보수정일</th>
						<td>${empInfo.updatedate.toString().substring(0, 19)}</td> <!--timestamp이므로 String 변환 후 자르기  -->
						<%-- <td>${empInfo.updatedate}</td> --%>
					</tr>
					<tr>
						<th>잔여 연차</th>
						<td>${annualLeave.annualCount}</td>
					</tr>
					<tr>
						<th>서명</th>
						<td>
							<c:choose>
								<c:when test="${empty empInfo.signSaveImgName or empInfo.signSaveImgName eq '이미지 없음'}">
									서명을 등록해주세요.
								</c:when>
								<c:otherwise>
									<img src="${pageContext.request.contextPath}/signImg/${empInfo.signSaveImgName}" alt="sign image" style="max-width: 300px; max-height: 300px;">
								</c:otherwise>
							</c:choose>		
							
						</td>
					</tr>
				</table>
				
					
				<a href="/JoinTree/empInfo/checkPw" class="btn btn-success btn-fw">정보 수정</a> &nbsp;
		
				<a href="/JoinTree/empInfo/modifyPw" class="btn btn-success btn-fw">비밀번호 변경</a>
				
	
			</div>
			</div>
			</div>
	
		</div>
	</div>
	<!-- footer -->
	<jsp:include page="/WEB-INF/view/inc/footer.jsp"/>
</html>
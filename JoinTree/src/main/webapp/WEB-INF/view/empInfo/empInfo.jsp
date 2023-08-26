<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<!-- header -->
	<jsp:include page="/WEB-INF/view/inc/header.jsp"/> 
	    <script>
	        $(document).ready(function() {
	            const urlParams = new URL(location.href).searchParams;
	            const msg = urlParams.get("msg");
	            if (msg != null) {
	                alert(msg);
	            }
	        });
	    </script>
	    
		<div class="container-fluid page-body-wrapper">
		<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
			<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
				
				<h1>나의 정보</h1>
		
				<%-- 현재 사용자 : ${empName} --%>
				<%-- 현재 로그인 아이디: ${loginAccount.empNo} --%>
				
				<table border="1">
					<tr>
						<td>사원이미지</td>
						<td>
							<c:choose>
								<c:when test="${empty empInfo.empSaveImgName or empInfo.empSaveImgName eq '이미지 없음'}">
									<img src="${pageContext.request.contextPath}/empImg/jointree.png" style="max-width: 200px; max-height: 200px;"><br>
								</c:when>
								<c:otherwise>
								<img src="${pageContext.request.contextPath}/empImg/${empInfo.empSaveImgName}" alt="employee image" style="max-width: 300px; max-height: 300px;"><br>
								</c:otherwise>
							</c:choose>				
						</td>
					</tr>
					<tr>
						<td>사번</td>
						<td>${empInfo.empNo}</td>
					</tr>
					<tr>
						<td>이름</td>
						<td>${empInfo.empName}</td>
					</tr>
					<tr>
						<td>주소</td>
						<td>${empInfo.empAddress}</td>
					</tr>
					<tr>
						<td>주민등록번호</td>
						<td>${empInfo.empJuminNo}</td>
					</tr>
					<tr>
						<td>연락처</td>
						<td>${empInfo.empPhone}</td>
					</tr>
					<tr>
						<td>내선번호</td>
						<td>${empInfo.empExtensionNo}</td>
					</tr>
					<tr>
						<td>부서</td>
						<td>${empInfo.dept}</td>
					</tr>
					<tr>
						<td>직급</td>
						<td>${empInfo.position}</td>
					</tr>
					<tr>
						<td>입사일</td>
						<td>${empInfo.empHireDate}</td>
					</tr>
					<tr>
						<td>정보수정일</td>
						<td>${empInfo.updatedate.toString().substring(0, 19)}</td> <!--timestamp이므로 String 변환 후 자르기  -->
						<%-- <td>${empInfo.updatedate}</td> --%>
					</tr>
					<tr>
						<td>서명</td>
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
				<div>
					<a href="/JoinTree/empInfo/checkPw">정보 수정</a>
				</div>
				<div>
					<a href="/JoinTree/empInfo/modifyPw">비밀번호 변경</a>
				</div>
	
		</div>
	</div>
</html>
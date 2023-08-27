<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<!-- header -->
	<jsp:include page="/WEB-INF/view/inc/header.jsp"/> 
	
	<!-- 필수 요소-->
	<div class="container-fluid page-body-wrapper">
		<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
			<div class="content-wrapper project"> <!-- 컨텐츠부분 wrapper -->
				<h1> ${project.projectName} 프로젝트</h1>
				<button>프로젝트 수정</button>
				<button>프로젝트 완료</button>
				<h3>담당자 : ${project.empName}</h3>
				<h3>기간 : ${project.projectStartDate.substring(0,10)} ~ ${project.projectEndDate.substring(0,10)}</h3>
				<div class="wrapper">
					<h3>팀원 : &nbsp;</h3>
					<div>
						<c:forEach var="m" items="${projectMemeber}">
							<span style="background-color: #999; border-radius: 10px; padding:4px; color: white;">${m.empName}</span>
						</c:forEach>
					</div>
				</div>
				<h3>진행률 : </h3>
				<div>
					
				</div>
				
		</div>
	</div>
	<!-- footer -->
	<jsp:include page="/WEB-INF/view/inc/footer.jsp"/>
</html>
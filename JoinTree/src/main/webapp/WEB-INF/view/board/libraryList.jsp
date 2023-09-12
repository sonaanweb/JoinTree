<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<!-- header -->
<jsp:include page="/WEB-INF/view/inc/header.jsp"/>
	<div class="container-fluid page-body-wrapper">
	<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
		<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
			
			<!-- boardList -->
			<jsp:include page="./boardList.jsp"></jsp:include>
			
		</div>
	</div>
	
	<!-- footer -->
    <jsp:include page="/WEB-INF/view/inc/footer.jsp"/>	
</html>
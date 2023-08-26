<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
					
				$("#checkPwBtn").click(function() {
					if ($("#empPw").val() == "") {
						alert("비밀번호를 입력해주세요.");
						$("#empPw").focus();
					} else {
						$("#checkPw").submit();
					}
				});
			});
	  	</script>
	  	
	  	<div class="container-fluid page-body-wrapper">
		<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
			<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
	  	

				<h1>비밀번호 확인</h1>
				
			    <form action="/JoinTree/empInfo/checkPw" method="post" id="checkPw">	        
			        <label for="empPw">Password:</label>
			        <input type="password" id="empPw" name="empPw"><br>
			       
			        <button type="button" id="checkPwBtn">입력</button>
		   		</form>
				
				<div>
					<a href="/JoinTree/empInfo/empInfo">이전</a>
				</div>
			</div>
		</div>
</html>
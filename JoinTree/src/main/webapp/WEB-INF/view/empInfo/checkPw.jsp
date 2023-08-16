<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>checkPw</title>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
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
	</head>
	<body>
		<h1>비밀번호 확인</h1>
		
		<div>
			<a href="/home">홈</a>
		</div>
		
	    <form action="/empInfo/checkPw" method="post" id="checkPw">	        
	        <label for="empPw">Password:</label>
	        <input type="password" id="empPw" name="empPw"><br>
	       
	        <button type="button" id="checkPwBtn">입력</button>
   		</form>
		
		<div>
			<a href="/empInfo/empInfo">이전</a>
		</div>
	
	</body>
</html>
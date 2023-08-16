<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>login</title>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
		<script>
			$(document).ready(function() {
				const urlParams = new URL(location.href).searchParams;
				const msg = urlParams.get("msg");
					if (msg != null) {
						alert(msg);
					}
					
				// <input type="number"> 일 경우 숫자만 입력받도록 설정
				$("input[type='number']").on("keypress", function(event) {
					if ((event.which < 48) || (event.which > 57)) {
						return false;
					}
			    });
			});
	  	</script>
	</head>
	<body>

		<div>
			<a href="/home">홈</a>
		</div>
		
	    <form action="/login/login" method="post">
	        <label for="empNo">Employee Number:</label>
	        <input type="number" id="empNo" name="empNo" value="${loginId}" required><br>
	        
	        <label for="empPw">Password:</label>
	        <input type="password" id="empPw" name="empPw" required><br>
	        
	        <input type="checkbox" id="saveId" name="saveId" value="y">
	        <label for="saveId">Save ID</label><br>
	        
	        <button type="submit">Login</button>
   		</form>
		<div>
			<a href="/login/resetPw">비밀번호를 잊으셨나요?</a>
		</div>
	</body>
</html>
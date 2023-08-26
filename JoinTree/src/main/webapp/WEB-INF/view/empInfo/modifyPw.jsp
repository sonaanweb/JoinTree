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
				
	 			$("#newPw").focusout(function() {
				    let currentPw = $("#empPw").val();
				    let newPw = $(this).val();
				    let errorSpan = $("#newPwError");

				    if (currentPw === newPw) {
				        errorSpan.text("새 비밀번호는 현재 비밀번호와 다르게 입력해주세요.");
				        $(this).val("");
				        $(this).focus();
				    } else {
				        errorSpan.text("");
				    }
				});

				$("#newPw2").focusout(function() {
				    let newPw = $("#newPw").val();
				    let newPw2 = $(this).val();
				    let errorSpan = $("#newPw2Error");

				    if (newPw !== newPw2) {
				        errorSpan.text("새 비밀번호가 일치하지 않습니다.");
				        $(this).val("");
				        $(this).focus();
				    } else {
				        errorSpan.text("");
				    }
				}); 
				
				// 비밀번호 변경 버튼 클릭 시 
				$("#modifyPwBtn").click(function() {
					if ($("#empPw").val() == "") {
						alert("현재 비밀번호를 입력해주세요.");
						$("#empPw").focus();
					} else if ($("#newPw").val() == "") {
						alert("새 비밀번호를 입력해주세요.");
						$("#newPw").focus();
					} else if ($("#newPw2").val() == "") {
						alert("새 비밀번호를 다시 입력해주세요.");
						$("#newPw2").focus();
					} else if ($("#newPw").val() !== $("#newPw2").val()) {
						alert("새 비밀번호가 일치하지 않습니다.");
						$("#newPw2").val("");
						$("#newPw2").focus();
					} else {
						$("#modifyPw").submit();
					}
				});
			});
	  	</script>
		
		<div class="container-fluid page-body-wrapper">
		<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
			<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->

	
				<h1>비밀번호 변경</h1>
				<form action="/JoinTree/empInfo/modifyPw" method="post" id="modifyPw">
					<div>
						<label for="empPw">현재 비밀번호 입력</label>
						<input type="password" name="empPw" id="empPw">
					</div>
					
					<div>
						<label for="newPw">새 비밀번호 입력</label>
						<input type="password" name="newPw" id="newPw">
						<span style="color: red;" id="newPwError" class="error-message"></span>
					</div>
					
					<div>
						<label for="newPw2">새 비밀번호 다시 입력</label>
						<input type="password" name="newPw2" id="newPw2">
						<span style="color: red;" id="newPw2Error" class="error-message"></span>
					</div>
					<button type="button" id="modifyPwBtn">비밀번호 변경</button>
				</form>
			</div>
		</div>
</html>
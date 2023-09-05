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
				    // let errorSpan = $("#newPwError");
				    let requirementsSpan = $("#password-requirements");
				    let errorSpan = $("#password-error-message");

				    if (currentPw === newPw) {
				        errorSpan.text("새 비밀번호는 현재 비밀번호와 다르게 입력해주세요.");
				        requirementsSpan.hide(); // 경고 메시지가 나오면 요구사항 메시지 숨김
				        $(this).val("");
				        $(this).focus();
				    } else {
				        errorSpan.text("");
				        
				        // 정규식을 사용하여 비밀번호 유효성 검사
				        if (!isValidPassword(newPw)) {
				        	errorSpan.text("영문 소문자, 숫자, 특수문자(@, #, $, %, ^, &, +, =, !)를 포함하여 8자 이상이어야 합니다.");
				        	requirementsSpan.hide(); // 경고 메시지가 나오면 요구사항 메시지 숨김
			                $(this).val("");
			                $(this).focus();
				        }
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
				
				// 비밀번호 유효성 검사
				function isValidPassword(password) {
					// 영문 소문자, 숫자, 특수문자를 포함하여 8자 이상
					return /^(?=.*[a-z])(?=.*\d)(?=.*[@#$%^&+=!]).{8,}$/.test(password);
				}
			});
	  	</script>
		
		<div class="container-fluid page-body-wrapper">
		<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
			<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
			
			<div class="col-lg-12 grid-margin stretch-card">
              	<div class="card">
                <div class="card-body">

	
				<h1>비밀번호 변경</h1>
				<form action="/JoinTree/empInfo/modifyPw" method="post" id="modifyPw">
					<div>
						<label for="empPw">현재 비밀번호 입력</label>
						<input type="password" name="empPw" id="empPw" class="form-control w-25">
					</div>
					
					<div>
						<!-- <div> -->
							<label for="newPw">새 비밀번호 입력</label>
						<!-- </div> -->
						<div class="form-inline">
						<input type="password" name="newPw" id="newPw" class="form-control w-25"> &nbsp;&nbsp;
						<!-- <span style="color: red;" id="newPwError" class="error-message"></span> -->
						 <span id="password-requirements">영문 소문자, 숫자, 특수문자(@, #, $, %, ^, &, +, =, !)를 포함하여 8자 이상 입력해주세요.</span>
						 <span style="color: red;" id="password-error-message"></span>
						</div>
					</div>
					<!-- 
					<div>
						<p style="font-size: 14px; color: #666;">(영문 소문자, 숫자, 특수문자(@, #, $, %, ^, &, +, =, !)를 포함하여 8자 이상 입력해주세요.)</p>
						<p style="font-size: 12px; color: #666;" id="password-error-message"></p>
					</div> -->
					<div>
						<label for="newPw2">새 비밀번호 다시 입력</label>
						<input type="password" name="newPw2" id="newPw2" class="form-control w-25">
						<span style="color: red;" id="newPw2Error" class="error-message"></span>
					</div>
					<br>
					<button type="button" id="modifyPwBtn" class="btn btn-success btn-fw">비밀번호 변경</button>
				</form>
			
			
				</div>
				</div>
				</div>
			</div>
		</div>
</html>
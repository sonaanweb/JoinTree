<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>resetPw</title>
		 <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	    <!-- plugins:css -->
	    <link rel="stylesheet" href="${pageContext.request.contextPath}/resource/vendors/iconfonts/mdi/css/materialdesignicons.min.css">
	    <link rel="stylesheet" href="${pageContext.request.contextPath}/resource/vendors/css/vendor.bundle.base.css">
	    <!-- endinject -->
	    <!-- plugin css for this page -->
	    <!-- End plugin css for this page -->
	    <!-- inject:css -->
	    <link rel="stylesheet" href="${pageContext.request.contextPath}/resource/css/style.css">
	    <!-- endinject -->
	    <link rel="shortcut icon" href="${pageContext.request.contextPath}/resource/images/favicon.png" />
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
		<script>
			$(document).ready(function() {
				const urlParams = new URL(location.href).searchParams;
				const msg = urlParams.get("msg");
					if (msg != null) {
						alert(msg);
					}
					
/* 				// 초기 비밀번호 입력/확인 필드 비활성화
				$("#newPw1").prop("disabled", true); // .prop: 요소의 속성값(property)을 가져오거나 설정
				$("#newPw2").prop("disabled", true);
				
				// 인증 버튼 클릭 시 
				$("#authBtn").click(function() {
					// 인증 조건 확인 로직 추가
					// 조건 충족 시 비밀번호 입력/확인 필드 활성화
					$("#newPw1").prop("disabled", false);
					$("#newPw2").prop("disabled", false);
				}); */
				
				// input type이 number 또는 password 일 경우 숫자만 입력받도록 설정
				$("input[type='number'], input[type='password']", ).on("keypress", function(event) {
					if ((event.which < 48) || (event.which > 57)) {
						return false;
					}
			    });
				
				// 인증 버튼 클릭 시 
				$("#authBtn").click(function() {
					const empNo = $("#empNo").val();
					const juminNo = $("#juminNo").val();
					
					if (empNo === "") {
						alert("사번을 입력해주세요.");
						$("#empNo").focus(); 
					} else if (juminNo === "") {
						alert("주민번호 뒷자리를 입력해주세요.");
						$("#juminNo").focus();
					} else {
						// AJAX 요청을 통해 인증 여부 확인
						$.ajax({
							type: "POST", 
							url: "/JoinTree/login/resetPw",
							data: {
								empNo: empNo, 
								juminNo: juminNo
							},
							success: function(response) {
								if (response === "success") {
									 $("#empNoHidden").val(empNo); // 인증 성공했을 경우 empNo 값을 비밀번호 변경을 위한 hidden 필드에 설정
									alert("인증이 완료되었습니다.");
									// 인증 성공 시 비밀번호 재설정 섹션 표시
									$("#authForm").hide();
									$("#resetPwSection").show();
									 // 인증 버튼 비활성화
				                    $("#authBtn").prop("disabled", true);
								} else {
									alert("인증 실패. 사번 또는 주민번호를 확인해주세요.");
									$("#juminNo").val("");
								}
							},
							error: function() {
								alert("서버 오류 발생. 관리자에게 문의해주세요.");
							}
						});
					}
				});	
				
				// 비밀번호 재설정 버튼 클릭 시 
				$("#resetPwBtn").click(function() {
					if ($("#newPw").val() == "") {
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
						$("#reset").submit();
					}
				});
			});
		</script>
	</head>
	<body>
		<div class="container-scroller">
		    <div class="container-fluid page-body-wrapper full-page-wrapper">
		      <div class="content-wrapper d-flex align-items-center auth">
		        <div class="row w-100">
		          <div class="col-lg-4 mx-auto">
		            <div class="auth-form-light text-left p-5">
		              <div class="brand-logo">
		                <img src="${pageContext.request.contextPath}/resource/images/jointree.png">
		              </div>
	
		<div>
			<a href="/JoinTree/login/login">이전</a>
		</div>
		
		<h3>비밀번호 재설정</h3>
	
		
		<form class="pt-3" action="/JoinTree/login/resetPw" method="post">
	        <div class="form-group">
            	<input type="number" class="form-control form-control-lg" id="empNo" name="empNo" placeholder="사번" required>
            </div>
            
            <div class="form-group">
            	<input type="password" class="form-control form-control-lg" id="juminNo" name="juminNo" placeholder="주민등록번호 뒷자리" required>
            </div>
           
           
            <button class="btn btn-block btn-success btn-lg font-weight-medium auth-form-btn" type="button" id="authBtn">인증</button >
			
<!-- 			<div>
				<label for="empNo">사번</label>
				<input type="number" name="empNo" id="empNo">
			</div> -->
			
		<!-- 	<div>
				<label for="juminNo">주민등록번호 뒷자리</label>
				<input type="password" name="juminNo" id="juminNo">
			</div> -->
		
			<!-- <button type="button" id="authBtn">인증</button> -->
		</form>
				
		<form class="pt-3" action="/JoinTree/login/resetPw/reset" method="post" id="reset">
			<input type="hidden" name="empNo" id="empNoHidden" value="">
	        <div id="resetPwSection" style="display: none;">
        		<div class="form-group">
            		<input type="password" class="form-control form-control-lg" id="newPw" name="newPw" placeholder="새 비밀번호 입력">
           	    </div>
            
	            <div class="form-group">
	            	<input type="password" class="form-control form-control-lg" id="newPw2" name="newPw2" placeholder="새 비밀번호 확인">
	            </div>
            	<button class="btn btn-block btn-success btn-lg font-weight-medium auth-form-btn" type="button" id="resetPwBtn">비밀번호 재설정</button >
	        </div>
	       
		
		
			<!-- <input type="hidden" name="empNo" id="empNoHidden" value=""> -->
<!-- 			<div id="resetPwSection" style="display: none;">
				<div>
					<label for="newPw">새 비밀번호 입력</label>
					<input type="password" name="newPw" id="newPw">
				</div>
				<div>
					<label for="newPw2">새 비밀번호 확인</label>
					<input type="password" name="newPw2" id="newPw2">
				</div>
				
				<button type="button" id="resetPwBtn">비밀번호 재설정</button>
			</div> -->
		</form>
		
		
	            	</div>
          		</div>
        	</div>
     	</div>
     	<!-- content-wrapper ends -->
    	</div>
   		<!-- page-body-wrapper ends -->
 		</div>
 		<!-- container-scroller -->
  		<!-- plugins:js -->
  		<script src="${pageContext.request.contextPath}/resource/vendors/js/vendor.bundle.base.js"></script>
  		<script src="${pageContext.request.contextPath}/resource/vendors/js/vendor.bundle.addons.js"></script>
  		<!-- endinject -->
  		<!-- inject:js -->
  		<script src="${pageContext.request.contextPath}/resource/js/off-canvas.js"></script>
  		<script src="${pageContext.request.contextPath}/resource/js/misc.js"></script>
  		<!-- endinject -->
		
	</body>
</html>
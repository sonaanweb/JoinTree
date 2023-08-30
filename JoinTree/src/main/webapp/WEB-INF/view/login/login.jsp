<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>login</title>
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
					
				// <input type="number"> 일 경우 숫자만 입력받도록 설정
				$("input[type='number']").on("keypress", function(event) {
					if ((event.which < 48) || (event.which > 57)) {
						return false;
					}
			    });
				
				// 로그인 버튼 클릭 시 
				$("#loginBtn").click(function() {
					if ($("#empNo").val() == "") {
						alert("사번을 입력해주세요.");
						$("#empNo").focus();
					} else if ($("#empPw").val() == "") {
						alert("비밀번호를 입력해주세요.");
						$("#empPw").focus();
					} else {
					 	$("#login").submit();
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
	
	
	    <h4>로그인</h4>
	    
	    <h6 class="font-weight-light">Sign in to continue.</h6>
	
	    <form class="pt-3" action="/JoinTree/login/login" method="post" id="login">
	        <div class="form-group">
            	<input type="number" class="form-control form-control-lg" id="empNo" name="empNo" value="${loginId}" placeholder="사번">
            </div>
           	 <div class="form-group">
                  <input type="password" class="form-control form-control-lg" id="empPw" name="empPw" placeholder="Password">
             </div>
             <div class="mt-3">
                  <button class="btn btn-block btn-success btn-lg font-weight-medium auth-form-btn" type="button" id="loginBtn">Login</button >
                </div>
                <div class="my-2 d-flex justify-content-between align-items-center">
                  <div class="form-check form-check-success">
                    <label class="form-check-label text-muted">
                      <input type="checkbox" class="form-check-input" id="saveId" name="saveId" value="y">
                      	사번 저장
                    </label>
                  </div>
                  <a href="/JoinTree/login/resetPw" class="auth-link text-black">비밀번호를 잊으셨나요?</a>
                </div>
        </form>
            
            
	        
<%-- 	        <label for="empNo">Employee Number:</label>
	        <input type="number" id="empNo" name="empNo" value="${loginId}" required><br>
	        
	        <label for="empPw">Password:</label>
	        <input type="password" id="empPw" name="empPw" required><br> --%>
	        
<!-- 	        <input type="checkbox" id="saveId" name="saveId" value="y">
	        <label for="saveId">Save ID</label><br> -->
	        
	       <!--  <button type="submit">Login</button> -->
   		
<!-- 		<div>
			<a href="/login/resetPw">비밀번호를 잊으셨나요?</a>
		</div> -->
		
		

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
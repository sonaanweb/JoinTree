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
		<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
		<script src="/JoinTree/resource/js/login/resetPw.js"></script>

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
			<a href="/JoinTree/login/login" class="btn btn-outline-success btn-sm">이전</a>
		</div><br>
		
		<h3>비밀번호 재설정</h3>
	
		
		<form class="pt-3" action="/JoinTree/login/resetPw" method="post">
	        <div class="form-group">
            	<input type="number" class="form-control form-control-lg" id="empNo" name="empNo" placeholder="사번" required>
            </div>
            
            <div class="form-group">
            	<input type="password" class="form-control form-control-lg" id="juminNo" name="juminNo" placeholder="주민등록번호 뒷자리" required>
            </div>
           
            <button class="btn btn-block btn-success btn-lg font-weight-medium auth-form-btn" type="button" id="authBtn">인증</button >
			

		</form>
				
		<form class="pt-3" action="/JoinTree/login/resetPw/reset" method="post" id="reset">
			<input type="hidden" name="empNo" id="empNoHidden" value="">
	        <div id="resetPwSection" style="display: none;">
        		<div class="form-group">
        			<span style="font-size: 14px; color: #666;" id="password-requirements">영문 소문자, 숫자, 특수문자(@, #, $, %, ^, &, +, =, !)를 포함하여 8자 이상 입력해주세요.</span><br>
            		<br>
            		<input type="password" class="form-control form-control-lg" id="newPw" name="newPw" placeholder="새 비밀번호 입력">
           	    </div>
            
	            <div class="form-group">
	            	<input type="password" class="form-control form-control-lg" id="newPw2" name="newPw2" placeholder="새 비밀번호 확인">
	            </div>
            	<button class="btn btn-block btn-success btn-lg font-weight-medium auth-form-btn" type="button" id="resetPwBtn">비밀번호 재설정</button >
	        </div>
	       
		
	
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
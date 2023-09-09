<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>login</title>
		<link rel="shortcut icon" href="/JoinTree/resource/images/jointree_mini.png" />
		
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
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
		<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
		<script src="/JoinTree/resource/js/login/login.js"></script>
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
                      <input type="checkbox" class="form-check-input" id="saveId" name="saveId" value="y" <c:if test="${loginId ne null}">checked</c:if>>
                      	사번 저장
                    </label>
                  </div>
                  <a href="/JoinTree/login/resetPw" class="auth-link text-black">비밀번호를 잊으셨나요?</a>
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
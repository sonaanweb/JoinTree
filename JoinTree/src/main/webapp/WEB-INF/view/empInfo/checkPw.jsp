<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<!-- header -->
	<jsp:include page="/WEB-INF/view/inc/header.jsp"/>
	<script src="/JoinTree/resource/js/empInfo/ckeckPw.js"></script>

	  	
	  	<div class="container-fluid page-body-wrapper">
		<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
			<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
	  	
	  		<div class="col-lg-12 grid-margin stretch-card">
              	<div class="card">
                 <div class="card-body">
                 
               	<div>
					<a href="/JoinTree/empInfo/empInfo" class="btn btn-outline-success btn-sm">이전</a>
				</div>
				<br>

				<div class="col d-flex align-items-center">
					<h3>비밀번호 확인</h3>
				</div>
				
			    <form action="/JoinTree/empInfo/checkPw" method="post" id="checkPw">	        
			        <!-- <label for="empPw">Password:</label> -->
			        <input type="password" id="empPw" name="empPw" placeholder="Password" class="form-control w-25"><br>
			       
			        <button type="button" id="checkPwBtn" class="btn btn-success btn-fw">입력</button>
		   		</form>
				
			
			</div>
			
			</div>
			</div>
			</div>
			
			
		</div>
		<!-- footer -->
		<jsp:include page="/WEB-INF/view/inc/footer.jsp"/>
</html>
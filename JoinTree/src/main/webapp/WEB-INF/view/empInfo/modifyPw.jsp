<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<!-- header -->
	<jsp:include page="/WEB-INF/view/inc/header.jsp"/>
	<script src="/JoinTree/resource/js/empInfo/modifyPw.js"></script>

		
		<div class="container-fluid page-body-wrapper">
		<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
			<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
			
			<div class="col-lg-12 grid-margin stretch-card">
              	<div class="card">
                <div class="card-body">

	
				<h1>비밀번호 변경</h1>
				<form action="/JoinTree/empInfo/modifyPw" method="post" id="modifyPw">
					<div>
						<!-- <label for="empPw">현재 비밀번호 입력</label> -->
						<input type="password" name="empPw" id="empPw" class="form-control w-25" placeholder="현재 비밀번호 입력">
					</div><br>
					
					<div>
						<!-- <div> -->
							<!-- <label for="newPw">새 비밀번호 입력</label> -->
						<!-- </div> -->
						<div class="form-inline">
						<input type="password" name="newPw" id="newPw" class="form-control w-25" placeholder="새 비밀번호 입력"> &nbsp;&nbsp;
						<!-- <span style="color: red;" id="newPwError" class="error-message"></span> -->
						 <span id="password-requirements">영문 소문자, 숫자, 특수문자(@, #, $, %, ^, &, +, =, !)를 포함하여 8자 이상 입력해주세요.</span>
						 <span style="color: red;" id="password-error-message"></span>
						</div>
					</div><br>
					<!-- 
					<div>
						<p style="font-size: 14px; color: #666;">(영문 소문자, 숫자, 특수문자(@, #, $, %, ^, &, +, =, !)를 포함하여 8자 이상 입력해주세요.)</p>
						<p style="font-size: 12px; color: #666;" id="password-error-message"></p>
					</div> -->
					<div>
						<!-- <label for="newPw2">새 비밀번호 다시 입력</label> -->
						<input type="password" name="newPw2" id="newPw2" class="form-control w-25" placeholder="새 비밀번호 다시 입력">
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
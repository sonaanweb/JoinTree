<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>home</title>
	  	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
	  	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	  	<link rel="stylesheet" href="/resource/css/style.css">
	  	<link rel="stylesheet" href="/resource/css/style2.css">
		<script>
			$(document).ready(function() {
				// 로그인
				const urlParams = new URL(location.href).searchParams;
				const msg = urlParams.get("msg");
					if (msg != null) {
						alert(msg);
					}
			
				// 현재시간 출력
			    updateTime();
			    setInterval(updateTime, 1000); // 1초마다 시간 업데이트

			    function updateTime() {
			        const time = new Date();
			        const hour = time.getHours();
			        const minutes = time.getMinutes();
			        const seconds = time.getSeconds();
			        
			        const formattedHour = hour < 10 ? '0' + hour : hour;
			       	const formattedMinutes = minutes < 10 ? '0' + minutes : minutes;
			       	const formattedSeconds = seconds < 10 ? '0' + seconds : seconds;
			        		
			        const formattedTime = formattedHour + ":" + formattedMinutes + ":" + formattedSeconds;
			        $('.clock').text(formattedTime);
			    }
			});
		</script>
	</head>
<body>
<div class="container-scroller"> <!-- 전체 스크롤 -->
	<div class="container-fluid page-body-wrapper"><!-- 상단제외 -->
	<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 위왼쪽 사이드바 -->
		<div class = "main-panel"> <!-- 컨텐츠 전체 -->
			<div class="content-wrapper"> <!-- 컨텐츠 -->
				<%-- <h1>home</h1>
				<c:if test="${loginAccount.empNo eq null}">
					<div>
						<a href="/login/login">로그인</a>
					</div>
				</c:if>
				<c:if test="${loginAccount.empNo ne null}">
					<div>
						현재 사용자 : ${empName}
						현재 로그인 아이디: ${loginAccount.empNo}
					</div>
					<div>
						<a href="/empInfo/empInfo">나의 정보</a>
					</div>
					<div>
						<a href="/logout">로그아웃</a>
					</div>
				</c:if> --%>
				<div class="row">
					<div class="col-md-4 stretch-card grid-margin">
						<div class="card bg-gradient-danger card-img-holder text-white">
							<div class="card-body center">
								<div class="home-profile">
									<img class="mb-2" src="/empImg/tiger.png" >
									<h1 class="mb-2 center">김미진과장</h1>
									<h4 class="mb-2 center">개발팀</h4>
									<h1 class="mb-2 clock"></h1>
									<h4 class="mb-2 on">출근시간 : </h4>
									<h4 class="onTime"></h4>
									<h4 class="mb-2 off">퇴근시간 : </h4>
									<h4 class="offTime"></h4>
									<button type="button" class="btn btn-success btn-fw">출근 / 퇴근하기</button>
								</div>
							</div>
						</div>
					</div>
					
					<div class="col-md-5 stretch-card grid-margin">
						<div class="card bg-gradient-danger card-img-holder text-white">
							<div class="card-body"> 
								공지사항
								<hr>
								프로젝트
							</div>
						</div>
					</div>
					
					<div class="col-md-3 stretch-card grid-margin">
						<div class="card bg-gradient-danger card-img-holder text-white">
							<div class="card-body"> 
								오늘일정
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col-md-9 stretch-card grid-margin">
						<div class="card bg-gradient-danger card-img-holder text-white">
							<div class="card-body"> 
								결재문서목록
								<hr>
								문서함
							</div>
						</div>
					</div>		
					
					<div class="col-md-3 stretch-card grid-margin">
						<div class="card bg-gradient-danger card-img-holder text-white">
							<div class="card-body"> 
								todo
							</div>
						</div>
					</div>					
				</div>
				
								<div class="row">
					<div class="col-md-9 stretch-card grid-margin">
						<div class="card bg-gradient-danger card-img-holder text-white">
							<div class="card-body"> 
							<!-- 	결재문서목록
								<hr>
								문서함 -->
							</div>
						</div>
					</div>		
					
					<div class="col-md-3 stretch-card grid-margin">
						<div class="card bg-gradient-danger card-img-holder text-white">
							<div class="card-body"> 
								<a href="/login/login">로그인</a>
								<a href="/logout">로그아웃</a>
							</div>
						</div>
					</div>					
				</div>
				
			</div><!-- 컨텐츠 끝 -->
		</div><!-- 컨텐츠전체 끝 -->
	</div><!-- 상단제외 끝 -->
</div><!-- 전체 스크롤 끝 -->	
</body>
</html>
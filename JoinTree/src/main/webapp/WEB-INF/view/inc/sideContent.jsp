<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>상단, 사이드 바</title>
	<!-- plugins:css -->
	<link rel="stylesheet" href="/resource/vendors/iconfonts/mdi/css/materialdesignicons.min.css">
	<link rel="stylesheet" href="/resource/vendors/css/vendor.bundle.base.css">
	<!-- endinject -->
	<!-- inject:css -->
	<link rel="stylesheet" href="/resource/css/style.css">
	<link rel="stylesheet" href="/resource/css/style2.css">
	<!-- endinject -->
	<link rel="shortcut icon" href="/resource/images/favicon.png" />
	<!-- plugins : js -->
	<script src="/resource/vendors/js/vendor.bundle.base.js"></script>
	<script src="/resource/vendors/js/vendor.bundle.addons.js"></script>
	<script src="/resource/js/off-canvas.js"></script>
	<script src="/resource/js/misc.js"></script>
	<script src="/resource/js/dashboard.js"></script>
</head>
<body>
	<!-- 상단바 -->
	<nav class="navbar default-layout-navbar col-lg-12 col-12 p-0 fixed-top d-flex flex-row">
		<!-- 로고 -->
		<div class="text-center navbar-brand-wrapper d-flex align-items-center justify-content-center">
			<a class="navbar-brand brand-logo" href="/home"><img src="/resource/images/jointree.png" alt="logo"/></a>
			<a class="navbar-brand brand-logo-mini" href="/home"><img src="/resource/images/jointree_mini.png" alt="logo"/></a>
		</div>
  		<!-- 위 - 메뉴바 -->
		<div class="navbar-menu-wrapper d-flex align-items-stretch">
			<!-- 위 - 검색 -->
			<div class="search-field d-none d-md-block">
				<form class="d-flex align-items-center h-100" action="#">
					<div class="input-group">
						<div class="input-group-prepend bg-transparent">
							<i class="input-group-text border-0 mdi mdi-magnify"></i>                
						</div>
						<input type="text" class="form-control bg-transparent border-0" placeholder="Search projects">
					</div>
				</form>
			</div>
  			<!-- 아이콘들 -->
			<ul class="navbar-nav navbar-nav-right">
				<!-- 위 - 세션시간 -->
				<li class="nav-item d-none d-lg-block full-screen-link">
					<a class="nav-link">
						세션시간
					</a>
				</li>
				<!-- 위 - 전체화면 -->
				<li class="nav-item d-none d-lg-block full-screen-link">
					<a class="nav-link">
						<i class="mdi mdi-fullscreen" id="fullscreen-button"></i>
					</a>
				</li>
				
				<!-- 위 - 쪽지 -->
				<li class="nav-item dropdown">
					<a class="nav-link count-indicator dropdown-toggle" id="messageDropdown" href="#" data-toggle="dropdown" aria-expanded="false">
						<i class="mdi mdi-email-outline"></i>
						<span class="count-symbol bg-warning"></span>
					</a>
			  		<!-- 쪽지 내용 -->
					<div class="dropdown-menu dropdown-menu-right navbar-dropdown preview-list" aria-labelledby="messageDropdown">
						<h6 class="p-3 mb-0">Messages</h6>
						<div class="dropdown-divider"></div>
						<a class="dropdown-item preview-item">
							<div class="preview-thumbnail">
								<img src="/empImg/tiger.png" alt="image" class="profile-pic">
							</div>
							<div class="preview-item-content d-flex align-items-start flex-column justify-content-center">
								<h6 class="preview-subject ellipsis mb-1 font-weight-normal">Mark send you a message</h6>
								<p class="text-gray mb-0">
								1 Minutes ago
								</p>
							</div>
						</a>
						<div class="dropdown-divider"></div>
							<h6 class="p-3 mb-0 text-center">1 new messages</h6>
						</div>
				</li><!-- 위 - 쪽지 끝 -->
				
				<!-- 위 - 알림 -->
				<li class="nav-item dropdown">
					<a class="nav-link count-indicator dropdown-toggle" id="notificationDropdown" href="#" data-toggle="dropdown">
						<i class="mdi mdi-bell-outline"></i>
						<span class="count-symbol bg-danger"></span>
					</a>
				 	 <!-- 알림 내용 -->
					<div class="dropdown-menu dropdown-menu-right navbar-dropdown preview-list" aria-labelledby="notificationDropdown">
						<h6 class="p-3 mb-0">Notifications</h6>
							<!-- 드롭다운 1번 -->
							<div class="dropdown-divider"></div>
								<a class="dropdown-item preview-item">
									<div class="preview-thumbnail">
										<div class="preview-icon bg-success">
											<i class="mdi mdi-calendar"></i>
										</div>
									</div>
									<!-- 내용 -->
									<div class="preview-item-content d-flex align-items-start flex-column justify-content-center">
										<h6 class="preview-subject font-weight-normal mb-1">Event today</h6>
										<p class="text-gray ellipsis mb-0">
											Just a reminder that you have an event today
										</p>
									</div>
								</a>
							<!-- 드롭다운 2번 -->
							<div class="dropdown-divider"></div>
								<a class="dropdown-item preview-item">
									<div class="preview-thumbnail">
										<div class="preview-icon bg-warning">
											<i class="mdi mdi-settings"></i>
										</div>
									</div>
									<div class="preview-item-content d-flex align-items-start flex-column justify-content-center">
										<h6 class="preview-subject font-weight-normal mb-1">Settings</h6>
										<p class="text-gray ellipsis mb-0">
											Update dashboard
										</p>
									</div>
								</a>
							<!-- 드롭다운 3번 -->
							<div class="dropdown-divider"></div>
							<h6 class="p-3 mb-0 text-center">See all notifications</h6>
					</div>
				</li><!-- 위 - 알림 끝 -->
				
				<!-- 위 - 로그아웃 -->
				<li class="nav-item nav-logout d-none d-lg-block">
					<a class="nav-link" href="#">
						<i class="mdi mdi-power"></i>
					</a>
				</li><!-- 위 - 로그아웃 끝 -->
			</ul><!-- 상단바 끝 -->
			<!--  화면 작아졌을 때 바버튼 -->
			<button class="navbar-toggler navbar-toggler-right d-lg-none align-self-center" type="button" data-toggle="offcanvas">
				<span class="mdi mdi-menu"></span>
			</button>
		</div><!-- 위 - 메뉴바 끝 -->
	</nav><!-- 상단바 끝 -->
	
	<!-- 왼쪽바 -->
	<nav class="sidebar sidebar-offcanvas" id="sidebar">
	<ul class="nav">
		<!-- 왼쪽 - 프로필 -->
		<li class="nav-item nav-profile">
			<a href="/empInfo/empInfo" class="nav-link">
				<div class="nav-profile-image">
					<img src="/empImg/tiger.png" alt="profile">
					<span class="login-status online"></span> <!--change to offline or busy as needed-->              
				</div>
				<div class="nav-profile-text d-flex flex-column">
					<span class="font-weight-bold mb-2">김미진</span>
					<span class="text-secondary text-small">개발팀</span>
				</div>
				<i class="mdi mdi-bookmark-check text-success nav-profile-badge"></i>
			</a>
		</li>

		<!-- 왼쪽 - 홈 -->
		<li class="nav-item">
			<a class="nav-link" href="/home">
				<span class="menu-title">홈</span>
				<i class="mdi mdi-home menu-icon"></i>
			</a>
		</li>

		 <!-- 왼쪽 - 공지 -->
		<li class="nav-item">
			<a class="nav-link" data-toggle="collapse" href="#notice" aria-expanded="false" aria-controls="general-pages">
				<span class="menu-title">공지</span>
				<i class="menu-arrow"></i>
				<i class="mdi mdi-bullhorn menu-icon"></i>
			</a>
			<div class="collapse" id="notice">
				<ul class="nav flex-column sub-menu">
					<li class="nav-item"> <a class="nav-link" href=""> 공지사항 </a></li>
					<li class="nav-item"> <a class="nav-link" href=""> 자료실 </a></li>
				</ul>
			</div>
		</li>

		<!-- 왼쪽 - 게시판 -->
		<li class="nav-item">
			<a class="nav-link" data-toggle="collapse" href="#board" aria-expanded="false" aria-controls="ui-basic">
				<span class="menu-title">게시판</span>
				<i class="menu-arrow"></i>
				<i class="mdi mdi-format-list-bulleted menu-icon"></i>
			</a>
			<div class="collapse" id="board">
				<ul class="nav flex-column sub-menu">
					<li class="nav-item"> <a class="nav-link" href="/community/freeCommList">자유게시판</a></li>
					<li class="nav-item"> <a class="nav-link" href="/community/anonymousCommList">익명게시판</a></li>
					<li class="nav-item"> <a class="nav-link" href="/community/secondhandCommList">중고장터게시판</a></li>
					<li class="nav-item"> <a class="nav-link" href="/community/lifeEventCommList">경조사게시판</a></li>
				</ul>
			</div>
		</li>

			<!-- 왼쪽 - 프로젝트 -->
		<li class="nav-item">
			<a class="nav-link" href="">
				<span class="menu-title">프로젝트</span>
				<i class="mdi mdi-newspaper menu-icon"></i>
			</a>
		</li>

		<!-- 왼쪽 - 일정 -->
		<li class="nav-item">
			<a class="nav-link" data-toggle="collapse" href="#calendarBar" aria-expanded="false" aria-controls="ui-basic">
				<span class="menu-title">일정</span>
				<i class="menu-arrow"></i>
				<i class="mdi mdi-calendar-check menu-icon"></i>
			</a>
			<div class="collapse" id="calendarBar">
				<ul class="nav flex-column sub-menu">
					<li class="nav-item"> <a class="nav-link" href="">전사일정</a></li>
					<li class="nav-item"> <a class="nav-link" href="">부서일정</a></li>
					<li class="nav-item"> <a class="nav-link" href="/schedule/personalSchedule">개인일정</a></li>
				</ul>
			</div>
		</li>

		<!-- 왼쪽 - 근태 -->
		<li class="nav-item">
			<a class="nav-link" data-toggle="collapse" href="#commute" aria-expanded="false" aria-controls="ui-basic">
				<span class="menu-title">근태</span>
				<i class="menu-arrow"></i>
				<i class="mdi mdi-clock-fast menu-icon"></i>
			</a>
			<div class="collapse" id="commute">
				<ul class="nav flex-column sub-menu">
					<li class="nav-item"> <a class="nav-link" href="">일별 출퇴근 리스트</a></li>
					<li class="nav-item"> <a class="nav-link" href="">근로시간 통계</a></li>
				</ul>
			</div>
		</li>
    
		<!-- 왼쪽 - 전자결재 -->
		<li class="nav-item">
			<a class="nav-link" data-toggle="collapse" href="#document" aria-expanded="false" aria-controls="ui-basic">
				<span class="menu-title">전자결재</span>
				<i class="menu-arrow"></i>
				<i class="mdi mdi-clipboard-text menu-icon"></i>
			</a>
		 	<div class="collapse" id="document">
				<ul class="nav flex-column sub-menu">
					<li class="nav-item"> <a class="nav-link" href="/document/testDocument">기안문서목록</a></li>
					<li class="nav-item"> <a class="nav-link" href="">결재함</a></li>
					<li class="nav-item"> <a class="nav-link" href="">개인문서함</a></li>
					<li class="nav-item"> <a class="nav-link" href="">팀별문서함</a></li>
				</ul>
			</div>
		</li>
   
		<!-- 왼쪽 - 주소록 -->
		<li class="nav-item">
			<a class="nav-link" href="">
				<span class="menu-title">주소록</span>
				<i class="mdi mdi-account-search menu-icon"></i>
			</a>
		</li>
		
		
		<%-- <c:if test="${loginMember == }></c:if> --%>
		
		<!-- 왼쪽 - 개발팀(공통코리 관리) -->
		<div class="line"></div>
		<li class="nav-item">
			<a class="nav-link" href="/code/codeList">
				<span class="menu-title">공통코드관리</span>
				<i class="mdi mdi mdi-server menu-icon"></i>
			</a>
		</li>
		
		<!-- 왼쪽 - 인사팀(인사관리) -->
		<div class="line"></div>
		<li class="nav-item">
			<a class="nav-link" data-toggle="collapse" href="#emp" aria-expanded="false" aria-controls="ui-basic">
				<span class="menu-title">인사관리</span>
				<i class="menu-arrow"></i>
				<i class="mdi mdi mdi-account-settings-variant menu-icon"></i>
			</a>
			<div class="collapse" id="emp">
				<ul class="nav flex-column sub-menu">
					<li class="nav-item"> <a class="nav-link" href="/empManage/selectEmpList">사원관리</a></li>
					<li class="nav-item"> <a class="nav-link" href="">출퇴근관리</a></li>
					<li class="nav-item"> <a class="nav-link" href="">연가관리</a></li>
					<li class="nav-item"> <a class="nav-link" href="">연차관리</a></li>
				</ul>
			</div>
		</li>
		
		<!-- 왼쪽 - 경영개발팀 -->
		<div class="line"></div>
		<!-- 왼쪽 - 예약관리 -->
		<li class="nav-item">
			<a class="nav-link" data-toggle="collapse" href="#reservation" aria-expanded="false" aria-controls="ui-basic">
				<span class="menu-title">예약관리</span>
				<i class="menu-arrow"></i>
				<i class="mdi mdi mdi-calendar-clock menu-icon"></i>
			</a>
			<div class="collapse" id="reservation">
				<ul class="nav flex-column sub-menu">
					<li class="nav-item"> <a class="nav-link" href="">회의실</a></li>
					<li class="nav-item"> <a class="nav-link" href="">법인차량</a></li>
				</ul>
			</div>
		</li>
		<!-- 왼쪽 - 기자재관리 -->
		<li class="nav-item">
			<a class="nav-link" data-toggle="collapse" href="#equipment" aria-expanded="false" aria-controls="ui-basic">
				<span class="menu-title">기자재관리</span>
				<i class="menu-arrow"></i>
				<i class="mdi mdi mdi-car menu-icon"></i>
			</a>
			<div class="collapse" id="equipment">
				<ul class="nav flex-column sub-menu">
					<li class="nav-item"> <a class="nav-link" href="">회의실</a></li>
					<li class="nav-item"> <a class="nav-link" href="">법인차량</a></li>
				</ul>
			</div>
		</li>
	</ul>
	</nav><!-- 왼쪽바 끝 -->
</body>
</html>
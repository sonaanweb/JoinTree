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
	<script>
       $(document).ready(function() {
		   let isTimerRunning = false;
           let interval;
           
           // 모달창 띄우기
        function showModal() {
            // TODO: 세션 연장 알림 및 버튼 표시 로직 구현
             $('#extensionModal').css('display', 'block'); // 세션 연장 알림 모달 표시
            // 5분 남았습니다. 로그인 시간을 연장하시겠습니까?
            // 예 / 아니오 버튼 모달
        }
           
           // 모달창 닫기
           $('.close').click(function () {
              $('#extensionModal').css('display', 'none'); // 세션 연장 알림 모달도 닫음
           });
           
           function resetTimer(newDuration) {
           	clearInterval(interval); // 기존 타이머 중지
               startTimer(newDuration); // 새로운 타이머 시작
           }
           
           // 세션 연장 알림 모달 "예" 버튼 클릭 시
           $('#extensionYesBtn').click(function () {
              $('#extensionModal').css('display', 'none'); // 세션 연장 알림 모달 닫음
              // TODO: 세션 연장 처리 로직 추가
              
                  if (!isTimerRunning) {
			        isTimerRunning = true;
			        
			        clearInterval(interval); // 이전 타이머 중지
			        
			        // 세션 연장 요청 보내기
			        extendSessionAndResetTimer(30 * 60); // 분 * 초 // 세션 연장 및 타이머 재시작
			   }
              
              // 연장 처리 후 다시 타이머 시작
              startTimer(sessionDuration);
           });
           
           // 세션 연장 및 새로운 타이머 시작 함수
           function extendSessionAndResetTimer(newDuration) {
               $.ajax({
                   url: '/extendSession', // 세션 연장 처리를 수행하는 서버의 URL
                   type: 'POST', 
                   success: function(response) {
                       if (response === "success") {
                           startTimer(newDuration);
                       } else {
                           // 세션 연장 처리가 실패한 경우 처리
                           // 예를 들어, 오류 메시지 출력 등의 작업 수행
                           alert("세션이 연장되지 않았습니다.");
                           isTimerRunning = false; // 실패한 경우 다시 실행 가능하도록 플래그 변경
                       }
                   },
                   error: function(xhr, status, error) {
                       // AJAX 요청 실패 시 처리
                       console.error(error);
                       alert("서버 오류 발생");
                       
                   }
               });
           }
           
           // 세션 연장 알림 모달 "아니오" 버튼 클릭 시
           $('#extensionNoBtn').click(function () {
              $('#extensionModal').css('display', 'none'); // 세션 연장 알림 모달 닫은 후 별도 처리 없음
           });
       	           
        const timerElement = $("#timer");
    
        const sessionDuration = 30 * 60; // 분 * 초 -> 세션 기본값인 30분 설정
        // 초기 타이머 시작
        startTimer(sessionDuration);
        
        function startTimer(duration) {
            let timer = duration, minutes, seconds;
            interval = setInterval(function () {
                minutes = parseInt(timer / 60, 10);
                seconds = parseInt(timer % 60, 10);

                minutes = minutes < 10 ? "0" + minutes : minutes;
                seconds = seconds < 10 ? "0" + seconds : seconds;

                // timerElement.text(`${minutes}:${seconds}`);
				timerElement.text(minutes + ":" + seconds);
               		        
	            if (--timer === 5 * 60) { // 5분(300초) 남았을 때
	            	showModal(); // 세션 연장 알림, 연장 모달 출력
	            } else if (timer < 0) {
	                clearInterval(interval);
	                showSessionExpirationAlert(); // 세션 만료 알림
	                window.location.href = "/logout"; // 로그아웃을 수행하는 URL로 리다이렉트
	            }
	        }, 1000);
	    }
		
        function showSessionExpirationAlert() {
            // TODO: 세션 만료 알림 및 세션 연장 버튼 표시 로직 구현
        	alert("세션이 만료되었습니다. 다시 로그인해주세요.");
        }
       });
   </script>
</head>
<body>
	<div id="extensionModal" class="modal">
 			<div class="modal-content">
	      <div class="modal-header">
	         <h4>세션 연장 알림</h4>
	         <span class="close">&times;</span>
	      </div>
	      <div class="modal-body">
	         <p>자동 로그아웃까지 5분 남았습니다. 로그인 시간을 연장하시겠습니까?</p>
	         <button id="extensionYesBtn">예</button>
	         <button id="extensionNoBtn">아니오</button>
	      </div>
	   </div>
	</div>

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
						<c:if test="${loginAccount.empNo ne null}">
							로그아웃까지 남은 시간&nbsp;<span id="timer">30:00</span>
						</c:if>
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
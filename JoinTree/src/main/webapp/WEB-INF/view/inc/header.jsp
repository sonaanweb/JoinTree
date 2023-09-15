<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>JoinTree</title>
	<link rel="shortcut icon" href="/JoinTree/resource/images/jointree_mini.png" />
	
	<!-- 템플릿 : css -->
	<link rel="stylesheet" href="/JoinTree/resource/vendors/iconfonts/mdi/css/materialdesignicons.min.css">
	<link rel="stylesheet" href="/JoinTree/resource/vendors/css/vendor.bundle.base.css">
	
	<!-- 템플릿 : js -->
	<script src="/JoinTree/resource/vendors/js/vendor.bundle.base.js"></script>
	<script src="/JoinTree/resource/vendors/js/vendor.bundle.addons.js"></script>
	<script src="/JoinTree/resource/js/off-canvas.js"></script>
	<script src="/JoinTree/resource/js/misc.js"></script>
	<script src="/JoinTree/resource/js/dashboard.js"></script>
	
	<!-- 부트스트랩 JavaScript 및 의존성 라이브러리 CDN -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
	
	<!-- css - 수정가능 -->
	<link rel="stylesheet" href="/JoinTree/resource/css/style.css">
	<link rel="stylesheet" href="/JoinTree/resource/css/style2.css">
	
	<!-- jquery -->
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	
	<!-- SweetAlert2 스타일시트와 스크립트 -->
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
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
                   url: '/JoinTree/extendSession', // 세션 연장 처리를 수행하는 서버의 URL
                   type: 'POST', 
                   success: function(response) {
                       if (response === "success") {
                           startTimer(newDuration);
                       } else {
                           // 세션 연장 처리가 실패한 경우 처리
                           // 예를 들어, 오류 메시지 출력 등의 작업 수행
                    	   Swal.fire({
								icon: 'warning',
								title: '세션이 연장되지 않았습니다.',
								showConfirmButton: false,
								timer: 1000
						   });
                           // alert("세션이 연장되지 않았습니다.");
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
    
        const loginEmpNo = ${loginAccount.empNo}; // JSP 변수 값을 JavaScript 변수에 할당
        const sessionDuration = 30 * 60; // 분 * 초 -> 세션 기본값인 30분 설정
        // 초기 타이머 시작
        // loginAccount.empNo 값이 null이 아닐 때에만 타이머 시작
         if (loginEmpNo !== null) {
        	console.log(loginEmpNo); 
        	startTimer(sessionDuration);
    	 } 
        
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
	                window.location.href = "/JoinTree/logout"; // 로그아웃을 수행하는 URL로 리다이렉트
	            }
	        }, 1000);
	    }
		
        function showSessionExpirationAlert() {
        	// alert("세션이 만료되었습니다. 다시 로그인해주세요.");
			Swal.fire({
				icon: 'warning',
				title: '세션이 만료되었습니다. 다시 로그인해주세요.',
				showConfirmButton: false,
				timer: 1000
			});
        }
       });
   </script>
</head>
<body>
<!-- 상단바 -->
<nav class="navbar default-layout-navbar col-lg-12 col-12 p-0 fixed-top d-flex flex-row">
	<!-- 로고 -->
	<div class="text-center navbar-brand-wrapper d-flex align-items-center justify-content-center">
		<a class="navbar-brand brand-logo" href="/JoinTree/home"><img src="/JoinTree/resource/images/jointree.png" alt="logo"/></a>
		<a class="navbar-brand brand-logo-mini" href="/JoinTree/home"><img src="/JoinTree/resource/images/jointree_mini.png" alt="logo"/></a>
	</div>
 		<!-- 위 - 메뉴바 -->
	<div class="navbar-menu-wrapper d-flex align-items-stretch">
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
			
			<!-- 위 - 로그아웃 -->
			<li class="nav-item nav-logout d-none d-lg-block">
				<a class="nav-link" href="/JoinTree/logout">
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

		<!-- 모달 -->
		<div id="extensionModal" class="modal">
			<div class="modal-dialog modal-md">
		 		<div class="modal-content">
					<div class="modal-header">
					   <h4>세션 연장 알림</h4>
					   <!-- <span class="close">&times;</span> -->
					</div>
					<div class="modal-body text-center">
					   <p>자동 로그아웃까지 5분 남았습니다. 로그인 시간을 연장하시겠습니까?</p>
					   <button type="button" class="btn btn-success" id="extensionYesBtn">예</button>
					   <button type="button" class="btn btn-success" id="extensionNoBtn">아니오</button>
					</div>
			   </div>
		   </div>
		</div>	
</body>
</html>
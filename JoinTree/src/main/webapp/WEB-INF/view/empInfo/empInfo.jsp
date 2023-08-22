<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>empInfo</title>
		<style>
			/* 모달 */
		   .modal {
		      display: none;
		      position: fixed;
		      z-index: 1;
		      left: 0;
		      top: 0;
		      width: 100%;
		      height: 100%;
		      overflow: auto;
		      background-color: rgba(0, 0, 0, 0.4);
		   }
		   
		   .modal-content {
		      background-color: #fefefe;
		      margin: 15% auto;
		      padding: 20px;
		      border: 1px solid #888;
		      width: 30%;
		   }
		   .modal-header {
		       display: flex;
		       justify-content: space-between;
		       align-items: center;
		   }
		   
		   .modal-header h4 {
		       margin: 0;
		   }
		   
		   .close {
		       font-size: 28px;
		       font-weight: bold;
		       cursor: pointer;
		   }
		</style>
	    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
	    <script>
	        $(document).ready(function() {
	            const urlParams = new URL(location.href).searchParams;
	            const msg = urlParams.get("msg");
	            if (msg != null) {
	                alert(msg);
	            }
	            
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
		<a href="/home">홈</a>
		<h1>나의 정보</h1>
		<div>
   			로그아웃까지 남은 시간&nbsp;<span id="timer">30:00</span>
		</div>
		
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
		
		<div>
			현재 사용자 : ${empName}
			<%-- 현재 로그인 아이디: ${loginAccount.empNo} --%>
		</div>
		
		<table border="1">
			<tr>
				<td>사원이미지</td>
				<td>
					<img src="${pageContext.request.contextPath}/empImg/${empInfo.empSaveImgName}" alt="employee image" style="max-width: 300px; max-height: 300px;"><br>
					<%-- ${empInfo.empSaveImgName} --%>
					<%-- <img src="이미지파일경로/${empInfo.empSaveImgName}" alt="Employee Image"> --%>
				</td>
			</tr>
			<tr>
				<td>사번</td>
				<td>${empInfo.empNo}</td>
			</tr>
			<tr>
				<td>이름</td>
				<td>${empInfo.empName}</td>
			</tr>
			<tr>
				<td>주소</td>
				<td>${empInfo.empAddress}</td>
			</tr>
			<tr>
				<td>주민등록번호</td>
				<td>${empInfo.empJuminNo}</td>
			</tr>
			<tr>
				<td>연락처</td>
				<td>${empInfo.empPhone}</td>
			</tr>
			<tr>
				<td>내선번호</td>
				<td>${empInfo.empExtensionNo}</td>
			</tr>
			<tr>
				<td>부서</td>
				<td>${empInfo.dept}</td>
			</tr>
			<tr>
				<td>직급</td>
				<td>${empInfo.position}</td>
			</tr>
			<tr>
				<td>입사일</td>
				<td>${empInfo.empHireDate}</td>
			</tr>
			<tr>
				<td>정보수정일</td>
				<td>${empInfo.updatedate.toString().substring(0, 19)}</td> <!--timestamp이므로 String 변환 후 자르기  -->
				<%-- <td>${empInfo.updatedate}</td> --%>
			</tr>
			<tr>
				<td>서명</td>
				<td>
					<img src="${pageContext.request.contextPath}/signImg/${empInfo.signSaveImgName}" alt="sign image" style="max-width: 300px; max-height: 300px;">
				</td>
			</tr>
		</table>
		
		<div>
			<a href="/empInfo/checkPw">정보 수정</a>
		</div>
		<div>
			<a href="/empInfo/modifyPw">비밀번호 변경</a>
		</div>
	</body>
</html>
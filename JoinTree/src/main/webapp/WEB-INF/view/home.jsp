<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
	<!-- header -->
	<jsp:include page="/WEB-INF/view/inc/header.jsp"/>
	
		<!-- todo 추가 모달창 -->
		<div class="modal fade" id="addTodoModal" tabindex="-1" role="dialog" aria-labelledby="addTodoModalLabel" aria-hidden="true">
		    <div class="modal-dialog" role="document">
		        <div class="modal-content">
		            <div class="modal-header">
		                <h5 class="modal-title" id="addTodoModalLabel">TODO</h5>
		                <button type="button" class="close" data-bs-dismiss="modal" aria-label="Close">
		                    <span aria-hidden="true">&times;</span>
		                </button>
		            </div>
		            <div class="modal-body">
		                <!-- TODO 추가 폼 -->
		                <form id="todoForm">
		                    <div class="form-group">
		                        <input type="text" class="form-control" id="todoContent" name="todoContent" required placeholder="할일을 입력해주세요">
		                    </div>
		                </form>
		            </div>
		            <div class="modal-footer">
		                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
		                <button type="button" class="btn btn-primary" id="addTodoBtn">추가</button>
		            </div>
		        </div>
		    </div>
		</div>
		
  	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
	<script>
		$(document).ready(function() {
			
			// 로그인
			const urlParams = new URL(location.href).searchParams;
			const msg = urlParams.get("msg");
				if (msg != null) {
					alert(msg);
				}
			
			// 쿼리 매개변수 "msg"를 제거하고 URL을 업데이트 (새로고침 시 메시지 알림창 출력하지 않음)
	        urlParams.delete("msg");
	        const newUrl = `${location.pathname}?${urlParams.toString()}`;
	        history.replaceState({}, document.title, newUrl);
		
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
			
			// 출퇴근 시간 업데이트 함수
		    function updateCommuteTimes(empOnTime, empOffTime){
		    	$('#onTime').text('출근시간 : '+empOnTime);
	    		$('#offTime').text('퇴근시간 : '+empOffTime);
		    }
		    
			// 출퇴근 데이터 화면 출력 함수
			function selectCommuteByDate(){
		    	$.ajax({
    		    	type:'GET',
    		    	url: '/JoinTree/getCommuteTime',
    		    	success: function(data){
    		    		
    		    		if(data){
    		    			let empOnTime = data.empOnTime;
    		    			let empOffTime = data.empOffTime;
    		            	console.log(empOnTime+'<--empOnTime');
    		            	console.log(empOffTime+'<--empOffTime');
    			    		
    		            	updateCommuteTimes(empOnTime, empOffTime); // 출퇴근 시간 업테이트
    		            	
    		            	// 출퇴근 시간 값에 따른 출퇴근 버튼 상태 분기
							if(empOnTime == null && empOffTime == null){
								$('#commuteBtn').text('출근하기');
								$('#commuteBtn').prop('disabled', false);
    		            	} else if(empOffTime == ''){
    		            		$('#commuteBtn').prop('disabled', false);
    							$('#commuteBtn').text('퇴근하기');
    		            	} else{
   		            			$('#commuteBtn').prop('disabled', true);
       							$('#commuteBtn').text('출근하기');
    		    			}
    		    		}
    		    	},
    		    	error: function(error){
    		    		console.error('error commute data', error);
    		    	}
    		    });
			}
			
			// 초기 페이지 로드 시 출퇴근 데이터 출력, 출퇴근 버튼 초기화
			selectCommuteByDate();
			
		 	// 출근/퇴근 버튼 클릭 이벤트 처리
	        $('#commuteBtn').click(function() {
	            const commuteBtnText = $('#commuteBtn').text().trim(); // 버튼 텍스트 저장
	            const currentTime = $('.clock').text(); // 현재시간 저장
	            const isCommute = commuteBtnText === '출근하기';
	            
	            $.ajax({
	            	type: 'post',
	            	url: '/JoinTree/saveCommuteTime',
	            	data:{
	            		time: currentTime,
	            		type: isCommute ? 'C0101' : 'C0102' // C0101:출근, C0102:퇴근
	            	},
		            success: function(data){
		            	console.log(data+'<--data');
		            	
		    		    selectCommuteByDate(); // 출퇴근 데이터 화면 출력
		            },
		            error: function(error){
		            	console.error('error commute time:', error);
		            }
	            });
	        });
		 	
		 	// 오늘의 일정
		 	// 초기 페이지 로드 시 오늘의 일정 표시
			getTodaySchedule();
		 	
			// 오늘의 일정 가져오기
			function getTodaySchedule() {
			    $.ajax({
			        type: 'GET',
			        url: '/JoinTree/schedule/todayScheduleList',
			        success: function(data) {
			            const todayScheduleList = $('#todayScheduleList'); // 오늘의 일정이 표시될 영역 선택
			            todayScheduleList.empty(); // 기존 내용 삭제

			            data.forEach(function(schedule) {
			            	const scheduleItem = '<li class="schedule-item">' +
			                    '<div class="schedule-title">' + schedule.scheduleTitle + '</div>' +
			                    '</li>';

			                todayScheduleList.append(scheduleItem);
			            });
			        },
			        error: function(error) {
			            console.error('Error getting today\'s schedule', error);
			        }
			    });
			}
		 	
		 	
		 	// TOdO
	    	// 초기 TODO 목록을 가져와서 표시
		    getTodoList();
		 	
	     	// TODO 리스트 가져오기
	        function getTodoList() {
	            $.ajax({
	                type: 'GET',
	                url: '/JoinTree/todo/todoList',
	                success: function(data) {
	                	console.log('data', data);
	                	const todoList = $('#todoList'); // Todo 리스트가 표시될 HTML 엘리먼트 선택
	    	            todoList.empty(); // 기존 내용 삭제
	                    data.forEach(function(todo) { 
	                    	const isChecked = todo.todoStatus === '1';
	                    	const textDecoration = isChecked ? 'text-decoration: line-through;' : '';
	                    	// id = "todoList" 영역에 리스트 출력
	                    	const todoItem = '<div class="todo-item">' +
	                    	   '<input type="checkbox" class="todo-checkbox " data-todono="' + todo.todoNo + '" ' + (todo.todoStatus === '1' ? 'checked' : '') + '>&nbsp;' +
	                    	   '<span class="todo-content" style="' + textDecoration + '">' + todo.todoContent + '</span>&nbsp;' +
	                    	   '<i class="mdi mdi-delete delete-todo" data-todono="' + todo.todoNo + '"></i>' +
	                    	   '</>';

	    	                todoList.append(todoItem);
	    	            });
	                },
	                error: function(error) {
	                    console.error('Error getting todo list', error);
	                }
	            });
	        }
	        
		 
	     	// 체크박스 변경 이벤트
	        $(document).on('change', '.todo-checkbox', function() {
	            const todoNo = $(this).data('todono')
	            const isChecked = $(this).prop('checked');
	            
	            $.ajax({
	                type: 'POST',
	                url: '/JoinTree/todo/updateTodoStatus',
	                contentType: "application/json",
	                data: JSON.stringify({
	                    todoNo: todoNo,
	                    isChecked: isChecked
	                }),
	                success: function(data) {
	                    getTodoList(); // Todo 리스트 업데이트
	                    
	                },
	                error: function(error) {
	                    console.error('Error updating todo status', error);
	                }
	            });
	        });
	     	
	     	// 버튼 클릭 이벤트 처리
	        $('#openAddTodoModalButton').click(function() {
	            // 추가 버튼 클릭 시 모달 창 열기
	            $('#addTodoModal').modal('show');
	        });
	     
	     
	     	// TODO 추가 버튼 클릭 이벤트
	        $('#addTodoBtn').click(function() {
	            const todoContent = $('#todoContent').val();
	            
	            $.ajax({
	                type: 'POST',
	                url: '/JoinTree/todo/addTodo', 
	                contentType: "application/json",
	                data: JSON.stringify({
	                    todoContent: todoContent
	                }),
	                success: function(data) {
	                	// TODO 추가 성공 시
	                	console.log("todo추가성공");
	                	
	                    alert("todo추가성공");
	                    $('#addTodoModal').modal('hide');
            
	        	        getTodoList();
	        	     
	                },
	                error: function(error) {
	                    console.error('Error adding todo', error);
	                }
	            });
	        });
	        
	    	// '할일 추가' 모달 창 숨김 이벤트 감지 및 입력 필드 초기화
	        $('#addTodoModal').on('hidden.bs.modal', function () {
	            $('#todoContent').val(''); // 할일 내용 입력 필드 초기화
	        });
	     	
	        // 삭제 아이콘 클릭
	        $(document).on('click', '.delete-todo', function() {
	            const todoNo = $(this).data('todono');
	           	console.log(todoNo);
	         	// 확인 알림창 띄우기
	            if (confirm('정말로 이 할 일을 삭제하시겠습니까?')) {
	                // "예"를 누르면 삭제 작업 실행
	                removeTodoItem(todoNo);
	            }
	        });
	        
	     	// 할 일 항목 삭제 함수
	        function removeTodoItem(todoNo) {
	        	
	            $.ajax({
	                type: 'POST',
	                url: '/JoinTree/todo/removeTodo', // 컨트롤러의 삭제 URL로 변경
	                contentType: "application/json",
	                data: JSON.stringify({
	                    todoNo: todoNo
	                }),
	                success: function(data) {
						getTodoList(); 
	                },
	                error: function(error) {
	                    console.error('Error removing todo', error);
	                }
	            });
	        }
		});
	</script>
	
	<!-- 필수 요소-->
	<div class="container-fluid page-body-wrapper">
		<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
			<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
				<!-- 컨텐츠 시작 -->
				<div class="row home">
					<div class="col-md-4 stretch-card grid-margin">
						<div class="card card-img-holder">
							<div class="card-body center ">
								<div class="home-profile">
									<img class="mb-2" src="/JoinTree/empImg/tiger.png" >
									<h1 class="mb-2 center">${empInfo.empName}${empInfo.position}</h1>
									<h4 class="mb-2 center">${empInfo.dept}</h4>
									<h1 class="mb-2 clock"></h1>
									<h4 class="mb-2" id="onTime">출근시간 : </h4>
									<h4 class="mb-2" id="offTime">퇴근시간 : </h4>
									<button type="button" class="btn btn-success btn-fw" id="commuteBtn">출근하기</button>
								</div>
							</div>
						</div>
					</div>
					
					<div class="col-md-5 stretch-card grid-margin">
						<div class="card card-img-holder">
							<div class="card-body"> 
								공지사항
								<hr>
								<ul>
										
										<c:forEach var="p" items="${homeProejctList}" varStatus="status">
											<li>
												${p.projectName}(${p.empName})
											</li>
										</c:forEach>
										<li>
											테스트
											</li>
											<li>
											테스트
											</li>
											<li>
											테스트
											</li>
											
									</ul>
								<div>
									<div>프로젝트</div>
									<hr>
									<ul>
										
										<c:forEach var="p" items="${homeProejctList}" varStatus="status">
											<li>
												${p.projectName}(${p.empName})
											</li>
										</c:forEach>
									</ul>
								</div>
							</div>
						</div>
					</div>
					
					<div class="col-md-3 stretch-card grid-margin">
						<div class="card card-img-holder">
							<div class="card-body"> 
								<div class="d-flex justify-content-between align-items-center mb-3">
					                todo
					                <button type="button" class="btn btn-inverse-success btn-icon" id="openAddTodoModalButton">
					                    <i class="mdi mdi-playlist-plus"></i>
					                </button>
					            </div>
								<hr>
								<div id="todoList"> <!-- id 추가 -->
					                <!-- 여기에 Todo 리스트가 동적으로 추가 -->
					            </div>
							</div>
						</div>
					</div>
				</div>
				<!--  두번째 줄 -->
				<div class="row">
					<div class="col-md-9 stretch-card grid-margin">
						<div class="card card-img-holder">
							<div class="card-body"> 
								결재문서목록
								<hr>
								문서함
							</div>
						</div>
					</div>		
					
					<div class="col-md-3 stretch-card grid-margin">
						<div class="card card-img-holder">
							<div class="card-body"> 
								오늘일정
								<hr>
								<ul id="todayScheduleList" class="schedule-list"> <!-- id 추가 -->
					                <!-- 여기에 오늘의 일정이 동적으로 추가 -->
					            </ul>
							</div>
							
						</div>
					</div>					
				</div>
				
				<!--  로그인 임시 -->
				<div class="row">
					<div class="col-md-3 stretch-card grid-margin">
						<div class="card card-img-holder">
							<div class="card-body"> 
								<a href="/login/login">로그인</a>
								<a href="/logout">로그아웃</a>
							</div>
						</div>
					</div>					
				</div>
				
		</div><!-- 컨텐츠 끝 -->
	</div><!-- 컨텐츠전체 끝 -->

</html>
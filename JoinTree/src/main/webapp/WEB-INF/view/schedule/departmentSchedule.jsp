<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.goodee.JoinTree.vo.AccountList" %>
<!DOCTYPE html>
<html>
	<!-- header -->
	<jsp:include page="/WEB-INF/view/inc/header.jsp"/> 
	
	<!-- FullCalendar CDN -->
	<link href='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/main.min.css' rel='stylesheet' />
	<script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/main.min.js'></script>
	<!-- FullCalendar 언어 CDN -->
	<script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/locales-all.min.js'></script>
	<!-- 부트스트랩 CSS CDN -->
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">



	<div class="container-fluid page-body-wrapper">
		<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
		<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
			
			<!-- 달력 출력 -->
			<div id='caslendar-container'>
		    	<div id='calendar'></div>
			</div>
			
		</div>
	</div>	
	
	<!-- footer -->
	<jsp:include page="/WEB-INF/view/inc/footer.jsp"/>				
	
	<!-- 일정 추가 모달창 -->
	<div class="modal fade" id="addScheduleModal" tabindex="-1" role="dialog" aria-labelledby="addScheduleModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">일정 추가</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<form id="eventForm">
						<input type="text" id="scheduleTitle" class="form-control" name="scheduleTitle" placeholder="제목을 입력하세요">
						<br>
						<input type="text" id="scheduleContent" class="form-control" name="scheduleContent" placeholder="내용을 입력하세요">
						<br>
						<input type="text" id="scheduleLocation" class="form-control" name="scheduleLocation"placeholder="장소를 입력하세요">
						<br>
						시작일
						<input type="datetime-local" id="scheduleStart" class="form-control" name="scheduleStart">
						<br>
						<!-- 종료일 선택 부분 -->
						<div id="endTimeContainer">
						종료일
						<input type="datetime-local" id="scheduleEnd" class="form-control" name="scheduleEnd">
						</div>
						<br>
						
						<label>시작일 종료일 같음
						<input type="checkbox" id="checkboxAllDay"></label>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
					<button type="button" class="btn btn-primary" id="submitScheduleBtn">추가</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 상세보기 모달창 -->
	<div class="modal fade" id="scheduleOneModal" tabindex="-1" role="dialog" aria-labelledby="viewScheduleModalLabel" aria-hidden="true">
	    <div class="modal-dialog">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title" id="exampleModalLabel">일정 상세보기</h5>
	                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	            </div>
	            <div class="modal-body">
	                <p><strong>제목:</strong> <span id="viewTitle"></span></p>
	                <p><strong>내용:</strong> <span id="viewContent"></span></p>
	                <p><strong>장소:</strong> <span id="viewLocation"></span></p>
	                <p><strong>시작일:</strong> <span id="viewStart"></span></p>
	                <p><strong>종료일:</strong> <span id="viewEnd"></span></p>
	            </div>
	            <div class="modal-footer">
	                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
	                <button type="button" class="btn btn-warning" id="editScheduleBtn">수정</button>
	                <button type="button" class="btn btn-danger" id="deleteScheduleBtn">삭제</button>
	            </div>
	        </div>
	    </div>
	</div>
	
	<!-- 수정 모달창 -->
	<div class="modal fade" id="editScheduleModal" tabindex="-1" role="dialog" aria-labelledby="editScheduleModalLabel" aria-hidden="true">
	    <div class="modal-dialog">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title" id="exampleModalLabel">일정 수정</h5>
	                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	            </div>
	            <div class="modal-body">
                    <input type="text" id="editScheduleTitle" class="form-control">
                    <br>
                    <input type="text" id="editScheduleContent" class="form-control">
                    <br>
                    <input type="text" id="editScheduleLocation" class="form-control">
                    <br>
                    시작일
                    <input type="datetime-local" id="editScheduleStart" class="form-control">
                    <br>
                    종료일
                    <input type="datetime-local" id="editScheduleEnd" class="form-control">
                    <br>
	            </div>
	            <div class="modal-footer">
	                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
	                <button type="button" class="btn btn-primary" id="updateScheduleBtn">수정</button>
	            </div>
	        </div>
	    </div>
	</div>

<script>
	// 페이지 로드 되면 부서 일정 출력
	$(document).ready(function() {
	    var calendarEl = document.getElementById('calendar');
	    var calendar = new FullCalendar.Calendar(calendarEl, {
	        timeZone: 'Asia/Seoul',
	        selectable: true,
	        events: '/JoinTree/schedule/getDepartmentSchedules',
	        select: function(info) {
				var startDate = info.start;
				var endDate = info.end;
				openModal(startDate, endDate);
			},
			eventClick: function(info) {
				var event = info.event;
				selectedEvent = event; // 선택한 일정을 selectedEvent 변수에 저장
				openEventModal(event);
			}
	       
	    });
	
	
	    // 일정추가 모달창
	    function openModal(startDate, endDate) {
	        $('#addScheduleModal').modal('show');
	        $('#scheduleTitle').val('');
	        $('#scheduleContent').val('');
	        $('#scheduleLocation').val('');
	        $('#scheduleStart').val(startDate.toISOString().slice(0, 16));
	        $('#scheduleEnd').val(endDate.toISOString().slice(0, 16));
	
	        var checkboxAllDay = $('#checkboxAllDay');
	        var startTimeInput = $('#scheduleStart');
	        var endTimeInput = $('#scheduleEnd');
	        var endTimeContainer = $('#endTimeContainer');
	
	        checkboxAllDay.change(function() {
	            if (checkboxAllDay.is(':checked')) {
	            	// 체크박시 선택시 종료일 선택 부분 숨김
					endTimeContainer.hide();
					// startTimeInput.prop('disabled', true); // 시작일 입력 비활성화
					endTimeInput.val(startTimeInput.val()); // 종료일을 시작일과 같은 값으로 설정
	            } else {
	            	endTimeContainer.show(); // 종료일 보여줌
	            }
	        });
	        
	        checkboxAllDay.trigger('change');
	    }
	    
		// 일정추가
	    var submitScheduleBtn = document.getElementById('submitScheduleBtn');
	    submitScheduleBtn.addEventListener('click', function() {
	        var allDay = $('#checkboxAllDay').prop('checked');
	        var startTime = $('#scheduleStart').val();
	        var endTime = allDay ? startTime : $('#scheduleEnd').val();
	
	        var title = $('#scheduleTitle').val();
	        var content = $('#scheduleContent').val();
	        if (title.trim() === '' || content.trim() === '') {
	            alert('제목과 내용은 필수 입력 사항입니다.');
	            return;
	        }
	
	        if (!allDay && new Date(endTime) < new Date(startTime)) {
	            alert('종료일은 시작일보다 늦어야 합니다.');
	            return;
	        }
	
	        var eventData = {
	        	    scheduleTitle: title,
	        	    scheduleContent: content,
	        	    scheduleLocation: $('#scheduleLocation').val(),
	        	    scheduleStart: startTime,
	        	    scheduleEnd: endTime,
	        };
			
	        // 일정 추가 비동기 처리
	        $.ajax({
	            type: 'POST',
	            url: '/JoinTree/schedule/addDepartmentSchedule',
	            contentType: 'application/json',
	            data: JSON.stringify(eventData),
	            success: function(response) {
	                if (response.success) {
	                    if (!allDay) {
	                        eventData.end = endTime;
	                    }
	                  	//alert("성공");
	                    calendar.addEvent(eventData);
	                    $('#addScheduleModal').modal('hide');
	                    
	                	// 캘린더를 새로 고치기 위해 함수 호출
	                    fetchAndRenderCalendarEvents();
	                } else {
	                    console.error('Failed to add schedule.');
	                }
	            }
	        });
	        
	    });
		
	    // 일정 추가후 새로고침
	    function fetchAndRenderCalendarEvents() {
	        calendar.refetchEvents();
	    }
		
	    // 상세보기
	    function openEventModal(event) {
	        // 일정 상세 정보를 가져오는 Ajax 요청
	        $.ajax({
	            type: 'GET',
	            url: '/JoinTree/schedule/selectScheduleOne',
	            data: { scheduleNo: event.id }, // 해당 일정의 id 값을 전달
	            success: function(response) {
	                $('#scheduleOneModal').modal('show');
	                $('#viewTitle').text(response.scheduleTitle);
	                $('#viewContent').text(response.scheduleContent);
	                $('#viewLocation').text(response.scheduleLocation);
	                $('#viewStart').text(response.scheduleStart);
	                $('#viewEnd').text(response.scheduleEnd);
	                
	             	// 작성자(empNo)와 로그인한 사용자의 empNo 비교
	                var loginEmpNo = <%= ((AccountList) session.getAttribute("loginAccount")).getEmpNo() %>;
	                if (response.empNo === loginEmpNo) {
	                    $('#editScheduleBtn').show(); // 작성자와 일치할 경우 수정 버튼 보이기
	                    $('#deleteScheduleBtn').show(); // 작성자와 일치할 경우 삭제 버튼 보이기
	                } else {
	                    $('#editScheduleBtn').hide(); // 작성자와 불일치할 경우 수정 버튼 숨기기
	                    $('#deleteScheduleBtn').hide(); // 작성자와 불일치할 경우 삭제 버튼 숨기기
	                }
	                
	             	// response 객체에서 일정 정보를 읽어와서 selectedEvent 객체 생성
	                var selectedEvent = {
	                    id: response.scheduleNo,
	                    scheduleTitle: response.scheduleTitle,
	                    scheduleContent: response.scheduleContent,
	                    scheduleLocation: response.scheduleLocation,
	                    scheduleStart: response.scheduleStart,
	                    scheduleEnd: response.scheduleEnd
	                };
	                
	             	// 기존의 click 이벤트 핸들러를 제거
	                $('#deleteScheduleBtn').off('click');
	             	
	             	// 일정상세에서 '삭제' 버튼 클릭 -> '확인' 클릭시 삭제 
	                $('#deleteScheduleBtn').on('click', function() {
	                    if (confirm('진짜 삭제하시겠습니까?')) {
	                        deleteSchedule(event.id);
	                    }
	                });
	             	
	             	// 수정 버튼 클릭
	    	        $('#editScheduleBtn').on('click', function() {
	    	        	openEditModal(selectedEvent);
	    	        });
	             
	            },
	            error: function() {
	                console.error('Failed to fetch schedule details.');
	            }
	        });
	    }
	    
		 // 일정 삭제
	    function deleteSchedule(scheduleNo) {
		    // 세션에서 empNo 추출
	    	var empNo = <%= ((AccountList) session.getAttribute("loginAccount")).getEmpNo() %>;
	    	console.log(empNo);
		        
            $.ajax({
                type: 'POST',
                url: '/JoinTree/schedule/removeSchedule',
                contentType: 'application/json',
                data: JSON.stringify({ scheduleNo: scheduleNo, empNo: empNo }), // 객체 형태로 전달
                success: function(response) {
                    if (response.success) {
                        // 캘린더를 새로 고치기 위해 함수 호출
                        fetchAndRenderCalendarEvents();
                        $('#scheduleOneModal').modal('hide');
						// 삭제 성공 알림창 띄우기
						alert('일정이 성공적으로 삭제되었습니다.');
                    } else {
                    	
                        console.error('Failed to delete schedule.');
                    }
                }
            });
        }
		 
	 	// 일정 수정
	    function openEditModal(selectedEvent) {
	    	
	    	console.log(selectedEvent);
	    	// 기존값 불러오기
	        $('#editScheduleTitle').val(selectedEvent.scheduleTitle);
	        $('#editScheduleContent').val(selectedEvent.scheduleContent);
	        $('#editScheduleLocation').val(selectedEvent.scheduleLocation);
	        $('#editScheduleStart').val(selectedEvent.scheduleStart);
	        $('#editScheduleEnd').val(selectedEvent.scheduleEnd);
	        
	     	// '수정' 버튼 클릭 시 수정 액션에 필요한 값들을 설정합니다.
	        $('#updateScheduleBtn').off('click'); // 기존 클릭 이벤트 핸들러 제거
			$('#updateScheduleBtn').on('click', function() {
				// 세션에서 empNo 추출
	            var scheduleNo = selectedEvent.id;
	            var empNo = <%= ((AccountList) session.getAttribute("loginAccount")).getEmpNo() %>;
	            
	         	// 서버로 수정된 일정 정보 전송
	            $.ajax({
	                type: 'POST',
	                url: '/JoinTree/schedule/modifySchedule',
	                contentType: 'application/json',
	                data: JSON.stringify({
	                    scheduleNo: scheduleNo,
	                    empNo: empNo,
	                    scheduleTitle: $('#editScheduleTitle').val(),
		                scheduleContent: $('#editScheduleContent').val(),
		                scheduleLocation: $('#editScheduleLocation').val(),
		                scheduleStart: $('#editScheduleStart').val(),
		                scheduleEnd: $('#editScheduleEnd').val()
	                }),
	                success: function(response) {
	                    if (response.success) {
	                        // 일정을 다시 불러와서 FullCalendar에 업데이트
	                        fetchAndRenderCalendarEvents();
	                        $('#editScheduleModal').modal('hide');
	                     	// 수정된 내용으로 상세보기 모달창 다시 열기
	                        openEventModal(selectedEvent);
	                    } else {
	                        console.error('Failed to update schedule.');
	                    }
	                }
	            });
	        });

	        $('#editScheduleModal').modal('show');
	    }
	       
	    calendar.render();
	    
	});
</script>
</html>
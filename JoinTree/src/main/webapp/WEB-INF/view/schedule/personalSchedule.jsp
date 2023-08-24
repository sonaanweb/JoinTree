<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
	            </div>
	        </div>
	    </div>
	</div>

	<!-- 스케줄 추가 모달창 -->
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

<script>
	// 페이지 로드 되면 개인 일정 출력
	$(document).ready(function() {
	    var calendarEl = document.getElementById('calendar');
	    var calendar = new FullCalendar.Calendar(calendarEl, {
	        timeZone: 'Asia/Seoul',
	        selectable: true,
	        events: '/schedule/getPersonalSchedules',
	        eventClick: function(info) {
	            var scheduleNo = parseInt(info.event.extendedProps.scheduleNo);
	            console.log(scheduleNo);
	            if (!isNaN(scheduleNo)) {
	                // 일정 번호를 가져와서 서버에서 상세 정보를 요청합니다.
	                fetchScheduleDetails(scheduleNo);
	            } else {
	                console.error('Invalid schedule number:', info.event.extendedProps.scheduleNo);
	            }
	        },
	        select: function(info) {
	            var startDate = info.start;
	            var endDate = info.end;
	            openModal(startDate, endDate);
	        }
	       
	    });
	
	    // 상세보기 모달창
	    function fetchScheduleDetails(scheduleNo) {
	        $.ajax({
	            type: 'GET',
	            url: '/schedule/selectScheduleOne',
	            data: { scheduleNo: scheduleNo },
	            dataType: 'json',
	            success: function(schedule) {
	                // 상세 정보를 모달 창에 표시하는 함수를 호출
	                displayScheduleDetails(schedule);
	            },
	            error: function(error) {
	                console.error('Failed to fetch schedule details.', error);
	            }
	        });
	    }
	
	    function displayScheduleDetails(schedule) {
	        $('#viewTitle').text(schedule.scheduleTitle);
	        $('#viewContent').text(schedule.scheduleContent);
	        $('#viewLocation').text(schedule.scheduleLocation);
	        $('#viewStart').text(schedule.scheduleStart);
	        $('#viewEnd').text(schedule.scheduleEnd);
	
	        $('#scheduleOneModal').modal('show');
	    }
	
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
	            url: '/schedule/addPersonalSchedule',
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
		
	    calendar.render();
	    
	});
</script>
</html>
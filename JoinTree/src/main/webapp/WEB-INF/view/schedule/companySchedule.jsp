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

<script>

	document.addEventListener('DOMContentLoaded', function() {
		var calendarEl = document.getElementById('calendar');
		var calendar = new FullCalendar.Calendar(calendarEl, {
			timeZone: 'Asia/Seoul',
			selectable: true,
			events: '/schedule/getCompanySchedules',
			eventClick: function(info) {
				var scheduleNo = parseInt(info.event.extendedProps.scheduleNo);
				console.log(info.event);
				if (!isNaN(scheduleNo)) { // 정수로 변환 가능한지 체크
			        openViewModal(scheduleNo); // 일정 클릭 시 상세보기 모달 창 열기
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
		
		calendar.render();
		
		//상세보기 모달창
		function openViewModal(scheduleNo) {
			 $.ajax({
	                type: 'GET',
	                url: '/schedule/selectScheduleOne', // 서버에서 상세 정보를 가져오는 URL
	                data: { scheduleNo: scheduleNo },
	                dataType: 'json', // JSON 형식으로 응답을 처리
	                success: function(schedule) {
	                	$('#viewTitle').text(schedule.scheduleTitle);
	                    $('#viewContent').text(schedule.scheduleContent);
	                    $('#viewLocation').text(schedule.scheduleLocation);
	                    $('#viewStart').text(schedule.scheduleStart);
	                    $('#viewEnd').text(schedule.scheduleEnd);

	         		    $('#scheduleOneModal').modal('show');
	                },
	                error: function(error) {
	                    console.error('Failed to fetch schedule details.', error);
	                }
	            })
		   
		}
		
		// 일정추가 모달창
		function openModal(startDate, endDate) {
			$('#addScheduleModal').modal('show');
			$('#scheduleTitle').val('');
			$('#scheduleContent').val('');
			$('#scheduleLocation').val('');
			$('#scheduleStart').val(startDate.toISOString().slice(0, 16));
			$('#scheduleEnd').val(endDate.toISOString().slice(0, 16));

			var allDayCheckbox = $('#allDay');
			var startTimeInput = $('#scheduleStart');
			var endTimeInput = $('#scheduleEnd');

			allDayCheckbox.change(function() {
				if (allDayCheckbox.is(':checked')) {
				startTimeInput.prop('disabled', true);
				endTimeInput.prop('disabled', true);
				startTimeInput.val(startDate.format('YYYY-MM-DDTHH:mm'));
				endTimeInput.val(startDate.clone().endOf('day').format('YYYY-MM-DDTHH:mm'));
				} else {
				startTimeInput.prop('disabled', false);
				endTimeInput.prop('disabled', false);
				}
			});

			allDayCheckbox.trigger('change');
		}

		var submitScheduleBtn = document.getElementById('submitScheduleBtn');
		submitScheduleBtn.addEventListener('click', function() {
			var allDay = $('#allDay').prop('checked');
			var startTime = $('#scheduleStart').val();
			var endTime = allDay ? startTime : $('#scheduleEnd').val();
    
			// 제목, 내용 필수(유효성검사)
			var title = $('#scheduleTitle').val();
			var content = $('#scheduleContent').val();
			if (title.trim() === '' || content.trim() === '') {
				alert('제목과 내용은 필수 입력 사항입니다.');
				return;
			}
    
			// 종료일은 시작일보다 이전X 
			if (!allDay && new Date(endTime) < new Date(startTime)) {
				alert('종료일은 시작일보다 늦어야 합니다.');
				return;
			}

			var eventData = {
			title: $('#scheduleTitle').val(),
			content: $('#scheduleContent').val(),
			location: $('#scheduleLocation').val(),
			start: startTime,
			end: endTime,
			allDay: allDay
			};
    
			$.ajax({
				type: 'POST',
				url: '/schedule/add',
				contentType: 'application/json',
				data: JSON.stringify(eventData),
				success: function(response) {
					if (response.success) {
						if (!allDay) {
							eventData.start = startTime;
							eventData.end = endTime;
						}
						calendar.addEvent(eventData);
						$('#addScheduleModal').modal('hide');
					} else {
						console.error('Failed to add schedule.');
					}
				}
			});
		});
  
		// 폼 닫힐때마다 모달창 초기화
		$('#addScheduleModal').on('hidden.bs.modal', function() {
			$('#scheduleTitle').val('');
			$('#scheduleContent').val('');
			$('#scheduleLocation').val('');
			$('#scheduleStart').val('');
			$('#scheduleEnd').val('');
			$('#allDay').prop('checked', false);
		});
  
	});
	
</script>

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
						종료일
						<input type="datetime-local" id="scheduleEnd" class="form-control" name="scheduleEnd">
						<br>
						
						<label>하루 종일
						<input type="checkbox" id="allDay"></label>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
					<button type="button" class="btn btn-primary" id="submitScheduleBtn">추가</button>
				</div>
			</div>
		</div>
	</div>

</body>
</html>
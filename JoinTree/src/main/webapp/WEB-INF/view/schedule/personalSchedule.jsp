<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<!-- FullCalendar CDN -->
	<link href='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/main.min.css' rel='stylesheet' />
	<script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/main.min.js'></script>
	<!-- FullCalendar 언어 CDN -->
	<script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/locales-all.min.js'></script>
	<!-- jQuery CDN -->
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<!-- 부트스트랩 CDN -->
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<!-- 달력 출력 -->
	<div id='calendar-container'>
    	<div id='calendar'></div>
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
						
						종료일
						<input type="datetime-local" id="scheduleEnd" class="form-control" name="scheduleEnd">
						<label>하루 종일</label>
						<input type="checkbox" id="allDay" class="form-check-input">
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
	document.addEventListener('DOMContentLoaded', function() {
		var calendarEl = document.getElementById('calendar');
		var calendar = new FullCalendar.Calendar(calendarEl, {
			timeZone: 'Asia/Seoul',
			selectable: true,
			events: '/schedule/getPersonalSchedules',
			select: function(info) {
				var startDate = info.start;
				var endDate = info.end;
				openModal(startDate, endDate);
			}
		});
		
		calendar.render();
		
		
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
</body>
</html>
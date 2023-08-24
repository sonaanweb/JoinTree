<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/fullcalendar@5.10.1/main.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.10.1/main.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.18.1/moment.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.10.1/locales-all.js"></script>
<style>
  html, body {
    margin: 0;
    padding: 0;
    font-family: Arial, Helvetica Neue, Helvetica, sans-serif;
    font-size: 14px;
  }

  #calendar {
    max-width: 1100px;
    margin: 40px auto;
  }
.fc .fc-button-primary {
	    background-color: #C8E4B2;
}
</style>
<!-- 캘린더 문제로 회의실별 예약 현황 캘린더로 수정해야 합니다 -->
<title>예약 현황 창(캘린더) + 예약하기</title>
</head>
<body>
<div id='calendar'></div>

<script>
document.addEventListener('DOMContentLoaded', function() {
	
	var calendarEl = document.getElementById('calendar');
	var calendar = new FullCalendar.Calendar(calendarEl, {
		initialView : 'timeGridWeek',
		headerToolbar : {
			start : 'prev next today',
			center : 'title',
			right: 'timeGridWeek'
		},
		titleFormat : function(date) {
			return date.date.year + '년 ' + (parseInt(date.date.month) + 1) + '월';
		},
		selectable : true,
		droppable : true,
		editable : true,
		nowIndicator: true,
		locale: 'ko',
		height: 'auto', // 캘린더 높이 조절
	    slotDuration: '00:30:00',
	    slotMinTime: '09:00:00',
	    slotMaxTime: '18:00:00',  // 오후 6시까지 슬롯 생성
	    slotLabelInterval: { hours: 1 },  // 1시간 간격으로 레이블 표시
	    slotLabelFormat: {
	        hour: 'numeric',
	        hour12: true
	    },
	    editable: false, //드래그 막기
	    
	    //DB 연결
	    events: function(info, successCallback, failureCallback) {
	    	var roomNo = ${roomNo};
	    	
		    $.ajax({
		        url: '/meetRoomReserv?roomNo=' + roomNo, // AJAX를 통해 데이터를 가져올 URL
		        type: 'GET',
		        dataType: 'json',
		        success: function(response) {
		            var events = [];
		            for (var i = 0; i < response.length; i++) {
		                events.push({
		                    title: response[i].title,
		                    start: response[i].start,
		                    end: response[i].end
		                });
		            }
		            successCallback(events); // 성공 시 이벤트 배열을 전달
		        },
		        error: function() {
		            failureCallback('There was an error while fetching events.'); // 오류 시 메시지 전달
		        }
		    });
		}
	 
	});
	calendar.render();
});
</script>
</body>
</html>
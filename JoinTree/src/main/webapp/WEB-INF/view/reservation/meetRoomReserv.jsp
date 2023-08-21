<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js'></script>
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
</style>

 <script>
  document.addEventListener('DOMContentLoaded', function() {
    var calendarEl = document.getElementById('calendar');

    var calendar = new FullCalendar.Calendar(calendarEl, {
      timeZone: 'UTC',
      initialView: 'dayGridWeek',
      headerToolbar: {
        left: 'prev,next',
        center: 'title',
        right: 'dayGridWeek'
      },
      editable: true,
      events: '/api/demo-feeds/events.json'
    });

    calendar.render();
  });
</script>
<title>예약 현황 창(캘린더) + 예약하기</title>
</head>
<body>
<div class="container-scroller"> <!-- 전체 스크롤 -->
	<div class="container-fluid page-body-wrapper"><!-- 상단제외 -->
	<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 위왼쪽 사이드바 -->
		<div class = "main-panel"> <!-- 컨텐츠 전체 -->
			<div class="content-wrapper"> <!-- 컨텐츠 -->
    			
    			<div id='calendar'></div>
    				
<!-- include footer start -->
			</div><!-- 컨텐츠 끝 -->
		</div><!-- 컨텐츠전체 끝 -->
	</div><!-- 상단제외 끝 -->
</div><!-- 전체 스크롤 끝 -->
<jsp:include page="/WEB-INF/view/inc/footer.jsp"/>
<!-- include footer end -->
</body>
</html>
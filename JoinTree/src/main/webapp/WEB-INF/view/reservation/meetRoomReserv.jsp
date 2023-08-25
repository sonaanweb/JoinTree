<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/fullcalendar@5.10.1/main.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/main.min.css' rel='stylesheet' />
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/main.min.js'></script>
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/locales-all.min.js'></script>
<script src="https://code.jquery.com/jquery-latest.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/dayjs/1.10.7/dayjs.min.js"></script>
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
<!-- header -->
<jsp:include page="/WEB-INF/view/inc/header.jsp"/>
<!-- 필수 요소-->
<div class="container-fluid page-body-wrapper">
	<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
		<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
			<!-- fullCal -->
			<div id='calendar'></div>
			<!------------->
			<!-- modal 추가 -->
			    <div class="modal fade" id="calendarModal" tabindex="-1" role="dialog" aria-labelledby="reservationModalLabel" aria-hidden="true">
			        <div class="modal-dialog" role="document">
			            <div class="modal-content">
			                <div class="modal-header">
			                    <h4 class="modal-title" id="exampleModalLabel">회의실 예약하기</h4>
			                </div>
			                <div class="modal-body">
			                    <div class="form-group">
			                    	<!-- 회의실 이름 끌고오기 -->
			                        <label for="taskId" class="col-form-label">회의실 이름</label>
			                        <input type="text" class="form-control" id="roomName" name="roomName" readonly="readonly">
			 						<label for="selectedDate" class="col-form-label">선택 날짜</label>
			        				<input type="text" class="form-control" id="selectedDate" name="selectedDate" readonly="readonly">
						            <label for="revStartTime" class="col-form-label">시작 시간</label>
			                        <select class="form-control" id="revStartTime" name="revStartTime">
										<option value="09:00">09:00</option>
										<option value="09:30">09:30</option>
										<option value="10:00">10:00</option>
										<option value="10:30">10:30</option>
										<option value="11:00">11:00</option>
										<option value="11:30">11:30</option>
										<option value="12:00">12:00</option>
										<option value="12:30">12:30</option>
										<option value="13:00">13:00</option>
										<option value="13:30">13:30</option>
										<option value="14:00">14:00</option>
										<option value="14:30">14:30</option>
										<option value="15:00">15:00</option>
										<option value="15:30">15:30</option>
										<option value="16:00">16:00</option>
										<option value="16:30">16:30</option>
										<option value="17:00">17:00</option>
										<option value="17:30">17:30</option>
							        </select>
			                        <label for="revEndTime" class="col-form-label">종료 시간</label>
			                        <select class="form-control" id="revEndTime" name="revEndTime">
										<option value="09:30">09:30</option>
										<option value="10:00">10:00</option>
										<option value="10:30">10:30</option>
										<option value="11:00">11:00</option>
										<option value="11:30">11:30</option>
										<option value="12:00">12:00</option>
										<option value="12:30">12:30</option>
										<option value="13:00">13:00</option>
										<option value="13:30">13:30</option>
										<option value="14:00">14:00</option>
										<option value="14:30">14:30</option>
										<option value="15:00">15:00</option>
										<option value="15:30">15:30</option>
										<option value="16:00">16:00</option>
										<option value="16:30">16:30</option>
										<option value="17:00">17:00</option>
										<option value="17:30">17:30</option>
										<option value="18:00">18:00</option>
							        </select>
			                        <label for="taskId" class="col-form-label">내용</label>
			                        <input type="text" class="form-control" id="revReason" name="revReason" placeholder="간단히 예약 사유를 적어주세요 :)">
			                        <!-- rev_status = 기본값 주기... 회의실 = A0302예약완료 A0303예약취소 -->
			                    </div>
			                </div>
			                <div class="modal-footer">
			                    <button type="button" class="btn btn-warning" id="addCalendar">추가</button>
			                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
			                </div>
			            </div>
			        </div>
   				</div>				
			</div><!-- 컨텐츠 끝 -->
		</div><!-- 컨텐츠전체 끝 -->

<script>
document.addEventListener('DOMContentLoaded', function() {
    var calendarEl = document.getElementById('calendar');
    var roomName = '<%= request.getParameter("roomName") %>';

    var calendar = new FullCalendar.Calendar(calendarEl, {
    	timeZone: 'Asia/Seoul',
    	locale: 'ko',
        initialView : 'timeGridWeek',
        headerToolbar : {
            start : 'prev next today',
            center : 'title',
            right: 'timeGridWeek'
        },
        titleFormat: function(date) {
            var formattedDate = date.date.year + '년 ' + (parseInt(date.date.month) + 1) + '월';
            return formattedDate + ' - ' + roomName + ' 예약현황';
        },
        selectable : true,
        droppable : true,
        editable : true,
        nowIndicator: true,
        height: 'auto',
        slotDuration: '00:30:00',
        slotMinTime: '09:00:00',
        slotMaxTime: '18:00:00',
        slotLabelInterval: { hours: 1 },
        slotLabelFormat: {
            hour: 'numeric',
            hour12: true
        },
        editable: false,
        
        events: function(info, successCallback, failureCallback) {
            var roomNo = ${roomNo};
            
            $.ajax({
                url: '/JoinTree/meetRoomReserv?roomNo=' + roomNo,
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
                    successCallback(events);
                },
                error: function() {
                    failureCallback('There was an error while fetching events.');
                }
            });
        },
        
        // 빈 시간대 클릭 시 예약 모달 창 띄우기 -- 닫아줘야해요
        select: function(info) {
            $('#calendarModal').modal('show');
			
            var selectedDate = info.startStr.split("T")[0];
            var selectedStartTime = info.startStr.split("T")[1].substring(0, 5); // HH:MM 형식으로 추출
            var selectedEndTime = info.endStr.split("T")[1].substring(0, 5); // HH:MM 형식으로 추출
           
         	// 선택한 날짜 정보를 모달 창에 전달
		 	$('#selectedDate').val(selectedDate);
		    $('#revStartTime').val(selectedStartTime);
		    $('#revEndTime').val(selectedEndTime);
		    $('#roomName').val(roomName);

            // 추가 버튼을 클릭하면 예약 추가
            $('#addCalendar').click(function() {
                var reservationInfo = {
                    roomName: $('#roomName').val(),
                    startTime: $('#revStartTime').val(),
                    endTime: $('#revEndTime').val(),
                    reason: $('#revReason').val()
                };
             
                // 캘린더에 해당 예약 이벤트를 추가합니다.
                calendar.addEvent({
                    title: reservationInfo.roomName,
                    start: reservationInfo.startTime,
                    end: reservationInfo.endTime
                });

                // 모달 창을 닫습니다.
                $('#calendarModal').modal('hide');
            });
        }
    });

    calendar.render();
});
</script>
</body>
</html>
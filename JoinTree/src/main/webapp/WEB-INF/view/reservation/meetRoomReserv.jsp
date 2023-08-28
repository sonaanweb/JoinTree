<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/main.min.css' rel='stylesheet' />
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/main.min.js'></script>
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/locales-all.min.js'></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment-timezone/0.5.36/moment-timezone-with-data.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">

<style>
html, body {
  margin: 0;
  padding: 0;
  font-family: Arial, Helvetica Neue, Helvetica, sans-serif;
  font-size: 14px;
}

#calendar {
  max-width: 1400px;
  margin: 40px auto;
}


.fc .fc-button-primary {
	    background-color: #C8E4B2;
}

.fc .fc-timegrid-slot {
    height: 2em;
}
</style>
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
			                    	<!-- 회의실 이름 끌고오기 , roomNo를 할당해줍니다 -->
			                    	<input type="hidden" id="equipNo" name="equipNo" value="${roomNo}">
			                        <label for="taskId" class="col-form-label">회의실 이름</label>
			                        <input type="text" class="form-control" id="roomName" name="roomName" readonly="readonly">
			                        <!-- 날짜와 시간을 따로 두었기 때문에 합쳐서 DB에 들어가는 작업이 필요함 -->
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
			                        <input type="text" class="form-control" id="revReason" name="revReason" placeholder="예약 내용을 적어주세요 :) 캘린더에 함께 표시됩니다.">
			                    	<div class="check" id="rn_check"></div>
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
    var urlParams = new URLSearchParams(window.location.search);
    var roomNo = urlParams.get('roomNo'); // URL 매개변수에서 roomNo 호출
    var roomName = urlParams.get('roomName'); // URL 매개변수에서 roomName 호출

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
        selectOverlap: false, // 중복 불가
        selectable : true,
        droppable : true,
        editable : false,
        nowIndicator: false,
        allDaySlot: false,
        slotLabelFormat: '',
        height: 'auto',
        slotDuration: '00:30:00',
        slotMinTime: '09:00:00', // 오전 9시부터 슬롯 시작
        slotMaxTime: '18:00:00', // 오후 6시까지 슬롯 끝
        slotLabelInterval: { hours: 1 },
        slotLabelFormat: {
            hour: 'numeric',
            hour12: true
        },
        events: function(info, successCallback, failureCallback) {
            $.ajax({
                url: '/JoinTree/meetRoomReserv?roomNo=' + roomNo,
                type: 'GET',
                dataType: 'json',
                success: function(response) {
                    var events = [];
                    for (var i = 0; i < response.length; i++) {
                        events.push({
                            title: response[i].title, // '', - 타이틀 안 보이게
                            start: response[i].start,
                            end: response[i].end
                        });
                    }
                    successCallback(events);
                },
                error: function() {
                    failureCallback('캘린더 값 오류');
                }
            });
        },
        
        select: function(info) {
        	
        	// --- 예약 중복 검사 LIST(select option창에서도 선택 불가능하게 제어해야함)
            var selectedStart = moment(info.startStr);
            var selectedEnd = moment(info.endStr);

            // 캘린더 확인 후 중복검사
            var overlappingEvent = calendar.getEvents().find(function(event) {
            	
                var eventStart = moment.tz(event.startStr, 'Asia/Seoul'); // start, end 뒤에 str 붙여야 적용 - 문자열 형식
                var eventEnd = moment.tz(event.endStr, 'Asia/Seoul');  
                //console.log(eventStart);
                //console.log(eventEnd);
                
                return (
                        (selectedStart.isSameOrAfter(eventStart) && selectedStart.isBefore(eventEnd)) ||
                        (selectedEnd.isAfter(eventStart) && selectedEnd.isSameOrBefore(eventEnd)) ||
                        (selectedStart.isSameOrBefore(eventStart) && selectedEnd.isSameOrAfter(eventEnd))
                    );
                });

                if (overlappingEvent) {
                    alert("이미 예약된 시간입니다.");
                    return;
                }
        	// ----
        	
        	// ---- 시간 유효성 검사
        	 var now = moment(); // 현재 날짜와 시간
       	     var selectedDateTime = moment.tz(info.startStr, 'Asia/Seoul'); //오류 기록해둬야지..
        	 //console.log(selectedDateTime);

       	    // 선택한 날짜와 시간 둘 다 이전인 경우
       	    if (selectedDateTime.isBefore(now)) {
       	        alert("지난 날짜와 시간에는 예약할 수 없습니다.");
       	        return;
       	    }

       	    // 날짜는 같지만 시간이 현재시간 기준으로 이전인 경우
       	    if (selectedDateTime.isSame(now, 'day') && selectedDateTime.isBefore(now, 'hour')) {
       	        alert("지난 시간에는 예약할 수 없습니다.");
       	        return;
       	    }
       	    
       	    // -----
            
            $('#calendarModal').modal('show');
 
            var selectedDate = info.startStr.split("T")[0];
            var selectedStartTime = info.startStr.split("T")[1].substring(0, 5);
            var selectedEndTime = info.endStr.split("T")[1].substring(0, 5);
            
            $('#selectedDate').val(selectedDate);
            $('#revStartTime').val(selectedStartTime);
            $('#revEndTime').val(selectedEndTime);
            $('#roomName').val(roomName);
        }
    });
    
    
    // 추가 버튼 클릭 이벤트 처리 -----> 모달창에선 지난 시간들 예약 처리되는 오류 수정해야함
    $('#addCalendar').click(function() {
        var revReason = $('#revReason').val().trim();

        if (revReason === "") {
            $("#rn_check").text("공백은 입력할 수 없습니다.");
            $("#rn_check").css("color", "red");
            $("#revReason").focus();
            return;
        }
        
        // 예약 중복 검사
        var selectedStart = moment.tz($('#selectedDate').val() + ' ' + $('#revStartTime').val(), 'Asia/Seoul');
        var selectedEnd = moment.tz($('#selectedDate').val() + ' ' + $('#revEndTime').val(), 'Asia/Seoul');
        console.log("추가 선택 시작 시간:",selectedStart);
        console.log("추가 선택 종료 시간:",selectedEnd);
        
        // 예약 시작시간이 종료 시간보다 느릴 경우 메시지 표시
        if (selectedStart.isSameOrAfter(selectedEnd)) {
            $("#rn_check").text("예약 시작시간이 종료 시간보다 늦거나 같을 수 없습니다.");
            $("#rn_check").css("color", "red");
            return;
        }
        
        var overlappingEvent = calendar.getEvents().find(function(event) {
            var eventStart = moment.tz(event.startStr, 'Asia/Seoul');
            var eventEnd = moment.tz(event.endStr, 'Asia/Seoul');
            console.log("예약중복검사 이미 존재하는 시작 시간:",eventStart);
            console.log("예약중복검사 이미 존재하는 종료 시간:",eventEnd);
            
            return (
                (selectedStart.isSameOrAfter(eventStart) && selectedStart.isBefore(eventEnd)) ||
                (selectedEnd.isAfter(eventStart) && selectedEnd.isSameOrBefore(eventEnd)) ||
                (selectedStart.isSameOrBefore(eventStart) && selectedEnd.isSameOrAfter(eventEnd))
            );
        });

        if (overlappingEvent) {
            alert("이미 예약된 시간입니다.");
            return;
        }
        
        var reservationInfo = {
            equipNo: roomNo,
            revStartTime: $('#selectedDate').val() + ' ' + $('#revStartTime').val(),
            revEndTime: $('#selectedDate').val() + ' ' + $('#revEndTime').val(),
            revReason: revReason // 변경된 예약 사유 사용
        };

        $.ajax({
            url: '/JoinTree/addReservation',
            type: 'POST',
            dataType: 'json',
            data: JSON.stringify(reservationInfo),
            contentType: 'application/json',
            success: function(response) {
                calendar.addEvent(reservationInfo);
                alert("예약이 성공적으로 완료되었습니다");
                $('#calendarModal').modal('hide'); 
                calreload(); // 목록 동적 생성
            },
            error: function() {
                //console.log('Reservation Info:', reservationInfo);
                console.error('예약 추가 실패');
            }
        });
    });
    
$('#calendarModal').on('hidden.bs.modal', function () {
    $("#rn_check").text("");
    $("#revReason").val("");
});

    function calreload() {
        calendar.refetchEvents(); // 풀캘린더 reload 함수
    }
    calendar.render();
});
</script>
</body>
</html>
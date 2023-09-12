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

<style>
.fc-event {
    background-color: #AEC3AE;
    border: none;
}
#calendar {
  max-width: 1200px;
  margin: 40px auto;
}
.fc .fc-button-primary {
	border: none;
	background-color: #C8E4B2;
}

.fc .fc-timegrid-slot {
    height: 2em;
}
.fc .fc-toolbar-title {
  font-family: 'Pretendard-Regular';
}
.today-slot {
    background-color: black;
}
.red-text {
    color: red;
}

.blue-text {
    color: blue;
}
.weekend-cell {
    background-color: red;
}
</style>
</head>
<!-- header -->
<jsp:include page="/WEB-INF/view/inc/header.jsp"/> 
<div class="container-fluid page-body-wrapper">
<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
<div class="content-wrapper">
<!-- 컨텐츠부분 wrapper -->
		 		
			<div>
			<span class="badge badge-success">notice</span>
			예약 신청을 하시려면 빈 시간대를 클릭해주세요(*정각 이전 예약)
			</div>
			<br>
			
			<div class="row">
				<div class="col-12 grid-margin">
					<div class="card">
 						<div class="card-body">
			
							<div class="mdi mdi-format-list-bulleted-type">
							<a href="/JoinTree/reservation/empMeetRoomList">회의실 목록</a>
							</div>
			<!-- fullCal -->
							<div id='calendar'></div>
			<!------------->
						</div>
					</div>
				</div>
			</div>
			
			<!-- modal 추가 -->
			    <div class="modal fade" id="calendarModal" tabindex="-1" role="dialog" aria-labelledby="reservationModalLabel" aria-hidden="true">
			        <div class="modal-dialog" role="document">
			            <div class="modal-content">
			                <div class="modal-header">
			                    <h4 class="modal-title" id="exampleModalLabel">회의실 예약하기</h4>
			                    			                
			                	<button type="button" class="btn btn-close" data-bs-dismiss="modal" aria-label="Close">
								<span>×</span>
								</button>
         
			                </div>
			                <div class="modal-body">
			                    <div class="form-group">
			                    	<!-- 회의실 이름 끌고오기 , roomNo를 할당해줍니다 -->
			                    	<input type="hidden" id="equipNo" name="equipNo" value="${roomNo}">
			                        <label for="roomName" class="col-form-label">회의실 이름</label>
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
			                        <label for="revReason" class="col-form-label">예약 사유</label>
			                        <input type="text" class="form-control" id="revReason" name="revReason" placeholder="간단한 예약 사유를 적어주세요.">
			                    	<div class="check" id="rn_check"></div>
			                    </div>
			                </div>
			                <div class="modal-footer">
			                    <button type="button" class="btn btn-success" id="addCalendar">추가</button>
			                </div>
			            </div>
			        </div>
   				</div>
   				
<!-- 컨텐츠전체 끝 -->			
</div>
</div>
<!-- footer -->
<jsp:include page="/WEB-INF/view/inc/footer.jsp"/>
	<div id="empNo" data-empno="${loginAccount.empNo}"></div>
	<script src="/JoinTree/resource/js/reservation/meetRoomReserv.js"></script>
</html>
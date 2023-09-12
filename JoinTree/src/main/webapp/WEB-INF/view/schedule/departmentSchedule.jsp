<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.goodee.JoinTree.vo.AccountList" %>
<!DOCTYPE html>
<html>
<style>
#calendar {
  max-width: 1400px;
  margin: 40px auto;
}


</style>
	<!-- header -->
	<jsp:include page="/WEB-INF/view/inc/header.jsp"/> 
	
	<!-- FullCalendar CDN -->
	<link href='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/main.min.css' rel='stylesheet' />
	<script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/main.min.js'></script>
	<!-- FullCalendar 언어 CDN -->
	<script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/locales-all.min.js'></script>



	<div class="container-fluid page-body-wrapper">
		<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
		<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
			<div class="row">
				<div class="col-12 grid-margin">
					<div class="card">
 						<div class="card-body">
							<!-- 달력 출력 -->
							<div id='caslendar-container'>
						    	<div id='calendar'></div>
							</div>
						</div>
					</div>
				</div>
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
					<button type="button" class="btn btn-close" data-bs-dismiss="modal" aria-label="Close">
						<span>×</span>
					</button>
				</div>
				<div class="modal-body">
					<input type="text" id="scheduleTitle" class="form-control" name="scheduleTitle" placeholder="제목을 입력하세요(필수)">
					<br>
					<input type="text" id="scheduleContent" class="form-control" name="scheduleContent" placeholder="내용을 입력하세요(필수)">
					<br>
					<input type="text" id="scheduleLocation" class="form-control" name="scheduleLocation"placeholder="장소를 입력하세요(선택)">
					<br>
					시작일
					<input type="datetime-local" id="scheduleStart" class="form-control" name="scheduleStart">
					<br>
					종료일
					<input type="datetime-local" id="scheduleEnd" class="form-control" name="scheduleEnd">
					<br>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-success" id="submitScheduleBtn">추가</button>
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
	                <button type="button" class="btn btn-close" data-bs-dismiss="modal" aria-label="Close">
						<span>×</span>
					</button>
	            </div>
	            <div class="modal-body">
	                <p><strong>제목:</strong> <span id="viewTitle"></span></p>
	                <p><strong>내용:</strong> <span id="viewContent"></span></p>
	                <p><strong>장소:</strong> <span id="viewLocation"></span></p>
	                <p><strong>시작일:</strong> <span id="viewStart"></span></p>
	                <p><strong>종료일:</strong> <span id="viewEnd"></span></p>
	                <p><strong>작성자:</strong> <span id="viewWriter"></span></p>
	            </div>
	            <div class="modal-footer">
	                <button type="button" class="btn btn-success" id="editScheduleBtn">수정</button>
	                <button type="button" class="btn btn-success" id="deleteScheduleBtn">삭제</button>
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
	                <button type="button" class="btn btn-close" data-bs-dismiss="modal" aria-label="Close">
						<span>×</span>
					</button>
	            </div>
	            <div class="modal-body">
                    <input type="text" id="editScheduleTitle" class="form-control" placeholder="제목을 입력하세요(필수)">
                    <br>
                    <input type="text" id="editScheduleContent" class="form-control" placeholder="내용을 입력하세요(필수)">
                    <br>
                    <input type="text" id="editScheduleLocation" class="form-control" placeholder="장소를 입력하세요(선택)">
                    <br>
                    시작일
                    <input type="datetime-local" id="editScheduleStart" class="form-control">
                    <br>
                    종료일
                    <input type="datetime-local" id="editScheduleEnd" class="form-control">
                    <br>
	            </div>
	            <div class="modal-footer">
	                <button type="button" class="btn btn-success" id="updateScheduleBtn">수정</button>
	            </div>
	        </div>
	    </div>
	</div>

	<input type="hidden" readonly="readonly" data-empno="${loginAccount.empNo}" id="empNo">
	<script src="/JoinTree/resource/js/schedule/departmentSchedule.js"></script>
	
</html>
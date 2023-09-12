<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
<!-- header -->
<jsp:include page="/WEB-INF/view/inc/header.jsp"/>
	<div class="container-fluid page-body-wrapper">
	<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
		<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
			
			<div class="col-lg-12 grid-margin stretch-card">
				<div class="card">
					<div class="card-body">
						<h3 class="font-weight-bold">근로시간 통계</h3>
						<br>
						<!-- 월 별 조회 -->
						<select id="monthSelect" class="form-control col-sm-1">
					    	<!-- 셀렉트 옵션 동적으로 생성 -->
						</select>
						
						<!-- 주 별 근로시간 차트 -->
						<div>
							<canvas id="workTimeWeekChart" height="400"></canvas>
						</div>
						
						<!-- 년 별 조회 -->
						<select id="yearSelect" class="form-control col-sm-1">
					    	<!-- 셀렉트 옵션 동적으로 생성 -->
						</select>
						
						<!-- 월 별 근로시간 차트 -->
						<div>
							<canvas id="workTimeMonthChart" height="400"></canvas>
						</div>
					</div>	
				</div>
			</div>
			
		</div>
	</div>
	
	<!-- footer -->
	<jsp:include page="/WEB-INF/view/inc/footer.jsp"/>	
	
	<!-- script -->
	<script src="/JoinTree/resource/js/commute/commuteChart.js"></script>
</html>
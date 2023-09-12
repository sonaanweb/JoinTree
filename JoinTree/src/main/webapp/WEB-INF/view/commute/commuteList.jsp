<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<link rel="stylesheet" type="text/css" href="/JoinTree/resource/css/custom.css">
<!-- header -->
<jsp:include page="/WEB-INF/view/inc/header.jsp"/>
	<div class="container-fluid page-body-wrapper">
	<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
		<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
			<div class="col-lg-12 grid-margin stretch-card">
				<div class="card">
					<div class="card-body">
						<div class="row">
							<!-- 년, 월 표시 -->
							<div class="col">
								<h3 class="font-weight-bold">
									<span id="targetYear"></span>
									<span id="targetMonth"></span>
									<span>출근부</span>
								</h3>
							</div>
							<!-- 연월 이동 버튼. 입사 연월에 따른 이전달, 다음달 버튼 분기-->
							<div class="col d-flex justify-content-end align-items-center">
								<div class="btn-group" role="group" >
									<button type="button" id="prevBtn" class="btn btn-dark btn-sm">이전달</button>
									<button type="button" id="nextBtn" class="btn btn-dark btn-sm">다음달</button>
								</div>
							</div>
						</div>
						<br>
						<!-- 월별 출퇴근 리스트 출력 -->
						<div>
							<table class="table table-sm">
								<thead>
									<tr>
										<th class="font-weight-bold" style="width:5%">날짜</th>
										<th class="font-weight-bold" style="width:5%">요일</th>
										<th class="font-weight-bold">출근시간</th>
										<th class="font-weight-bold">퇴근시간</th>
										<th class="font-weight-bold">연가구분</th>
									</tr>
								</thead>
								<tbody id="commuteList">
								
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>		
			
		</div>
	</div>
	
	<!-- footer -->
	<jsp:include page="/WEB-INF/view/inc/footer.jsp"/>
	
	<!-- script -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
	<script src="/JoinTree/resource/js/commute/commuteList.js"></script>	
</html>
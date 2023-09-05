<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<style>
    .saturday {
        background-color: lightblue;
    }
    
    .sunday {
        background-color: lightpink;
    }
</style>
<!-- header -->
<jsp:include page="/WEB-INF/view/inc/header.jsp"/>
	<div class="container-fluid page-body-wrapper">
	<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
		<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
			
			<div>
				<h1><span id="targetYear"></span><span id="targetMonth"></span></h1>
			</div>
			
			<!-- 연월 이동 버튼. 입사 연월에 따른 이전달, 다음달 버튼 분기-->
			<div>
				<button type="button" id="prevBtn">이전달</button>
				<button type="button" id="nextBtn">다음달</button>
			</div>
			
			<!-- 월별 출퇴근 리스트 출력 -->
			<div>
				<table class="table table-sm">
					<thead>
						<tr>
							<th style="width:100px">날짜</th>
							<th style="width:80px">요일</th>
							<th>출근시간</th>
							<th>퇴근시간</th>
							<th>연가</th>
						</tr>
					</thead>
					<tbody id="commuteList">
					
					</tbody>
				</table>
			</div>
			
		</div>
	</div>
	
	<script>
		$(document).ready(function(){
			
			// 변수 설정
			let targetYear; // 선택 년도
			let targetMonth; // 선택 월
			let hireYear; // 입사 년도
			let hireMonth; // 입사 월
			let currentYear; // 현재 년도
			let currentMonth ; // 현재 월
			
			// 초기 페이지 로드 시 출퇴근 목록 출력
			loadCommuteList(targetYear, targetMonth);
			
			// 초기 페이지 로드 시 버튼 상태 
			updatePrevBtnState(hireYear, hireMonth, targetYear, targetMonth); // 이전달 버튼
			updateNextBtnState(targetYear, targetMonth, currentYear, currentMonth); // 다음달 버튼
		
		});
		
		// 이전달 버튼 클릭 시 이벤트
		$('#prevBtn').click(function(){
			targetMonth--;
			loadCommuteList(targetYear, targetMonth);
		});
		
		// 다음달 버튼 클릭 시 이벤트 
		$('#nextBtn').click(function(){
			targetMonth++;
			loadCommuteList(targetYear, targetMonth);
		});
		
		// 출퇴근 목록 조회 함수
		function loadCommuteList(year, month){
			$.ajax({
				type: 'GET',
				url: '/JoinTree/commute/getCommuteList',
				data:{
					targetYear: year,
					targetMonth: month
				},
				success: function(data){
					console.log(data);
					
					// 값 저장
					hireYear = data.hireYear; // 입사 년도
					hireMonth = data.hireMonth; // 입사 월
					currentYear = data.currentYear; // 현재 년도
					currentMonth = data.currentMonth; // 현재 월
					targetYear = data.targetYear; // 선택한 년
					targetMonth = data.targetMonth; // 선택한 월
					
					updateCommuteList(data); // 월별 출퇴근 목록 업데이트
					updatePrevBtnState(hireYear, hireMonth, targetYear, targetMonth); // 이전달 버튼 업데이트
					updateNextBtnState(targetYear, targetMonth, currentYear, currentMonth); // 다음달 버튼 업데이트
				},
				error: function(error){
					console.error('commuteList.jsp loadCommuteList error', error);
				}
			});
		}
		
		// 월별 출퇴근 목록 업데이트 함수
		function updateCommuteList(data){
			
			// 값 저장
			targetYear = data.targetYear; // 선택한 년
			targetMonth = data.targetMonth; // 선택한 월
			let daysInMonth = data.daysInMonth; // 해당 월의 마지막 일
			let daysOfWeek = data.daysOfWeek; // 요일 배열
			let firstDayOfWeek = data.firstDayOfWeek; // 해당 월의 1일의 요일
			let commuteTimeList = data.commuteTimeList; // 해당 월의 출퇴근 리스트
			
			$('#targetYear').text(targetYear + '년');
			$('#targetMonth').text(targetMonth +1 + '월');
			
			let tbody = $('#commuteList'); // tbody(commuteList) 값 저장
			tbody.empty(); // 이전 내용 삭제
			
			// 월이 1의 자리이면 앞자리에 0 붙여서 저장
			let formattedMonth = (targetMonth + 1 < 10) ? '0' + (targetMonth + 1) : (targetMonth + 1);
			
			for(let day =1; day <= daysInMonth; day++){
				
				let formattedDay = (day < 10) ? '0' + (day) : (day); // 일이 1의 자리이면 앞자리에 0 붙여서 저장
				let currentDate = targetYear + '-' + formattedMonth + '-' + formattedDay; // 현재 날짜 값 저장
				
				// class 설정
				let rowClass = ((day + firstDayOfWeek - 2) % 7 === 0) ? 'sunday' : (((day + firstDayOfWeek - 2) % 7 === 6) ? 'saturday' : '');
				
				let row = $('<tr>').addClass(rowClass);
				
				$('<td>').text((targetMonth + 1) +'월' + day + '일').appendTo(row); // 날짜
	            $('<td>').text(daysOfWeek[(day + firstDayOfWeek - 2) % 7]).appendTo(row); // 요일
	            
	            // 출퇴근, 연가 초기값 설정
	            let onTime = '-';
	            let offTime = '-';
	            let leaveType = '-';
	            
	         	// DB에 저장된 날짜, 달력의 현재 날짜 비교하여 동일한 날짜에 출근 목록 출력
	            $.each(commuteTimeList, function (index, commute) {
	                if (commute.empOnOffDate === currentDate) {
	                	
	                	if(commute.empOnTime){ // 출근 값이 있을 경우 값 저장
	                		onTime = commute.empOnTime;
	                	}
	                	
	                	if(commute.empOffTime){ // 퇴근 값이 있을 경우 값 저장
	                		offTime = commute.empOffTime;
	                	}
	                	
	                	if(commute.leaveType){ // 연가 값이 있을 겨우 값 저장
	                		leaveType = commute.leaveType;
	                	}
	                }
	            });
	            
	            $('<td>').text(onTime).appendTo(row); // 출근시간
	            $('<td>').text(offTime).appendTo(row); // 퇴근시간
	            $('<td>').text(leaveType).appendTo(row); // 연가 정보
	            
	            row.appendTo(tbody);
			}
		}
		
		// 이전달 버튼 활성화 분기
		function updatePrevBtnState(hireYear, hireMonth, targetYear, targetMonth){
		
			// 입사일 년월 +1 ~ 현재 년월 사이에서만 이전달 버튼 활성화
			if (hireYear < targetYear || (hireYear == targetYear && targetMonth+1 > hireMonth)) {
				$('#prevBtn').show();
		    } else{
		    	$('#prevBtn').hide();
		    }
		}
		
		// 다음달 버튼 활성화 분기
		function updateNextBtnState(targetYear, targetMonth, currentYear, currentMonth){
			
			// 입사일 년월 ~ 현재 년월 -1 사이에서만 다음달 버튼 활성화
			if (targetYear < currentYear || (targetYear == currentYear && targetMonth+1 < currentMonth)) {
				$('#nextBtn').show();
		    } else{
		    	$('#nextBtn').hide();
		    }
		}
	</script>	
</html>
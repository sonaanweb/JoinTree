<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>commuteFullList</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
</head>
<body>
	<h1>출퇴근 목록</h1>
	
	<!-- 검색별 조회 -->
	<div>
		<form id="searchAnnualLeaveListForm">
			<div>
				<div>사번</div>
				<input type="text" id="searchEmpNo" name="empNo">
			</div>
			<div>
				<div>사원명</div>
				<input type="text" id="searchEmpName" name="empName">
			</div>
			<div>
				<div>부서</div>
				<select id="searchDept" name="dept">
					<option value="">선택하세요</option>
					<c:forEach var="d" items="${deptCodeList}">
						<option value="${d.code}">${d.codeName}</option>
					</c:forEach>
				</select>
			</div>
			<div>
				<div>연도</div>
				<select id="searchYear" name="year">
					<option value="">선택하세요</option>
					<!-- 나머지 옵션 동적으로 생성 -->
				</select>
			</div>
			<div>
				<div>조회일</div>
				<input type="date" id="searchStartDate" name="startDate"> &#126; 
				<input type="date" id="searchEndDate" name="endDate">
			</div>
			<div>
				<button type="button" id="searchCommuteFullListBtn">검색</button>
			</div>
		</form>
	</div>
	
	<!-- 검색별 출퇴근 목록 출력 -->
	<table>
		<thead>
			<tr>
				<th>날짜</th>
				<th>사번</th>
				<th>부서명</th>
				<th>사원명</th>
				<th>출근시간</th>
				<th>퇴근시간</th>
			</tr>
		</thead>
		<tbody id="commuteFullList">
		
		</tbody>
	</table>
	
	
	<!-- 페이지 네비게이션 -->
	<div id="pagination">
		
	</div>
</body>
<script>
	$(document).ready(function(){
		// 페이지 로드 시 검색조건 초기화
		searchCommuteFullListResults();
	});
	
	let currentYear = new Date().getFullYear(); // 현재 년도
	let companyFoundationYear = 2022; // 회사 창립일
	
	let yearSelect = $('#searchYear');
	
	// yearSelect 옵션 생성 및 추가
	for (let year = currentYear; year >= companyFoundationYear; year--) {
			
		let $option = $('<option>', {
			value: year,
			text: year + "년"
		});
		yearSelect.append($option);
	}
	
	// 페이지 네비게이션 수정 함수
	function updatePagination(data){
		let pagination = $('#pagination');
		pagination.empty();
		
		// 이전 페이지 버튼
		if(data.startPage > 1){
			let prevButton = $('<button type="button" class="page-btn">').text('이전');
            prevButton.click(function() {
                goToPage(data.startPage - 1);
            });
            pagination.append(prevButton);
		}
		
		// 페이지 버튼 생성
		for(let i = data.startPage; i <= data.endPage; i++){
			const page = i;
			let pageButton = $('<button type="button" class="page-btn">').text(i);
	        pageButton.click(function(){
	        	goToPage(page);
	        });
	        pagination.append(pageButton);
		}
		
		// 다음 페이지 버튼
		if(data.endPage < data.lastPage){
			let nextButton = $('<button type="button" class="page-btn">').text('다음');
            nextButton.click(function() {
                goToPage(data.endPage + 1);
            });
            pagination.append(nextButton);
		}
	}
	
	// 검색별 출퇴근 목록 테이블(commuteFullList) 데이터 수정 함수
	function updateCommuteFullListTableWithData(data){
		
		// 테이블의 tbody를 선택하고 초기화
	    let tbody = $('#commuteFullList');
	    tbody.empty();
	    
	    // data의 길이만큼 테이블 행 추가
	    for (let i = 0; i < data.length; i++) {
	        let leave = data[i];
	        let row = $('<tr>');
	        row.append($('<td>').text(leave.empOnOffDate)); // 날짜
	        row.append($('<td>').text(leave.empNo)); // 사번
	        row.append($('<td>').text(leave.dept)); // 부서명
	        row.append($('<td>').text(leave.empName)); // 사원명
	        row.append($('<td>').text(leave.empOnTime)); // 출근시간
	        row.append($('<td>').text(leave.empOffTime)); // 퇴근시간
	        tbody.append(row);
	    }
	}
	
	// 검색 조건별 결과 값 함수
	function searchCommuteFullListResults(page=1){
		
		// 데이터 조회
		$.ajax({
			url: '/JoinTree/commuteManage/searchCommuteFullList',
			type: 'GET',
			data:{
				empNo: $('#searchEmpNo').val(), // 사번
				empName: $('#searchEmpName').val(), // 사원명
				dept: $('#searchDept').val(), // 부서
				year: $('#searchYear').val(),// 조회 연도
				startDate: $('#searchStartDate').val(), // 조회 시작일
				endDate: $('#searchEndDate').val(),// 조회 마지막일
				currentPage: page,
				rowPerPage: 10
			},
			success: function(data){
				console.log(data);
				
				let leaveRecodeList = data.searchCommuteFullListByPage; // 출퇴근 목록
				updateCommuteFullListTableWithData(leaveRecodeList); // 테이블 데이터 수정 함수
				updatePagination(data); // 페이지 네비게이션 데이터 수정 함수
			},
			error: function(){
				console.log('error');
			}
		});
	}
	
	// 페이지 이동 함수
	function goToPage(page){
		// 검색 및 페이지 데이터 수정 함수
	  	searchCommuteFullListResults(page);
    }
	
	// 검색 버튼 클릭 이벤트
	$('#searchCommuteFullListBtn').click(function(){
		searchCommuteFullListResults();
	});
</script>
</html>
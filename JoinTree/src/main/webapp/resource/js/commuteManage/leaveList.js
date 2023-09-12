	$(document).ready(function(){
		// 페이지 로드 시 검색조건 초기화
		searchLeaveRecodeListResults();
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
			let prevButton = $('<button type="button" class="page-link">').text('이전');
            prevButton.click(function() {
                goToPage(data.startPage - 1);
            });
            pagination.append(prevButton);
		}
		
		// 페이지 버튼 생성
		for(let i = data.startPage; i <= data.endPage; i++){
			const page = i;
			let pageButton = $('<button type="button" class="page-link">').text(i);
	        
			// 현재 페이지일 때 'selected-page' 클래스 추가
	        if (page === data.currentPage) {
	        	pageButton.addClass('selected-page');
				pageButton.prop('disabled', true); // 현재 페이지 버튼 비활성화
	        } 
			
			pageButton.click(function(){
	        	goToPage(page);
	        });
	        pagination.append(pageButton);
		}
		
		// 다음 페이지 버튼
		if(data.endPage < data.lastPage){
			let nextButton = $('<button type="button" class="page-link">').text('다음');
            nextButton.click(function() {
                goToPage(data.endPage + 1);
            });
            pagination.append(nextButton);
		}
	}
	
	// 검색별 연가 목록 테이블(annualLeaveList) 데이터 수정 함수
	function updateLeaveRecodeListTableWithData(data){
		
		// 테이블의 tbody를 선택하고 초기화
	    let tbody = $('#leaveRecodeList');
	    tbody.empty();
	    
	    // data의 길이만큼 테이블 행 추가
	    for (let i = 0; i < data.length; i++) {
	        let leave = data[i];
	        let row = $('<tr>');
	        row.append($('<td>').text(leave.empNo)); // 사번
	        row.append($('<td>').text(leave.dept)); // 부서명
	        row.append($('<td>').text(leave.empName)); // 사원명
	        row.append($('<td>').text(leave.leaveType)); // 연가 구분
	        row.append($('<td>').text(leave.startDate)); // 시작일
	        row.append($('<td>').text(leave.endDate)); // 종료일
	        row.append($('<td>').text(leave.leavePeriodDate)); // 휴가일수
	        row.append($('<td>').text(leave.active)); // 사원 활성화 상태
	        tbody.append(row);
	    }
	}
	
	// 검색 조건별 결과 값 함수
	function searchLeaveRecodeListResults(page=1){
		
		// 데이터 조회
		$.ajax({
			url: '/JoinTree/commuteManage/searchLeaveRecodeList',
			type: 'GET',
			data:{
				empNo: $('#searchEmpNo').val(), // 사번
				empName: $('#searchEmpName').val(), // 사원명
				leaveType: $('#searchLeaveType').val(), // 휴가구분
				year: $('#searchYear').val(),// 조회 연도
				startDate: $('#searchStartDate').val(), // 조회 시작일
				endDate: $('#searchEndDate').val(),// 조회 마지막일
				active:	$('#searchActive').val(), // 사원 활성화 상태
				currentPage: page,
				rowPerPage: 10
			},
			success: function(data){
				console.log(data);
				
				let leaveRecodeList = data.searchLeaveRecodeListByPage; // 연가 목록
				updateLeaveRecodeListTableWithData(leaveRecodeList); // 테이블 데이터 수정 함수
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
	  	searchLeaveRecodeListResults(page);
    }
	
	// 검색 버튼 클릭 이벤트
	$('#searchLeaveRecodeListBtn').click(function(){
		searchLeaveRecodeListResults();
	});
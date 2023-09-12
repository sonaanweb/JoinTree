	$(document).ready(function(){
		// 페이지 로드 시 검색조건 초기화
		searchAnnualLeaveListResults();
	});
	
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
	
	// 문자열로 들어온 시간 값 시간 형식으로 변환하는 함수
	function formatTime(timeString) {
	    
		if(timeString == null){
			return 0;
		}
		
		let parts = timeString.split(":");
	    
	    // 시간, 분, 초 값 추출
	    let hours = parseInt(parts[0]);
	    let minutes = parseInt(parts[1]);
	    let seconds = parseInt(parts[2]);
	    
	    // 시간을 HH:MM:SS 형식으로 변환
	    let formattedTime = hours.toString().padStart(2, '0') + ":" +
	                        minutes.toString().padStart(2, '0') + ":" +
	                        seconds.toString().padStart(2, '0');
	    
	    return formattedTime;
	} 
	
	// 검색별 연차 목록 테이블(annualLeaveList) 데이터 수정 함수
	function updateAnnualLeaveListTableWithData(data, date){
		
		// 테이블의 tbody를 선택하고 초기화
	    let tbody = $('#annualLeaveList');
	    tbody.empty();
	    
	    // data의 길이만큼 테이블 행 추가
	    for (let i = 0; i < data.length; i++) {
	        let annual = data[i];
	        
	        let workYears = annual.workYears; // 근속년수
	        let workMonths = annual.workMonths; // 근속 개월수
	        
	        let oneMonthAfterHireDateStr = annual.oneMonthAfterHireDate; // 입사한지 한 달 후의 날짜
	        let oneYearAfterHireDateStr = annual.oneYearAfterHireDate; // 입사한지 1년 후의 날짜
	        let oneMonthAfterAddAnnualDateStr = annual.oneMonthAfterAddAnnualDate; // 마지막 연차 지급일 부터의 한 달 후의 날짜
	        let oneYearAfterAddAnnualDateStr = annual.oneYearAfterAddAnnualDate; // 마지막 연차 지급일 부터의 1년 후의 날짜
	        
	        // 날짜 값 비교를 위해 형식 변환
	        let currentDate = new Date(date); // 현재 날짜
	        let oneMonthAfterHireDate = new Date(oneMonthAfterHireDateStr); // 입사한지 한 달 후의 날짜
	        let oneYearAfterHireDate = new Date(oneYearAfterHireDateStr); // 입사한지 1년 후의 날짜
	        let oneMonthAfterAddAnnualDate = new Date(oneMonthAfterAddAnnualDateStr); // 마지막 연차 지급일 부터의 한 달 후의 날짜
	        let oneYearAfterAddAnnualDate = new Date(oneYearAfterAddAnnualDateStr); // 마지막 연차 지급일 부터의 1년 후의 날짜
	        
	        let totalFirstMonthWorkTimeStr = annual.totalFirstMonthWorkTime; // 첫 달 근무 시간
	        let totalMonthWorkTimeStr = annual.totalMonthWorkTime; // 한달 근무 시간
	        let totalFristYearWorkTimeStr = annual.totalFristYearWorkTime; // 첫 해 1년 근무 시간
	        let totalYearWorkTimeStr = annual.totalYearWorkTime; // 1년 근무 시간
	        let workTimeInOneFirstMonthStr = annual.workTimeInOneFirstMonth; // 첫 달 평일 근무 소정 시간
	        let workTimeInOneMonthStr = annual.workTimeInOneMonth; // 한 달 평일 근무 소정 시간
	        let workTimeInYearStr = annual.workTimeInYear; // 1년 평일 근무 소정 시간
	        
	        // 문자열로 들어온 시간 값 시간 형식으로 변환
	        let totalFirstMonthWorkTime = formatTime(totalFirstMonthWorkTimeStr); // 첫 달 근무 시간
	        let totalMonthWorkTime = formatTime(totalMonthWorkTimeStr); // 한달 근무 시간
	        let totalFristYearWorkTime = formatTime(totalFristYearWorkTimeStr); // 첫 해 1년 근무 시간
	        let totalYearWorkTime = formatTime(totalYearWorkTimeStr); // 1년 근무 시간
	        let workTimeInOneFirstMonth = formatTime(workTimeInOneFirstMonthStr); // 첫 달 평일 근무 소정 시간
	        let workTimeInOneMonth = formatTime(workTimeInOneMonthStr); // 한 달 평일 근무 소정 시간
	        let workTimeInYear = formatTime(workTimeInYearStr); // 1년 평일 근무 소정 시간
	       
	        let row = $('<tr class="selectde-tr">');
	        row.append($('<td class="text-center">').text(annual.empNo)); // 사번
	        row.append($('<td class="text-center">').text(annual.dept)); // 부서
	        row.append($('<td class="text-center">').text(annual.empName)); // 사원명
	        row.append($('<td class="text-center">').text(annual.annualCount)); // 잔여연차
	        
	     	// 연차 생성 표시
	     	// 1년차 미만 근속사원, 첫달 근무
	        if((workYears == 0 && workMonths == 1 && totalFirstMonthWorkTime >= workTimeInOneFirstMonth 
	        	&& currentDate.getTime() >= oneMonthAfterHireDate.getTime() && oneMonthAfterAddAnnualDateStr == null) 
	        	
	        	// 1년차 미만 근속사원 
	        	|| (workYears == 0 && workMonths > 1 && totalMonthWorkTime >= workTimeInOneMonth
	        		&& currentDate.getTime() >= oneMonthAfterAddAnnualDate.getTime()) 
	        	
	        	// 1년차 근속사원
	        	|| (workYears == 1 && workMonths == 0 && totalFristYearWorkTime >= workTimeInYear
	        		&& currentDate.getTime() >= oneYearAfterHireDate.getTime()) 
	        	
	        	// 1년차 이상 근속사원
	        	|| (workYears >= 1 && totalYearWorkTime >= workTimeInYear)
	        		&& currentDate.getTime() >= oneYearAfterAddAnnualDate.getTime()){ 
	        	
	        	let addAnnualLeaveTd = $('<td class="text-center text-danger font-weight-bold">연차 발생</td>');
	        	row.append(addAnnualLeaveTd);
	        } else{
	        	let emptyTd = $('<td></td>');
	            row.append(emptyTd);
	        }
	     
	        tbody.append(row);
	    }
	}
	
	
	// 검색 조건별 결과 값 함수
	function searchAnnualLeaveListResults(page=1){
		
		// 값 저장
		let empNo = $('#searchEmpNo').val();
		let empName = $('#searchEmpName').val();
		let dept = $('#searchDept').val();
		
		// 데이터 조회
		$.ajax({
			url: '/JoinTree/commuteManage/searchAnnualLeaveList',
			type: 'GET',
			data:{
				empNo: empNo,
				empName: empName,
				dept: dept,
				currentPage: page,
				rowPerPage: 10
			},
			success: function(data){
				console.log(data);
	
				let currentDate = data.currentDate; // 현재 날짜
				let annualLeaveList = data.searchAnnualLeaveListByPage; // 연차 목록
				updateAnnualLeaveListTableWithData(annualLeaveList, currentDate); // 테이블 데이터 수정 함수
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
	  	searchAnnualLeaveListResults(page);
    }
	
	// 검색 버튼 클릭 이벤트
	$('#searchAnnualLeaveListBtn').click(function(){
		searchAnnualLeaveListResults();
	});
	
	// 모달창 초기화 함수
	function clearModal() {
	    $('#empName').text('');
	    $('#empHireDate').text('');
	    $('#workDays').text('');
	    $('#yearsAndMonths').text('');
	    $('#workTime').text('');
	    $('#addAnnualLeave').text('');
	    $('#addAnnualLeaveDate').text('');
	}
	
	// 사원 연차관리, 연차 기록 조회
	$('#annualLeaveList').on('click', 'tr', function(){
		let empNo = $(this).find('td:eq(0)').text(); // 사번 값 저장
		getAnnualLeaveInfo(empNo); // 사원 근속일수 조회 함수
		$('#addAnnualLeaveBtn').hide(); // 연차등록 버튼 숨기기
		$('#annualLeaveModal').modal('show'); // 모달창 열기
	});
	
	// 사원 연차 정보 조회
	function getAnnualLeaveInfo(empNo){
		
		clearModal(); // 모달창 초기화
		let annualLeaveCount = 0; // 연차 변수 초기화
		
		// 사원별 연차 정보 조회
		$.ajax({
			url: '/JoinTree/commuteManage/getAnnualLeaveInfo',
			type: 'GET',
			data:{
				empNo: empNo
			},
			success: function(data){
				console.log(data+"<--getAnnualLeaveInfo");
				
				// 값 저장
				let empAnnualLeaveCnt = data.empAnnualLeaveCnt; // 사원별 연차 테이블 count
				let empNo = data.empNo; // 사번
				let empName = data.empName; // 사원명
				let empHireDate = data.empHireDate // 입사일
				let workDays = data.workDays; // 근속일수
				let workYears = data.workYears // 근속년수
				let workMonths = data.workMonths // 근속 개월수
				
				let currentDateStr = data.currentDate; // 현재 날짜
				let oneMonthAfterHireDateStr = data.oneMonthAfterHireDate; // 입사한지 한 달 후의 날짜
		        let oneYearAfterHireDateStr = data.oneYearAfterHireDate; // 입사한지 1년 후의 날짜
		        let oneMonthAfterAddAnnualDateStr = data.oneMonthAfterAddAnnualDate; // 마지막 연차 지급일 부터의 한 달 후의 날짜
		        let oneYearAfterAddAnnualDateStr = data.oneYearAfterAddAnnualDate; // 마지막 연차 지급일 부터의 1년 후의 날짜
		        
		        // 날짜 값 비교를 위해 형식 변환
		        let currentDate = new Date(currentDateStr); // 현재 날짜
		        let oneMonthAfterHireDate = new Date(oneMonthAfterHireDateStr); // 입사한지 한 달 후의 날짜
		        let oneYearAfterHireDate = new Date(oneYearAfterHireDateStr); // 입사한지 1년 후의 날짜
		        let oneMonthAfterAddAnnualDate = new Date(oneMonthAfterAddAnnualDateStr); // 마지막 연차 지급일 부터의 한 달 후의 날짜
		        let oneYearAfterAddAnnualDate = new Date(oneYearAfterAddAnnualDateStr); // 마지막 연차 지급일 부터의 1년 후의 날짜
				
				let totalFirstMonthWorkTimeStr = data.totalFirstMonthWorkTime; // 첫 달 근무 시간
		        let totalMonthWorkTimeStr = data.totalMonthWorkTime; // 한달 근무 시간
		        let totalFristYearWorkTimeStr = data.totalFristYearWorkTime; // 첫 해 1년 근무 시간
		        let totalYearWorkTimeStr = data.totalYearWorkTime; // 1년 근무 시간
		        let workTimeInOneFirstMonthStr = data.workTimeInOneFirstMonth; // 첫 달 평일 근무 소정 시간
		        let workTimeInOneMonthStr = data.workTimeInOneMonth; // 한 달 평일 근무 소정 시간
		        let workTimeInYearStr = data.workTimeInYear; // 1년 평일 근무 소정 시간
		        
		     	// 문자열로 들어온 시간 값 시간 형식으로 변환
		        let totalFirstMonthWorkTime = formatTime(totalFirstMonthWorkTimeStr); // 첫 달 근무 시간
		        let totalMonthWorkTime = formatTime(totalMonthWorkTimeStr); // 한달 근무 시간
		        let totalFristYearWorkTime = formatTime(totalFristYearWorkTimeStr); // 첫 해 1년 근무 시간
		        let totalYearWorkTime = formatTime(totalYearWorkTimeStr); // 1년 근무 시간
		        let workTimeInOneFirstMonth = formatTime(workTimeInOneFirstMonthStr); // 첫 달 평일 근무 소정 시간
		        let workTimeInOneMonth = formatTime(workTimeInOneMonthStr); // 한 달 평일 근무 소정 시간
		        let workTimeInYear = formatTime(workTimeInYearStr); // 1년 평일 근무 소정 시간
				
		        // 연차 생성 분기
		        // 1. 1년차 미만 근속사원 : 1달 소정 근로시간 이상 근무 시 연차 매월 연차 1개 발생
		        // 2. 1년 이상 근속사원 : 15개, 근속연수 매 2년이 지나면 가산 +1, 최대 25개
		        if (workYears == 0) { // 1년 미만 근속사원
				    if (workMonths == 1 && totalFirstMonthWorkTime >= workTimeInOneFirstMonth 
				    	&& currentDate.getTime() >= oneMonthAfterHireDate.getTime() && empAnnualLeaveCnt == 0) { // 첫 달 근무
				        
				    	annualLeaveCount++; // 연차 발생
				        $('#workTime').text(totalFirstMonthWorkTime + ' / ' 
				        					+ workTimeInOneFirstMonth + ' (월 근로시간 / 월 소정 근로시간)'); 
				        
				        $('#addAnnualCount').text(annualLeaveCount); // 발생 연차 수
				        $('#addAnnualDate').text(oneMonthAfterHireDateStr); // 연차 발생일
				        
				        $('input[name="addAnnualCount"]').val(annualLeaveCount); // form으로 보낼 연차 값 설정
				        $('input[name="addAnnualDate"]').val(oneMonthAfterHireDateStr); // form으로 보낼 연차 발생일 값 설정
				        
				        $('#addAnnualLeaveBtn').show(); // 연차등록 버튼 보이기
				    } else if (workMonths > 1 && totalMonthWorkTime >= workTimeInOneMonth 
				    			&& currentDate.getTime() >= oneMonthAfterAddAnnualDate.getTime()) { // 그 이후 월 근무
				        
				    	annualLeaveCount++; // 연차 발생
				        $('#workTime').text(totalMonthWorkTime + ' / ' 
				        					+ workTimeInOneMonth + ' (월 근로시간 / 월 소정 근로시간)'); 
				        
				        $('#addAnnualCount').text(annualLeaveCount); // 발생 연차 수
				        $('#addAnnualDate').text(oneMonthAfterAddAnnualDateStr); // 연차 발생일
				        
				        $('input[name="addAnnualCount"]').val(annualLeaveCount); // form으로 보낼 연차 값 설정
				        $('input[name="addAnnualDate"]').val(oneMonthAfterHireDateStr); // form으로 보낼 연차 발생일 값 설정
				        
				        $('#addAnnualLeaveBtn').show(); // 연차등록 버튼 보이기
				    }
				} else if(workYears == 1 && totalFristYearWorkTime >= workTimeInYear
		        			&& currentDate.getTime() >= oneYearAfterHireDate.getTime()){ // 1년 근속 사원
						
						annualLeaveCount += 15; // 15일 연차 발생
						$('#workTime').text(totalFristYearWorkTime + ' / ' 
	        								+ workTimeInYear + ' (년 근로시간 / 년 소정 근로시간)'); 
				        
						$('#addAnnualCount').text(annualLeaveCount); // 발생 연차 수
				        $('#addAnnualDate').text(oneYearAfterHireDateStr); // 연차 발생일
				        
				        $('input[name="addAnnualCount"]').val(annualLeaveCount); // form으로 보낼 연차 값 설정
				        $('input[name="addAnnualDate"]').val(oneMonthAfterHireDateStr); // form으로 보낼 연차 발생일 값 설정
				        
				        $('#addAnnualLeaveBtn').show(); // 연차등록 버튼 보이기
		        } else if(workYears > 1 && totalYearWorkTime >= workTimeInYear
	        				&& currentDate.getTime() >= oneYearAfterAddAnnualDate.getTime()){ // 1년 이상 근속 사원
			
						annualLeaveCount += 15; // 기본 15일 연차 발생
		                let additionalLeave = Math.floor(workYears / 2); // 추가 연차 계산
		                annualLeaveCount += additionalLeave; // 추가 연차 추가
		                if (annualLeaveCount > 25) {
		                    annualLeaveCount = 25; // 최대 연차는 25일로 제한
		                }
		                
		                $('#workTime').text(totalYearWorkTime + ' / ' 
	        								+ workTimeInYear + ' (년 근로시간 / 년 소정 근로시간)'); 
		                
				        $('#addAnnualCount').text(annualLeaveCount); // 발생 연차 수
				        $('#addAnnualDate').text(oneYearAfterAddAnnualDateStr); // 연차 발생일
				        
				        $('input[name="addAnnualCount"]').val(annualLeaveCount); // form으로 보낼 연차 값 설정
				        $('input[name="addAnnualDate"]').val(oneMonthAfterHireDateStr); // form으로 보낼 연차 발생일 값 설정
				        
				        $('#addAnnualLeaveBtn').show(); // 연차등록 버튼 보이기
		        }
		        
				// 값 설정
				$('#empName').text(empName); // 사원명
				$('#empHireDate').text(empHireDate); // 입사일
				$('#workDays').text(' ( ' + workDays + ' 일 )'); // 근속일수
				$('#yearsAndMonths').text(workYears+' 년 ' + workMonths + ' 개월 ');
				
				if (workYears == 0) { // 1년 미만 근속사원
				    if (workMonths == 1) { // 첫 달 근무
				        
				    	$('#workTime').text(totalFirstMonthWorkTime + ' / ' 
				        					+ workTimeInOneFirstMonth + ' (월 근로시간 / 월 소정 근로시간)'); 
				    
				    } else if (workMonths > 1) { // 그 이후 월 근무
		
				        $('#workTime').text(totalMonthWorkTime + ' / ' 
				        					+ workTimeInOneMonth + ' (월 근로시간 / 월 소정 근로시간)'); 
				    }
				} else if(workYears == 1 && workMonths == 0){ // 1년 근속 사원
						
						$('#workTime').text(totalFristYearWorkTime + ' / ' 
	        								+ workTimeInYear + ' (년 근로시간 / 년 소정 근로시간)');
			
		        } else if(workYears >= 1){ // 1년 이상 근속 사원
		        	
		                $('#workTime').text(totalYearWorkTime + ' / ' 
	        								+ workTimeInYear + ' (년 근로시간 / 년 소정 근로시간)'); 
		        }
				
				// 연차발생 사번 값 설정
				$('#annualEmpNo').val(empNo);
				
			}
		});
	};
	
	// 연차등록버튼(addAnnualLeaveBtn) 클릭
	$('#addAnnualLeaveBtn').click(function(){
		let addAnnualLeaveUrl = '/JoinTree/commuteManage/addAnnualLeave';
		$('#addAnnualLeaveForm').attr('action', addAnnualLeaveUrl);
	    $('#addAnnualLeaveForm').submit();
	});
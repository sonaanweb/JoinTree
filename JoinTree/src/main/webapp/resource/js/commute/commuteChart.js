	$(document).ready(function(){
			
		// yearSelect option 생성(입사년도~현재년도)
		function yearSelectOption(empHireDate){
			
			let empHireDateYear = new Date(empHireDate).getFullYear(); // 입사 년도
			let currentYear = new Date().getFullYear(); // 현재 년	도	
			
			// yearSelect option 생성
			let yearSelect = $('#yearSelect');
			for (let year = currentYear; year >= empHireDateYear; year--) {
				yearSelect.append($('<option>', {
				value: year,
				text: year + '년'
				}));
		    }	
		}
		
		// monthSelect option 생성(입사년월~현재년월)
		function monthSelectOption(empHireDate){
			
			let empHireDateYear = new Date(empHireDate).getFullYear(); // 입사 년도
			let empHireDateMonth = new Date(empHireDate).getMonth() + 1 // 입사 월
			let currentYear = new Date().getFullYear(); // 현재 년	도
			let currentMonth = new Date().getMonth() + 1 // 현재 월
			
			// monthSelect option 생성
            let monthSelect = $('#monthSelect');
		    let months = ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'];
		
		    for (let year = currentYear; year >= empHireDateYear; year--) {
		        let startMonth = (year === currentYear) ? currentMonth : 12;
		        let endMonth = (year === empHireDateYear) ? empHireDateMonth : 1;
		
		        for (let month = startMonth; month >= endMonth; month--) {
		            monthSelect.append($('<option>', {
		                value: year + '-' + month,
		                text: year + '년 ' + months[month - 1]
		            }));
		        }
		    }
		}
		
		// 입사년도 조회
		$.ajax({
			url: '/JoinTree/commute/getEmpHireDate',
			type: 'GET',
			success: function(data){
				console.log('commuteChartEmpHiredate : '+data);
				let empHireDate = data.empHireDate; // 입사일
				console.log('empHireDate : '+empHireDate);
				
				yearSelectOption(empHireDate); // yearSelect option 생성
				monthSelectOption(empHireDate); // monthSelect option 생성
			}
		});
		
		
		let currentYear = new Date().getFullYear(); // 현재 년	도
		let currentMonth = new Date().getMonth()+1; // 현재 월
		
		// 월 별 근로시간 차트 초기화
		monthWorkTimeDataUpdate(currentYear);
		// 주 별 근로시간 차트 초기화
		weekWorkTimeDataUpdate(currentYear, currentMonth)
		
		
		// 월 별 근로시간 차트 데이터
		let monthChartData = {
			
			labels: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'], // 월 레이블
			datasets: [
	            {
	                label: '월 별 근로시간',
	                data: [], // 월 별 근로시간 데이터
	                backgroundColor: 'rgba(21, 78, 15, 0.2)', // 차트 색상
	                borderColor: 'rgba(3, 60, 0, 1)', // 선 색상
	                borderWidth: 1 // 선 굵기
	            }
	        ]
		};
		
		// 월 별 근로시간 차트 옵션
		let monthChartOptions = {
			
			responsive: true,
			maintainAspectRatio: false,
			scales: {
				y: {
					beginAtZero: true,
		            title: {
		                display: true,
		                text: '근로시간'
		            }
				},
				x: {
					title: {
						display: true,
						text: '월'
					}
				}
			}
		};
		
		
		// 차트 객체 초기화
		let workTimeMonthChart = null;
		
		// 월 별 근로시간 조회 후 차트 업데이트
		function monthWorkTimeDataUpdate(year){
		
			$.ajax({
				url: '/JoinTree/commute/getMonthWorkTimeData',
				data: {
					year: year
				},
				success: function(data){
					console.log('monthWorkTimeDataUpdate data :'+data);
					
					// 데이터 변환 및 데이터셋 설정
		            let transformedData = data.map(function(monthlyData) {
		                
		            	// 근로시간 시간 형식 변환
		                const totalWorkTimeInHours = Math.floor(moment.duration(monthlyData.totalWorkTime).asHours());
		                
		                return {
		                    month: monthlyData.month, // 월
		                    totalWorkTime: totalWorkTimeInHours // 근로시간
		                };
		            });
		         	
					// 월별 근로시간 데이터를 저장 할 배열을 초기화
					// 배열의 길이는 12로 고정, 각 월별 근로시간을 저장 할 공간을 0으로 초기화
		            monthChartData.datasets[0].data = new Array(12).fill(0);
	
		            transformedData.forEach(function(monthlyData) {
		            	// DB에서 받아온 데이터를 반복하면서 각 월별 근로시간 값을 해당 배열의 저장
		            	monthChartData.datasets[0].data[monthlyData.month - 1] = monthlyData.totalWorkTime;
		            });
		         	
		         	// 이전 차트 객체를 제거
		            if (workTimeMonthChart) {
		            	workTimeMonthChart.destroy();
		            }
		            
					// 차트 생성
					let ctx = $('#workTimeMonthChart')[0].getContext('2d');
			
					workTimeMonthChart = new Chart(ctx, {
						type: 'bar',
						data: monthChartData,
						options: monthChartOptions,
					});	
				}
			});
		}
		
		// yearSelect 옵션 값 선택 시 해당 연도 차트 호출
		$('#yearSelect').on('change', function() {
			let selectedYear = $(this).val(); // 선택된 연도값 가져오기
	        monthWorkTimeDataUpdate(selectedYear); // 함수 호출
	    });
		
		// 주 별 근로시간 차트 데이터
		let weekChartData = {
			
			labels: ['1주', '2주', '3주', '4주', '5주'], // 주 레이블
			datasets: [
	            {
	                label: '주 별 근로시간',
	                data: [], // 주 별 근로시간 데이터
	                backgroundColor: 'rgba(21, 78, 15, 0.2)', // 차트 색상
	                borderColor: 'rgba(3, 60, 0, 1)', // 선 색상
	                borderWidth: 1 // 선 굵기
	            }
	        ]
		};
		
		// 주 별 근로시간 차트 옵션
		let weekChartOptions = {
			
			responsive: true,
			maintainAspectRatio: false,
			scales: {
				y: {
					beginAtZero: true,
		            title: {
		                display: true,
		                text: '근로시간'
		            }
				},
				x: {
					title: {
						display: true,
						text: '주'
					}
				}
			}
		};
		
		// 차트 객체 초기화
		let workTimeWeekChart = null;
		
		// 주 별 근로시간 조회 후 차트 업데이트
		function weekWorkTimeDataUpdate(year, month){
			
			$.ajax({
				url: '/JoinTree/commute/getWeekWorkTimeData',
				data: {
					year: year,
					month: month
				},
				success: function(data){
					console.log('weekWorkTimeDataUpdate data :'+data);
					
					// 데이터 변환 및 데이터셋 설정
		            let transformedData = data.map(function(weeklyData, index) {
		                
		            	// 근로시간 시간 형식 변환
		                const totalWorkTimeInHours = Math.floor(moment.duration(weeklyData.totalWorkTime).asHours());
		                
		                return {
		                    week: index+1, // 주, 들어온 순서대로 1-5로 변경
		                    totalWorkTime: totalWorkTimeInHours // 근로시간
		                };
		            });
		         	
		         	// 주 별 근로시간 데이터를 저장 할 배열을 초기화
		            weekChartData.datasets[0].data = new Array(5).fill(0);
	
		            transformedData.forEach(function(weeklyData) {
		                // 주차 데이터를 그대로 사용하여 해당 주차에 근로시간 값을 저장
		                weekChartData.datasets[0].data[weeklyData.week - 1] = weeklyData.totalWorkTime;
		            });
		            
		         	// 이전 차트 객체를 제거
		            if (workTimeWeekChart) {
		            	workTimeWeekChart.destroy();
		            }
		         	
					// 차트 생성
					let ctx = $('#workTimeWeekChart')[0].getContext('2d');
					workTimeWeekChart = new Chart(ctx, {
						type: 'bar',
						data: weekChartData,
						options: weekChartOptions,
					});	
				}
			});
		}
			
		// monthSelect 옵션 값 선택 시 해당 연도 차트 호출
		$('#monthSelect').on('change', function() {
			let selectedValue = $(this).val(); // 선택된 연도와 월 값 가져오기
		    let [selectedYear, selectedMonth] = selectedValue.split('-'); // 연도와 월 분리
		    
		    // 함수 호출 및 선택된 연도와 월 값 전달
		    weekWorkTimeDataUpdate(selectedYear, selectedMonth);
	    });
		
	});
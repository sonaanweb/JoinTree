// 페이지 로드 되면 전사 일정 출력
	$(document).ready(function() {
	    var calendarEl = document.getElementById('calendar');
	    var calendar = new FullCalendar.Calendar(calendarEl, {
	    	// 공휴일 추가를 위한 구글캘린더 연동
	    	googleCalendarApiKey : "AIzaSyBUdKm-pJMILaqOkkO1YcoMB9Ib4P0TpQA",
	        eventSources :[ 
	            {
	            	googleCalendarId : 'ko.south_korea#holiday@group.v.calendar.google.com',
	                color: 'transparent', // 배경색을 투명으로 설정
	                textColor: 'red' // 글자색을 빨간색으로 설정
	            }
	    	],
	    	initialView: "dayGridMonth",
	        titleFormat: function (date) {
	          year = date.date.year;
	          month = date.date.month + 1;

	          return year + "년 " + month + "월";
	        },
	        timeZone: 'Asia/Seoul',
	        locale: 'ko',
	        selectable: true,
	        headerToolbar : {
            start : 'prev next today',
            center : 'title',
            right: 'dayGridMonth'
        	},
	        events: '/JoinTree/schedule/getCompanySchedules',
	        select: function(info) {
	        	// 세션에서 dept 정보 추출
                var dept = $('#empDept').data('empdept');
                console.log(dept);
             	// 경영지원부(D0202)만 입력 모달창 열기 가능
                if (dept === 'D0202') {
                    var startDate = info.start;
                    var endDate = info.end;
                    openModal(startDate, endDate);
                }
	        },
	        eventClick: function(info) {
	        	// 공휴일 일정 클릭시 기본동작 막기
	        	info.jsEvent.preventDefault();
	        	
	            var event = info.event
	            selectedEvent = event; // 선택한 일정을 selectedEvent 변수에 저장
	            openEventModal(event);
	        }
	       
	    });
	    
	 	// 유효성 검사 함수
	    function validateSchedule(title, content, startTime, endTime) {
	        if (title.trim() === '' || content.trim() === '') {
	            Swal.fire(
	                'Error',
	                '제목과 내용은 필수 입력 사항입니다.',
	                'error'
	            );
	            return false;
	        }

	        if (new Date(endTime) < new Date(startTime)) {
	            Swal.fire(
	                'Error',
	                '종료일은 시작일보다 늦어야 합니다.',
	                'error'
	            );
	            return false;
	        }

	        return true;
	    }
	
	
	    // 일정추가 모달창
	    function openModal(startDate, endDate) {
	        $('#addScheduleModal').modal('show');
	        $('#scheduleTitle').val('');
	        $('#scheduleContent').val('');
	        $('#scheduleLocation').val('');
	        
	     	// 시작일 설정
	        var startHour = 9; // 시작 시간을 9 (오전 9시)으로 설정
	        var startMinute = 0; // 분을 0으로 설정
	        
	        // 시작일의 날짜와 시간 설정
	        $('#scheduleStart').val(startDate.toISOString().slice(0, 11) + formatTime(startHour, startMinute));
	        
	     	// 종료일 설정 (날짜를 시작일과 동일하게 설정)
	        $('#scheduleEnd').val($('#scheduleStart').val());
	        
	        // 종료 시간 설정 (오후 11시 59분)
	        var endHour = 18; // 시간을 23 (오후 11시)으로 설정
	        var endMinute = 00; // 분을 59로 설정
	        
	        // 종료 시간을 시간과 분 입력 필드에 설정
	        $('#scheduleEnd').val($('#scheduleEnd').val().slice(0, 11) + formatTime(endHour, endMinute));
	
	    }
	    
	 	// 시간을 hh:mm 형식으로 포맷하는 함수
	    function formatTime(hours, minutes) {
	        var formattedHours = hours < 10 ? '0' + hours : hours;
	        var formattedMinutes = minutes < 10 ? '0' + minutes : minutes;
	        return formattedHours + ':' + formattedMinutes;
	    }
	    
		// 일정추가
	    var submitScheduleBtn = document.getElementById('submitScheduleBtn');
	    submitScheduleBtn.addEventListener('click', function() {
	    	var title = $('#scheduleTitle').val();
	        var content = $('#scheduleContent').val();
	    	var startTime = $('#scheduleStart').val();
	        var endTime = $('#scheduleEnd').val();
	        
	        if (!validateSchedule(title, content, startTime, endTime)) {
	            return; // 유효성 검사 실패 시 함수 종료
	        }
	        
	     	// 작성자 정보 가져오기
	        var writerName = $('#empName').data('empname');
	
	        var eventData = {
	        	    scheduleTitle: title,
	        	    scheduleContent: content,
	        	    scheduleLocation: $('#scheduleLocation').val(),
	        	    scheduleStart: startTime,
	        	    scheduleEnd: endTime,
	        	    empName: writerName // 작성자 이름 추가
	        };
			
	        // 일정 추가 비동기 처리
	        $.ajax({
	            type: 'POST',
	            url: '/JoinTree/schedule/addCompanySchedule',
	            contentType: 'application/json',
	            data: JSON.stringify(eventData),
	            success: function(response) {
	                if (response.success) {
	                	// calendar에 추가
	            		calendar.addEvent(eventData);
	            		
	            		// 모달창 숨기기
	            		$('#addScheduleModal').modal('hide');
	            		
	            		// 추가확인 알림창
	                  	Swal.fire({
							icon: 'success',
							title: '사내일정이 추가되었습니다',
							showConfirmButton: false,
							timer: 1000
						});
	                    
	                	// 캘린더를 새로 고치기 위해 함수 호출
	                    fetchAndRenderCalendarEvents();
	                	
	                } else {
	                    console.error('Failed to add schedule.');
	                }
	            }
	        });
	        
	    });
		
	    // 일정 추가후 새로고침
	    function fetchAndRenderCalendarEvents() {
	        calendar.refetchEvents();
	    }
	    
	 	// 상세보기
	    function openEventModal(event) {
	        // 일정 상세 정보를 가져오는 Ajax 요청
	        $.ajax({
	            type: 'GET',
	            url: '/JoinTree/schedule/selectScheduleOne',
	            data: { scheduleNo: event.id }, // 해당 일정의 id 값을 전달
	            success: function(response) {
	                $('#scheduleOneModal').modal('show');
	                $('#viewTitle').text(response.scheduleTitle);
	                $('#viewContent').text(response.scheduleContent);
	                $('#viewLocation').text(response.scheduleLocation);
	                $('#viewStart').text(new Date(response.scheduleStart).toLocaleString('ko-KR', { year: 'numeric', month: 'numeric', day: 'numeric', hour: '2-digit', minute: '2-digit' }));
	                $('#viewEnd').text(new Date(response.scheduleEnd).toLocaleString('ko-KR', { year: 'numeric', month: 'numeric', day: 'numeric', hour: '2-digit', minute: '2-digit' }));
	                $('#viewWriter').text(response.empName + " (" + response.empNo + ")");
	                
	             	// 작성자(empNo)와 로그인한 사용자의 empNo 비교
	                var loginEmpNo = $('#empNo').data('empno');
	                if (response.empNo === loginEmpNo) {
	                    $('#editScheduleBtn').show(); // 작성자와 일치할 경우 수정 버튼 보이기
	                    $('#deleteScheduleBtn').show(); // 작성자와 일치할 경우 삭제 버튼 보이기
	                } else {
	                    $('#editScheduleBtn').hide(); // 작성자와 불일치할 경우 수정 버튼 숨기기
	                    $('#deleteScheduleBtn').hide(); // 작성자와 불일치할 경우 삭제 버튼 숨기기
	                }
	                
	             	// response 객체에서 일정 정보를 읽어와서 selectedEvent 객체 생성
	                var selectedEvent = {
	                    id: response.scheduleNo,
	                    scheduleTitle: response.scheduleTitle,
	                    scheduleContent: response.scheduleContent,
	                    scheduleLocation: response.scheduleLocation,
	                    scheduleStart: response.scheduleStart,
	                    scheduleEnd: response.scheduleEnd
	                };
	             
	             	// 기존의 click 이벤트 핸들러를 제거
	                $('#deleteScheduleBtn').off('click');
	             	
	             	// 일정상세에서 '삭제' 버튼 클릭 -> '확인' 클릭시 삭제 
	                $('#deleteScheduleBtn').on('click', function() {
	                	Swal.fire({
	        				title: '정말 삭제하시겠습니까?',
	        				text: "삭제한 일정은 되돌릴 수 없습니다.",
	        				icon: 'warning',
	        				showCancelButton: true,
	        				confirmButtonColor: '#8BC541',
	        				cancelButtonColor: '#888',
	        				confirmButtonText: '삭제',
	        				cancelButtonText: '취소'
       					}).then((result) => {
	        					if (result.isConfirmed) {
	                        		deleteSchedule(event.id);
	        					}
        				});
	                });
	    	        
	             	
	             	// 수정 버튼 클릭
	    	        $('#editScheduleBtn').on('click', function() {
	    	        	openEditModal(selectedEvent);
	    	        });
	             	
	            },
	            error: function() {
	                console.error('Failed to fetch schedule details.');
	            }
	        });
	    }
	    
	    // 일정 삭제
	    function deleteSchedule(scheduleNo) {
		    // 세션에서 empNo 추출
	    	var empNo = $('#empNo').data('empno');
	    	console.log(empNo);
		        
            $.ajax({
                type: 'POST',
                url: '/JoinTree/schedule/removeSchedule',
                contentType: 'application/json',
                data: JSON.stringify({ scheduleNo: scheduleNo, empNo: empNo }), // 객체 형태로 전달
                success: function(response) {
                    if (response.success) {
                    	// 모달창 숨기기
                        $('#scheduleOneModal').modal('hide');
                        
                        // 삭제확인 알림창
                        Swal.fire({
							icon: 'success',
							title: '일정이 삭제되었습니다',
							showConfirmButton: false,
							timer: 1000
						});
                        
                    	 // 캘린더를 새로 고치기 위해 함수 호출
                        fetchAndRenderCalendarEvents();
                    	 
                    } else {
                    	
                        console.error('Failed to delete schedule.');
                    }
                }
            });
        }
	    
	 	// 일정 수정
	    function openEditModal(selectedEvent) {
	    	
	    	console.log(selectedEvent);
	    	// 기존값 불러오기
	        $('#editScheduleTitle').val(selectedEvent.scheduleTitle);
	        $('#editScheduleContent').val(selectedEvent.scheduleContent);
	        $('#editScheduleLocation').val(selectedEvent.scheduleLocation);
	        $('#editScheduleStart').val(selectedEvent.scheduleStart);
	        $('#editScheduleEnd').val(selectedEvent.scheduleEnd);
	        
	     	// '수정' 버튼 클릭 시 수정 액션에 필요한 값들을 설정합니다.
	        $('#updateScheduleBtn').off('click'); // 기존 클릭 이벤트 핸들러 제거
			$('#updateScheduleBtn').on('click', function() {
				
	            var scheduleNo = selectedEvent.id;
	         	// 세션에서 empNo 추출
	            var empNo = $('#empNo').data('empno');
	            var editStartTime = $('#editScheduleStart').val();
	            var editEndTime = $('#editScheduleEnd').val();
	            var editTitle = $('#editScheduleTitle').val();
	            var editContent = $('#editScheduleContent').val();
	            
	            if (!validateSchedule(editTitle, editContent, editStartTime, editEndTime)) {
	                return; // 유효성 검사 실패 시 함수 종료
	            }
	            
	         	// 서버로 수정된 일정 정보 전송
	            $.ajax({
	                type: 'POST',
	                url: '/JoinTree/schedule/modifySchedule',
	                contentType: 'application/json',
	                data: JSON.stringify({
	                    scheduleNo: scheduleNo,
	                    empNo: empNo,
	                    scheduleTitle: $('#editScheduleTitle').val(),
		                scheduleContent: $('#editScheduleContent').val(),
		                scheduleLocation: $('#editScheduleLocation').val(),
		                scheduleStart: $('#editScheduleStart').val(),
		                scheduleEnd: $('#editScheduleEnd').val()
	                }),
	                success: function(response) {
	                    if (response.success) {
	                    	// 모달창 숨기기
	                        $('#editScheduleModal').modal('hide');
	                        
	                    	 // 수정확인 알림창
	                        Swal.fire({
								icon: 'success',
								title: '일정이 수정되었습니다',
								showConfirmButton: false,
								timer: 1000
							});
	                    	 
	                     	// 일정을 다시 불러와서 FullCalendar에 업데이트
	                        fetchAndRenderCalendarEvents();
	                     
	                     	// 수정된 내용으로 상세보기 모달창 다시 열기
	                        openEventModal(selectedEvent);
	                     	
	                    } else {
	                        console.error('Failed to update schedule.');
	                    }
	                }
	            });
	        });

	        $('#editScheduleModal').modal('show');
	    }
		
	    calendar.render();
	    
	});
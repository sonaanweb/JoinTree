// 회의실 예약 관련 풀캘린더 페이지
document.addEventListener('DOMContentLoaded', function() {
    var calendarEl = document.getElementById('calendar');
    var urlParams = new URLSearchParams(window.location.search);
    var roomNo = urlParams.get('roomNo'); // URL 매개변수에서 roomNo 호출
    var roomName = urlParams.get('roomName'); // URL 매개변수에서 roomName 호출
    
    var calendar = new FullCalendar.Calendar(calendarEl, {
    	    	
    	timeZone: 'Asia/Seoul',
    	locale: 'ko',
        initialView : 'timeGridWeek',   
        headerToolbar : {
            start : 'prev next today',
            center : 'title',
            right: 'timeGridWeek'
        },
        titleFormat: function(date) {
            var formattedDate = date.date.year + '년 ' + (parseInt(date.date.month) + 1) + '월';
            return formattedDate + ' - ' + roomName + ' 예약현황';
        },
        
        dayHeaderContent: function(arg) {
            var classNames = ['fc-day-header']; // 기본 클래스

            if (arg.date.getDay() === 0) { // 일요일
                classNames.push('red-text'); // 빨간색 폰트 클래스 추가
            } else if (arg.date.getDay() === 6) { // 토요일
                classNames.push('blue-text'); // 파란색 폰트 클래스 추가
            }

            return {
                html: '<span class="' + classNames.join(' ') + '">' + arg.text + '</span>' // 새로운 HTML 요소 반환
            };
        },
   
        selectOverlap: false, // 중복 불가
        selectable : true,
        droppable : true,
        editable : false,
        nowIndicator: false,
        allDaySlot: false,
        slotLabelFormat: '',
        height: 'auto',
      	slotDuration: '00:30:00',
        slotMinTime: '09:00:00', // 오전 9시부터 슬롯 시작
        slotMaxTime: '18:00:00', // 오후 6시까지 슬롯 끝
        slotLabelInterval: { hours: 1 },
        slotLabelFormat: {
            hour: 'numeric',
            hour12: true
        },
        
        events: function(info, successCallback, failureCallback) {
            $.ajax({
                url: '/JoinTree/meetRoomReserv?roomNo=' + roomNo,
                type: 'GET',
                dataType: 'json',
                success: function(response) {
                    var events = [];
                    for (var i = 0; i < response.length; i++) {
                        events.push({
                            /* title: response[i].title, 예약 시간만 표시*/
                            start: response[i].start,
                            end: response[i].end
                        });
                    }
                    successCallback(events);
                },
                error: function() {
                    failureCallback('캘린더 값 오류');
                }
            });
        },

        select: function(info) {
        	
        	// 중복검사
            var selectedEnd = moment(info.endStr);
        	var now = moment(); // 현재 날짜와 시간
       	    var selectedStart = moment.tz(info.startStr, 'Asia/Seoul'); // 문자열 아니면 시간 불일치 오류
        	/* console.log("selectedDateTime",selectedDateTime); 사용자가 선택한 시간
        	console.log("now",now);
        	console.log("selectedStart",selectedStart); 선택 시작시간
        	console.log("selectedEnd",selectedEnd); 선택 종료 */
       	     
       		// --------------------------------------------------------------------------------------------
       		// 캘린더 자체에서 클릭할 때 액션
       		if (selectedStart.day() === 0 || selectedStart.day() === 6) { // moment -> 0 = 일요일 & 6 = 토요일
		        Swal.fire(
		            'Error',
		            '주말에는 예약할 수 없습니다.',
		            'error'
		        );
		        return;
		    }
       		    		
       	    // 선택한 날짜와 시간 둘 다 이전인 경우
       	    if (selectedStart.isBefore(now)) {
       	       Swal.fire(
				'Error',
				'지난 날짜와 시간에는 예약할 수 없습니다.',
				'error'
				)
       	        return;
       	    }

       	    // 날짜는 같지만 시간이 현재시간 기준으로 이전인 경우
       	    if (selectedStart.isSame(now, 'day') && selectedStart.isBefore(now, 'hour')) {
       	         Swal.fire(
				'Error',
				'지난 시간에는 예약할 수 없습니다.',
				'error'
				)
       	        return;
       	    }
	    	// --------------------------------------------------------------------------------------------
            
            $('#calendarModal').modal('show');

			var selectedDate = info.startStr.split("T")[0]; // 사용자가 선택한 날짜
			var selectedStartTime = moment.tz(info.startStr, 'Asia/Seoul').format('HH:mm'); // 선택 시작시간
			var selectedEndTime = moment.tz(info.endStr, 'Asia/Seoul').format('HH:mm'); // 선택 종료시간

			$('#selectedDate').val(selectedDate);
			$('#revStartTime').val(selectedStartTime);
			$('#revEndTime').val(selectedEndTime);
			$('#roomName').val(roomName); // 모달창에 자동으로 들어가는 정보
			
			var eventsByDate = {}; // 날짜별 저장 객체 생성
		    calendar.getEvents().forEach(function(event) {
		        var eventDate = moment.tz(event.startStr, 'Asia/Seoul').format('YYYY-MM-DD');
		        if (!eventsByDate[eventDate]) {
		            eventsByDate[eventDate] = [];
		        }
		        eventsByDate[eventDate].push(event);
		    });

		    if (eventsByDate[selectedDate]) {
		        eventsByDate[selectedDate].forEach(function(event) {
		            var eventStart = moment.tz(event.startStr, 'Asia/Seoul').format('HH:mm');
		            var eventEnd = moment.tz(event.endStr, 'Asia/Seoul').format('HH:mm');
		            
		            $('#revStartTime option[value="' + eventStart + '"]').prop('disabled', true).css('color', '#EAEAEA');
		            $('#revEndTime option[value="' + eventEnd + '"]').prop('disabled', true).css('color', '#EAEAEA');
		        });
		    }
		
			var now = moment.tz('Asia/Seoul');
			var selectedStartDate = moment.tz(selectedDate + ' ' + selectedStartTime, 'Asia/Seoul'); // 날짜 + 시작시간
			console.log(selectedStartDate);
			var selectedEndDate = moment.tz(selectedDate + ' ' + selectedEndTime, 'Asia/Seoul'); // 날짜 + 종료시간
			var reservRange = now.isBetween(selectedStartDate, selectedEndDate); // 예약 시간 범위
			// select option 비활성화/활성화
			$('#revStartTime option').each(function() {
			    var optionValue = $(this).val();

			    if ((now.isBefore(selectedStartDate) || reservRange) && now.isBefore(moment(selectedDate + ' ' + optionValue, 'YYYY-MM-DD HH:mm'))) {
			        // 오늘 날짜가 아닐때
			        var isReserved = false;
			        if (eventsByDate[selectedDate]) {
			            eventsByDate[selectedDate].forEach(function(event) {
			                var eventStart = moment.tz(event.startStr, 'Asia/Seoul').format('HH:mm');
			                var eventEnd = moment.tz(event.endStr, 'Asia/Seoul').format('HH:mm');
		                if (eventStart <= optionValue && optionValue < eventEnd) { // 시작 ~ 종료 시간 사이에 예약 데이터 있으면
			                    isReserved = true;
			                    return false; // 예약된 시간 찾으면 빠져나감
			                }
			            });
			        }

			        if (isReserved) {
			            $(this).prop('disabled', true).css('color', '#EAEAEA');
			        } else {
			            $(this).prop('disabled', false).css('color', '');
			        }
			    } else {
			        // 현재 시간이나 or 지난 시간
			        $(this).prop('disabled', true).css('color', '#EAEAEA');
			    }
			});

			$('#revEndTime option').each(function() {
			    var optionValue = $(this).val();

			    if ((now.isBefore(selectedStartDate) || reservRange) && now.isBefore(moment(selectedDate + ' ' + optionValue, 'YYYY-MM-DD HH:mm'))) {
			        var isReserved = false;
			        if (eventsByDate[selectedDate]) {
			            eventsByDate[selectedDate].forEach(function(event) {
			                var eventStart = moment.tz(event.startStr, 'Asia/Seoul').format('HH:mm');
			                var eventEnd = moment.tz(event.endStr, 'Asia/Seoul').format('HH:mm');
			                if (eventStart < optionValue && optionValue <= eventEnd) { 
			                    isReserved = true;
			                    return false;
			                }
			            });
			        }

			        if (isReserved) {
			            $(this).prop('disabled', true).css('color', '#EAEAEA');
			        } else {
			            $(this).prop('disabled', false).css('color', '');
			        }
			    } else {
			        $(this).prop('disabled', true).css('color', '#EAEAEA');
			    }
			});
        } //select end    
});
    
    // 추가 버튼 클릭 이벤트 처리 -----> 모달창에선 지난 시간들 예약 처리되는 오류 수정해야함
    $('#addCalendar').click(function() {
        var revReason = $('#revReason').val().trim();

        if (revReason === "") {
            $("#rn_check").text("공백은 입력할 수 없습니다.");
            $("#rn_check").css("color", "red");
            $("#revReason").focus();
            return;
        }
        
        // 예약 중복 검사
        var selectedStart = moment.tz(
        $('#selectedDate').val() + ' ' + $('#revStartTime').val(), 
        'Asia/Seoul'
	    );
	    var selectedEnd = moment.tz(
	        $('#selectedDate').val() + ' ' + $('#revEndTime').val(), 
	        'Asia/Seoul'
	    );
        console.log("추가 선택 시작 시간:",selectedStart);
        console.log("추가 선택 종료 시간:",selectedEnd);
        
        // 예약 시작시간이 종료 시간보다 느릴 경우 메시지 표시
        if (selectedStart.isSameOrAfter(selectedEnd)) {
            $("#rn_check").text("예약 시작시간이 종료 시간보다 늦거나 같을 수 없습니다.");
            $("#rn_check").css("color", "red");
            return;
        }
        
        var overlappingEvent = calendar.getEvents().find(function(event) {
            var eventStart = moment.tz(event.startStr, 'Asia/Seoul');
            var eventEnd = moment.tz(event.endStr, 'Asia/Seoul');
            console.log("예약중복검사 이미 존재하는 시작 시간:",eventStart);
            console.log("예약중복검사 이미 존재하는 종료 시간:",eventEnd);
            
            return (
                (selectedStart.isSameOrAfter(eventStart) && selectedStart.isBefore(eventEnd)) ||
                (selectedEnd.isAfter(eventStart) && selectedEnd.isSameOrBefore(eventEnd)) ||
                (selectedStart.isSameOrBefore(eventStart) && selectedEnd.isSameOrAfter(eventEnd))
            );
        });

        if (overlappingEvent) {
            Swal.fire(
					'Error',
					'이미 예약된 시간이 포함되어 있습니다.',
					'error'
				)
            return;
        }
        
        
      
        var reservationInfo = {
            equipNo: roomNo,
		/* revStartTime: $('#selectedDate').val() + ' ' + $('#revStartTime').val(),
            revEndTime: $('#selectedDate').val() + ' ' + $('#revEndTime').val(),*/
            revStartTime: $('#selectedDate').val() + 'T' + $('#revStartTime').val(),
    		revEndTime: $('#selectedDate').val() + 'T' + $('#revEndTime').val(),
            revReason: revReason // 변경된 예약 사유 사용
 
        };

        $.ajax({
            url: '/JoinTree/addReservation',
            type: 'POST',
            dataType: 'json',
            data: JSON.stringify(reservationInfo),
            contentType: 'application/json',
            success: function(response) {
                calendar.addEvent(reservationInfo);
                Swal.fire({
					icon: 'success',
					title: '예약이 완료되었습니다.',
					showConfirmButton: false,
					timer: 1500
				})
                $('#calendarModal').modal('hide'); 
                calreload(); // 목록 동적 생성
            },
            error: function() {
                //console.log('Reservation Info:', reservationInfo);
                console.error('예약 추가 실패');
                Swal.fire(
					'Error',
					'다른 사용자가 이미 예약한 시간대입니다.',
					'error'
				)
            }
        });
    });

// 모달창이 닫힐때 초기화 하는 옵션
$('#calendarModal').on('hidden.bs.modal', function () {
    $("#rn_check").text("");
    $("#revReason").val("");
    $('#revStartTime option, #revEndTime option').prop('disabled', false).css('color', '');
});

    function calreload() {
        calendar.refetchEvents(); // 풀캘린더 reload 함수
    }
    calendar.render();
});
$(document).ready(function() {
	const urlParams = new URL(location.href).searchParams;
	const msg = urlParams.get("msg");
	if (msg != null) {
		Swal.fire({
			icon: 'success',
			title: msg,
			showConfirmButton: false,
			timer: 1000
		});
	}
	
	// 쿼리 매개변수 "msg"를 제거하고 URL을 업데이트 (새로고침 시 메시지 알림창 출력하지 않음)
    urlParams.delete("msg");
    const newUrl = `${location.pathname}?${urlParams.toString()}`;
    history.replaceState({}, document.title, newUrl);
    
    
    // 여기에서 empNo 값을 가져오는 방법을 추가
	const empNo = $("#empNo").data("empno"); // 현재 사용자의 사원 번호
    
	// 사원 근속일수 조회(일)
	function getEmpWorkDay(empNo) {
		$.ajax({
			url: '/JoinTree/commuteManage/getWorkDay',
			type: 'GET',
			data:{
				empNo: empNo
			},
			success: function(data) {
				console.log(data + " <--getWorkDay");
				
				
				// 값 저장
				let workDay = data.getWorkDay; // 근속일수
				
				// 값 설정
				$('#workDay').text(workDay); // 근속일수
				
				// 사원 근속일수 조회(연, 월) 및 표시
				getFormatEmpWorkDay(workDay);
			}
		});
	};
	getEmpWorkDay(empNo); // 사원 근로일 수 조회 함수
	
	// 사원 근속일수 조회(연, 월)
	function getFormatEmpWorkDay(workDay) {
		let years = Math.floor(workDay / 365); // 년 단위 계산
		let months = Math.floor((workDay % 365) / 30); // 개월 단위 계산
		let duration = "";
	    
	    if (years > 0) {
	        duration += years + "년 ";
	    }
	    
	    if (months > 0) {
	        duration += months + "개월";
	    }
	    
        if (years === 0 && months === 0) {
        	duration = "1개월 미만"; // 근속일이 1개월 미만인 경우
    	}
	    
	    $('#duration').text(duration); // 근속일수를 년, 개월로 표시
	}
	
});
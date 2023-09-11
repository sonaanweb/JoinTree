$(document).ready(function() {
	const urlParams = new URL(location.href).searchParams;
	const msg = urlParams.get("msg");
		if (msg != null) {
			let icon;
			
			// 메시지 내용에 따라 아이콘 변경
			if (msg.includes("로그아웃") || msg.includes("다시")) {
				icon = 'success'; // 성공 아이콘
			} else {
				icon = 'warning'; // 경고 아이콘
			} 
			
			Swal.fire({
				icon: icon,
				title: msg,
				showConfirmButton: false,
				timer: 1000
			});
		}
		
	// <input type="number"> 일 경우 숫자만 입력받도록 설정
	$("input[type='number']").on("keypress", function(event) {
		if ((event.which < 48) || (event.which > 57)) {
			return false;
		}
    });
	
	// 로그인 버튼 클릭 시 
	$("#loginBtn").click(function() {
		if ($("#empNo").val() == "") {
			// alert("사번을 입력해주세요.");
			Swal.fire({
				icon: 'warning',
				title: '사번을 입력해주세요.',
				showConfirmButton: false,
				timer: 1000
			});
			$("#empNo").focus();
		} else if ($("#empPw").val() == "") {
			// alert("비밀번호를 입력해주세요.");
			Swal.fire({
				icon: 'warning',
				title: '비밀번호를 입력해주세요.',
				showConfirmButton: false,
				timer: 1000
			});
			$("#empPw").focus();
		} else {
		 	$("#login").submit();
		}
	});
});
$(document).ready(function() {
	const urlParams = new URL(location.href).searchParams;
	const msg = urlParams.get("msg");
		if (msg != null) {
			alert(msg);
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
			alert("사번을 입력해주세요.");
			$("#empNo").focus();
		} else if ($("#empPw").val() == "") {
			alert("비밀번호를 입력해주세요.");
			$("#empPw").focus();
		} else {
		 	$("#login").submit();
		}
	});
});
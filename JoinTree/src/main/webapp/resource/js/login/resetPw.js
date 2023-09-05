$(document).ready(function() {
	const urlParams = new URL(location.href).searchParams;
	const msg = urlParams.get("msg");
		if (msg != null) {
			alert(msg);
		}

	
	// input type이 number 일 경우 숫자만 입력받도록 설정
	$("input[type='number']").on("keypress", function(event) {
		if ((event.which < 48) || (event.which > 57)) {
			return false;
		}
    });
	
	// 인증 버튼 클릭 시 
	$("#authBtn").click(function() {
		const empNo = $("#empNo").val();
		const juminNo = $("#juminNo").val();
		
		if (empNo === "") {
			alert("사번을 입력해주세요.");
			$("#empNo").focus(); 
		} else if (juminNo === "") {
			alert("주민번호 뒷자리를 입력해주세요.");
			$("#juminNo").focus();
		} else {
			// AJAX 요청을 통해 인증 여부 확인
			$.ajax({
				type: "POST", 
				url: "/JoinTree/login/resetPw",
				data: {
					empNo: empNo, 
					juminNo: juminNo
				},
				success: function(response) {
					if (response === "success") {
						 $("#empNoHidden").val(empNo); // 인증 성공했을 경우 empNo 값을 비밀번호 변경을 위한 hidden 필드에 설정
						alert("인증이 완료되었습니다.");
						// 인증 성공 시 비밀번호 재설정 섹션 표시
						$("#authForm").hide();
						$("#resetPwSection").show();
						 // 인증 버튼 비활성화
	                    $("#authBtn").prop("disabled", true);
					} else {
						alert("인증 실패. 사번 또는 주민번호를 확인해주세요.");
						$("#juminNo").val("");
					}
				},
				error: function() {
					alert("서버 오류 발생. 관리자에게 문의해주세요.");
				}
			});
		}
	});	
	

	
	

	// 비밀번호 재설정 버튼 클릭 시 
	$("#resetPwBtn").click(function() {
		if ($("#newPw").val() == "") {
			alert("새 비밀번호를 입력해주세요.");
			$("#newPw").focus();
		} else if (!isValidPassword($("#newPw").val())) {
			alert("비밀번호는 영문 소문자, 숫자, 특수문자(@, #, $, %, ^, &, +, =, !)를 포함하여 8자 이상이어야 합니다.");
			$("#newPw").val("");
			$("#newPw").focus();
		} else if ($("#newPw2").val() == "") {
			alert("새 비밀번호를 다시 입력해주세요.");
			$("#newPw2").focus();
		} else if ($("#newPw").val() !== $("#newPw2").val()) {
			alert("새 비밀번호가 일치하지 않습니다.");
			$("#newPw2").val("");
			$("#newPw2").focus();
		} else {
			$("#reset").submit();
		}
	});
	
	// 비밀번호 유효성 검사
	function isValidPassword(password) {
		// 영문 소문자, 숫자, 특수문자를 포함하여 8자 이상
		return /^(?=.*[a-z])(?=.*\d)(?=.*[@#$%^&+=!]).{8,}$/.test(password);
	}
});
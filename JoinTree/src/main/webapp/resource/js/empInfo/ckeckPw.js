			$(document).ready(function() {
				const urlParams = new URL(location.href).searchParams;
				const msg = urlParams.get("msg");
					if (msg != null) {
						alert(msg);
					}
					
				$("#checkPwBtn").click(function() {
					if ($("#empPw").val() == "") {
						alert("비밀번호를 입력해주세요.");
						$("#empPw").focus();
					} else {
						$("#checkPw").submit();
					}
				});
			});
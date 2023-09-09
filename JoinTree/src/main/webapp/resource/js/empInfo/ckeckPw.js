			$(document).ready(function() {
				const urlParams = new URL(location.href).searchParams;
				const msg = urlParams.get("msg");
					if (msg != null) {
						Swal.fire({
							icon: 'warning',
							title: msg,
							showConfirmButton: false,
							timer: 1000
						});
					}
					
				$("#checkPwBtn").click(function() {
					if ($("#empPw").val() == "") {
						Swal.fire({
							icon: 'warning',
							title: '비밀번호를 입력해주세요.',
							showConfirmButton: false,
							timer: 1000
						});
						$("#empPw").focus();
					} else {
						$("#checkPw").submit();
					}
				});
			});
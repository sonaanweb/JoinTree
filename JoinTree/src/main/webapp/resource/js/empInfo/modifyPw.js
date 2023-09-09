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
			
 			$("#newPw").focusout(function() {
			    let currentPw = $("#empPw").val();
			    let newPw = $(this).val();
			    // let errorSpan = $("#newPwError");
			    let requirementsSpan = $("#password-requirements");
			    let errorSpan = $("#password-error-message");

			    if (currentPw === newPw) {
			        errorSpan.text("새 비밀번호는 현재 비밀번호와 다르게 입력해주세요.");
			        requirementsSpan.hide(); // 경고 메시지가 나오면 요구사항 메시지 숨김
			        $(this).val("");
			        $(this).focus();
			    } else {
			        errorSpan.text("");
			        
			        // 정규식을 사용하여 비밀번호 유효성 검사
			        if (!isValidPassword(newPw)) {
			        	errorSpan.text("영문 소문자, 숫자, 특수문자(@, #, $, %, ^, &, +, =, !)를 포함하여 8자 이상이어야 합니다.");
			        	requirementsSpan.hide(); // 경고 메시지가 나오면 요구사항 메시지 숨김
		                $(this).val("");
		                $(this).focus();
			        }
			    }
			});

			$("#newPw2").focusout(function() {
			    let newPw = $("#newPw").val();
			    let newPw2 = $(this).val();
			    let errorSpan = $("#newPw2Error");

			    if (newPw !== newPw2) {
			        errorSpan.text("새 비밀번호가 일치하지 않습니다.");
			        $(this).val("");
			        $(this).focus();
			    } else {
			        errorSpan.text("");
			    }
			}); 
			
			// 비밀번호 변경 버튼 클릭 시 
			$("#modifyPwBtn").click(function() {
				if ($("#empPw").val() == "") {
					// alert("현재 비밀번호를 입력해주세요.");
					Swal.fire({
						icon: 'warning',
						title: '현재 비밀번호를 입력해주세요.',
						showConfirmButton: false,
						timer: 1000
					});
					$("#empPw").focus();
				} else if ($("#newPw").val() == "") {
					// alert("새 비밀번호를 입력해주세요.");
					Swal.fire({
						icon: 'warning',
						title: '새 비밀번호를 입력해주세요.',
						showConfirmButton: false,
						timer: 1000
					});
					$("#newPw").focus();
				} else if ($("#newPw2").val() == "") {
					// alert("새 비밀번호를 다시 입력해주세요.");
					Swal.fire({
						icon: 'warning',
						title: '새 비밀번호를 다시 입력해주세요.',
						showConfirmButton: false,
						timer: 1000
					});
					$("#newPw2").focus();
				} else if ($("#newPw").val() !== $("#newPw2").val()) {
					// alert("새 비밀번호가 일치하지 않습니다.");
					Swal.fire({
						icon: 'warning',
						title: '새 비밀번호가 일치하지 않습니다.',
						showConfirmButton: false,
						timer: 1000
					});
					$("#newPw2").val("");
					$("#newPw2").focus();
				} else {
					$("#modifyPw").submit();
				}
			});
			
			// 비밀번호 유효성 검사
			function isValidPassword(password) {
				// 영문 소문자, 숫자, 특수문자를 포함하여 8자 이상
				return /^(?=.*[a-z])(?=.*\d)(?=.*[@#$%^&+=!]).{8,}$/.test(password);
			}
		});
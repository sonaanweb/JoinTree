// 입력폼 유효성 검사
$(document).ready(function(){
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
		
	const fileInput = $('#fileInput');
    const previewImage = $('#previewImage');	
    const currentImage = $('#currentImage');
    
    const removeBtn = $('#removeBtn');
	
 	// 초기에 파일 삭제 버튼 숨기기
 	removeBtn.hide();

 	// 파일 선택 시 미리보기, 파일 크기 검사, 파일 확장자 검사
    fileInput.change(function() {
        const file = fileInput.prop('files')[0]; // 선택한 파일 객체 가져오기
        if (file) {
            const reader = new FileReader();
            reader.onload = function(e) {
                previewImage.attr('src', e.target.result);
                currentImage.hide(); // 기존 이미지 감추기
                // currentImageTxt.hide(); // 기존 이미지 글씨 감추기
                // previewImage.show(); // 미리보기 이미지 보이기
                previewImage.attr('src', e.target.result); 
            };
            reader.readAsDataURL(file); // 파일을 데이터 URL로 읽기 시작
        
        	// 파일 크기, 확장자 검사
        	const fileSize = file.size;
        	const maxSize = 3 * 1024 * 1024; // 3MB
        	const allowedExtensions = ['.jpg', '.jpeg', '.png', 'gif', '.bmp'];
        	const fileExtensions = file.name.substr(file.name.lastIndexOf('.')).toLowerCase();
        	
        	if (fileSize > maxSize) {
        		Swal.fire({
					icon: 'warning',
					title: '파일 크기가 3MB를 초과합니다.',
					showConfirmButton: false,
					timer: 1000
				});
        		fileInput.val(''); // 파일 선택 초기화
        		previewImage.attr('src', ''); // 미리보기 초기화
        	} else if (!allowedExtensions.includes(fileExtensions)) {
        		Swal.fire({
					icon: 'warning',
					title: '이미지 파일만 첨부 가능합니다.',
					showConfirmButton: false,
					timer: 1000
				});
            	fileInput.val(''); // 파일 선택 초기화
            	previewImage.attr('src', ''); // 미리보기 초기화
        	} else {
        		// 파일 선택 시 파일 삭제 버튼 표시
        		removeBtn.show();
        	}
        
        } else {
            previewImage.attr('src', '');
            currentImage.show(); // 기존 이미지 보이기
            // currentImageTxt.show(); // 기존 이미지 글씨 보이기
            previewImage.hide(); // 미리보기 이미지 감추기
            
        }
    });
 	
 	// 파일 삭제 버튼 클릭 시 파일 선택 초기화
 	removeBtn.click(function() {
 		fileInput.val(''); // 파일 선택 초기화
 		previewImage.attr('src', ''); // 미리보기 초기화
 		removeBtn.hide(); // 파일 삭제 버튼 숨기기
 	});
    
    // 사진 등록 버튼 클릭되었을 때
    $("#uploadImgBtn").click(function() {
    	console.log("사진 등록 버튼 클릭");
    	// 입력 요소에서 선택한 파일 가져옴
    	const file = $("#fileInput")[0].files[0];
    	
    	if (file) {
    		const formData = new FormData();
    		formData.append("uploadImg", file); // FormData 객체에 파일 추가
    	
    	
        	// 서버로 AJAX 요청
        	$.ajax({
        		url: "/JoinTree/empInfo/modifyEmp/uploadEmpImg",
        		type: "POST",
        		data: formData, 
        		processData: false, // false로 선언 시 formData를 string으로 변환하지 않음
        		contentType: false, // false로 선언 시 content-type 헤더가 multipart/form-data로 전송되게 함
        		success: function(response) {
        			console.log(response);
        	 		if (response === "success") {
	    				Swal.fire({
							icon: 'success',
							title: '사진이 등록되었습니다.',
							showConfirmButton: false,
							timer: 1000
       				  	 }).then(() => {
	                        // 서버에서 새로 업데이트된 이미지 경로로 뷰 업데이트
	                        $("#currentImage").attr("src", response.newImagePath);
	                        location.reload(); // 현재 메인 페이지 새로고침
	                    });
		    		} else {		
    	 				Swal.fire({
							icon: 'warning',
							title: '사진 등록 중 오류가 발생했습니다.',
							showConfirmButton: false,
							timer: 1000
						});
		    		}
        		}, 
        		error: function(error) {
        			alert("서버 오류 발생");
        		}	
        	});
    	} else {
			Swal.fire({
				icon: 'warning',
				title: '업로드할 사진을 선택해주세요.',
				showConfirmButton: false,
				timer: 1000
			});
 
    	}
    });
    
    // 사진 삭제 버튼 클릭되었을 때
    $("#removeImgBtn").click(function() {
    	console.log("사진 삭제 버튼 클릭");
    	Swal.fire({
            title: '사진이 완전히 삭제됩니다.',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#8BC541',
            cancelButtonColor: '#888',
            confirmButtonText: '확인',
            cancelButtonText: '취소'
            }).then((result) => {
               if (result.isConfirmed) {
                  $.ajax({
                     type : "POST",
                     url : "/JoinTree/empInfo/modifyEmp/removeEmpImg",
                     success : function(response) {
                        console.log("respose",response);
                        if (response === "success") {
                           Swal.fire({
                              icon: 'success',
                              title: '사진이 삭제되었습니다.',
                              showConfirmButton: false,
                              timer: 1000
                        	 }).then(() => {
	                            // 서버에서 삭제된 이미지 경로로 뷰 업데이트
	                            $("#currentImage").attr("src", "");
	                            $("#currentImage").hide();
	                            $("#currentImageTxt").hide();
	
	                            location.reload(); // 페이지 새로고침
                       		 });
                        } else {
							Swal.fire({
								icon: 'warning',
								title: '사진 삭제 중 오류가 발생했습니다.',
								showConfirmButton: false,
								timer: 1000
							});
						}
                     }, 
                      error: function(error) {
	                    alert("서버 오류 발생");
	                }
                  });
               }
            });
    });
   	  
	// 이름 칸은 문자만 입력 허용
	$("#empName").on("keypress", function(event) {
	    // ASCII 코드 값이 숫자 범위(48~57)인 경우 입력 막음
	    if (event.which >= 48 && event.which <= 57) {
	        event.preventDefault();
	    }
	});
	
	// 주민번호, 연락처 칸은 숫자만 입력 허용
   	$("[id^='empJuminNo'], [id^='empPhone']").on("keypress", function(event) {
   		if ((event.which < 48 || event.which > 57) && event.which !== 8) {
            return false;
        }
    });
    
    
    // 상세주소 필드
    $("#sample6_detailAddress").on("input", function() {
	    const detailAddressInput = $(this);
	    const detailAddressValue = detailAddressInput.val();
	    
	    if (detailAddressValue.includes("/")) {
	        const cleanedValue = detailAddressValue.replace("/", "").trim();
	        detailAddressInput.val(cleanedValue);
        	Swal.fire({
				icon: 'warning',
				title: '/ 는 입력할 수 없습니다.',
				showConfirmButton: false,
				timer: 1000
			});
	    }
	});
	
	// 정보 수정 버튼 클릭 시 
	$("#modifyEmpBtn").click(function() {
		if ($("#empName").val() == "") {
			Swal.fire({
				icon: 'warning',
				title: '이름을 입력해주세요.',
				showConfirmButton: false,
				timer: 1000
			});
			$("#empName").focus();
		} else if ($("#sample6_postcode").val() == "") {
			// alert("우편번호를 입력해주세요.");
			Swal.fire({
				icon: 'warning',
				title: '우편번호를 입력해주세요.',
				showConfirmButton: false,
				timer: 1000
			});
			$("#sample6_postcode").focus();
		} else if ($("#sample6_address").val() == "") {
			// alert("주소를 입력해주세요.");
			Swal.fire({
				icon: 'warning',
				title: '주소를 입력해주세요.',
				showConfirmButton: false,
				timer: 1000
			});
			$("#sample6_address").focus();
		} else if ($("#sample6_detailAddress").val() == "") {
			// alert("상세주소를 입력해주세요.");
			Swal.fire({
				icon: 'warning',
				title: '상세주소를 입력해주세요.',
				showConfirmButton: false,
				timer: 1000
			});
			$("#sample6_detailAddress").focus();
		} else if ($("#sample6_extraAddress").val() == "") {
			// alert("참고항목을 입력해주세요.");
			Swal.fire({
				icon: 'warning',
				title: '참고항목을 입력해주세요.',
				showConfirmButton: false,
				timer: 1000
			});
			$("#sample6_extraAddress").focus();
		} else if ($("#empJuminNo1").val() == "") {
			// alert("주민등록번호 앞자리를 입력해주세요.");
			Swal.fire({
				icon: 'warning',
				title: '주민등록번호 앞자리를 입력해주세요.',
				showConfirmButton: false,
				timer: 1000
			});
			$("#empJuminNo1").focus();
		} else if ($("#empJuminNo2").val() == "") {
			// alert("주민등록번호 뒷자리를 입력해주세요.");
			Swal.fire({
				icon: 'warning',
				title: '주민등록번호 뒷자리를 입력해주세요.',
				showConfirmButton: false,
				timer: 1000
			});
			$("#empJuminNo2").focus();
		} else if ($("#empPhone1").val() == "") {
			// alert("연락처 첫 번째 칸을 입력해주세요.");
			Swal.fire({
				icon: 'warning',
				title: '연락처 첫 번째 칸을 입력해주세요.',
				showConfirmButton: false,
				timer: 1000
			});
			$("#empPhone1").focus();
		} else if ($("#empPhone2").val() == "") {
			// alert("연락처 두 번째 칸을 입력해주세요.");
			Swal.fire({
				icon: 'warning',
				title: '연락처 두 번째 칸을 입력해주세요.',
				showConfirmButton: false,
				timer: 1000
			});
			$("#empPhone2").focus();
		} else if ($("#empPhone3").val() == "") {
			// alert("연락처 세 번째 칸을 입력해주세요.");
			Swal.fire({
				icon: 'warning',
				title: '연락처 세 번째 칸을 입력해주세요.',
				showConfirmButton: false,
				timer: 1000
			});
			$("#empPhone3").focus();
		} else {
			// alert("사원 정보가 변경되었습니다.");
			$("#modifyEmp").submit();
		}
	});
	
	// 서명 그리기 기능
    let goal = $("#goal")[0]; // goal의 첫 번째 배열값
    let uploadSignImg = new SignaturePad(goal, {minWidth: 2, maxWidth: 2, penColor: 'rgb(0, 0, 0)'});
    
	$("#clear").click(function() {
		console.log("clear 버튼 클릭");
		uploadSignImg.clear();
	});
	
	$("#save").click(function() { // 이미지 보여주기
		console.log("save 버튼 클릭");
		if (uploadSignImg.isEmpty()) {
			alert("내용이 없습니다.");
		} else {
			let data = uploadSignImg.toDataURL("image/png"); // 캐시 URL 가져오기
			$("#target").attr("src", data); // 이미지 파일의 경로를 위 URL로 설정
		}
	});
	
	$("#send").click(function() { // 저장
		console.log("send 버튼 클릭");
		if (uploadSignImg.isEmpty()) {
			// alert("내용이 없습니다.");
			Swal.fire({
				icon: 'warning',
				title: '내용이 없습니다.',
				showConfirmButton: false,
				timer: 1000
			});
		} else {
			/*
			if (confirm("서명을 등록하시겠습니까? 서명은 최초 1회만 등록 가능합니다.")) {
				$.ajax({
					url : "/JoinTree/empInfo/modifyEmp/uploadSignImg",
					data : {uploadSignImg : uploadSignImg.toDataURL("image/png", 1.0)},
					type : "post",
					success : function(jsonData) { // jsonData: 서버로부터 받아온 응답 데이터 (변수명 변경 가능)
						alert("서명 저장 성공 " + jsonData);
						location.reload(); // 현재 화면 새로고침
					}
				});
			}
			*/
			Swal.fire({
			    title: '서명을 등록하시겠습니까?',
			    text: '서명은 최초 1회만 등록 가능합니다.',
			    icon: 'warning',
			    showCancelButton: true,
			    confirmButtonColor: '#8BC541',
			    cancelButtonColor: '#888',
			    confirmButtonText: '확인',
			    cancelButtonText: '취소'
			}).then((result) => {
			    if (result.isConfirmed) {
			        $.ajax({
			            url: '/JoinTree/empInfo/modifyEmp/uploadSignImg',
			            data: { uploadSignImg: uploadSignImg.toDataURL('image/png', 1.0) },
			            type: 'post',
			            success: function (jsonData) { // jsonData: 서버로부터 받아온 응답 데이터 (변수명 변경 가능)
		                Swal.fire({
		                    icon: 'success',
		                    title: '서명 저장 성공 ' + jsonData,
		                    showConfirmButton: false,
		                    timer: 1000
	                     }).then(() => {
                    location.reload(); // 알림창이 사라진 후에 화면 리로드
                });
            }
    	});
    }
});
		}
	});
});

// 주소API
var themeObj = {
 		  // searchBgColor: "#F24182", 
 		  // queryTextColor: "#FFFFFF" 
 		};
function sample6_execDaumPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {
            var addr = ''; 
            var extraAddr = ''; 
            if (data.userSelectedType === 'R') { 
                addr = data.roadAddress;
            } else { 
                addr = data.jibunAddress;
            }
            if(data.userSelectedType === 'R'){
                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraAddr += data.bname;
                }
                if(data.buildingName !== '' && data.apartment === 'Y'){
                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                if(extraAddr !== ''){
                    extraAddr = ' (' + extraAddr + ')';
                }
                document.getElementById("sample6_extraAddress").value = extraAddr;
            
            } else {
                document.getElementById("sample6_extraAddress").value = '';
            }
            document.getElementById('sample6_postcode').value = data.zonecode;
            document.getElementById("sample6_address").value = addr;
            document.getElementById("sample6_detailAddress").focus();
        },
        theme: themeObj
    }).open();
}
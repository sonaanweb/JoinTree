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
		
	const fileInput = $('#fileInput');
    const previewImage = $('#previewImage');
    const removeBtn = $('#removeBtn');
    
    // 초기에 파일 삭제 버튼 숨기기
    removeBtn.hide();
        
    // 파일 선택 시 미리보기, 파일 크기 검사, 파일 확장자 검사
    fileInput.change(function() {
        const file = fileInput.prop('files')[0]; // 선택한 파일 객체 가져오기
        if (file) {
            const reader = new FileReader(); // FileReader 객체 생성
            reader.onload = function(e) { // 파일 읽기 완료 후 실행될 함수 정의
            	// 미리보기 이미지의 'src' 속성을 읽은 파일 내용으로 설정
                previewImage.attr('src', e.target.result); 
            };
            reader.readAsDataURL(file); // 파일을 데이터 URL로 읽기 시작
            
            // 파일 크기, 확장자 검사
            const fileSize = file.size;
            const maxSize = 3 * 1024 * 1024; // 3MB
            const allowedExtensions = ['.jpg', '.jpeg', '.png', 'gif', '.bmp'];
            const fileExtensions = file.name.substr(file.name.lastIndexOf('.')).toLowerCase();
            
            if (fileSize > maxSize) {
            	// alert("파일 크기가 3MB를 초과합니다.");
            	Swal.fire({
					icon: 'warning',
					title: '파일 크기가 3MB를 초과합니다.',
					showConfirmButton: false,
					timer: 1000
				});
            	fileInput.val(''); // 파일 선택 초기화
            	previewImage.attr('src', ''); // 미리보기 초기화
            	// removeBtn.hide(); // 파일 삭제 버튼 숨기기
            } else if (!allowedExtensions.includes(fileExtensions)) {
            	// alert("이미지 파일만 첨부 가능합니다.");
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
            previewImage.attr('src', ''); // 파일이 선택되지 않았을 때 미리보기 초기화
        }
    });
    
    // 파일 삭제 버튼 클릭 시 파일 선택 초기화
    removeBtn.click(function() {
        fileInput.val(''); // 파일 선택 초기화
        previewImage.attr('src', ''); // 미리보기 초기화
        removeBtn.hide(); // 파일 삭제 버튼 숨기기
    });
    
    /*
	// 게시글 등록 버튼 클릭 시 
	$("#addAnonymousCommBtn").click(function() {
		if ($("#boardTitle").val() == "") {
			alert("제목을 입력해주세요.");
			$("#boardTitle").focus();
		} else {
			console.log($("#boardContent").val() + " 넘어간 경우");
			$("#addAnonymousComm").submit();
		}
	});   
    
    */
});
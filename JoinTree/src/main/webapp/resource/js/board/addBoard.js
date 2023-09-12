	$(document).ready(function(){
			
		// addBoard 실행 후 메세지(게시글 등록 실패 메세지)
		const urlParams = new URL(location.href).searchParams;
		const msg = urlParams.get("msg");
		
		if (msg != null) {
			Swal.fire({
				icon: 'warning',
				title: msg,
				showConfirmButton: false,
				timer: 1000
			});
			
			// 쿼리 매개변수 "msg"를 제거하고 URL을 업데이트
	        urlParams.delete("msg");
	        const newUrl = `${location.pathname}?${urlParams.toString()}`;
	        history.replaceState({}, document.title, newUrl);
		}

		// 파일삭제 버튼 초기 실행시 숨기기
		let removeFileBtn = $('#removeFileBtn');
		removeFileBtn.hide();
	});
	
	// CKEditor 초기화 및 설정
	let editor; // 에디터 변수 설정
	
	ClassicEditor
    .create(document.querySelector('#boardContent'), {
    	// 에디터 구성 옵션 설정
        toolbar: ['heading', 'bold', 'italic', 'link', 'bulletedList', 'numberedList', 'undo', 'redo'], // 필요한 툴바 옵션 추가
        placeholder: '내용을 입력해주세요', 
    })
    .then(editor => {
        // 에디터 스타일 및 설정
    	editor.ui.view.editable.element.style.overflow = 'auto';
        
        // 에디터 변수에 에디터 인스턴스 할당
    	editorInstance = editor;
    })
    
    .catch(error => {
        console.error(error);
    });
	

	// 파일 확장자 검사
	let boardFile = $('#boardFile'); // 파일
	let removeFileBtn = $('#removeFileBtn'); // 파일 삭제버튼
	
	boardFile.change(function(){
		
		let file = boardFile.prop('files')[0]; // 선택한 파일 저장
		
		if(file){
			
			// 파일 크기 검사
			const fileSize = file.size; // 파일 크기
			const maxSize = 3 * 1024 * 1024; // 최대 파일 크기 3MB
			
			if(fileSize > maxSize){
				Swal.fire({
					icon: 'warning',
					title: '파일 크기가 3MB를 초과합니다',
					showConfirmButton: false,
					timer: 1000
				});
				boardFile.val(''); // 파일 선택 초기화
			} else{
				// 파일 선택 시 파일 삭제 버튼 표시
				removeFileBtn.show();
			}
		}
	});
	
	// 파일 삭제버튼(removeFileBtn)클릭
	removeFileBtn.click(function() {
        boardFile.val(''); // 파일 선택 초기화
        removeFileBtn.hide(); // 파일 삭제버튼 숨기기
    });
	
	// 요청 값 공백검사 함수
	function checkEmptyAndAlert(input, message, focus) {
	    if (input.trim() == '') {
	        Swal.fire({
				icon: 'warning',
				title: message,
				showConfirmButton: false,
				timer: 1000
			});
	        $(focus).focus();
	        return true;
	    }
	    return false;
	}
	
	// 제목 엔터 키 눌렀을 때 동작 중지
	$('#boardTitle').keypress(function(event){
		if(event.key == 'Enter'){
			event.preventDefault(); // 엔터 키 기본 동작 중지
			$('#boardTitle').val(''); // 제목 필드 값 삭제
		}
	});
	
	// 등록(addBoard) 버튼 클릭
	$('#addBoardBtn').on('click', function(){
		
		const editorData = editorInstance.getData(); // 에디터 값 변수에 저장
		
		// 값 공백 검사
		if (checkEmptyAndAlert($('#boardTitle').val(), '제목을 입력해주세요', '#boardTitle')) return; // 제목
		if (checkEmptyAndAlert(editorData, '내용을 입력해주세요', '#boardContent')) return; // 내용
		
		// 유효성 검사 후 등록
		let addBoardUrl = '/JoinTree/board/addBoard';
		$('#addBoardForm').attr('action', addBoardUrl);
		$('#addBoardForm').submit();
	});	
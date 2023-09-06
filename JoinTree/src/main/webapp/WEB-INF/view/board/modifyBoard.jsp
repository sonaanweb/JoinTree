<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<!-- header -->
<jsp:include page="/WEB-INF/view/inc/header.jsp"/>
<script src="https://cdn.ckeditor.com/ckeditor5/39.0.1/classic/ckeditor.js"></script>
<style>
    .ck-editor__editable {
        min-height: 450px;
        overflow: auto;
    }
</style>
	<div class="container-fluid page-body-wrapper">
	<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
		<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
			<!-- 게시글 수정 -->
			<div class="col-lg-12 grid-margin stretch-card">
				<div class="card">
					<div class="card-body">
						<!-- 게시글 수정 폼 -->
						<form id="modifyBoardForm" enctype="multipart/form-data" method="post">
							
							<input type="hidden" name="boardNo" value="${board.boardNo}">
							<div class="row">
								<div class="col">
									<h3>&#91;${board.boardCategory}&#93;&nbsp;&nbsp;글 수정</h3>
								</div>
								<div class="col text-right">
									<div class="d-flex justify-content-end align-items-center">
										<div class="form-check form-check-success">
											<label class="form-check-label">
												<!-- 상단공지 체크박스 체크된 상태로 수정폼 호출 -->
												<input type="checkbox" name="boardPinned" class="form-check-input" 
												${board.boardPinned == 1 ? 'checked' : ''}> 게시판 상단고정 &nbsp;&nbsp;&nbsp;&nbsp;
											</label>
										</div>
										<button type="button" id="modifyBoardBtn" class="btn btn-success btn-sm">수정</button>
									</div>
								</div>
							</div>
							<hr>
							<div>
								<input type="text" id="boardTitle" name="boardTitle" value="${board.boardTitle}"class="form-control form-control-lg">
							</div>
							<br>
							<div>
								<textarea id="boardContent" name="boardContent">${board.boardContent}</textarea>
							</div>
							<br>
							<!-- 첨부파일 유무의 따른 분기
								 첨부파일이 있을 경우 파일명, 파일삭제 버튼 활성화 -->			
							<c:if test="${board.boardSaveFilename != null}">
								<div id="existingFile">
									<span>첨부파일&nbsp;&nbsp;&nbsp;&nbsp;${board.boardOriginFilename}</span>&nbsp;&nbsp;&nbsp;&nbsp;
									<i class="mdi mdi-close-circle" id="removeExistingFileBtn">파일삭제</i>
								</div>
								<br>
							</c:if>
							<div>
								<input type="file" id="boardFile" name="multipartFile">
								<i class="mdi mdi-close-circle" id="removeFileBtn">파일삭제</i>
								<br>
								<span>(3MB 이하의 파일만 첨부 가능합니다)</span>
							</div>				
						</form>
					</div>
				</div>
			</div>
			
		</div>
	</div>
	
	<script>
		$(document).ready(function(){
			
			// addBoard 실행 후 메세지
			const urlParams = new URL(location.href).searchParams;
			const msg = urlParams.get("msg");
			
			if (msg != null) {
				
				alert(msg);
				
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
		
		
		// 게시글 기존 첨부파일 삭제
		$('#removeExistingFileBtn').click(function(){
			
			let boardNo = '${board.boardNo}'; // 문서번호 저장
			let existingFileDiv = $('#existingFile'); // 기존 첨부파일 Div
			
			$.ajax({
				url: '/JoinTree/board/removeBoardFile',
				type: 'POST',
				data:{
					boardNo: boardNo
				},
				success: function(data){
					console.log(data);
					if(data == 1){
						alert('첨부파일 삭제 완료');
					} else{
						alert('첨부파일 삭제 실패')
					}
					
					// existingFileDiv 업데이트
					existingFileDiv.load('/JoinTree/board/modifyBoardForm?boardNo=' + boardNo + ' #existingFile');
				},
				error: function(){
					console.log('modifyBoard removeExistingFileBtn click : '+error);
				}
			});
		});
		
		
		// 파일 확장자 검사
		let boardFile = $('#boardFile'); // 파일
		let removeFileBtn = $('#removeFileBtn'); // 파일 삭제버튼
		
		boardFile.change(function(){
			
			let file = boardFile.prop('files')[0]; // 선택한 파일 저장
			
			if(file){
				
				const reader = new FileReader(); // FileReader 객체 생성
				reader.readAsDataURL(file); // 파일을 데이터 URL로 읽기 시작
				
				// 파일 크기 검사
				const fileSize = file.size; // 파일 크기
				const maxSize = 3 * 1024 * 1024; // 최대 파일 크기 3MB
				
				if(fileSize > maxSize){
					alert("파일 크기가 3MB를 초과합니다.");
                	fileInput.val(''); // 파일 선택 초기화
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
		        alert(message);
		        $(focus).focus();
		        return true;
		    }
		    return false;
		}
		
		// 수정(modifyBoardBtn) 버튼 클릭
		$('#modifyBoardBtn').on('click', function(){
			
			const editorData = editorInstance.getData(); // 에디터 값 변수에 저장
			
			// 값 공백 검사
			if (checkEmptyAndAlert($('#boardTitle').val(), '제목을 입력해주세요', '#boardTitle')) return; // 제목
			if (checkEmptyAndAlert(editorData, '내용을 입력해주세요', '#boardContent')) return; // 내용
			
			// 유효성 검사 후 등록
			let modifyBoardUrl = '/JoinTree/board/modifyBoard';
			$('#modifyBoardForm').attr('action', modifyBoardUrl);
			$('#modifyBoardForm').submit();
		});	
	</script>
</html>
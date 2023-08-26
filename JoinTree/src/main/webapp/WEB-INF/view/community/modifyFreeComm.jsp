<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<!-- header -->
	<jsp:include page="/WEB-INF/view/inc/header.jsp"/> 
		<script src="https://cdn.ckeditor.com/ckeditor5/39.0.1/classic/ckeditor.js"></script>
	    <style>
        .ck-editor__editable {
            min-height: 300px;
            overflow: auto;
        }
   		</style>
		<script>
			// 입력폼 유효성 검사 추가
			$(document).ready(function(){
				const urlParams = new URL(location.href).searchParams;
				const msg = urlParams.get("msg");
					if (msg != null) {
						alert(msg);
					}
					
				const fileInput = $('#fileInput');
		        const previewImage = $('#previewImage');	
		        const currentImage = $('#currentImage');
		        const currentImageTxt = $('#currentImageTxt');
		        
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
		            		alert("파일 크기가 3MB를 초과합니다.");
		            		fileInput.val(''); // 파일 선택 초기화
		            		previewImage.attr('src', ''); // 미리보기 초기화
		            	} else if (!allowedExtensions.includes(fileExtensions)) {
		            		alert("이미지 파일만 첨부 가능합니다.");
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
		        		formData.append("boardNo", "${comm.boardNo}"); // boardNo 추가
		        	
			        	// 서버로 AJAX 요청
			        	$.ajax({
			        		url: "/JoinTree/community/uploadFile",
			        		type: "POST",
			        		data: formData,	 
			        		processData: false, // false로 선언 시 formData를 string으로 변환하지 않음
			        		contentType: false, // false로 선언 시 content-type 헤더가 multipart/form-data로 전송되게 함
			        		success: function(response) {
			        			console.log(response);
			        	 		if (response === "success") {
					    			alert("사진이 등록되었습니다.");
					    			// 서버에서 새로 업데이트된 이미지 경로로 뷰 업데이트
					                $("#currentImage").attr("src", response.newImagePath);
					    			location.reload(); // 현재 메인 페이지 새로고침
					    		} else {		
			        	 			alert("사진 등록 중 오류가 발생했습니다.");
					    		}
			        		}, 
			        		error: function(error) {
			        			alert("서버 오류 발생");
			        		}
			        	});
		        	} else {
		        		alert("업로드할 사진을 선택해주세요.");
		        	}
		        });
		        
		        // 이미지 삭제 버튼 클릭되었을 때
		        $("#removeImgBtn").click(function() {
		        	console.log("사진 삭제 버튼 클릭");
		        	
		            $.ajax({
		                url: "/JoinTree/community/removeFile", 
		                type: "POST",
		                data: {"boardNo": "${comm.boardNo}"}, // boardNo 값을 추가하여 전송
		                success: function(response) {
		                    console.log(response);
		                    if (response === "success") {
		                        alert("이미지가 삭제되었습니다.");
		                        // 서버에서 삭제된 이미지 경로로 뷰 업데이트
		                        $("#currentImage").attr("src", "");
		                        $("#currentImage").hide();
		                        
		                        location.reload(); // 페이지 새로고침
		                    } else {
		                        alert("이미지 삭제 중 오류가 발생했습니다.");
		                    }
		                },
		                error: function(error) {
		                    alert("서버 오류 발생. 관리자에게 문의해주세요.");
		                }
		            });
		        	
		        });
			});	
		</script>
	
	
	
		<div class="container-fluid page-body-wrapper">
			<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
				<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
	
	
					<a href="/JoinTree/community/freeCommList/freeCommOne?boardNo=${comm.boardNo}">이전</a>
				
					<h1>게시글 수정</h1>
					
					<!-- 추후 삭제 -->
					<div>
						부서코드: ${dept}
					</div>		
					
					<div>
						카테고리: 자유게시판
					</div>
					
					<form action="/JoinTree/community/modifyComm" method="post">
						<input type="hidden" name="boardNo" value="${comm.boardNo}">
						<input type="hidden" name="empNo" value="${loginAccount.empNo}">
						<input type="hidden" name="boardCategory" value="B0103">
						<div>
							<c:if test="${dept eq 'D0202'}">	
								게시판 상단고정 <input type="checkbox" name="boardPinned" <c:if test="${comm.boardPinned eq '1'}">checked</c:if>> <!-- 기존 상단고정 상태일 경우 체크박스 선택하여 출력 -->
							</c:if>
						</div>
						<table border="1">
							<tr>
								<!-- <th>제목</th> -->
								<td><input type="text" name="boardTitle" value="${comm.boardTitle}"></td>
							</tr>
							<tr>
								<!-- <th>내용</th> -->
								<td>
									<textarea id="boardContent" name="boardContent" rows="4" cols="50">${comm.boardContent}</textarea>
								</td>
							</tr>
							<tr>
								<!-- <th>첨부파일</th> -->
								<td>
							    	<c:choose>
								        <c:when test="${boardFile.boardSaveFilename eq null or boardFile.boardSaveFilename == '이미지 없음'}">
								        	<input type="file" name="multipartFile" id="fileInput" accept="image/jpg, image/jpeg, image/png, image/gif, image/bmp"><br>
								        	<img id="previewImage" src="" style="max-width: 300px; max-height: 300px;"><br>
											<button type="button" id="removeBtn">이미지 삭제</button>
								        	<button type="button" id="uploadImgBtn">이미지 등록</button>
								        	<div>
												* 이미지 선택 후 이미지 등록 버튼을 클릭해야 새 이미지가 저장됩니다. 
											</div>
								        </c:when>
								        <c:otherwise>
								            <img src="${pageContext.request.contextPath}/commImg/${boardFile.boardSaveFilename}" style="width: 300px; height: auto;"><br>
								       	    <button type="button" id="removeImgBtn">이미지 삭제</button>
							       	    	<div>
												* 이미지 삭제 버튼 클릭 시 등록된 이미지가 완전히 삭제됩니다. 
											</div>
								        </c:otherwise>
								    </c:choose>
								</td>
							</tr>
						</table>
						<div>
							<button type="submit" id="modifyFreeCommBtn">수정</button>
						</div>
					</form>
			</div>
		</div>
		<!-- CKEditor 초기화 및 설정 -->
	    <script>
	        ClassicEditor
	            .create(document.querySelector('#boardContent'), {
	            	// 에디터 구성 옵션 설정
	                toolbar: ['heading', 'bold', 'italic', 'link', 'bulletedList', 'numberedList', 'blockQuote', 'undo', 'redo'], // 필요한 툴바 옵션 추가
	                placeholder: '내용을 입력해주세요.', // 에디터 창에 보이는 미리보기 문구
	            })
	            .then(editor => {
	                // 에디터 스타일 및 설정
	                // editor.ui.view.editable.element.style.minHeight = '300px';
	                // editor.ui.view.editable.element.style.height = '300px';
	                editor.ui.view.editable.element.style.overflow = 'auto';
	            })
	            
	            .catch(error => {
	                console.error(error);
	            });
	    </script>
</html>
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
		        const removeBtn = $('#removeBtn');
        
		     	// 초기에 미리보기 삭제 버튼 숨기기
		     	removeBtn.hide();
		     	
		        // 파일 선택 및 미리보기 핸들러
		        $(document).on('change', '#fileInput', function() {
		        	console.log("파일 선택 버튼 클릭");
		            const file = $(this).prop('files')[0]; // 선택한 파일 객체 가져오기

		            if (file) { // 파일이 있을 경우
		                const reader = new FileReader();
		                
		            	// 파일 읽기 완료 이벤트 핸들러
		            	reader.onload = function(e) {
		                	if ($('#removeBtn').is(':visible')) { // 미리보기 삭제 버튼이 보일 경우에만 미리보기 표시
		                        previewImage.attr('src', e.target.result);

		                    }
		                  	// previewImage.attr('src', e.target.result);
		                    // previewImage.attr('src', e.target.result);
		            
		                };
		                reader.readAsDataURL(file);

		                const fileSize = file.size;
		                const maxSize = 3 * 1024 * 1024; // 3MB
		                const allowedExtensions = ['.jpg', '.jpeg', '.png', 'gif', '.bmp'];
		                const fileExtension = file.name.substr(file.name.lastIndexOf('.')).toLowerCase();

		                if (fileSize > maxSize) {
		                    alert("파일 크기가 3MB를 초과합니다.");
		                    $(this).val('');
		                    previewImage.attr('src', '');
		                } else if (!allowedExtensions.includes(fileExtension)) {
		                    alert("이미지 파일만 첨부 가능합니다.");
		                    $(this).val('');
		                    previewImage.attr('src', '');
		                } else {
		                	// 미리보기 이미지 표시
		                	console.log("이미지 선택 완료");
		                	previewImage.show();
		                	console.log("미리보기 이미지 출력");
		                    removeBtn.show();
		                    console.log("미리보기 삭제버튼 출력");
		                }
		            } else { // 파일이 없을 경우
		                previewImage.attr('src', '');
		                // previewImage.hide();
		                removeBtn.hide();
		            }
		        });

		        // 미리보기 삭제 핸들러
		        $(document).on('click', '#removeBtn', function() {
		        	console.log("미리보기 삭제 버튼 클릭");
		            fileInput.val('');
		            previewImage.attr('src', '');
		            $(this).hide();
		        });
		     	
		   
		        // 이미지 등록 버튼 클릭 이벤트 핸들러
		        $(document).on('click', '#uploadImgBtn', function() {
		            console.log("사진 등록 버튼 클릭");
		            const file = $("#fileInput")[0].files[0];
		            
		            if (file) {
		                const formData = new FormData();
		                formData.append("uploadImg", file);
		                formData.append("boardNo", "${comm.boardNo}");
		                
		                $.ajax({
		                    url: "/JoinTree/community/uploadFile",
		                    type: "POST",
		                    data: formData,
		                    processData: false,
		                    contentType: false,
		                    success: function(response) {
		                        console.log(response);
		                        if (response === "success") {
		                            alert("사진이 등록되었습니다.");
		                            // $("#currentImage").attr("src", response.newImagePath);
		                            $("#attachmentCell").load(location.href + " #attachmentCell>*", function() {
		                                //$("#uploadImgBtn").click(); // 이미지 등록 이벤트 재등록
		                            	//removeBtn.hide();
		                            });
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

		        // 이미지 삭제 버튼 클릭 이벤트 핸들러
		        $(document).on('click', '#removeImgBtn', function() {
		            console.log("사진 삭제 버튼 클릭");
		            
		            $.ajax({
		                url: "/JoinTree/community/removeFile",
		                type: "POST",
		                data: {"boardNo": "${comm.boardNo}"},
		                success: function(response) {
		                    console.log(response);
		                    if (response === "success") {
		                        alert("이미지가 삭제되었습니다.");		
		                      
		                    	
		                        $("#attachmentCell").load(location.href + " #attachmentCell>*", function() { // 이미지 셀 리로드
		                        	// 미리보기 이미지를 초기화
		                            //$(this).find('#previewImage').attr('src', '');
			                        // previewImage.hide();
		                        	//$("#uploadImgBtn").click(); // 이미지 등록 이벤트 재등록
		                        	// removeBtn.hide();
		                        	// 리로드된 셀 내에서 removeBtn을 찾아 숨김 처리
		                            $(this).find('#removeBtn').hide();
		                        	
		                            
			                        // 이미지 삭제 후에 미리보기 이미지 업데이트
			                        previewImage.attr('src', '');
			                        removeBtn.hide();
		                        });
		                    } else {
		                        alert("이미지 삭제 중 오류가 발생했습니다.");
		                    }
		                },
		                error: function(error) {
		                    alert("서버 오류 발생. 관리자에게 문의해주세요.");
		                }
		            });
		        });
		        
/* 				// 수정 버튼 클릭 시 
				$("#modifyFreeCommBtn").click(function() {
					if ($("#boardTitle").val() == "") {
						alert("제목을 입력해주세요.");
						$("#boardTitle").focus();
					} else {
						console.log($("#boardContent").val() + " 넘어간 경우");
						$("#modifyFreeComm").submit();
					}
				});    */ 
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
					
					<form action="/JoinTree/community/modifyComm" method="post" id="modifyFreeComm">
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
								<td><input type="text" name="boardTitle" value="${comm.boardTitle}" id="boardTitle"></td>
							</tr>
							<tr>
								<!-- <th>내용</th> -->
								<td>
									<textarea id="boardContent" name="boardContent" rows="4" cols="50">${comm.boardContent}</textarea>
								</td>
							</tr>
							<tr>
								<!-- <th>첨부파일</th> -->
								<td id="attachmentCell">
							    	<c:choose>
								        <c:when test="${boardFile.boardSaveFilename eq null or boardFile.boardSaveFilename == '이미지 없음'}">
								        	<input type="file" id="fileInput" accept="image/jpg, image/jpeg, image/png, image/gif, image/bmp"><br>
								        	<img id="previewImage" src="" style="max-width: 300px; max-height: 300px;"><br>
											<button type="button" id="removeBtn">미리보기 삭제</button>
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
							<button type="button" id="modifyFreeCommBtn">수정</button>
						</div>
					</form>
			</div>
		</div>
		<!-- CKEditor 초기화 및 설정 -->
	    <script>
	        ClassicEditor
	            .create(document.querySelector('#boardContent'), {
	            	// 에디터 구성 옵션 설정
	                toolbar: ['heading', 'bold', 'italic', 'link', 'bulletedList', 'numberedList', 'undo', 'redo'], // 필요한 툴바 옵션 추가
	                placeholder: '내용을 입력해주세요.', // 에디터 창에 보이는 미리보기 문구
	            })
	            .then(editor => {
	                // 에디터 스타일 및 설정
	                // editor.ui.view.editable.element.style.minHeight = '300px';
	                // editor.ui.view.editable.element.style.height = '300px';
	                editor.ui.view.editable.element.style.overflow = 'auto';
	                
	                // editorInstance 변수에 에디터 할당
	                editorInstance = editor;
	            })
	            
	            .catch(error => {
	                console.error(error);
	            });
	        
				// Assuming there is a <button id="submit">Submit</button> in your application.
			    document.querySelector( '#modifyFreeCommBtn' ).addEventListener( 'click', () => {
			    	const editorData = editorInstance.getData();
			    	if (document.querySelector("#boardTitle").value == "") {
						alert("제목을 입력해주세요.");
						$("#boardTitle").focus();
					} else if (editorData == "") {
						alert("내용을 입력해주세요.");
					} else {
						alert("게시글이 수정되었습니다.");
						$("#modifyFreeComm").submit();
					}
			    });
	    </script>
</html>
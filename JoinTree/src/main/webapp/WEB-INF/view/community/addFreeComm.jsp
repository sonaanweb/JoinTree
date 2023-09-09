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
   		<script src="/JoinTree/resource/js/community/addFreeComm.js"></script>

		<div class="container-fluid page-body-wrapper">
		<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
			<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
			<div class="col-lg-12 grid-margin stretch-card">
            	<div class="card">
             		<div class="card-body">
						
                 <!--  <h4 class="card-title">게시글 작성</h4> -->
 <%--                  	<div>
						로그인 부서코드: ${dept}
					</div>	
                  <p class="card-description">
                    Add class <code>.table-bordered</code><br>
                  	카테고리: 자유게시판
                  </p> --%>
                   <form action="/JoinTree/community/addComm" method="post" enctype="multipart/form-data" id="addFreeComm">
	                    <input type="hidden" name="empNo" value="${loginAccount.empNo}">
						<input type="hidden" name="boardCategory" value="B0103">
	     				<h3>&#91;자유 게시판&#93;&nbsp;&nbsp;게시글 작성</h3>
	     				<div class="col text-right">
							<div class="d-flex justify-content-end align-items-center">
								<div class="form-check form-check-success">
									<label class="form-check-label">
										<c:if test="${dept eq 'D0202'}">	
											게시판 상단고정 <input type="checkbox" name="boardPinned"> &nbsp;&nbsp;&nbsp;&nbsp; <!-- value 지정하지 않았을 경우 체크박스 선택 시 boardPinned="on" 과 같이 넘어감 -->
						 				</c:if>
									</label>
								</div>
								<button type="button" id="addFreeCommBtn" class="btn btn-success btn-fw">게시글 등록</button>
							</div>
						</div>
						<hr>
	                   <input class="form-control form-control-lg" type="text" name="boardTitle" placeholder="제목을 입력해주세요." id="boardTitle">
                       <br>
                       <textarea name="boardContent" style="height:300px;" rows="5" cols="50" id="boardContent"></textarea>
	                   <br>   
					   <input type="file" name="multipartFile" id="fileInput" accept="image/jpg, image/jpeg, image/png, image/gif, image/bmp">
					   <button type="button" id="removeBtn" class="btn btn-success btn-sm">미리보기 삭제</button>
					   (3MB 이하의 이미지 파일만 첨부 가능합니다.)<br>
					   <img id="previewImage" src="" style="max-width: 400px; max-height: 400px;">
				   </form>
                  
                </div>
              </div>
            </div>
		</div>
	</div>
	<%-- <script src="${pageContext.request.contextPath}/resource/js/ckeditor.js"></script> --%>
	<!-- CKEditor 초기화 및 설정 -->
    <script>
	let editor;    
    
    ClassicEditor
    .create(document.querySelector('#boardContent'), {
    	// 에디터 구성 옵션 설정
        toolbar: ['heading', 'bold', 'italic', 'link', 'bulletedList', 'numberedList', 'undo', 'redo', ], // 필요한 툴바 옵션 추가
        placeholder: '내용을 입력해주세요.', // 에디터 창에 보이는 미리보기 문구
    })
    .then(editor => {
        // 에디터 스타일 및 설정
        // editor.ui.view.editable.element.style.minHeight = '300px';
        // editor.ui.view.editable.element.style.height = '300px';
        editor.ui.view.editable.element.style.overflow = 'auto';
        
        // editor 변수에 에디터 인스턴스 할당
        // editorInstance = editor;
        editorInstance = editor;
    })
    
    .catch(error => {
        console.error(error);
    });
    
	// Assuming there is a <button id="submit">Submit</button> in your application.
    document.querySelector( '#addFreeCommBtn' ).addEventListener( 'click', () => {
    	const editorData = editorInstance.getData();
    	if (document.querySelector("#boardTitle").value == "") {
			// alert("제목을 입력해주세요.");
			Swal.fire({
				icon: 'warning',
				title: '제목을 입력해주세요.',
				showConfirmButton: false,
				timer: 1000
			});
			$("#boardTitle").focus();
		} else if (editorData == "") {
			// alert("내용을 입력해주세요.");
			Swal.fire({
				icon: 'warning',
				title: '내용을 입력해주세요.',
				showConfirmButton: false,
				timer: 1000
			});
		} else {
			// alert("게시글이 작성되었습니다.");
/* 			Swal.fire({
				icon: 'success',
				title: '게시글이 작성되었습니다.',
				showConfirmButton: false,
				timer: 1000
			}); */
			$("#addFreeComm").submit();
		}
    	
    	//editor.setData('#boardContent');
    	// 
		// alert(!editorData)
        // ...
        
        // confirm
    });
	
    // var contents = editor.getData();
    
	
  /*   const editor = ClassicEditor
    .create(document.querySelector('#editor'))
    .then(editor => {
        // CKEditor의 인스턴스를 얻었습니다.

        // 값을 가져오려면 editor.getData() 메서드를 사용합니다.
        const editorData = editor.getData();
        console.log(editorData); // CKEditor에서 입력한 내용을 출력합니다.
    })
    .catch(error => {
        console.error(error);
    }); */
    </script>
    <!-- footer -->
    <jsp:include page="/WEB-INF/view/inc/footer.jsp"/>
</html>
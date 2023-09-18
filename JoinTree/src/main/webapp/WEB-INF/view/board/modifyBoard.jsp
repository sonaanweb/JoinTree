<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<!-- header -->
<jsp:include page="/WEB-INF/view/inc/header.jsp"/>
<script src="https://cdn.ckeditor.com/ckeditor5/39.0.1/classic/ckeditor.js"></script>
<link rel="stylesheet" type="text/css" href="/JoinTree/resource/css/custom.css">
	<div class="container-fluid page-body-wrapper">
	<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
		<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
			<!-- 게시글 수정 -->
			<div class="col-lg-12 grid-margin stretch-card">
				<div class="card">
					<div class="card-body">
						<!-- 게시글 수정 폼 -->
						<form id="modifyBoardForm" enctype="multipart/form-data" method="post">
							
							<input type="hidden" id="boardNo" name="boardNo" value="${board.boardNo}">
							<div class="row">
								<div class="col d-flex align-items-center">
									<h3 class="">&#91;${board.boardCategory}&#93;&nbsp;&nbsp;글 수정</h3>
								</div>
								<div class="col d-flex justify-content-end align-items-center">
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
	
	<!-- footer -->
    <jsp:include page="/WEB-INF/view/inc/footer.jsp"/>	
	
	<!-- script -->
	<script src="/JoinTree/resource/js/board/modifyBoard.js"></script>
</html>
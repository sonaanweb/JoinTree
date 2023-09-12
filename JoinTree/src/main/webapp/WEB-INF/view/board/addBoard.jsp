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
			<!-- 게시글 작성 -->
			<div class="col-lg-12 grid-margin stretch-card">
				<div class="card">
					<div class="card-body">
						<!-- 게시글 입력 폼 -->
						<form id="addBoardForm" enctype="multipart/form-data" method="post">
							<input type="hidden" name="boardCategory" value="${boardCategory}">
							<div class="row">
								<div class="col">
									<h3>&#91;${boardCategoryName}&#93;&nbsp;&nbsp;글 작성</h3>
								</div>
								<div class="col text-right">
									<div class="d-flex justify-content-end align-items-center">
										<div class="form-check form-check-success">
											<label class="form-check-label">
												<!-- 상단공지 체크박스 체크된 상태로 수정폼 호출 -->
												<input type="checkbox" name="boardPinned" class="form-check-input"> 게시판 상단고정 &nbsp;&nbsp;&nbsp;&nbsp;
											</label>
										</div>
										<button type="button" id="addBoardBtn" class="btn btn-success btn-fw">게시글 등록</button>
									</div>
								</div>
							</div>
							<hr>
							<div>
								<input type="text" id="boardTitle" name="boardTitle" placeholder="제목을 입력해주세요" class="form-control form-control-lg">
							</div>
							<br>
							<div>
								<textarea id="boardContent" name="boardContent"></textarea>
							</div>
							<br>			
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
	<script src="/JoinTree/resource/js/board/addBoard.js"></script>
</html>
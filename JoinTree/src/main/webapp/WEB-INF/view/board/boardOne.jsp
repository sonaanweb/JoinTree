<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<!-- header -->
<jsp:include page="/WEB-INF/view/inc/header.jsp"/>
	<div class="container-fluid page-body-wrapper">
	<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
		<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
			
			<!-- 이전글, 다음글, 목록 버튼 -->
			<div>
				<c:if test="${preBoardNo != null}">
					<a href="boardOne?boardNo=${preBoardNo}">이전글</a>
				</c:if>
				<c:if test="${nextBoardNo != null}">
					<a href="boardOne?boardNo=${nextBoardNo}">다음글</a>
				</c:if>
				<a href="/JoinTree/board/${boardCategory}?boardCategory=${board.categoryCode}">목록</a>
			</div>
			
			<!-- 게시글 상세 -->
			<div class="col-lg-12 grid-margin stretch-card">
				<div class="card">
					<div class="card-body">
						<div>
							<h2>${board.boardTitle}</h2>
						</div>
						<div>
							<span>${board.dept}&nbsp;관리자</span>
						</div>
						<div>
							<span>${board.createdate}</span>
						</div>
						<div>
							<span>조회&nbsp;${board.boardCount}</span>
						</div>
						<div>
							<span>${board.boardContent}</span>
						</div>
						<br>
						<!-- 첨부파일 유무의 따른 분기
							 첨부파일이 있을 경우 파일 다운로드 버튼 활성화 -->
						<c:if test="${board.boardSaveFilename != null}">
							<div>
								<a href="${pageContext.request.contextPath}/boardFile/${board.boardSaveFilename}" 
									download="${board.boardOriginFilename}">${board.boardOriginFilename} 다운로드</a>
							</div>	
						</c:if>		
					</div>
				</div>
			</div>
			
			<!-- 수정, 삭제 버튼. 작성자에 따른 버튼 활성화 분기 -->
			<c:if test="${loginAccount.empNo == board.createId}">
				<div>
					<a href="/JoinTree/board/modifyBoardForm?boardNo=${board.boardNo}">수정</a>
					<a href="/JoinTree/board/removeBoard?boardNo=${board.boardNo}" onclick="return confirm('게시글을 삭제하시겠습니까?')">삭제</a>
				</div>
			</c:if>
			
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
		});
	</script>
	
</html>
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
			<div class="col-lg-12 text-right">
				<c:if test="${preBoardNo != null}">
					<a href="boardOne?boardNo=${preBoardNo}" class="btn btn-success btn-sm">이전글</a>
				</c:if>
				<c:if test="${nextBoardNo != null}">
					<a href="boardOne?boardNo=${nextBoardNo}" class="btn btn-success btn-sm">다음글</a>
				</c:if>
				<a href="/JoinTree/board/${boardCategory}?boardCategory=${board.categoryCode}" class="btn btn-success btn-sm">목록</a>
			</div>
			<br>
			<!-- 게시글 상세 -->
			<div class="col-lg-12 stretch-card">
				<div class="card">
					<div class="card-body" id="contentDiv" style="height: 700px;">
						<div>
							<h3>&#91;${board.boardCategory}&#93;&nbsp;&nbsp;${board.boardTitle}</h3>
						</div>
						<div>
							<span>${board.dept}&nbsp;관리자</span>
						</div>
						<div>
							<span>${board.createdate}</span>&nbsp;&nbsp;&nbsp;
							<span>조회&nbsp;${board.boardCount}</span>
						</div>
						<hr>
						<!-- 첨부파일 유무의 따른 분기
							 첨부파일이 있을 경우 파일 다운로드 버튼 활성화 -->
						<c:if test="${board.boardSaveFilename != null}">
							<div class="text-right">
								<a href="${pageContext.request.contextPath}/boardFile/${board.boardSaveFilename}" 
									download="${board.boardOriginFilename}">${board.boardOriginFilename} 다운로드</a>
							</div>	
						</c:if>
						<br>	
						<div style="">
							<span>${board.boardContent}</span>
						</div>
					</div>
				</div>
			</div>
			<br>
			<!-- 수정, 삭제 버튼. 작성자에 따른 버튼 활성화 분기 -->
			<c:if test="${loginAccount.empNo == board.createId}">
				<div class="col-lg-12 text-right">
					<a href="/JoinTree/board/modifyBoardForm?boardNo=${board.boardNo}" class="btn btn-success btn-sm">수정</a>
					<a href="/JoinTree/board/removeBoard?boardNo=${board.boardNo}" class="btn btn-success btn-sm" id="removeBtn">삭제</a>
				</div>
			</c:if>
			
		</div>
	</div>
	
	<script>
		$(document).ready(function(){
			
			// modifyBoard, removeBoard 실행 후 메세지
			const urlParams = new URL(location.href).searchParams;
			const msg = urlParams.get("msg");
			const removeBoardRow = urlParams.get("removeBoardRow");
			
			if (msg != null) {
				
				Swal.fire({ // 게시글 수정 성공 메세지
					icon: 'success',
					title: msg,
					showConfirmButton: false,
					timer: 1000
				});
				
				if(removeBoardRow == 0){ // 게시글 삭제 실패 메세지
					Swal.fire({
						icon: 'warning',
						title: msg,
						showConfirmButton: false,
						timer: 1000
					});
				}
				
				// 쿼리 매개변수 "msg"를 제거하고 URL을 업데이트
		        urlParams.delete("msg");
		        const newUrl = `${location.pathname}?${urlParams.toString()}`;
		        history.replaceState({}, document.title, newUrl);
			}
			
			// contentDiv의 게시글이 기본 높이 초과 시 div 높이 증가
			let contentDiv = $('#contentDiv'); // contentDiv 선택
	        contentDiv.css('height', contentDiv[0].scrollHeight + 'px');
		});
		
		// 삭제 시 confirm 실행
		let removeBtn = $('#removeBtn');
		removeBtn.click(function (event) {
		    event.preventDefault(); // 기본 링크 동작 중단
					
		    Swal.fire({
		        title: '게시글을 삭제하시겠습니까?',
		        text: '삭제한 게시글은 복구할 수 없습니다.',
		        icon: 'warning',
		        showCancelButton: true,
		        confirmButtonColor: '#8BC541',
		        cancelButtonColor: '#888',
		        confirmButtonText: '삭제',
		        cancelButtonText: '취소',
		        preConfirm: () => {
		            
		        	// 확인 버튼을 클릭한 경우 링크로 이동
		            window.location.href = removeBtn.attr('href');
		        }
		    });
		});
	</script>	
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<!-- header -->
	<jsp:include page="/WEB-INF/view/inc/header.jsp"/>
		<script>
			$(document).ready(function() {
				const urlParams = new URL(location.href).searchParams;
				const msg = urlParams.get("msg");
					if (msg != null) {
						alert(msg);
					}
					
				// textarea에 placeholder과 비슷한 기능 적용
	            function setPlaceholder(element, placeholder) {
	                element.val(placeholder).css('color', 'gray');
	                
	                element.focus(function() {
	                    if (element.val() === placeholder) {
	                        element.val('').css('color', 'black');
	                    }
	                });
	                
	                element.blur(function() {
	                    if (element.val() === '') {
	                        element.val(placeholder).css('color', 'gray');
	                    }
	                });
	            }
	            
	            setPlaceholder($('#commentContent'), '댓글을 입력해주세요.');
	            
	            $("#addCommentBtn").click(function() {
	                const commentContent = $("#commentContent").val();
	                if (commentContent.trim() === "") {
	                    alert("댓글을 입력해주세요.");
	                    $("#commentContent").focus();
	                } else {
	                    $("#addComment").submit();
	                }
	            });
					
					
				
					
				// 새로고침 시 메시지 알림창 출력하지 않음
		        // urlParams.delete("msg");
		        //const newUrl = `${location.pathname}?${urlParams.toString()}`;
		        //history.replaceState({}, document.title, newUrl);
			});
		</script>
		
		<div class="container-fluid page-body-wrapper">
		<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
			<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
		
	
				<a href="/JoinTree/community/freeCommList">이전</a>
				
				<h1>상세정보</h1>
				<%-- ${loginAccount.empNo} --%>
				<%-- ${comm.boardCategory} --%>
				
				<table border="1">
					<tr>
						<th>제목</th>
						<td>${comm.boardTitle}</td>
					</tr>
					<tr>
						<th>내용</th>
						<td>${comm.boardContent}</td>
					</tr>
					<tr>
						<th>작성자</th>
						<td>${comm.empName}</td>
					</tr>
					<tr>
						<th>작성일자</th>
						<td>${comm.createdate}</td>
					</tr>
					<tr>
						<th>수정일자</th>
						<td>${comm.updatedate}</td>
					</tr>
					<tr>
					<th>첨부파일</th>
						<td>
					    	<c:choose>
						        <c:when test="${boardFile.boardSaveFilename eq null or boardFile.boardSaveFilename == '이미지 없음'}">
						            이미지 없음
						        </c:when>
						        <c:otherwise>
						            <img src="${pageContext.request.contextPath}/commImg/${boardFile.boardSaveFilename}" style="width: 300px; height: auto;"><br>
						        </c:otherwise>
						    </c:choose>
						</td>
					</tr>
				</table>
				<!-- 자신이 작성한 게시글일 경우에만 수정, 삭제 버튼 노출 -->
				<c:if test="${loginAccount.empNo eq comm.empNo}">
					<a href="/JoinTree/community/freeCommList/modifyFreeComm?boardNo=${comm.boardNo}">수정</a>
					<a href="/JoinTree/community/removeComm?boardNo=${comm.boardNo}">삭제</a>
				</c:if>
				
				<hr>
				
				<!-- 댓글 목록 -->
				<h2>댓글</h2>
				<table border="1">
					<tr>
						<th>작성자</th>
						<th>내용</th>
						<th>작성일자</th>
						<th></th>
						<th></th>
					</tr>
					<c:forEach items="${comments}" var="comment">
						<tr>
							<td>${comment.empName}</td>
							<td>${comment.commentContent}</td>
							<td>${comment.createdate}</td>
							<td>
								<!-- 자신이 작성한 댓글일 경우에만 수정, 삭제 버튼 노출 -->
								<c:if test="${loginAccount.empNo eq comment.empNo}">
									<a href="/JoinTree/comment/removeComment?commentNo=${comment.commentNo}&boardNo=${comment.boardNo}">삭제</a>
								</c:if>
							</td>
							<td><button type="button">답글</button></td>
						</tr>
					</c:forEach>
				</table>
				<hr>
				
				<!-- 댓글 작성 폼 -->
				<h2>댓글 작성</h2>
				<form action="/JoinTree/comment/addComment" method="POST" id="addComment">
					<input type="hidden" name="boardNo" value="${comm.boardNo}">
					<input type="hidden" name="empNo" value="${loginAccount.empNo}">
					<input type="hidden" name="category" value="${comm.boardCategory}">
					<input type="hidden" name="commentGroupNo" value="1">
					<textarea name="commentContent" id="commentContent" rows="3" cols="50"></textarea><br>
					<button type="button" id="addCommentBtn">댓글 입력</button>
				</form>
		</div>
	</div>
</html>
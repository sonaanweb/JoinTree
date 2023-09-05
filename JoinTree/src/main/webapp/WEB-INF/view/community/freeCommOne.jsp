<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
	<!-- header -->
	<jsp:include page="/WEB-INF/view/inc/header.jsp"/>
	<script src="/JoinTree/resource/js/community/freeCommOne.js"></script>
		<script>

		</script>
		<style>
			.comment-section {
			    max-height: 400px; 
			    overflow-y: auto;
			    border: 1px solid #ccc;
			    padding: 10px;
			}		    
		</style>
		
		
		<div class="container-fluid page-body-wrapper">
		<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
			<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
		
			<div class="col-lg-12 grid-margin stretch-card">
              <div class="card">
                <div class="card-body">
	
				<a href="/JoinTree/community/freeCommList" class="btn btn-outline-success btn-sm">목록으로</a><br>
				<br>
				
				<h1>상세정보</h1>
				<%-- ${loginAccount.empNo} --%>
				<%-- ${comm.boardCategory} --%>
				
				<table class="table table-bordered">
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
				<br>
				<c:if test="${loginAccount.empNo eq comm.empNo}">
					<a href="/JoinTree/community/freeCommList/modifyFreeComm?boardNo=${comm.boardNo}" class="btn btn-success btn-sm">수정</a>

					<a href="/JoinTree/community/removeComm?boardNo=${comm.boardNo}" onclick="return confirm('게시글을 삭제하시겠습니까?')" class="btn btn-success btn-sm">삭제</a>
				</c:if>
				
				</div>
			</div>
			</div>
			
			   <div class="col-lg-12 grid-margin stretch-card">
              	<div class="card">
                <div class="card-body">
				
				
				
				<!-- 댓글 목록 -->
				<h2>댓글</h2>
				
				<div class="comment-section" id="commentSection">
					<table class="table table-bordered">
						<tr>
							<th>No</th> <!-- 나중에 수정 -->
							<th>작성자</th>
							<th>내용</th>
							<th>작성일자</th>
							<th>삭제</th>
							<th>답글 달기 OR 원 댓글 번호</th>
						</tr>
						<c:forEach items="${comments}" var="comment">
							<c:choose>
								 <c:when test="${comment.parentCommentNo eq 0}">
								    <!-- 댓글인 경우 -->
									<tr class="comment-row">
										<td>${comment.commentNo}</td>
										<%-- <td>${comment.empNo}</td> --%>
										<td>${comment.empName}</td>
										<td>${comment.commentContent}</td>
										<td>${comment.createdate}</td>
										<td>
											<!-- 자신이 작성한 댓글일 경우에만 삭제 버튼 노출 -->
											<c:if test="${loginAccount.empNo eq comment.empNo}">
												<%-- <a href="/JoinTree/comment/removeComment?commentNo=${comment.commentNo}&boardNo=${comment.boardNo}">삭제</a> --%>
												<button type="button" class="remove-comment-btn btn btn-outline-success btn-sm" data-comment-no="${comment.commentNo}">삭제</button>
											</c:if>
										</td>
										<td>
											<!-- 클릭 시 jQuery 이벤트 바인딩 -->
											<button type="button" class="reply-btn btn btn-outline-success btn-sm">답글</button>
											<%-- ${comment.commentNo} --%>
										</td>
									</tr>
								</c:when>
							</c:choose>
							
							 <c:choose>
				                <c:when test="${not empty comment.parentCommentNo && comment.parentCommentNo ne 0}">
				                    <!-- 대댓글인 경우 -->
				                    <tr class="reply-row">
				                    	<td>${comment.commentNo}</td>
				                        <td>${comment.empName}</td>
				                        <td style="padding-left: 20px;">-> ${comment.commentContent}</td>
				                        <td>${comment.createdate}</td>
				                        <td>
				                            <!-- 자신이 작성한 댓글일 경우에만 삭제 버튼 노출 -->
				                            <c:if test="${loginAccount.empNo eq comment.empNo}">
				                                <%-- <a href="/JoinTree/comment/removeComment?commentNo=${comment.commentNo}&boardNo=${comment.boardNo}">삭제</a> --%>
				                            	<button type="button" class="remove-comment-btn btn btn-outline-success btn-sm" data-comment-no="${comment.commentNo}">삭제</button>
				                            </c:if>
				                        </td>
				                        <td>
				                            ${comment.parentCommentNo}
				                        </td>
				                    </tr>
				                </c:when>
				            </c:choose>

							<tr class="reply-form-row" style="display: none;">
								<td colspan="5">
					          		<form action="/JoinTree/comment/addReply" method="POST" class="reply-form">
						                <input type="hidden" name="boardNo" class="boardNo2" value="${comm.boardNo}">
						                <input type="hidden" name="empNo" class="empNo2" value="${loginAccount.empNo}">
						                <input type="hidden" name="category" class="category2" value="${comm.boardCategory}">
						                <!-- <input type="hidden" name="commentGroupNo" id="commentGroupNo" value="2"> -->
						                <input type="hidden" name="parentCommentNo" class="parentCommentNo" value="${comment.commentNo}">
						                <textarea name="commentContent" class="reply-content form-control" rows="3" cols="50"></textarea><br>
						                <button type="button" class="add-reply-btn btn btn-outline-success btn-sm">등록</button>
	           					 	</form>
	           					 </td>
							</tr>
						</c:forEach>
					</table>
				</div>
				<hr>
				
				<!-- 댓글 작성 폼 -->
				<h2>댓글 작성</h2>
				<form action="/JoinTree/comment/addComment" method="POST" id="addComment">
					<input type="hidden" name="boardNo" id="boardNo" value="${comm.boardNo}">
					<input type="hidden" name="empNo" id="empNo" value="${loginAccount.empNo}">
					<input type="hidden" name="category" id="category" value="${comm.boardCategory}">
					<!-- <input type="hidden" name="commentGroupNo" id="commentGroupNo" value="1"> -->
					<textarea name="commentContent" id="commentContent" rows="3" cols="50" class="form-control"></textarea><br>
					<button type="button" id="addCommentBtn" class="btn btn-success btn-md">댓글 입력</button>
				</form>
				
				<hr>
<%-- 				${preBoard.boardCategory} ${preBoard.boardNo}<br>
				${nextBoard.boardCategory} ${nextBoard.boardNo}<br> --%>
				
				<c:if test="${preBoard.boardNo ne null}">
					<a href="freeCommOne?boardNo=${preBoard.boardNo}">이전 글</a>
				</c:if>
				<c:if test="${nextBoard.boardNo ne null}">
					<a href="freeCommOne?boardNo=${nextBoard.boardNo}">다음 글</a>
				</c:if>	
				
			</div>
			</div>
			</div>
				
		</div>
	</div>
</html>
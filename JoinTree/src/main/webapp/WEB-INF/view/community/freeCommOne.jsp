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
				/*	
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
	            
	            */
	            
	            // 입력 버튼 클릭 시 
	            $("#addCommentBtn").click(function() {
	            	const boardNo = $("#boardNo").val();
	                const empNo = $("#empNo").val();
	                const category = $("#category").val();
	                // const commentGroupNo = $("#commentGroupNo").val();
	                const commentContent = $("#commentContent").val();
	                
	                if (commentContent.trim() === "") {
	                    alert("댓글을 입력해주세요.");
	                    $("#commentContent").focus();
	                } else {
	                    // $("#addComment").submit();
	                    $.ajax({
	                    	type: "POST", 
	                    	url: "/JoinTree/comment/addComment",
	                    	data: {
	                    		boardNo: boardNo, 
	                    		empNo: empNo, 
	                    		category: category, 
	                    		commentGroupNo: 1, 
	                    		commentContent: commentContent
	                    	}, 
	                    	 success: function(response) {
	                             if (response === "success") {
	                            	 alert("댓글이 등록되었습니다.");
	                                 // 새 댓글 업데이트 로직
	                                 // 예: $("#commentSection").append(...);
	                            	 $("#commentContent").val("");
	                            	 
	                            	  $("#commentSection").load(location.href + " #commentSection>*", function() {
	  		                        	// 이벤트 핸들러 다시 바인딩
	  		                        	bindEventHandlers();
	  		                       	  });
	                             } else {
	                                 alert("댓글 추가 실패");
	                             }
	                         },
	                         error: function() {
	                             alert("서버 오류 발생");
	                         }
	                    	
	                    });
	                    
	                }
	            });
	            
	            // 답글 버튼
	            $(".reply-btn").click(function() {
	                $(this).closest("tr").next(".reply-form-row").toggle();
	            });

	            $(".add-reply-btn").click(function() {
	                const replyForm = $(this).closest(".reply-form");
	                const commentContent = replyForm.find(".reply-content").val();
	                
	                if (commentContent.trim() === "") {
	                    alert("답글을 입력해주세요.");
	                    replyForm.find(".reply-content").focus();
	                } else {
	                    replyForm.submit();
	                }
	            });
	            
	            // 댓글 목록 부분 업데이트 시 이벤트 핸들러 다시 바인딩
	            function bindEventHandlers() {
	                $(".remove-comment-btn").off("click");
	                $(".reply-btn").off("click");
	                $(".add-reply-btn").off("click");

	                $(".remove-comment-btn").click(function() {
	                    const commentNo = $(this).data("comment-no");
	                    removeComment(commentNo);
	                });
	                
	                // 답글 버튼
		            $(".reply-btn").click(function() {
		                $(this).closest("tr").next(".reply-form-row").toggle();
		            });
	                
		  

		            $(".add-reply-btn").click(function() {
		                const replyForm = $(this).closest(".reply-form");
		                const commentContent = replyForm.find(".reply-content").val();
		                
		                if (commentContent.trim() === "") {
		                    alert("답글을 입력해주세요.");
		                    replyForm.find(".reply-content").focus();
		                } else {
		                    replyForm.submit();
		                }
		            });
	            }
	            
	       	  	// 댓글 또는 대댓글 삭제 함수
	       	  	function removeComment(commentNo) {
		       		$.ajax({
		       			type: "POST",
		                url: "/JoinTree/comment/removeComment",
		                data: {
		                    commentNo: commentNo,
		                },
		                success: function(response) {
		                    // alert(data); // 삭제 성공 여부 메시지 출력
		                    if (response === "success") {
		                        alert("삭제되었습니다.");
		                    	
		                        $("#commentSection").load(location.href + " #commentSection>*", function() {
		                        	// 이벤트 핸들러 다시 바인딩
		                        	bindEventHandlers();
		                        });
		                    }
		                },
		                error: function() {
		                    alert("서버 오류 발생");
		                }
		       		});
	       	 	 }
	       		
	       		// 댓글 삭제 버튼 클릭 시
	            $(".remove-comment-btn").click(function() {
	                const commentNo = $(this).data("comment-no");
	                removeComment(commentNo);
	                
	             	// 해당 댓글 행을 비워서 제거
	                // $(this).closest("tr").empty();
	                
	            });
			});
		</script>
		<style>
			.comment-section {
			    max-height: 400px; /* 원하는 높이로 설정 */
			    overflow-y: auto;
			    border: 1px solid #ccc;
			    padding: 10px;
			}
			
			/* 들여쓰기 스타일 */
   			.comment-row {
        		margin-left: 0;
   		 	 }
					
			.reply-row {
		        margin-left: 20px; /* 들여쓰기 간격 조정 */
		    }
		</style>
		
		
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
				
				<div class="comment-section" id="commentSection">
					<table border="1">
						<tr>
							<th>작성자</th>
							<th>내용</th>
							<th>작성일자</th>
							<th></th>
							<th></th>
						</tr>
						<c:forEach items="${comments}" var="comment">
							<c:choose>
								 <c:when test="${comment.commentGroupNo eq 1}">
								    <!-- 댓글인 경우 -->
									<tr class="comment-row">
										<td>${comment.empName}</td>
										<td>${comment.commentContent}</td>
										<td>${comment.createdate}</td>
										<td>
											<!-- 자신이 작성한 댓글일 경우에만 삭제 버튼 노출 -->
											<c:if test="${loginAccount.empNo eq comment.empNo}">
												<%-- <a href="/JoinTree/comment/removeComment?commentNo=${comment.commentNo}&boardNo=${comment.boardNo}">삭제</a> --%>
												<button type="button" class="remove-comment-btn" data-comment-no="${comment.commentNo}">삭제</button>
											</c:if>
										</td>
										<td>
											<!-- 클릭 시 jQuery 이벤트 바인딩 -->
											<button type="button" class="reply-btn">답글</button>
											${comment.commentNo}
										</td>
									</tr>
								</c:when>
							</c:choose>
							
							
							 <c:choose>
				                <c:when test="${comment.commentGroupNo eq 2}">
				                    <!-- 대댓글인 경우 -->
				                    <tr class="reply-row">
				                        <td>${comment.empName}</td> <!-- 작성자 정보 등을 채우세요 -->
				                        <td style="padding-left: 20px;">${comment.commentContent}</td>
				                        <td>${comment.createdate}</td>
				                        <td>
				                            <!-- 자신이 작성한 댓글일 경우에만 삭제 버튼 노출 -->
				                            <c:if test="${loginAccount.empNo eq comment.empNo}">
				                                <%-- <a href="/JoinTree/comment/removeComment?commentNo=${comment.commentNo}&boardNo=${comment.boardNo}">삭제</a> --%>
				                            	<button type="button" class="remove-comment-btn" data-comment-no="${comment.commentNo}">삭제</button>
				                            </c:if>
				                        </td>
				                        <td>
				                            ${comment.commentNo}
				                        </td>
				                    </tr>
				                </c:when>
				            </c:choose>

							<tr class="reply-form-row" style="display: none;">
								<td colspan="5">
					          		<form action="/JoinTree/comment/addReply" method="POST" class="reply-form">
						                <input type="hidden" name="boardNo" value="${comm.boardNo}">
						                <input type="hidden" name="empNo" value="${loginAccount.empNo}">
						                <input type="hidden" name="category" value="${comm.boardCategory}">
						                <input type="hidden" name="commentGroupNo" value="2">
						                <input type="hidden" name="parentCommentNo" value="${comment.commentNo}">
						                <textarea name="commentContent" class="reply-content" rows="3" cols="50"></textarea><br>
						                <button type="button" class="add-reply-btn">등록</button>
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
					<input type="hidden" name="commentGroupNo" id="commentGroupNo" value="1">
					<textarea name="commentContent" id="commentContent" rows="3" cols="50"></textarea><br>
					<button type="button" id="addCommentBtn">댓글 입력</button>
				</form>
		</div>
	</div>
</html>
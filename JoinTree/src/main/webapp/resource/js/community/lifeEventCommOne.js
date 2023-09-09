$(document).ready(function() {
	const urlParams = new URL(location.href).searchParams;
	const msg = urlParams.get("msg");
	if (msg != null) {
		Swal.fire({
			icon: 'success',
			title: msg,
			showConfirmButton: false,
			timer: 1000
		});
	}
	
		// 삭제(게시글) 버튼 클릭 시 
		$("#removeBtn").click(function(e) {
			e.preventDefault(); // 기본 동작 막기
   			e.stopPropagation(); // 이벤트 버블링 막기
   			
		    Swal.fire({
	        title: '게시글을 삭제하시겠습니까?',
	        icon: 'warning',
	        showCancelButton: true,
	        confirmButtonColor: '#8BC541',
        	cancelButtonColor: '#888',
	        confirmButtonText: '확인',
	        cancelButtonText: '취소'
		    }).then((result) => {
		        if (result.isConfirmed) {						
		            window.location.href = $("#removeBtn").attr('href');
		         }
		    });
			
		});
	
			
		 // 입력 버튼 클릭 시 
        $("#addCommentBtn").click(function() {
        	const boardNo = $("#boardNo").val();
            const empNo = $("#empNo").val();
            const category = $("#category").val();
            // const commentGroupNo = $("#commentGroupNo").val();
            const commentContent = $("#commentContent").val();
            
            if (commentContent.trim() === "") {
                // alert("댓글을 입력해주세요.");
                Swal.fire({
					icon: 'warning',
					title: '댓글을 입력해주세요.',
					showConfirmButton: false,
					timer: 1000
				});
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
                		commentContent: commentContent
                	}, 
                	 success: function(response) {
                         if (response === "success") {
                        	 // alert("댓글이 등록되었습니다.");
                        	  Swal.fire({
								icon: 'success',
								title: '댓글이 등록되었습니다.',
								showConfirmButton: false,
								timer: 1000
							});
                             // 새 댓글 업데이트 로직
                             // 예: $("#commentSection").append(...);
                        	 $("#commentContent").val("");
                        	 
                        	 console.log("댓글 등록 완료");
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

        // 등록 버튼 클릭 시 답글 등록
        $(".add-reply-btn").click(function() {
            const replyForm = $(this).closest(".reply-form");
            const boardNo = replyForm.find(".boardNo2").val();
            const empNo = replyForm.find(".empNo2").val();
            const category = replyForm.find(".category2").val();
            const parentCommentNo = replyForm.find(".parentCommentNo").val();
            const commentContent = replyForm.find(".reply-content").val();
            
            if (commentContent.trim() === "") {
                // alert("답글을 입력해주세요.");
                 Swal.fire({
					icon: 'warning',
					title: '답글을 입력해주세요.',
					showConfirmButton: false,
					timer: 1000
				});
                replyForm.find(".reply-content").focus();
            } else {
                // replyForm.submit();
              
                $.ajax({
                	type: "POST", 
                	url: "/JoinTree/comment/addReply",
                	data: {
                		boardNo: boardNo,
                		empNo: empNo,
                		category: category,
                		parentCommentNo: parentCommentNo,
                		commentContent: commentContent
                	}, 
                	success: function(response) {
                		if (response === "success") {
                			// alert("답글이 등록되었습니다.");
                			 Swal.fire({
								icon: 'success',
								title: '답글이 등록되었습니다.',
								showConfirmButton: false,
								timer: 1000
							});
			                			
                			console.log("답글 등록 완료");
                			event.preventDefault();
                			 $("#commentSection").load(location.href + " #commentSection>*", function() {
                                 // 이벤트 핸들러를 다시 바인딩합니다
                                 bindEventHandlers();
                             });
            		} else {
                			alert("답글 추가 실패");
                		}
                	}, 
                	error: function() {
                		alert("서버 오류 발생");
                	}
                });
              
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
           
            // 등록 버튼 클릭 시 답글 등록
            $(".add-reply-btn").click(function() {
                const replyForm = $(this).closest(".reply-form");
                const boardNo = replyForm.find(".boardNo2").val();
                const empNo = replyForm.find(".empNo2").val();
                const category = replyForm.find(".category2").val();
                const parentCommentNo = replyForm.find(".parentCommentNo").val();
                const commentContent = replyForm.find(".reply-content").val();
                
                if (commentContent.trim() === "") {
                    // alert("답글을 입력해주세요.");
                    Swal.fire({
						icon: 'warning',
						title: '답글을 입력해주세요.',
						showConfirmButton: false,
						timer: 1000
					});
                    replyForm.find(".reply-content").focus();
                } else {
                    // replyForm.submit();
                  
                    $.ajax({
                    	type: "POST", 
                    	url: "/JoinTree/comment/addReply",
                    	data: {
                    		boardNo: boardNo,
                    		empNo: empNo,
                    		category: category,
                    		parentCommentNo: parentCommentNo,
                    		commentContent: commentContent
                    	}, 
                    	success: function(response) {
                    		if (response === "success") {
                    			// alert("답글이 등록되었습니다.");
                    			Swal.fire({
									icon: 'success',
									title: '답글이 등록되었습니다.',
									showConfirmButton: false,
									timer: 1000
								});
                    			
                    			console.log("답글 등록 완료");
                    			event.preventDefault();
                    			 $("#commentSection").load(location.href + " #commentSection>*", function() {
                                     // 이벤트 핸들러를 다시 바인딩합니다
                                     bindEventHandlers();
                                 });
                		} else {
                    			alert("답글 추가 실패");
                    		}
                    	}, 
                    	error: function() {
                    		alert("서버 오류 발생");
                    	}
                    });
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
                        // alert("삭제되었습니다.");
                        Swal.fire({
							icon: 'success',
							title: '삭제되었습니다.',
							showConfirmButton: false,
							timer: 1000
						});
                    	
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
        });
});
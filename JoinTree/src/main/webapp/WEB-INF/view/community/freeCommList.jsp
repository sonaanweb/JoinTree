<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<!-- header -->
	<jsp:include page="/WEB-INF/view/inc/header.jsp"/> 
		<script>
		$(document).ready(function() {
			let currentPage = 1; // 초기 페이지 설정
            let category = "B0103"; // 초기 카테고리 설정
            
		    // 페이지 로딩 시 초기 데이터 로드
		    loadFreeCommList(currentPage, category, "", ""); // 초기 데이터 로드
		    
		    
		    // searchBoardPinnedListResults();
		    // searchBoardListResults();
		    
		    // 페이지 내비게이션 수정 함수
		    function updatePagination(currentPage, startPage, endPage, lastPage) {
		    	let pagination = $("#pagination");
		    	pagination.empty();
		    	
		    	// 이전 페이지 버튼
		    	if (startPage > 1) {
		    		let prevButton = $('<button type="button" class="btn btn-success">').text('이전');
		            prevButton.click(function() {
		                goToPage(startPage - 1);
		            });
		            pagination.append(prevButton);
		    	}
		    	
		    	// 페이지 버튼 생성
		    	for (let i = startPage; i <= endPage; i++){
					const page = i;
					let pageButton = $('<button type="button" class="btn btn-success">').text(i);
			        
				  // 현재 페이지일 때 'selected-page' 클래스 추가
			        if (page === currentPage) {
			            // pageButton.addClass('selected-page');
			        	pageButton.addClass('selected-page');
       					pageButton.prop('disabled', true); // 현재 페이지 버튼 비활성화
			        }
				  
			     	// 추가할 클래스를 여기에 추가
			        pageButton.addClass('btn btn-success');
					
					pageButton.click(function(){
			        	goToPage(page);
			        });
					 
			        pagination.append(pageButton);
				}
		    	
				// 다음 페이지 버튼
				if (endPage < lastPage){
					let nextButton = $('<button type="button" class="btn btn-success">').text('다음');
		            nextButton.click(function() {
		                goToPage(endPage + 1);
		            });
		            pagination.append(nextButton);
				}
		    }

		    function loadFreeCommList(currentPage, category, searchOption, searchText) {
                $.ajax({
                    type: "GET",
                    url: "/JoinTree/community/freeCommListData",
                    data: {
                        currentPage: currentPage,
                        category: category,
                        searchOption: searchOption,
                        searchText: searchText
                    },
                    success: function(data) {
                        // 성공 시 데이터를 이용해 페이지 업데이트
                        updatePage(data);
                        
                    },
                    error: function() {
                        console.log('loadFreeCommListError');
                        alert("서버 오류 발생. 관리자에게 문의해주세요.");
                    }
                });
            }
		  
		    
			// updatePinnedComm 함수 추가
		    function updatePinnedComm(pinnedCommList) {
		        let thead = $("#pinnedList");
		        thead.empty();
		        
		     	// 헤더 추가
		        let headerRow = $("<tr>");
		        headerRow.append("<th>번호</th>");
		        headerRow.append("<th>제목</th>");
		        headerRow.append("<th>작성자</th>");
		        headerRow.append("<th>작성일</th>");
		        headerRow.append("<th>조회수</th>"); // 헤더를 추가하는 부분
		        thead.append(headerRow);

		        $.each(pinnedCommList, function(index, pinnedComm) {
		            var row = $("<tr>");
		            row.append("<td width='10%'>" + pinnedComm.boardNo + "</td>");
		            var titleCell = $("<td width='40%'>");
		            var titleLink = $("<a>").attr("href", "/JoinTree/community/freeCommList/freeCommOne?boardNo=" + pinnedComm.boardNo);
		            if (pinnedComm.commentCnt > 0) {
		                titleLink.append("<span style='color:red;'>[공지] " + pinnedComm.boardTitle + " [" + pinnedComm.commentCnt + "]</span>");
		            } else {
		                titleLink.append("<span style='color:red;'>[공지] " + pinnedComm.boardTitle + "</span>");
		            }
		            titleCell.append(titleLink);
		            row.append(titleCell);
		            row.append("<td width='20%'>" + pinnedComm.empName + "</td>");
		            row.append("<td width='15%'>" + pinnedComm.createdate + "</td>");
		            row.append("<td width='15%'>" + pinnedComm.boardCount + "</td>");
		            thead.append(row);
		        });
		    }
		    
		    function updatePage(data) {
                // 상단고정 게시글 업데이트
                updatePinnedComm(data.pinnedCommList);

                // 게시글 목록 업데이트
                let tbody = $("#commList");
                tbody.empty(); // 새로운 데이터를 가져오기 전 기존 데이터 삭제 
                $.each(data.commList, function(index, comm) {
                    var row = $("<tr>");
                    row.append("<td width='10%'>" + comm.boardNo + "</td>");
                    var titleCell = $("<td width='40%'>");
                    var titleLink = $("<a>").attr("href", "/JoinTree/community/freeCommList/freeCommOne?boardNo=" + comm.boardNo);
                    if (comm.commentCnt > 0) {
                        titleLink.append("<span>" + comm.boardTitle + " [" + comm.commentCnt + "]</span>");
                    } else {
                        titleLink.append("<span>" + comm.boardTitle + "</span>");
                    }
                    titleCell.append(titleLink);
                    row.append(titleCell);
                    row.append("<td width='20%'>" + comm.empName + "</td>");
                    row.append("<td width='15%'>" + comm.createdate + "</td>");
                    row.append("<td width='15%'>" + comm.boardCount + "</td>");
                    tbody.append(row);
                });
                
            	// 페이지 내비게이션 업데이트
             	updatePagination(data.currentPage, data.startPage, data.endPage, data.lastPage);
		    }
		    

            // 검색 버튼 클릭 이벤트 처리
            $("#searchBtn").on("click", function() {
                let selectedOption = $("#searchOption").val();
                let searchText = $("#searchText").val();
                
                // 검색 시 currentPage 초기화
                currentPage = 1;
                
                loadFreeCommList(currentPage, category, selectedOption, searchText);
            });
            
            // 페이지 이동 함수
            function goToPage(page) {
            	// 검색 및 페이지 데이터 수정 함수
            	// searchCommListResults(currentPage);
            	// currentPage = page;
            	// loadFreeCommList(currentPage, category, "", ""); 
            	loadFreeCommList(page, category, $("#searchOption").val(), $("#searchText").val()); // 이전 검색 조건을 그대로 유지하며 데이터 로드
            }
            
            
		});


		</script>
		<style>
			.selected-page {
			    font-weight: bold;
			    pointer-events: none; /* 버튼 클릭 불가 */
			}
		</style>

		<div class="container-fluid page-body-wrapper">
		<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
			<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
				<h1>자유 게시판</h1>
	
				<div>
					<a href="/JoinTree/community/freeCommList/addFreeComm">게시글 작성</a>
				</div>
			
				<!-- 검색 폼  -->
				<form>
				    <select name="searchOption" id="searchOption">
				        <option value="board_title">제목</option>
				        <option value="board_content">내용</option>
				        <option value="board_title_content">제목+내용</option>
				    </select>
				    <input type="text" name="searchText" id="searchText" placeholder="검색어를 입력하세요.">
				    <button type="button" id="searchBtn">검색</button>
				</form>
					
				<table border="1">
				    <thead id="pinnedList">
				    </thead>
				    <tbody id="commList">
				        
				    </tbody>
				</table>
				<br>
				
				<!-- 페이지 내비게이션  -->
				<div id="pagination" class="btn-group"></div>
		</div>
	</div>
</html>
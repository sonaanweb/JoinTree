<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<!-- header -->
	<jsp:include page="/WEB-INF/view/inc/header.jsp"/> 
	<style>
		.selected-page {
		    font-weight: bold;
		    background-color: #D4F4FA;
		    pointer-events: none; /* 버튼 클릭 불가 */
		}
		
		a {
			color:#000000;
			text-decoration: none;
		}
	
		a:hover {
			color:#003399;
			text-decoration: none; 
		}
		
		a.text-danger.font-weight-bold:hover{
		color:#003399 !important;
		text-decoration: none;
		}	
	</style>
	<script src="/JoinTree/resource/js/community/freeCommList.js"></script>


	<div class="container-fluid page-body-wrapper">
	<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
	<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
		<!-- 게시글 검색 폼 -->
	    <div class="col-lg-12 text-right">
			<form class="form-inline justify-content-end">
				<div class="input-group-append">
				    <select name="searchOption" id="searchOption" class="form-control">
				        <option class="dropdown-item" value="board_title">제목</option>
				        <option class="dropdown-item" value="board_content">내용</option>
				        <option class="dropdown-item" value="board_title_content">제목+내용</option>
				    </select>
			    </div>
		    
		    	<input type="text" name="searchText" id="searchText" placeholder="검색어를 입력하세요." class="form-control">
			    <div class="input-group-append">
            		<button class="btn btn-sm btn-success" type="button" id="searchBtn">검색</button>
           		</div>
			</form><br>
		</div>
		<div class="col-lg-12 grid-margin stretch-card">
        	<div class="card">
              	<div class="card-body">
					<h3 class="font-weight-bold">자유 게시판</h3>
					<hr>
					<div class="text-right">
						<a href="/JoinTree/community/freeCommList/addFreeComm" class="btn btn-success btn-sm">게시글 작성</a>
					</div><br>

					<table class="table table-bordered">
					    <thead id="pinnedList">
					    </thead>
					    <tbody id="commList">
					        
					    </tbody>
					</table>
					<br>
						
						<!-- 페이지 내비게이션  -->
						<div id="pagination" class="paging center pagination"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- footer -->
	<jsp:include page="/WEB-INF/view/inc/footer.jsp"/>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<!-- header -->
	<jsp:include page="/WEB-INF/view/inc/header.jsp"/> 
	<script src="/JoinTree/resource/js/community/freeCommList.js"></script>
	<style>
		.selected-page {
		    font-weight: bold;
		    pointer-events: none; /* 버튼 클릭 불가 */
		}
		
		.selected-title:hover {
	      cursor: pointer;
	      /* color: #050099 */
	   }
		
	</style>

	<div class="container-fluid page-body-wrapper">
	<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
		<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
			<div class="col-lg-12 grid-margin stretch-card">
	        	<div class="card">
	              	<div class="card-body">
						<h1>자유 게시판</h1><br>
						<div>
							<a href="/JoinTree/community/freeCommList/addFreeComm" class="btn btn-success btn-sm">게시글 작성</a>
						</div><br>
						<!-- 검색 폼  -->
		<!-- 			    <div class="input-group-prepend">
                        	<button class="btn btn-sm btn-outline-primary dropdown-toggle" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Dropdown</button>
	                        <div class="dropdown-menu">
	                          <a class="dropdown-item" href="#">Action</a>
	                          <a class="dropdown-item" href="#">Another action</a>
	                          <a class="dropdown-item" href="#">Something else here</a>
	                          <div role="separator" class="dropdown-divider"></div>
	                          <a class="dropdown-item" href="#">Separated link</a>
	                        </div>
                        </div> -->
						<form class="form-inline">
							<div class="input-group-append">
							    <select name="searchOption" id="searchOption" class="btn btn-sm btn-outline-success dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
							        <!-- <option value="" disabled selected>선택하세요</option> -->
							        <option class="dropdown-item" value="board_title">제목</option>
							        <option class="dropdown-item" value="board_content">내용</option>
							        <option class="dropdown-item" value="board_title_content">제목+내용</option>
							    </select>
						    </div>
					    
					    	<input type="text" name="searchText" id="searchText" placeholder="검색어를 입력하세요." class="form-control">
						    <div class="input-group-append">
                       			<button class="btn btn-sm btn-success" type="button" id="searchBtn">검색</button>
                      		</div>
                      		
						    <!-- <button type="button" id="searchBtn">검색</button> -->
						</form><br>
							
						<table class="table table-bordered">
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
			</div>
		</div>
	</div>
</html>
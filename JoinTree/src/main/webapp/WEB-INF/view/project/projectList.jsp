<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<!-- header -->
	<jsp:include page="/WEB-INF/view/inc/header.jsp"/> 
	<script src="/JoinTree/resource/js/project/projectList.js"></script>
	<!-- 필수 요소-->
	<div class="container-fluid page-body-wrapper">
		<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
			<div class="content-wrapper project"> <!-- 컨텐츠부분 wrapper -->
			<!--  컨텐츠 -->
				<!-- 프로젝트 리스트 -->
				<div class="warpper">
					<!-- 타이틀, 이름 검색창 -->
					<div class="input-group">
					
						<input type="date" class="form-control margin10" id="startDate"><p class="margin10">~</p><input type="date" class="form-control margin10" id="endDate">
						
						<input type="text" class="form-control margin10" id="searchName" name="searchName" placeholder="프로젝트명 / 담당자이름으로 검색가능">
						<button type="button" id="searchBtn" class="btn btn-success btn-sm margin10">검색</button>
					
					</div>
					<div>
					</div>
					<!-- 프로젝트 라디오 -->
					<div>
						<input type="radio" name="projectCate" value="all" checked>전체 프로젝트
						<input type="radio" name="projectCate" value="participating">참여중인 프로젝트
						<input type="radio" name="projectCate" value="completed">종료된 프로젝트
					</div>
					<div>
						<h1 id="projectCategory">전체 프로젝트</h1>
						<button type="button" id="addProjectBtn" class="btn btn-success">프로젝트 추가</button>
					</div>
					<div class="wrapper" id="projectData">
						<!-- 프로젝트 카드 -->
					</div>
				</div>
				<!-- 페이징 -->
				<div class="paging center pagination" id="paging">
						<!-- 페이징 버튼이 표시되는 부분 -->
				</div>
			</div>
	</div>
	<!-- footer -->
	<jsp:include page="/WEB-INF/view/inc/footer.jsp"/>
	
	<!-- 프로젝트 추가 모달 -->
	<div class="modal" id="addProject" tabindex="-1">
		<div class="modal-dialog">
			<div class="modal-content project-modal">
				<div class="modal-header">
					<h5 class="modal-title">프로젝트 추가</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
					
				<div class="modal-body">
					<div>
						담당자 : <input type="text" readonly="readonly" value="${empName}" data-empno="${loginAccount.empNo}" id="projectHost">
					</div>
					<div>
						프로젝트명 : <input type="text" id="projectName">
					</div>
					<div class="wrapper">
						카드지정색 : 
								<input type="radio" class="projectColor" name="projectColor" value="#8AE6C5"> <div class="color"></div>
								<input type="radio" class="projectColor" name="projectColor" value="#EDC6B1"> <div class="color" style="background-color: #EDC6B1"></div>
								<input type="radio" class="projectColor" name="projectColor" value="#EDE8AB"> <div class="color" style="background-color: #EDE8AB"></div>
								<input type="radio" class="projectColor" name="projectColor" value="#8CA8BF"> <div class="color" style="background-color: #8CA8BF"></div>
								<input type="radio" class="projectColor" name="projectColor" value="#D9CCCE"> <div class="color" style="background-color: #D9CCCE"></div>
					</div>
					<div>프로젝트 시작일 : <input type="date" id="projectStartDate"></div>
					<div>프로젝트 종료일 : <input type="date" id="projectEndDate"></div>
					<div>프로젝트 설명 : <input type="text" id="projectContent"></div>
					<div>
						<button type="button" id="addProjectSubmitBtn" class="btn btn-success">프로젝트 추가</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<!-- header -->
	<jsp:include page="/WEB-INF/view/inc/header.jsp"/> 
	<!-- projectList js파일 -->
	<script src="/JoinTree/resource/js/project/projectList.js"></script>
	<!-- 필수 요소-->
	<div class="container-fluid page-body-wrapper">
		<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
			<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
			<!--  컨텐츠 -->
				<!-- 프로젝트 리스트 -->
				<div class="project">
					<!-- 타이틀, 이름 검색창 -->
					<div class="card grid-margin">
						<div class="card-body">
							<div class="input-group">
								<input type="date" class="form-control margin10" id="startDate"><p class="margin10">~</p><input type="date" class="form-control margin10" id="endDate">
								
								<input type="text" class="form-control margin10" id="searchName" name="searchName" placeholder="프로젝트명 / 담당자이름으로 검색가능">
								<button type="button" id="searchBtn" class="btn btn-success btn-sm margin10">검색</button>
							</div>
						</div>
					</div>
					<div class="card">
						<div class="card-body">
							<button type="button" id="addProjectBtn" class="btn btn-success floatR">프로젝트 추가</button>
							<!-- 프로젝트 라디오 -->
							<div class="wrapper">
								<div class="form-check form-check-success">
									<label class="form-check-label">
										<input type="radio" class="form-check-input" name="projectCate" value="all" checked>전체 프로젝트 
									</label>
								</div>
								<div class="form-check margin-left10 form-check-success">
									<label class="form-check-label">
										<input type="radio" class="form-check-input" name="projectCate" value="participating">참여중인 프로젝트 
									</label>
								</div>
								<div class="form-check margin-left10 form-check-success">
									<label class="form-check-label">
										<input type="radio" class="form-check-input" name="projectCate" value="completed">종료된 프로젝트 
									</label>
								</div>
							</div>
							<h1 id="projectCategory" class="">전체 프로젝트 </h1>
							<div class="wrapper projectData" id="projectData">
								<!-- 프로젝트 카드 -->
							</div>
						<!-- 페이징 -->
						<div class="center pagination" id="paging">
								<!-- 페이징 버튼이 표시되는 부분 -->
						</div>
						</div>
					</div>	
				</div>
			</div>
	</div>
	<!-- footer -->
	<jsp:include page="/WEB-INF/view/inc/footer.jsp"/>
	
	<!-- 프로젝트 추가 모달 -->
	<div class="modal fade" id="addProject" tabindex="-1">
		<div class="modal-dialog">
			<div class="modal-content project-modal">
				<div class="modal-header">
					<h5 class="modal-title"><b>프로젝트 추가</b></h5>
					<button type="button" class="btn btn-close" data-bs-dismiss="modal" aria-label="Close">
						<span>×</span>
					</button>
				</div>
					
				<div class="modal-body">
					<div class="margin-top20">
						<b>담당자</b><input type="text" class="form-control" readonly="readonly" value="${empName}" data-empno="${loginAccount.empNo}" id="projectHost">
					</div>
					<div class="margin-top20">
						<b>프로젝트명</b> <input type="text" class="form-control" id="projectName">
					</div>
					<div class="margin-top20">
						<b>카드지정색</b>
						<div class="wrapper">
								<input type="radio" class="projectColor" name="projectColor" value="#8AE6C5"> <span class="color"></span>
								<input type="radio" class="projectColor" name="projectColor" value="#EDC6B1"> <span class="color" style="background-color: #EDC6B1"></span>
								<input type="radio" class="projectColor" name="projectColor" value="#EDE8AB"> <span class="color" style="background-color: #EDE8AB"></span>
								<input type="radio" class="projectColor" name="projectColor" value="#8CA8BF"> <span class="color" style="background-color: #8CA8BF"></span>
								<input type="radio" class="projectColor" name="projectColor" value="#D9CCCE"> <span class="color" style="background-color: #D9CCCE"></span>
						</div>
					</div>
					<div class="margin-top20">
						<b>프로젝트 시작일</b>
						<input type="date"  class="form-control" id="projectStartDate">
					</div>
					<div class="margin-top20">
						<b>프로젝트 종료일</b>
						<input type="date"  class="form-control" id="projectEndDate">
					</div>
					<div class="margin-top20">
						<b>프로젝트 설명</b>
						<textarea id="projectContent" class="form-control"></textarea>
					</div>
					<div class="margin-top20 right">
						<button type="button" id="addProjectSubmitBtn" class="btn btn-success">프로젝트 추가</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</html>
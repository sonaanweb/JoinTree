<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<!-- header -->
	<jsp:include page="/WEB-INF/view/inc/header.jsp"/> 
	<!-- jQuery 트리뷰 및 쿠키 라이브러리 -->
	<script src="/JoinTree/resource/lib/jquery.cookie.js" type="text/javascript"></script>
	<script src="/JoinTree/resource/lib/jquery.treeview.js" type="text/javascript"></script>
	
	<!-- 트리뷰 스타일 시트 -->
	<link rel="stylesheet" href="/JoinTree/resource/jquery.treeview.css">
	
	<!-- projectOne js파일 -->
	<script src="/JoinTree/resource/js/project/projectOne.js"></script>

	<!-- 필수 요소-->
	<div class="container-fluid page-body-wrapper">
		<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
			<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
				<div class="card">
					<div class="projectOne card-body">
						<!-- 프로젝트 상세정보 출력 -->
					</div>
				</div>
				<div>
					<button id="addPjTaskBtn" class="btn btn-success btn-sm margin-top20">작업추가</button>
				</div>
				<div class="projectTaskListAll col-md-4">
					
					<div class="card margin-top20">
						<div class="card-body">
							<h4 class="">미완료</h4>
							<div class="projectTaskList1 wrapper ">
								<!-- 프로젝트 미완료된 작업 리스트 출력 -->
							</div>
							
							<div class="line"></div>
							<h4>완료</h4>
							<div class="projectTaskList2 wrapper">
								<!-- 프로젝트 완료된 작업 리스트 출력 -->
							</div>
						</div>
					</div>
					<div>
						<button id="removeProjectBtn" class="btn btn-success btn-sm margin-top20">프로젝트 삭제</button>
					</div>
				</div>
				<div class="col-md-8 project-task-comment">
					<div class="projectTask">
						<!-- 프로젝트 작업 정보 출력 -->
					</div>
					<div class="taskComment">
						<!-- 프로젝트 작업 댓글 정보 출력 -->
						
					</div>
				</div>
				
			</div>
	</div>
	
	<!-- footer -->
	<jsp:include page="/WEB-INF/view/inc/footer.jsp"/>
	
	<!-- 사원 트리 리스트 모달 -->
	<div class="modal fade" id="projectMemberModal" tabindex="-1">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">JOINTREE</h5>
					<button type="button" class="btn btn-close" data-bs-dismiss="modal" aria-label="Close">
						<span>×</span>
					</button>
				</div>
				
				<div class="modal-body">
					<ul id="addMemberList">
						<c:forEach var="dept" items="${deptList}">
							<li>
								<span class="empTree folder code" data-dept="${dept.code}" data-deptname="${dept.codeName}">${dept.codeName}<button class="memberAllClick btn btn-sm btn-success">전체선택</button></span>
								<ul>
									<!-- 여기에 데이터를 추가하는 부분 -->
								</ul>
							</li>
						</c:forEach>
					</ul>
				</div>
			</div>
		</div>
	</div>
	<!-- 프로젝트 작업추가 모달 -->
	<div class="modal fade" id="addProjectTaskModal" tabindex="-1">
		<div class="modal-dialog">
			<div class="modal-content project-modal">
				<div class="modal-header">
					<h5 class="modal-title">프로젝트 작업 추가</h5>
					<button type="button" class="btn btn-close" data-bs-dismiss="modal" aria-label="Close">
						<span>×</span>
					</button>
				</div>
					
				<div class="modal-body">
					<div class="margin-top20">
						<b>담당자</b>
						<input type="text" readonly="readonly" class="form-control" value="${empName}" data-empno="${loginAccount.empNo}" id="teskHost">
					</div>
					<div class="margin-top20">
						<b>작업명</b>
						<input type="text" class="form-control" id="taskTitle">
					</div>
					<div class="margin-top20">
						<b>작업 시작일 </b>
						<input type="date" class="form-control" id="taskStartDate">
					</div>
					<div class="margin-top20">
						<b>작업 종료일</b>
						<input type="date" class="form-control" id="taskEndDate">
					</div>
					<div class="margin-top20">
						<b>작업 설명</b>
						<textarea id="taskContent" class="form-control"></textarea>
					</div>
					
					<div class="margin-top20 taskFile">
						<b>첨부파일</b>
						<input type="file" class="form-control " id="taskOriginFilename">
					</div>						
					<div class="margin-top20">
						<button type="button" id="addTaskSubmitBtn" class="btn btn-success">작업 추가</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</html>
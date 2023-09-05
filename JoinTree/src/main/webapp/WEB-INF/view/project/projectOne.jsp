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
				<a href="/JoinTree/project/projectList">돌아가기</a>
				<div class="projectOne">
					<!-- 프로젝트 상세정보 출력 -->
				</div>
					<div class="projectTaskListAll col-md-4">
						<div class="card">
							<div>미완료</div>
							<div class="projectTaskList1 wrapper card-body">
								<!-- 프로젝트 미완료된 작업 리스트 출력 -->
							</div>
							<div class="line"></div>
							<div>완료</div>
							<div class="projectTaskList2 wrapper card-body">
								<!-- 프로젝트 완료된 작업 리스트 출력 -->
							</div>
						</div>
						<div>
							<button id="removeProjectBtn" class="btn btn-success btn-sm margin10">프로젝트 삭제</button>
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
	<div class="modal" id="projectMemberModal" tabindex="-1">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">JOINTREE</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				
				<div class="modal-body">
					<ul id="addMemberList">
						<c:forEach var="dept" items="${deptList}">
							<li>
								<span class="empTree folder code" data-dept="${dept.code}" data-deptname="${dept.codeName}">${dept.codeName}<button class="memberAllClick">전체선택</button></span>
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
	<div class="modal" id="addProjectTaskModal" tabindex="-1">
		<div class="modal-dialog">
			<div class="modal-content project-modal">
				<div class="modal-header">
					<h5 class="modal-title">프로젝트 작업 추가</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
					
				<div class="modal-body">
					<div>
						담당자 : <input type="text" readonly="readonly" value="${empName}" data-empno="${loginAccount.empNo}" id="teskHost">
					</div>
					<div>
						작업명 : <input type="text" id="taskTitle">
					</div>
					<div>작업 시작일 : <input type="date" id="taskStartDate"></div>
					<div>작업 종료일 : <input type="date" id="taskEndDate"></div>
					<div>작업 설명 : <textarea id="taskContent"></textarea></div>
					<div>첨부파일 :<input type="file" id="taskOriginFilename"></div>
					<div>
						<button type="button" id="addTaskSubmitBtn" class="btn btn-success">작업 추가</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</html>
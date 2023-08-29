<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<!-- header -->
	<jsp:include page="/WEB-INF/view/inc/header.jsp"/> 
	<script>
	$(document).ready(function() {
		/* 페이징 */
			const projectDataElement = $('#projectData'); // 프로젝트 목록을 담는 요소
			const pagingElement = $('#paging'); // 페이징 버튼 컨테이너
			let selectedTab = 'all'; // 선택된 탭을 나타내는 변수
			
			const tabs = { // 페이징 관리
				all: {
					startRow: 0,
					currentPage: 1,
					totalItems: 0,
					totalPages: 0
				},
				participating: {
					startRow: 0,
					currentPage: 1,
					totalItems: 0,
					totalPages: 0
				},
				completed: {
					startRow: 0,
					currentPage: 1,
					totalItems: 0,
					totalPages: 0
				}
			};
			
			const rowPerPage = 8; // 한 페이지당 수
			
			fetchProjectListAndUpdate(selectedTab);
		
			// 버튼 클릭 시 이벤트
			function attachPageButtonEventHandlers() {
				$('.page-button').click(function() {
					const clickedTab = $(this).data('tab');
					const pageNum = $(this).data('page');
					
					tabs[clickedTab].startRow = (pageNum - 1) * rowPerPage;
					
					fetchProjectListAndUpdate(clickedTab); 	
				});
			}
			
			// 버튼 생성 및 삭제 -> 버튼 업데이트
			function updatePagingButtons(selectedTab) {
					//console.log("selectedTab",selectedTab);
				// tab은 tabs에서 선택된 탭
				const tab = tabs[selectedTab];
				const buttons = [];
					//console.log("tab.totalPages",tab.totalPages);
				// 전체페이지가 1과 같거나 크면 
				if (tab.totalPages >= 1) {
					for (let i = 1; i <= tab.totalPages; i++) {
						buttons.push('<button class="page-button" data-tab="' + selectedTab + '" data-page="' + i + '">' + i + '</button>');
					}
				}
				pagingElement.html(buttons.join(' '));
			
				// 새로운 클릭 이벤트 핸들러 추가
				attachPageButtonEventHandlers();
			}
			
			// 페이징 계산
			function calculateTotalPages(totalItems) {
				return Math.ceil(totalItems / rowPerPage);
			}
		/* 페이징 끝 */
		/* 라디오 변경에 따른 변화 */	
			// 라디오 탭변경
			function switchTab(selectedTab) {
				const tab = tabs[selectedTab];
					//console.log("tab",tabs[selectedTab]);
				
				fetchProjectListAndUpdate(selectedTab);
				
			};
			
			// 프로젝트 목록을 가져와서 업데이트하는 함수
			function fetchProjectListAndUpdate(selectedTab) {
				const tab = tabs[selectedTab];
				const selectedValue = $('input[name="projectCate"]:checked').val();
					//console.log("selectedValue",selectedValue);
				const h1Element = $('#projectCategory');
				const searchName = $('#searchName').val();
				const startDate = $('#startDate').val();
				const endDate = $('#endDate').val();
			
				if (selectedValue === 'all') {
					$.ajax({
						url: '/JoinTree/project/projectListAll',
						type: 'GET',
						data: { 
							startRow: tab.startRow,
							rowPerPage: rowPerPage,
							searchName : searchName,
							startDate: startDate,
							endDate : endDate
						},
						success: function(response){
							//console.log("response",response);
							const totalCnt = response.totalCnt;
							//console.log("totalCnt",totalCnt);
							const projectList = response.projectList; // 실제 프로젝트 리스트 데이터
							//console.log("projectList",projectList);

							projectDataElement.empty(); // 기존 내용을 지우기
							
							projectList.forEach(function(project) {
								console.log("project",project);
								const html = 
									'<div class="col-md-3 stretch-card grid-margin">'+
										'<div class="card" style="background-color: ' + project.projectColor + ';">'+
											'<div class="card-body center" data-pjno=' + project.projectNo+'>'+
												'<div>' + project.projectName + '</div>'+
												'<div>' + project.empCnt + '명 참여중</div>'+
											'</div>'+
										'</div>'+
									'</div>';
									//console.log("project.projectColor",project.projectColor);
								 projectDataElement.append(html);
							});
							
							// 페이징 버튼 업데이트
							tab.totalItems = totalCnt; // 총 프로젝트 수
								// console.log("Åll tab.totalItems",tab.totalItems);
							tab.totalPages = calculateTotalPages(tab.totalItems); // 총 페이지 수
								// console.log("Åll tab.totalPages",tab.totalPages);
							updatePagingButtons(selectedTab);
						},
						error: function() {
							projectDataElement.text('데이터를 불러오는 데 실패했습니다.');
						}
					});
				} else if (selectedValue === 'participating') {
					$.ajax({
						url: '/JoinTree/project/personalProjectList',
						type: 'GET',
						data: { 
							startRow: tab.startRow,
							rowPerPage: rowPerPage,
							searchName : searchName,
							startDate : startDate,
							endDate : endDate
						},
						success: function(response) {
							//console.log("response",response);
							const personalProjectList = response.personalProjectList; // 실제 프로젝트 리스트 데이터
							//console.log("personalProjectList",personalProjectList);
						
							const projectDataElement = $('#projectData');
							projectDataElement.empty(); // 기존 내용을 지우기
							
							personalProjectList.forEach(function(project) {
								const html = 
									'<div class="col-md-3 stretch-card grid-margin">'+
										'<div class="card" style="background-color: ' + project.projectColor + ';">'+
											'<div class="card-body center">'+
												'<div data-pjNo=' + project.projectNo+'>' + project.projectName + '</div>'+
												'<div>' + project.empCnt + '명 참여중</div>'+
											'</div>'+
										'</div>'+
									'</div>';
									
								 projectDataElement.append(html);
							});
							// 페이징 버튼 업데이트
							tab.totalItems = personalProjectList.length; // 총 프로젝트 수
							// console.log("personal tab.totalItems",tab.totalItems);
							tab.totalPages = calculateTotalPages(tab.totalItems); // 총 페이지 수
							// console.log("personal tab.totalPages",tab.totalPages);

							updatePagingButtons(selectedTab);
						},
						error: function() {
							projectDataElement.text('데이터를 불러오는 데 실패했습니다.');
						}
					});
				} else if (selectedValue === 'completed') {
					$.ajax({
						url: '/JoinTree/project/endProjectList',
						type: 'GET',
						data: { 
							startRow: tab.startRow,
							rowPerPage: rowPerPage,
							searchName : searchName,
							startDate : startDate,
							endDate : endDate
						},
						success: function(response) {
							//console.log("response",response);
							const endProjectList = response.endProjectList; // 실제 프로젝트 리스트 데이터
							//console.log("endProjectList",endProjectList);

							const projectDataElement = $('#projectData');
							projectDataElement.empty(); // 기존 내용을 지우기
							
							endProjectList.forEach(function(project) {
								const html = 
									'<div class="col-md-3 stretch-card grid-margin">'+
										'<div class="card" style="background-color: ' + project.projectColor + ';">'+
											'<div class="card-body center">'+
												'<div data-pjNo=' + project.projectNo+'>' + project.projectName + '</div>'+
												'<div>' + project.empCnt + '명 참여중</div>'+
											'</div>'+
										'</div>'+
									'</div>';
									
								 projectDataElement.append(html);
							});
							// 페이징 버튼 업데이트
							tab.totalItems = endProjectList.length; // 총 프로젝트 수
							tab.totalPages = calculateTotalPages(tab.totalItems); // 총 페이지 수
							updatePagingButtons(selectedTab);
						},
						error: function() {
							projectDataElement.text('데이터를 불러오는 데 실패했습니다.');
						}
					});
				}
			};
		/* 라디오 변경에 따른 변화 끝*/		
		/* 검색 */
			$("#searchBtn").on("click",function() {
				alert("버튼클릭");
				fetchProjectListAndUpdate(selectedTab);
			});
			
			// 라디오 변경 시
			$('input[name="projectCate"]').on("change",function() {
				const tab = tabs[selectedTab];
				const selectedValue = $('input[name="projectCate"]:checked').val();
					//console.log("selectedValue",selectedValue);
				const h1Element = $('#projectCategory');
			
				if (selectedValue === 'all') {
					h1Element.text('전체 프로젝트');
					switchTab('all');
					
				} else if (selectedValue === 'participating') {
					h1Element.text('참여중인 프로젝트');
					switchTab('participating');
					
				} else if (selectedValue === 'completed') {
					h1Element.text('종료된 프로젝트');
					switchTab('completed');
						//console.log(selectedTab)
					
				}
			});
		/* 검색 끝 */	
		/* 프로젝트 추가 */
			// 프로젝트 추가 클릭 시 모달창
			$("#addProjectBtn").on("click", function() {
				$("#addProject").modal("show");
			});
			
			$("#addProjectSubmitBtn").on("click", function() {
				const empNo = ${loginAccount.empNo};
				const projectName = $("#projectName").val();
				const projectColor = $("input.projectColor:checked").val();
				const projectStartDate = $("#projectStartDate").val();
				const projectEndDate = $("#projectEndDate").val();
				const projectContent = $("#projectContent").val();
						
				console.log("empNo:", empNo);
				console.log("projectName:", projectName);
				console.log("projectColor:", projectColor);
				console.log("projectStartDate:", projectStartDate);
				console.log("projectEndDate:", projectEndDate);
				console.log("projectContent:", projectContent);
				
				if(!empNo || !projectName || !projectColor || !projectStartDate || !projectEndDate || !projectContent) {
					alert("값 넣어줘 ");
					return;
				} 
				
				$.ajax({
					url: "/JoinTree/project/addProject",
					type: "POST",
					data: {
						empNo : empNo,
						projectName : projectName,
						projectColor : projectColor,
						projectStartDate : projectStartDate,
						projectEndDate : projectEndDate,
						projectContent : projectContent,
						createId : empNo,
						updateId : empNo
					},
					success : function(response) {
						console.log("response",response);
						//alert("성공");
						$("#addProject").modal("hide");
						
						$("#projectName").val('');
						$("input.projectColor:checked").val('');
						$("#projectStartDate").val('');
						$("#projectEndDate").val('');
						$("#projectContent").val('');
						
						$.ajax({
							url: "/JoinTree/project/addProjectMember",
							type: "POST",
							data: {
								empNo : [empNo],
								projectNo: response,
								createId: empNo,
								updateId: empNo
							},
							success : function(response) {
								console.log("response",response);
								fetchProjectListAndUpdate(selectedTab);
								alert("성공");
							},
							error: function() {
								alert("다시");
							}
						});
					},
					error: function() {
						alert("다시");
					}
				});
				
			});
			
		/* 프로젝트 상세창 */
			// 프로젝트 상세창으로
			$("#projectData").on("click", '[data-pjNo]', function() {
				const projectNo = $(this).data("pjno");
				//console.log("projectNo",projectNo);
				// 프로젝트 상세창으로
				window.location.href = '/JoinTree/project/projectOne?projectNo=' + projectNo;
			});
		/* 프로젝트 상세창 끝 */
		}); // 마지막 
	</script>
	
	<!-- 필수 요소-->
	<div class="container-fluid page-body-wrapper">
		<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
			<div class="content-wrapper project"> <!-- 컨텐츠부분 wrapper -->
			<!--  컨텐츠 -->
				<!-- 프로젝트 리스트 -->
				<div class="warpper">
					<!-- 타이틀, 이름 검색창 -->
					<div class="input-group">
						<div class="input-group-prepend bg-transparent">
							<i class="input-group-text border-0 mdi mdi-magnify"></i>
						</div>
						<input type="text" class="form-control" id="searchName" name="searchName" placeholder="프로젝트명 / 담당자이름으로 검색가능">
					</div>
					<!-- 날짜 검색창 -->
					<div class="input-group">
						<div class="input-group-prepend bg-transparent">
							<i class="input-group-text border-0 mdi mdi-magnify"></i>
						</div>
						<input type="date" class="form-control" id="startDate"> ~ 
						<input type="date" class="form-control" id="endDate">
					</div>
					<div>
						<button type="button" id="searchBtn">검색</button>
					</div>
					<!-- 프로젝트 라디오 -->
					<div>
						<input type="radio" name="projectCate" value="all" checked>전체 프로젝트
						<input type="radio" name="projectCate" value="participating">참여중인 프로젝트
						<input type="radio" name="projectCate" value="completed">종료된 프로젝트
					</div>
					<div>
						<h1 id="projectCategory">전체 프로젝트</h1>
						<button type="button" id="addProjectBtn">프로젝트 추가</button>
					</div>
					<div class="wrapper" id="projectData">
						<!-- 프로젝트 카드 -->
					</div>
				</div>
				<!-- 페이징 -->
				<div class="paging center" id="paging">
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
						담당자 : <input type="text" readonly="readonly" value="${empName}" id="projectHost">
					</div>
					<div>
						프로젝트명 : <input type="text" id="projectName">
					</div>
					<div class="wrapper">
						카드지정색 : 
								<input type="radio" class="projectColor" name="projectColor" value="#B7B7B7"> <div class="color"></div>
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
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<!-- header -->
	<jsp:include page="/WEB-INF/view/inc/header.jsp"/> 
	<script>
		$(document).ready(function() {
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
			
			const rowPerPage = 6; // 한 페이지당 수
			
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
				console.log("selectedTab",selectedTab);
				// tab은 tabs에서 선택된 탭
				const tab = tabs[selectedTab];
				const buttons = [];
					console.log("tab.totalPages",tab.totalPages);
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
			
			// 스위치 탭변경
			function switchTab(selectedTab) {
				const tab = tabs[selectedTab];
					console.log("tab",tabs[selectedTab]);
				
				fetchProjectListAndUpdate(selectedTab);
				
			};
			
			function getRandomColor() {
			    const letters = "0123456789ABCDEF";
			    let color = "#";
			    for (let i = 0; i < 6; i++) {
			        color += letters[Math.floor(Math.random() * 16)];
			    }
			    return color;
			}
			// 프로젝트 목록을 가져와서 업데이트하는 함수
			function fetchProjectListAndUpdate(selectedTab) {
				const tab = tabs[selectedTab];
				const selectedValue = $('input[name="projectCate"]:checked').val();
				console.log("selectedValue",selectedValue);
				const h1Element = $('#projectCategory');
			
				if (selectedValue === 'all') {

					$.ajax({
						url: '/project/projectListAll',
						type: 'GET',
						data: { 
							startRow: tab.startRow,
							rowPerPage: rowPerPage 
						},
						success: function(response){
							console.log("response",response);
					    const totalCnt = response.totalCnt;
					    //console.log("totalCnt",totalCnt);
					    const projectList = response.projectList; // 실제 프로젝트 리스트 데이터
					    //console.log("projectList",projectList);

							projectDataElement.empty(); // 기존 내용을 지우기
							
							projectList.forEach(function(project) {
								const html = 
									'<div class="col-md-4 stretch-card grid-margin">'+
									'<div class="card" style="background-color: ' + getRandomColor() + ';">'+
											'<div class="card-body center">'+
												'<div>' + project.projectName + '</div>'+
												'<div>' + project.empCnt + '명 참여중</div>'+
											'</div>'+
										'</div>'+
									'</div>';
									
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
						url: '/project/personalProjectList',
						type: 'GET',
						data: { 
							startRow: tab.startRow,
							rowPerPage: rowPerPage 
						},
						success: function(response) {
							console.log("response",response);
						    const personalProjectList = response.personalProjectList; // 실제 프로젝트 리스트 데이터
						    console.log("personalProjectList",personalProjectList);
						    
							const projectDataElement = $('#projectData');
							projectDataElement.empty(); // 기존 내용을 지우기
							
							personalProjectList.forEach(function(project) {
								const html = 
									'<div class="col-md-4 stretch-card grid-margin">'+
									'<div class="card" style="background-color: ' + getRandomColor() + ';">'+
											'<div class="card-body center">'+
												'<div>' + project.projectName + '</div>'+
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
						url: '/project/endProjectList',
						type: 'GET',
						data: { 
							startRow: tab.startRow,
							rowPerPage: rowPerPage 
						},
						success: function(response) {
							// console.log("response",response);
							const endProjectList = response.endProjectList; // 실제 프로젝트 리스트 데이터
							console.log("endProjectList",endProjectList);

							const projectDataElement = $('#projectData');
							projectDataElement.empty(); // 기존 내용을 지우기
							
							endProjectList.forEach(function(project) {
								const html = 
									'<div class="col-md-4 stretch-card grid-margin">'+
										'<div class="card" style="background-color: #D3D3D3;">'+
											'<div class="card-body center">'+
												'<div>' + project.projectName + '</div>'+
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
			
			
			
			// 페이징 계산
			function calculateTotalPages(totalItems) {
				return Math.ceil(totalItems / rowPerPage);
			}
		
			// 라디오 변경 시
			$('input[name="projectCate"]').change(function() {
				const tab = tabs[selectedTab];
				const selectedValue = $('input[name="projectCate"]:checked').val();
				console.log("selectedValue",selectedValue);
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
					console.log(selectedTab)
					
				}
			});
		});
	</script>
	
	<!-- 필수 요소-->
	<div class="container-fluid page-body-wrapper">
		<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
			<div class="content-wrapper project"> <!-- 컨텐츠부분 wrapper -->
			<!--  컨텐츠 -->
				<!-- 프로젝트 리스트 -->
				<div class="warpper">
					<div class="input-group">
						<div class="input-group-prepend bg-transparent">
							<i class="input-group-text border-0 mdi mdi-magnify"></i>
						</div>
						<input type="text" class="form-control" placeholder="Search projects">
					</div>
					<div>
						<input type="radio" name="projectCate" value="all" checked>전체 프로젝트
						<input type="radio" name="projectCate" value="participating">참여중인 프로젝트
						<input type="radio" name="projectCate" value="completed">종료된 프로젝트
					</div>
					<div>
						<h1 id="projectCategory">전체 프로젝트</h1>
					</div>
					<div class="wrapper" id="projectData">
						<!-- 프로젝트 카드 -->
					</div>
				</div>
				<!-- 페이징 -->
				<div class="paging" id="paging">
					<!-- 페이징 버튼이 표시되는 부분 -->
				</div>
			</div>
	</div>
	<!-- footer -->
	<jsp:include page="/WEB-INF/view/inc/footer.jsp"/>
</html>
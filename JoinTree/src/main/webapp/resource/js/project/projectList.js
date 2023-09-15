/* 프로젝트 리스트 */
$(document).ready(function() {
	const loginEmpNo = $("#projectHost").data("empno");
		console.log("loginEmpNo",loginEmpNo);
	/* 페이징 */
		const projectDataElement = $('#projectData'); // 프로젝트 목록을 담는 요소
		const pagingElement = $('#paging'); // 페이징 버튼 컨테이너
		let selectedTab = 'all'; // 선택된 탭을 나타내는 변수
		let pageNum = 1; // 선택된 탭을 나타내는 변수
		
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
		
	 	updatePagingButtons(selectedTab, pageNum);
		
		// 버튼 클릭 시 이벤트
		function attachPageButtonEventHandlers() {
			// 기존의 클릭 이벤트 제거 (중복연결로 인해 같은 동작 실행 방지)
			$('.pageBtn').off('click');
	
			// 클릭 이벤트 핸들러 다시 연결
			$('.pageBtn').on('click',function() {
				const clickedTab = $(this).data('tab');
				pageNum = $(this).data('page');
				
				tabs[clickedTab].startRow = (pageNum - 1) * rowPerPage;
				
				// 페이지 버튼 클릭 시 업데이트 함수 호출
				updatePagingButtons(clickedTab, pageNum);
				
				fetchProjectListAndUpdate(clickedTab); 	
			});
		}
		
		// 버튼 생성 및 삭제 -> 버튼 업데이트
		function updatePagingButtons(selectedTab, selectedPageNum) {
			console.log("selectedPageNum2",selectedPageNum);
				//console.log("selectedTab",selectedTab);
			// tab은 tabs에서 선택된 탭
			const tab = tabs[selectedTab];
			const buttons = [];
				//console.log("tab.totalPages",tab.totalPages);
			
			// 전체페이지가 1과 같거나 크면 
			if (tab.totalPages >= 1) {
				for (let i = 1; i <= tab.totalPages; i++) {
					const activeClass = selectedPageNum === i ? ' active' : '';
					buttons.push('<div class="page-item' + activeClass + '"><button class="page-link pageBtn" data-tab="' + selectedTab + '" data-page="' + i + '">' + i + '</button></div>');
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
						endDate : endDate,
						empNo : 0
					},
					success: function(response){
						//console.log("response",response);
						const totalCnt = response.totalCnt;
						//console.log("totalCnt",totalCnt);
						const projectList = response.projectList; // 실제 프로젝트 리스트 데이터
						//console.log("projectList",projectList);

						projectDataElement.empty(); // 기존 내용을 지우기
						
						projectList.forEach(function(project) {
							//console.log("project",project);
							const html = 
								'<div class="col-md-3 stretch-card grid-margin">'+
									'<div class="card" style="background-color: ' + project.projectColor + ';">'+
										'<div class="card-body center" data-pjno=' + project.projectNo+'>'+
											'<div><b>' + project.projectName + '</b></div>'+
											'<div>' + project.projectContent + '</div>'+
											'<div class="membercnt">' + project.empCnt + '명 참여중</div>'+
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
						updatePagingButtons(selectedTab,pageNum);
					},
					error: function() {
						projectDataElement.text('데이터를 불러오는 데 실패했습니다.');
					}
				});
			} else if (selectedValue === 'participating') {
				$.ajax({
					url: '/JoinTree/project/projectListAll',
					type: 'GET',
					data: { 
						startRow: tab.startRow,
						rowPerPage: rowPerPage,
						searchName : searchName,
						startDate : startDate,
						endDate : endDate,
						projectStatus : '1',
						empNo : loginEmpNo
					},
					success: function(response) {
						//console.log("response",response);
						const totalCnt = response.totalCnt;
						console.log("totalCnt",totalCnt);
						const projectList = response.projectList; // 실제 프로젝트 리스트 데이터
						//console.log("personalProjectList",personalProjectList);
					
						const projectDataElement = $('#projectData');
						projectDataElement.empty(); // 기존 내용을 지우기
						
						projectList.forEach(function(project) {
							const html = 
								'<div class="col-md-3 stretch-card grid-margin">'+
									'<div class="card" style="background-color: ' + project.projectColor + ';">'+
										'<div class="card-body center" data-pjno=' + project.projectNo+'>'+
											'<div data-pjNo=' + project.projectNo+'>' + project.projectName + '</div>'+
											'<div>' + project.projectContent + '</div>'+
											'<div class="membercnt">' + project.empCnt + '명 참여중</div>'+
										'</div>'+
									'</div>'+
								'</div>';
								
							 projectDataElement.append(html);
						});
						// 페이징 버튼 업데이트
						tab.totalItems = totalCnt; // 총 프로젝트 수
						// console.log("personal tab.totalItems",tab.totalItems);
						tab.totalPages = calculateTotalPages(tab.totalItems); // 총 페이지 수
						// console.log("personal tab.totalPages",tab.totalPages);

						updatePagingButtons(selectedTab,pageNum);
					},
					error: function() {
						projectDataElement.text('데이터를 불러오는 데 실패했습니다.');
					}
				});
			} else if (selectedValue === 'completed') {
				$.ajax({
					url: '/JoinTree/project/projectListAll',
					type: 'GET',
					data: { 
						startRow: tab.startRow,
						rowPerPage: rowPerPage,
						searchName : searchName,
						startDate : startDate,
						endDate : endDate,
						projectStatus : '0',
						empNo : 0
					},
					success: function(response) {
						//console.log("response",response);
						const totalCnt = response.totalCnt;
						const projectList = response.projectList; // 실제 프로젝트 리스트 데이터
						//console.log("endProjectList",endProjectList);

						const projectDataElement = $('#projectData');
						projectDataElement.empty(); // 기존 내용을 지우기
						
						projectList.forEach(function(project) {
							const html = 
								'<div class="col-md-3 stretch-card grid-margin">'+
									'<div class="card" style="background-color: ' + project.projectColor + ';">'+
										'<div class="card-body center" data-pjno=' + project.projectNo+'>'+
											'<div data-pjNo=' + project.projectNo+'>' + project.projectName + '</div>'+
											'<div>' + project.projectContent + '</div>'+
											'<div class="membercnt">' + project.empCnt + '명 참여중</div>'+
										'</div>'+
									'</div>'+
								'</div>';
								
							 projectDataElement.append(html);
						});
						// 페이징 버튼 업데이트
						tab.totalItems = totalCnt; // 총 프로젝트 수
						tab.totalPages = calculateTotalPages(tab.totalItems); // 총 페이지 수
						updatePagingButtons(selectedTab,pageNum);
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
			const projectName = $("#projectName").val();
			const projectColor = $("input.projectColor:checked").val();
			const projectStartDate = $("#projectStartDate").val();
			const projectEndDate = $("#projectEndDate").val();
			const projectContent = $("#projectContent").val();
					
			console.log("projectName:", projectName);
			console.log("projectColor:", projectColor);
			console.log("projectStartDate:", projectStartDate);
			console.log("projectEndDate:", projectEndDate);
			console.log("projectContent:", projectContent);
			
			// 시작일자와 종료일자 비교 검사
			if (projectStartDate > projectEndDate) {
				$("#projectStartDate").val('');
				$("#projectEndDate").val('');
				Swal.fire(
					'Error',
					'종료일자는 시작일자보다 커야합니다.',
					'error'
				)
				return; // 수정 작업 중단
			};
			
			if(!projectName || !projectColor || !projectStartDate || !projectEndDate || !projectContent) {
				Swal.fire(
					'Error',
					'모든 값을 입력해주세요.',
					'error'
				)
				return;
			};
			
			$.ajax({
				url: "/JoinTree/project/addProject",
				type: "POST",
				data: {
					empNo : loginEmpNo,
					projectName : projectName,
					projectColor : projectColor,
					projectStartDate : projectStartDate,
					projectEndDate : projectEndDate,
					projectContent : projectContent,
					createId : loginEmpNo,
					updateId : loginEmpNo
				},
				success : function(response) {
					console.log("response",response);
					if (response === 0) {
						console.log("프로젝트 추가 실패");
						return;
					}
					//alert("성공");
					$("#addProject").modal("hide");
					Swal.fire({
							icon: 'success',
							title: '프로젝트가 추가되었습니다.',
							showConfirmButton: false,
							timer: 1000
						})
					$("#projectName").val('');
					$("input.projectColor:checked").val('');
					$("#projectStartDate").val('');
					$("#projectEndDate").val('');
					$("#projectContent").val('');
					
					$.ajax({
						url: "/JoinTree/project/addProjectMember",
						type: "POST",
						data: {
							empNo : [loginEmpNo],
							projectNo: response,
							createId: loginEmpNo,
							updateId: loginEmpNo
						},
						success : function(response) {
							console.log("response",response);
							fetchProjectListAndUpdate(selectedTab);
						},
						error: function() {
							console.log("프로젝트 멤버 추가 실패");
						}
					});
				},
				error: function() {
					console.log("프로젝트 추가 실패");
				}
			});
			
		});
		
	/* 프로젝트 상세창 */
		// 프로젝트 상세창으로
		$("#projectData").on("click", '[data-pjNo]', function() {
			const projectNo = $(this).data("pjno");
			//console.log("projectNo",projectNo);
			
			$.ajax({
				url: '/JoinTree/project/projectMemberDup',
				type: 'POST',
				data: { 	
					empNo : loginEmpNo,
					projectNo : projectNo
				},
				success: function(response) {
					console.log("response",response);
					if(response === "success") {
						// 프로젝트 상세창으로
						window.location.href = '/JoinTree/project/projectOne?projectNo=' + projectNo;
					} else {
						Swal.fire(
							'Error',
							'프로젝트 내용은 팀원이 아니면 열람할 수 없습니다.',
							'error'
						)
					}
				},
				error: function(errer) {
					console.log("팀원 확인 데이터 오류",errer);
				}
			});		
		});
	/* 프로젝트 상세창 끝 */
}); // 마지막 
	
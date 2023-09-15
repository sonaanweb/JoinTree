/**  projectOne */
$(document).ready(function() {
	/* 전역변수 */
		const urlParams = new URLSearchParams(window.location.search); // 주소창에 있는 값
		const projectNo = urlParams.get("projectNo"); // 주소창 값 중에서 프로젝트 번호
			console.log("projectNo",projectNo);		
		const loginEmpNo = $("#teskHost").data("empno");
			console.log("loginEmpNo",loginEmpNo);		
		let taskNo;
		let currentProjectName; // 현재 프로젝트 이름
		let currentProjectContent;// 현재 프로젝트 내용
		let currentProjectStartDate; // 현재 프로젝트 시작일
		let currentProjectEndDate; // 현재 프로젝트 종료일
		let taskStatus;
	/* 전역변수 끝 */
/* 프로젝트 */
	/* 프로젝트 상세정보 출력 */
		// 페이지 로딩 시 프로젝트 데이터를 가져옴
		fetchProjectData();
						
		function fetchProjectData() {
			// AJAX 요청
			$.ajax({
				type: "GET",
				url: "/JoinTree/project/projectOneInfo",
				data : {projectNo : projectNo},
				success: function(response) {
					// 맵으로 받아온 값 분해
					const project = response.project;
					const projectMemeber = response.projectMemeber;

					$(".projectOne").empty();
					$(".taskComment").empty();
					// 팀원 정보 추가
					const empNoToDel = loginEmpNo === project.empNo;
						//console.log("loginEmpNo",loginEmpNo);
						//console.log("empNoToDel",empNoToDel);
						
					// projectMemeber에 있는 요소 m을 순환하면서 아래 스펜으로 가공
					const teamMembers = projectMemeber.map(m =>
						'<div class="memberName" ' +
							'data-empno="' + m.empNo + '" ' +
							'data-name="' + m.empName + '"><p>' +
							m.empName  + ' (' + m.empNo + ')' +
						(m.empNo !== project.empNo ? 
							(empNoToDel ? '<span class="deleteMember" style="display: none;" data-empno="' + m.empNo + '">×</span>' : '') 
						: "")+
						'</p></div>'
					);
					
					// 서버로부터 받아온 데이터를 이용하여 해당 요소들에 추가
					$(".projectOne").append(
						'<div class="wrapper">' +
							'<h1><input type="text" id="projectName" value="' + project.projectName + '"readonly="readonly""></input></h1>' +
							'<div id="pjBtns">'+
								'<button id="modifyProjectBtn" class="btn btn-success btn-sm">프로젝트 수정</button>' +
								'<button id="modifyProjectEndBtn" style="display:none;" class="btn btn-success btn-sm">수정 완료</button>' +
								'<button id="endProjectBtn" class="btn btn-success btn-sm">프로젝트 완료</button>' + 
							'</div>'+
						'</div>'+
						'<h3>' +
							'<input type="text" id="projectContent" value="' + project.projectContent +'"readonly="readonly""></input>' +
						'</h3>' +
						'<hr>' +
						'<div class="wrapper fontGray"><h3><i class="mdi mdi mdi-account-outline"></i>&nbsp;담당자</h3><p>' + project.empName + "(" + project.createdate.substring(5,7) + "." + project.createdate.substring(8,10)  + " " + project.createdate.substring(11,16) + ")" +'</p></div>' +
						'<div class="wrapper fontGray"><h3><i class="mdi mdi-calendar"></i>&nbsp;기&nbsp;&nbsp;&nbsp;간 </h3><p><input type="date" id="projectStartDate" value="' + project.projectStartDate.substring(0, 10) + '" readonly="readonly"></input> ~ ' +  
							'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="date" id="projectEndDate" value="' + project.projectEndDate.substring(0, 10) + '" readonly="readonly"></input></p></div>' + 
						'' +
						'<div class="wrapper">'+
							'<h3><i class="mdi mdi-account-multiple-outline"></i>&nbsp;팀&nbsp;&nbsp;&nbsp;원</h3>' +
							'<div id="memberList" class="memberList">' 
								+ teamMembers.join(" ") + 
							'<button id="addPjMemeberBtn" class="btn btn-success btn-sm"><i class="mdi mdi-plus"></i></button>' +
							'<button class="btn btn-success btn-sm" id="deleteMemberAll">전체삭제</button>' + 
							'</div>' +
						'</div>' +
						'<div class="wrapper">'+
						'<h3><i class="mdi mdi-chart-gantt"></i>&nbsp;진행률</h3>'+
							'<div class="progress"></div><div class="progressNo"></div>'+
						'</div>'
					);
					// 초기 프로젝트 이름 + 프로젝트
					setProjectName(project.projectName);
					
					// 상태가 완료일때는 수정 불가로 버튼 숨기기
					if(project.projectStatus === '0') {
						$("#modifyProjectBtn").hide();
						$("#modifyProjectEndBtn").hide();
						$("#endProjectBtn").hide();
						$("#addPjMemeberBtn").hide();
						$("#addPjTaskBtn").hide();
						$(".deleteMember").hide();
						$("#deleteMemberAll").hide();
					} else {
						$(".deleteMember").show();
					};
					
					if(!empNoToDel) {
						$("#modifyProjectBtn").hide();
						$("#modifyProjectEndBtn").hide();
						$("#endProjectBtn").hide();
						$("#removeProjectBtn").hide();
						$("#addPjMemeberBtn").hide();
						$("#deleteMemberAll").hide();
					};
				
					// 팀원 명단 모달창 -> 내용이 로드되지 않았을수도 잇기에 해당 버튼은 이 함수 내에서 선언
					$("#addPjMemeberBtn").on("click", function() {
						$("#projectMemberModal").modal("show");
					});
					fetchProjectTaskData();
				},
				error: function(error) {
					console.error("데이터 가져오기 중 오류가 발생했습니다.", error);
				}
			});
		}
		// 프로젝트 이름 옆에 "프로젝트" 추가
		function setProjectName(name) {
			const projectNameInput = $("#projectName");
	
			// 프로젝트 입력란의 현재 값 가져오기
			const currentProjectName = projectNameInput.val();
				console.log("currentProjectName",currentProjectName);
	
			// 입력란이 비어있거나 이미 "프로젝트"가 없는 경우에만 추가
			if (!currentProjectName || currentProjectName.indexOf("프로젝트") === -1) {
				
				projectNameInput.val(name + " 프로젝트");
			}
		}
	/* 프로젝트 상세정보 끝 */
	
	/* 프로젝트 수정 */
		// 프로젝트 수정 
		$(".projectOne").on("click", "#modifyProjectBtn", function() {
			// 프로젝트 수정 버튼 숨기고 수정완료 보여주기
			$("#modifyProjectBtn").hide();
			$("#modifyProjectEndBtn").show();
			
			// readonly 속성 해제 및 css
			$("#projectContent, #projectStartDate, #projectEndDate, #projectName")
				.prop("readonly", false)
				.css("box-shadow", "0 0 4px rgba(0, 0, 0, 0.2)")
				.on("focus", function() {
					$(this).css("border", "1px solid skyblue"); // 포커스 효과 추가
				})
				.on("blur", function() {
					$(this).css("border", "none"); // 포커스 효과 추가
				})
				
			// 이전 값 받아오기
			currentProjectName = $("#projectName").val();
			currentProjectContent = $("#projectContent").val();
			currentProjectStartDate = $("#projectStartDate").val();
			currentProjectEndDate = $("#projectEndDate").val();
			
				//console.log("currentProjectName",currentProjectName);
				//console.log("currentProjectContent",currentProjectContent);
				///console.log("currentProjectStartDate",currentProjectStartDate);
				//console.log("currentProjectEndDate",currentProjectEndDate);
			
		});
		// 수정완료
		$(".projectOne").on("click", "#modifyProjectEndBtn", function() {
			
			const newProjectName = $("#projectName").val();
			const newProjectContent = $("#projectContent").val();
			const newProjectStartDate = $("#projectStartDate").val();
			const newProjectEndDate = $("#projectEndDate").val();
			
			// 시작일자와 종료일자 비교 검사
			if (newProjectStartDate > newProjectEndDate) {
				$("#projectStartDate").val(currentProjectStartDate);
				$("#projectEndDate").val(currentProjectEndDate);
				Swal.fire(
						'Error',
						'종료일자는 시작일자보다 커야합니다.',
						'error'
					)
				return; // 수정 작업 중단
			}
			
			// 수정완료 버튼 숨기고 프로젝트 수정 보여주기
			$("#modifyProjectBtn").show();
			$("#modifyProjectEndBtn").hide();
			
			// readonly 속성 주기
			$("#projectContent, #projectStartDate, #projectEndDate, #projectName")
				.prop("readonly", true); 
			
			if(currentProjectName !== newProjectName || currentProjectContent !== newProjectContent ||
				currentProjectStartDate !== newProjectStartDate||currentProjectEndDate !== newProjectEndDate) {
				//console.log("타이틀 값이 변경되었습니다. 새 값:", newProjectName);
				//console.log("내용 값이 변경되었습니다. 새 값:", newProjectContent);
				//console.log("시작일 값이 변경되었습니다. 새 값:", newProjectStartDate);
				//console.log("종료일 값이 변경되었습니다. 새 값:", newProjectEndDate);
			}
			$.ajax ({
				type : "POST",
				url : "/JoinTree/project/modifyProject",
				data : {
					projectNo : projectNo,
					projectName : newProjectName,
					projectContent : newProjectContent,
					projectStartDate : newProjectStartDate,
					projectEndDate : newProjectEndDate,
					updateId : loginEmpNo
				},
				success : function(response) {
					console.log("response",response);
					if(response === "success") {
						Swal.fire({
							icon: 'success',
							title: '프로젝트 정보가 수정되었습니다.',
							showConfirmButton: false,
							timer: 1000
						})
						fetchProjectData();
					}
				},
				error: function(error) {
					console.log("수정 중 오류가 발생했습니다.",error);
				}
			});
		});
	/* 프로젝트 수정 끝 */
	/* 프로젝트 완료로 상태변경 */
		$(".projectOne").on("click", "#endProjectBtn", function() {
			 // projectTaskList1 내에 projectTaskOne 클래스를 가진 요소를 선택
			const projectTaskOnes = $(".projectTaskList1 .projectTaskOne");
				console.log("projectTaskOnes",projectTaskOnes);
			// 미완료된 작업이 없을 경우에만 삭제 가능 
			if (projectTaskOnes.length > 0) {
				Swal.fire(
						'Error',
						'완료되지 않은 작업이 있어 완료처리 할 수 없습니다.',
						'error'
					)
				return;
			} else {
			Swal.fire({
				title: '프로젝트를 완료하시겠습니까?',
				text: "완료한 프로젝트는 더이상 수정할 수 없습니다.",
				icon: 'warning',
				showCancelButton: true,
				confirmButtonColor: '#8BC541',
				cancelButtonColor: '#888',
				confirmButtonText: '완료',
				cancelButtonText: '취소'
				}).then((result) => {
					if (result.isConfirmed) {
						$.ajax({
							type : "POST",
							url : "/JoinTree/project/endProject",
							data : {
								projectNo : projectNo
							},
							success : function(response) {
								console.log("respose",response);
								if(response === "success") {
									Swal.fire({
										icon: 'success',
										title: '프로젝트가 완료처리 되었습니다.',
										showConfirmButton: false,
										timer: 1500
									})
									fetchProjectData();
								}
							}
						});
					}
				});
			}
		});
	/* 프로젝트 상태 수정 끝 */
	/* 프로젝트 삭제 */
		$("#removeProjectBtn").on("click", function() {
			Swal.fire({
				title: '정말 삭제하시겠습니까?',
				text: "삭제된 프로젝트는 되돌릴 수 없습니다.",
				icon: 'warning',
				showCancelButton: true,
				confirmButtonColor: '#8BC541',
				cancelButtonColor: '#888',
				confirmButtonText: '삭제',
				cancelButtonText: '취소'
				}).then((result) => {
					if (result.isConfirmed) {
						$.ajax({
							type : "POST",
							url : "/JoinTree/project/removeProject",
							data : {
								projectNo : projectNo
							},
							success : function(response) {
								console.log("response",response);
								if(response === "success") {
									 Swal.fire({
										icon: 'success',
										title: '프로젝트가 삭제처리 되었습니다.',
										showConfirmButton: false,
										timer: 1500
									}).then(function() {
										// 타이머가 종료된 후에 이동할 URL 설정
										window.location.href = '/JoinTree/project/projectList';
									});
								}
							}
						});
					}
				})
		});
	/* 프로젝트 삭제 끝 */
/* 프로젝트 끝 */	
	
/* 프로젝트 팀원 */
	/* 프로젝트 팀원 추가 */
		// empTree 요소에 대한 데이터를 가져옴 -> 각 부서에 맞는 사원들을 가져옴
		$(".empTree").each(function() {
			const dept = $(this).data("dept"); 
			const deptLi = $(this).closest("li"); // 선택된 부서와 가장 가까운 li
			
			$.ajax({
				type: "GET",
				url: "/JoinTree/org/orgEmpList",
				dataType: "json",
				data: { dept: dept },
				success: function(data) {
					data.forEach(function(emp) {
						const empName = emp.empName; // emp로 들어온 값들의 변수를 선언함
						const empNo = emp.empNo;
						const empPosition = emp.positionName;
						const li = 
							'<li class="empInfoModal"><a href="#" data-no="'+ empNo +'" data-name="'+ empName +'" data-position="'+ empPosition +'" class="file code">' + empName + " " + empPosition + "(" + empNo + ")" + '</a></li>';
						deptLi.find("ul").append(li); // ul을 찾아서 li를 추가
					});
				}
			});
		});	
		
		$("#addMemberList").treeview({ collapsed: true });
		
	/* 팀원 선택 모달창 */
		// 선택한 멤버들 배열
		let selectedMembers = [];
	
		// 한명씩 추가
		$("#addMemberList").on("click", ".file.code", function() {
			const selectedMemberNo = $(this).data("no");
			const selectedMemberName = $(this).data("name");
			const selectedMemberPosition = $(this).data("position");
			const selectedMemberInfo = selectedMemberName + " " + selectedMemberPosition + "(" + selectedMemberNo + ")";
			
			if (!selectedMembers.includes(selectedMemberInfo)) {
				selectedMembers.push(selectedMemberInfo);
				console.log("selectedMembers",selectedMembers);
				sendDataToServer(selectedMemberNo); // 사번만 전송
			} else {
				Swal.fire(
					'Error',
					'이미 선택한 사원입니다.',
					'error'
				)
			}
		});
		
		// 부서별 전체 추가 -> 모달창 내 전체선택 버튼
		$(".memberAllClick").on("click", function() {
			const selectedDepartment = $(this).closest(".empTree.folder.code"); // 선택된 버튼에서 가장 가까운 부서 가져오기
			const selectedDeptMembers = new Array();
			console.log("selectedDeptMembers",selectedDeptMembers);
			// 선택한 버튼을 기준으로 가장 가까운 li안에 클래스를 찾아 순회하면서 배열에 넣기
			selectedDepartment.closest("li").find(".file.code").each(function() {
				const selectedMemberNo = $(this).data("no");
					
				selectedDeptMembers.push(selectedMemberNo);
					
			}); 
			sendDataToServer(selectedDeptMembers);
		});
		
		// 사번을 받아서 서버로 전송
		function sendDataToServer(memberNos) {
			$.ajax({
				type: "POST",
				url: "/JoinTree/project/addProjectMember",
				data: {
					projectNo: projectNo,
					empNo: Array.isArray(memberNos) ? memberNos : [memberNos], // 배열인지 아닌지 확인
					createId: loginEmpNo,
					updateId: loginEmpNo
				},
				success: function(response) {
					console.log("데이터가 성공적으로 전송되었습니다.", response);
					if (response === "success") {
						console.log("데이터가 성공적으로 전송되었습니다.");
						fetchProjectData();
					} else if (response === "duplicate") {
						Swal.fire({
							icon: 'success',
							title: '포함된 사원을 제외하고 추가합니다.',
							showConfirmButton: false,
							timer: 1000
						})
						fetchProjectData();
					}
				},
				error: function(xhr, status, error) {
					console.error("데이터 전송 중 오류가 발생했습니다.");
					console.error("상태 코드:", xhr.status);
					console.error("상태:", status);
					console.error("오류 내용:", error);
				}
			});
		}
		/* 팀원 선택 모달창 끝 */
		/* 프로젝트 팀원 추가 끝 */
		
		/* 프로젝트 팀원 삭제 */
		// 한명씩 삭제
		$(".projectOne").on("click", ".deleteMember", function() {
			const selectedMemeberNo = $(this).data("empno");
				console.log("selectedMemeberNo",selectedMemeberNo);
			sendDelMemberDataToServer([selectedMemeberNo]);
		});
		
		// 전체삭제
		$(".projectOne").on("click", "#deleteMemberAll", function(){
			
			const deleteMembers = new Array();
			
			$(".memberName").each(function() {			
				const selectedMemeberNo = $(this).data("empno");
				deleteMembers.push(selectedMemeberNo);	
				console.log("deleteMembers",deleteMembers);
			}); 
			sendDelMemberDataToServer(deleteMembers);
		});
		
		function sendDelMemberDataToServer(memberNos) {
			// 필터함수를 사용하여 loginEmpNo 즉, 삭제버튼이 활성화 된 담당자를 제외하고 삭제
			// empNo를 돌리면서 그 중에 loginEmpNo와 다른 사람만 filteredMemberNos배열에 저장
			let filteredMemberNos = [];
			if (Array.isArray(memberNos)) {
				filteredMemberNos = memberNos.filter(empNo => empNo !== loginEmpNo);
				console.log("filteredMemberNos",filteredMemberNos);
			}
			if(filteredMemberNos.length > 0) {
				$.ajax({
					type: "POST",
					url: "/JoinTree/project/removeProjectMemeber",
					data: {
						projectNo: projectNo,
						empNo: Array.isArray(memberNos) ? filteredMemberNos : [memberNos], // 배열인지 아닌지 확인
						createId: loginEmpNo,
						updateId: loginEmpNo
					},
					success: function(response) {
						console.log("데이터가 성공적으로 전송되었습니다.", response);
						if (response === "successAll") {
							//console.log("데이터가 성공적으로 전송되었습니다.");
							
							Swal.fire({
								icon: 'success',
								title: '담당자를 제외하고 삭제되었습니다.',
								showConfirmButton: false,
								timer: 1000
							})
							fetchProjectData();
						} else if(response === "success") {
							Swal.fire({
								icon: 'success',
								title: '선택한 팀원이 삭제되었습니다.',
								showConfirmButton: false,
								timer: 1000
							})
							fetchProjectData();
						} 
					},
					error: function(xhr, status, error) {
						console.error("데이터 전송 중 오류가 발생했습니다.");
						console.error("상태 코드:", xhr.status);
						console.error("상태:", status);
						console.error("오류 내용:", error);
					}
				});
			} else if(filteredMemberNos.length === 0){
				Swal.fire(
						'Error',
						'담당자는 삭제할 수 없습니다.',
						'error'
					)
			} 
		}
	/* 프로젝트 팀원 삭제 끝 */
/* 프로젝트 팀원 끝 */		

/*프로젝트 작업*/
	/* 프로젝트 하위작업 리스트 */
	function fetchProjectTaskData() {
		// AJAX 요청
		$.ajax({
			type: "GET",
			url: "/JoinTree/project/projectTask",
			data : {projectNo : projectNo},
			success: function(response) {
				const projectTaskList = response.projectTaskList;
				const projectProgress = response.projectProgress;
				console.log("projectTaskList",projectTaskList);
				console.log("projectProgress",projectProgress);
				
				$(".projectTask").empty();
				$(".projectTaskList1").empty();
				$(".projectTaskList2").empty();
				$(".progress").empty();
				$(".progressNo").empty();
				
				projectTaskList.forEach(function (task) {
					if(task.taskStatus === '0') {
						$(".projectTaskList1").append(
							'<div class="projectTaskOne margin10"' +
								'data-taskno="' + task.taskNo + '" ' +
								'data-taskempno="' + task.empNo + '" ' +
								'data-taskempname="' + task.empName + '" ' +
								'data-tasktitle="' + task.taskTitle + '" ' +
								'data-taskcontent="' + task.taskContent + '" ' +
								'data-taskstartdate="' + task.taskStartDate.substring(0,10) + '" '+ 
								'data-taskenddate="' + task.taskEndDate.substring(0,10) + '" '+ 
								'data-taskstatus="' + (task.taskStatus === '1' ? '완료' : '미완료') + '" ' +
								'data-taskoriginfilename="' + task.taskOriginFilename + '" ' +
								'data-tasksavefilename="' + task.taskSaveFilename + '" ' +
								'data-createdate="' + task.createdate.substring(0,10) + '">' +
								'<div>' + task.taskTitle + '</div>'+
							'</div>'
						);
					} else {
						$(".projectTaskList2").append(
							'<div class="projectTaskOne margin10"' +
								'data-taskno="' + task.taskNo + '" ' +
								'data-taskempno="' + task.empNo + '" ' +
								'data-taskempname="' + task.empName + '" ' +
								'data-tasktitle="' + task.taskTitle + '" ' +
								'data-taskcontent="' + task.taskContent + '" ' +
								'data-taskstartdate="' + task.taskStartDate.substring(0,10) + '" '+ 
								'data-taskenddate="' + task.taskEndDate.substring(0,10) + '" '+ 
								'data-taskstatus="' + (task.taskStatus === '1' ? '완료' : '미완료') + '" ' +
								'data-taskoriginfilename="' + task.taskOriginFilename + '" ' +
								'data-tasksavefilename="' + task.taskSaveFilename + '" ' +
								'data-createdate="' + task.createdate.substring(0,10) + '">' +
								'<div>' + task.taskTitle + '</div>'+
							'</div>'
						);
					}
				});
				
				// 리스트에 있는 테스크 선택 시
				$(".projectTaskListAll").on("click", ".projectTaskOne", function() {
					taskNo = $(this).data("taskno");
					const taskTitle = $(this).data("tasktitle");
					const taskEmpNo = $(this).data("taskempno");
					const taskEmpName = $(this).data("taskempname");
					const taskContent = $(this).data("taskcontent");
					const taskStartDate = $(this).data("taskstartdate");
					const taskEndDate = $(this).data("taskenddate");
					taskStatus = $(this).data("taskstatus");
					const taskOriginFilename = $(this).data("taskoriginfilename");
					const taskSaveFilename = $(this).data("tasksavefilename");
					const empName =  $("#teskHost").val();
					//console.log("taskEmpName:",taskEmpName);
					// 댓글
					fetchProjectTaskComment(taskNo);
					
					$(".projectTask").empty();
					$(".projectTask").append(
						'<div class="stretch-card margin-top20">' +
							'<div class="card">' +
								'<div class="card-body projectTaskCard"> ' +
									'<div><h3>' + taskTitle + '</h3></div>' +
									'<div><h4>담당자 : ' + taskEmpName + '('+ taskEmpNo + ')' + '</h4></div>' +
									'<div><h4>기간 : ' + taskStartDate + " ~ " + taskEndDate + '</h4></div>' +
									'<div><h4>작업상태 : ' + taskStatus + '</h4></div>' +
									'<div><h4>작업내용 : ' + taskContent + '</h4></div>' +
									'<div id="taskFile"><h4>' + 
										(taskSaveFilename ? 
										'첨부파일 : <a href="/JoinTree/taskFile/' + taskSaveFilename + '" id="downloadLink" download="' + taskOriginFilename + '">' + taskOriginFilename + '</a>' :
										'첨부파일이 없습니다.') + 
									'</h4></div>' +
									(taskEmpNo === loginEmpNo ? 
										(taskStatus === '미완료' ? 
										'<div class="right">' +
										'<button type="button" class="btn btn-success btn-sm" id="taskEndBtn">작업완료</button>' +
										'<button type="button" class="btn btn-success btn-sm margin-left10" id="taskDelBtn" class="margin10">작업삭제</button>'+
										'</div>' 
										: 
										'<div class="right">' +
										'<button type="button" class="btn btn-success btn-sm margin-left10" id="taskDelBtn" class="margin10">작업삭제</button>'+
										'</div>'
									) : '' ) +
								'</div>' + 
							'</div>' +
						'</div>'+
						// 댓글추가
						'<div class="stretch-card margin-left30 add-comment">' +
							'<div class="card">' +
								'<div class="card-body">' +
									'<div><b>' + empName + '(' + loginEmpNo + ')</b></div>' +
									'<div class="wrapper"><textarea id="taskCommentInput" class="form-control"></textarea>' +
										'<button type="button" class="taskCommentInputBtn btn btn-success btn-sm">등록</button>' +
									'</div>' +
								'</div>' +
							'</div>'+
						'</div>'
					);
				});
				
				projectProgress.forEach(function (progress) {
					$(".progress").append(
						'<div class="progress-bar" role="progressbar" ' +
							'aria-valuenow="' + progress.progressRate + '" ' +
							'aria-valuemin="0" aria-valuemax="100" ' +
							'style="width: ' + progress.progressRate + '%;">' + 
							progress.progressRate + '%'+
						'</div>' 
					);
					
					$(".progressNo").append(
						'<p>' +progress.completedTasks+ " / "+progress.totalTasks+'</p>'
					);
				});
				
			},
			error: function(error) {
				console.error("데이터 가져오기 중 오류가 발생했습니다.", error);
			}
		});
	}
	/* 프로젝트 하위작업 리스트 끝 */

	/* 프로젝트 작업 추가 */
		// 모달
		$("#addPjTaskBtn").on("click",function() {
			$("#addProjectTaskModal").modal("show");
		});
	
		// 프로젝트 파일 크기 제한
		$("#taskFilename").on("change", function(event) {
			const maxFileSize = 3 * 1024 * 1024; // 3MB
			const selectedFile = event.target.files[0];
			
			if (selectedFile && selectedFile.size > maxFileSize) {
				Swal.fire(
					'Error',
					'"파일 크기가 너무 큽니다. " + (maxFileSize / (1024 * 1024)) + "MB 이하의 파일만 업로드 가능합니다.")',
					'error'
				)
				$(this).val("");
			}
		});
		// 추가했을때
		$("#addTaskSubmitBtn").on("click", function() {
			const taskTitle = $("#taskTitle").val();
			const taskStartDate = $("#taskStartDate").val();
			const taskEndDate = $("#taskEndDate").val();
			const taskContent = $("#taskContent").val();
			const taskOriginFilename = $("#taskOriginFilename").val();
				//console.log("taskOriginFilename",taskOriginFilename);
			
			// 시작일자와 종료일자 비교 검사
			if (taskStartDate > taskEndDate) {
				$("#taskStartDate").val('');
				$("#taskEndDate").val('');
				Swal.fire(
					'Error',
					'종료일자는 시작일자보다 커야합니다.',
					'error'
				)
				return; // 추가 작업 중단
			}
			if(!taskTitle || !taskStartDate || !taskEndDate || !taskContent){
				Swal.fire(
					'Error',
					'모든 값을 넣어주세요.',
					'error'
				)
				return;
			} 
			
			$.ajax({
				url: "/JoinTree/project/addProjectTask",
				type: "POST",
				data: {
					projectNo : projectNo,
					empNo : loginEmpNo,
					taskTitle : taskTitle,
					taskStartDate : taskStartDate,
					taskEndDate : taskEndDate,
					taskContent : taskContent,
					createId : loginEmpNo,
					updateId : loginEmpNo
				},
				success : function(response) {
					console.log("response",response);
					if (response === 0) {
						console.log("프로젝트 작업 추가 실패");
						return;
					} else {
						Swal.fire({
							icon: 'success',
							title: '프로젝트 작업이 추가되었습니다.',
							showConfirmButton: false,
							timer: 1000
						})
					}
				
					$("#addProjectTaskModal").modal("hide");
					
					$("#taskTitle").val('');
					$("#taskStartDate").val('');
					$("#taskEndDate").val('');
					$("#taskContent").val('');
					
					if(taskOriginFilename) {
						uploadProjectTaskFile(response);
					}
					$(".projectTaskCard").empty();
					$(".taskComment").empty();
					fetchProjectTaskData();
				
				},error: function(error) {
					console.log("프로젝트 작업 추가 실패",error);
				}
			});
		});
		
		// 첨부파일 추가
		function uploadProjectTaskFile(taskNo) {
			// 파일 
			let file = $("#taskOriginFilename").val();
			
			// .을 제거한 확장자만 얻어내서 소문자로 변경
			file = file.slice(file.indexOf('.')+1).toLowerCase();
			
			const formData = new FormData();
			const files = $('#taskOriginFilename')[0].files;
			formData.append('taskNo', taskNo); // 작업 번호
				
			if (files.length > 0) {
				formData.append('file', files[0]); // 'file'은 서버에서 기대하는 파일 파트 이름
			}
			
			//console.log('files:' + files);
			//console.log(files[0]);
			
			// 파일등록 하러 비동기로
			$.ajax({
				url: '/JoinTree/project/fileUpload',
				type: 'post',
				data: formData,
				contentType: false, // 비동기로 파일을 등록할 때 필수
				processData: false, // 비동기로 파일을 등록할 때 필수
				success: function(data) {
					//console.log("data",data);
					if(data === 'success'){
						$("#taskFile").append(files[0].name);
						$(".projectTaskCard").empty();
						$("#taskOriginFilename").val('');
						fetchProjectTaskData();
					} else {
						console.log("업로드 실패");
					}
				},
				error : function() {
					console.log("업로드 실패");
				}
			});
		}
	/* 프로젝트 작업 추가 끝 */
	
	/* 프로젝트 작업 완료로 변경 */
		$(".projectTask").on("click", "#taskEndBtn", function() {
			Swal.fire({
				title: '작업을 완료하시겠습니까?',
				text: "완료된 작업은 수정할 수 없습니다.",
				icon: 'warning',
				showCancelButton: true,
				confirmButtonColor: '#8BC541',
				cancelButtonColor: '#888',
				confirmButtonText: '완료',
				cancelButtonText: '취소'
				}).then((result) => {
					if (result.isConfirmed) {
						console.log("taskNo",taskNo);
						$.ajax({
							type : "POST",
							url : "/JoinTree/project/endProjectTask",
							data : {taskNo : taskNo},
							success : function(response) {
								console.log("respose",response);
								if(response === "success") {
									Swal.fire({
										icon: 'success',
										title: '작업이 완료처리 되었습니다',
										showConfirmButton: false,
										timer: 1500
									})
									fetchProjectTaskData();
									$(".taskComment").empty();
								}
							}
						});
					}
				});
		});
	/* 프로젝트 작업 완료로 변경 끝 */
	
	/* 프로젝트 작업 삭제 */
		$(".projectTask").on("click", "#taskDelBtn", function() {
			Swal.fire({
				title: '작업을 삭제하시겠습니까?',
				text: "완료된 작업은 수정할 수 없습니다.",
				icon: 'warning',
				showCancelButton: true,
				confirmButtonColor: '#8BC541',
				cancelButtonColor: '#888',
				confirmButtonText: '완료',
				cancelButtonText: '취소'
				}).then((result) => {
					if (result.isConfirmed) {
						console.log("taskNo",taskNo);
						$.ajax({
							type : "POST",
							url : "/JoinTree/project/removeProjectTask",
							data : {
								taskNo : taskNo,
								projectNo : projectNo
							},
							success : function(response) {
								console.log("respose",response);
								if(response === "success") {
									Swal.fire({
										icon: 'success',
										title: '작업이 삭제되었습니다',
										showConfirmButton: false,
										timer: 1500
									})								
									fetchProjectData();
									fetchProjectTaskData();
								}
							}
						});
					}
				});
		})
	/* 프로젝트 작업 삭제 끝 */
/* 프로젝트 작업 끝 */
/* 프로젝트 작업 */
	/* 프로젝트 작업 댓글 리스트 */
		function fetchProjectTaskComment(taskNo) {
			console.log("taskNo",taskNo);
			$.ajax({
				type : "GET",
				url : "/JoinTree/project/selectTaskComment",
				data : {taskNo: taskNo},
				success: function(taskCommentList) {
					console.log("taskCommentList",taskCommentList);
					$(".taskComment").empty();
					
					//console.log("taskStatus",taskStatus);
					
					//alert("댓글리스트 성공");
					taskCommentList.forEach(function (comment) {
						// 댓글
						if(comment.commentParentNo === 0){
							$(".taskComment").append(
								'<div class="stretch-card">' +
									'<div class="floatL">  </div>' + 
									'<div class="card">' +
										'<div class="card-body">' +
											'<div data-commentno=' + comment.taskCommentNo+ '><b>' + comment.empName + "(" + comment.empNo + ")</b>" +
											'<div class="floatR">' + comment.createdate.substring(0,10) +'</div></div>'+
											'<div>' + comment.taskCommentContent +'</div>'+
											'<div class="wrapper right"><button id="addTaskComment" class="btn btn-success btn-sm" data-commentno=' + comment.taskCommentNo + '>댓글작성</button>'+
											'<button id="delTaskComment" class="btn btn-success btn-sm margin-left10" data-commentno=' + comment.taskCommentNo + '>삭제</button>'+
											'<button data-commentno=' + comment.taskCommentNo + ' data-parentno='+ comment.commentParentNo + ' class="tcShowandhideBtn btn btn-success btn-sm margin-left10">대댓글 보기<span id="childCommentCnt"></span></button></div>' +
										'</div>' +
									'</div>'+
								'</div>'
							)
							$.ajax({
								type: "GET",
								url: "/JoinTree/project/taskCommentChildCnt",
								data: { commentParentNo: comment.taskCommentNo },
								success: function (data) {
									//console.log("data",data);
									if (data > 0) {
										// 대댓글 수를 해당 버튼 옆의 span에 표시
										$(".childCommentCount").empty();
										$(".tcShowandhideBtn[data-commentno='" + comment.taskCommentNo + "']").append('<span class="childCommentCount">' + "(" + data + ")" +'</span>');
									} else {
										// 대댓글이 없는 경우 해당 버튼 숨김
										$(".tcShowandhideBtn[data-commentno='" + comment.taskCommentNo + "']").hide();
									}
									if(taskStatus === '완료') {
										$(".add-comment").hide();
										$("#addTaskComment[data-commentno='" + comment.taskCommentNo + "']").hide();
										$("#delTaskComment[data-commentno='" + comment.taskCommentNo + "']").hide();
										$("#delTaskCommentChild[data-commentno='" + comment.taskCommentNo + "']").hide();
									}
								},
								error: function (error) {
									console.log("error", error);
								}
							});
						// 대댓글
						} else if(comment.commentParentNo !== 0){
							commentParentNo = comment.commentParentNo;
							$(".taskComment").append(
								'<div class="child">'+
								'<div class="stretch-card childComment hidden" data-commentno=' + comment.commentParentNo + '>' +
									'<div class="floatL"><i class="mdi mdi-arrow-right"></i></div>' + 
									'<div class="card">' +
										'<div class="card-body">' +
											'<div><b>'+ comment.empName + "(" + comment.empNo + ")</b>" +
											'<div class="floatR">' + comment.createdate.substring(0,10) +'</div>' +
											'<div>' + comment.taskCommentContent +'</div>' +
											'<div class="right"><button id="delTaskCommentChild" class="btn btn-success btn-sm" data-commentno=' + comment.taskCommentNo + '>삭제</button></div>'+
										'</div>' +
									'</div>'+
								'</div></div>'
							)
							if(taskStatus === '완료') {
								$("#delTaskCommentChild[data-commentno='" + comment.taskCommentNo + "']").hide();
							}
						}
					}); // foreach
				},
				error: function(error){
					console.log("error",error);
				}
			});
		}
	/* 프로젝트 작업 댓글 리스트 끝 */
	/* 프로젝트 작업 댓글 추가 */
		$(".projectTask").on("click", ".taskCommentInputBtn", function() {
			const taskCommentContent =  $("#taskCommentInput").val();
			
			if(!taskCommentContent) {
				Swal.fire(
					'Error',
					'댓글을 입력해주세요.',
					'error'
				)
				$("#taskCommentInput").focus();
				return;
			}
				//console.log("taskNo",taskNo);
				//console.log("loginEmpNo",loginEmpNo);
				//console.log("taskCommentContent",taskCommentContent);
			$.ajax({
				type: "POST",
				url: "/JoinTree/project/addTaskComment",
				data: {
					taskNo : taskNo,
					empNo : loginEmpNo,
					taskCommentContent : taskCommentContent,
					createId : loginEmpNo,
					updateId : loginEmpNo
				},
				success:function(response){
					console.log("response",response);
					$("#taskCommentInput").val('');
					fetchProjectTaskComment(taskNo);
				},
				error:function(error) {
					console.log("댓글추가 오류 발생",error);
				}
			});
		});
		/* 프로젝트 작업 댓글 끝 */
		/* 프로젝트 작업 대댓글 추가 */
		// 추가하기 눌렀을때
		$(".taskComment").on("click", "#addTaskComment", function() {
			const currentCard = $(this).closest('.stretch-card');
			const empName =  $("#teskHost").val();;
			const commentNo = currentCard.find('[data-commentno]').data('commentno');
				//console.log("commentNo" ,commentNo);
		if (!currentCard.next().hasClass('childComment')) {	
			const addCard = $('<div class="stretch-card grid-margin childComment">' +
			'<div class="floatL"><i class="mdi mdi-arrow-right"></i></div>' + 
				'<div class="card">' +
					'<div class="card-body">' +
						'<div><b>' + empName + "(" + loginEmpNo + ')</b></div>'+						
						'<div class="wrapper"><textarea id="taskCommentChildInput" class="form-control"></textarea>' +
						'<button type="button" class="taskCommentChildInputBtn btn btn-success btn-sm" data-commentno=' + commentNo + '>등록</button></div>' +
					'</div>' +
				'</div>'
			);
		
			currentCard.after(addCard);
		}	
			$("#taskCommentChildInput").focus();
		});
		
		// 등록을 눌렀을때
		$(".taskComment").on("click", ".taskCommentChildInputBtn", function() {
			const taskCommentContent =  $("#taskCommentChildInput").val();
			const commentNo = $(this).data('commentno'); 
				//console.log("taskNo",taskNo);
				//console.log("loginEmpNo",loginEmpNo);
				//console.log("commentNo",commentNo);
				//console.log("taskCommentContent",taskCommentContent);
			if(!taskCommentContent) {
				Swal.fire(
					'Error',
					'댓글을 입력해주세요.',
					'error'
				)
				$("#taskCommentChildInput").focus();
				return;
			}
			$.ajax({
				type: "POST",
				url: "/JoinTree/project/addTaskCommentChild",
				data: {
					taskNo : taskNo,
					empNo : loginEmpNo,
					commentParentNo : commentNo,
					taskCommentContent : taskCommentContent,
					createId : loginEmpNo,
					updateId : loginEmpNo
				},
				success:function(response){
					//console.log("response",response);
					//console.log("commentNo",commentNo);
					
					fetchProjectTaskComment(taskNo);
					
				},
				error:function(error) {
					console.log("댓글추가 오류 발생",error);
				}
			});
		});
		
		// 대댓글 보기&숨기기
		function toggleChildComments(commentNo) {
			// 대댓글을 포함하는 상위 요소를 찾기
			const child = $('.child');
				
			// 대댓글을 찾기 commentNo와 같은
			const childComments = child.find('[data-commentno="' + commentNo + '"]');
			
			// 대댓글을 숨기거나 표시합니다.
			childComments.toggleClass('hidden');
		}
		
		// 대댓글 보기 클릭 시 
		$(".taskComment").on("click", ".tcShowandhideBtn", function() {
			//console.log("버튼이 클릭");
			const commentNo = $(this).data('commentno');
			
			toggleChildComments(commentNo);
		});
	/* 프로젝트 작업 대댓글 추가 끝 */
	/* 프로젝트 작업 댓글 삭제 */
		// 댓글
		$(".taskComment").on("click", "#delTaskComment", function() {
			const taskCommentNo = $(this).data('commentno');
			console.log("댓글 번호", taskCommentNo);
			Swal.fire({
				title: '댓글을 삭제하시겠습니까?',
				text: "삭제된 댓글은 되돌릴 수 없으며 대댓글도 함께 삭제됩니다.",
				icon: 'warning',
				showCancelButton: true,
				confirmButtonColor: '#8BC541',
				cancelButtonColor: '#888',
				confirmButtonText: '완료',
				cancelButtonText: '취소'
				}).then((result) => {
					if (result.isConfirmed) {
						delComments(taskCommentNo);
					}
				});
			
		});
		// 대댓글
		$(".taskComment").on("click", "#delTaskCommentChild", function() {
			const taskCommentNo = $(this).data('commentno');
			console.log("댓글 번호", taskCommentNo);
			
			delComments(taskCommentNo)
		});
		
		function delComments(taskCommentNo) {
			$.ajax({
				type: "POST",
				url: "/JoinTree/project/removeTaskComment",
				data: {taskCommentNo : taskCommentNo},
				success:function(response){
					//console.log("response",response);
					
					fetchProjectTaskComment(taskNo);
				},
				error:function(error) {
					console.log("댓글삭제 오류 발생",error);
				}
			});
		}
	/* 프로젝트 작업 댓글 삭제 끝 */
/* 프로젝트 작업 댓글 끝 */
}); // 마지막
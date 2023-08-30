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
	
	
<script>
	$(document).ready(function() {
	/* 전역변수 */
		const urlParams = new URLSearchParams(window.location.search); // 주소창에 있는 값
		const projectNo = urlParams.get("projectNo"); // 주소창 값 중에서 프로젝트 번호
			console.log("projectNo",projectNo);		
		const loginEmpNo = ${loginAccount.empNo};
		let currentProjectName; // 현재 프로젝트 이름
		let currentProjectContent;// 현재 프로젝트 내용
		let currentProjectStartDate; // 현재 프로젝트 시작일
		let currentProjectEndDate; // 현재 프로젝트 종료일
	/* 전역변수 끝 */
/* 프로젝트 */
	/* 프로젝트 상세정보 출력 */
		// 페이지 로딩 시 프로젝트 데이터를 가져옴
		fetchProjectData();
		
		function fetchProjectData() {
			const dept = $(".empTree.folder.code").data("dept");
			const deptName = $(".empTree.folder.code").data("deptname");
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
					// 팀원 정보 추가
					const empNoToDel = loginEmpNo === project.empNo;
						//console.log("loginEmpNo",loginEmpNo);
						//console.log("empNoToDel",empNoToDel);
						
					// projectMemeber에 있는 요소 m을 순환하면서 아래 스펜으로 가공
					const teamMembers = projectMemeber.map(m =>
						'<div class="memberName" ' +
							'data-empno="' + m.empNo + '" ' +
							'data-name="' + m.empName + '">' +
							m.empName  + ' (' + m.empNo + ')' +
							(empNoToDel ? '<span class="deleteMember" style="display: none;" data-empno="' + m.empNo + '">×</span>' : '') +
						'</div>'
					);
					
					// 서버로부터 받아온 데이터를 이용하여 해당 요소들에 추가
					$(".projectOne").append(
						'<div class="wrapper">' +
							'<h1><input type="text" id="projectName" value="' + project.projectName + '"readonly="readonly""></input> 프로젝트</h1>' +
							'<div id="pjBtns">'+
								'<button id="modifyProjectBtn">프로젝트 수정</button>' +
								'<button id="modifyProjectEndBtn" style="display:none;">수정 완료</button>' +
								'<button id="endProjectBtn">프로젝트 완료</button>' + 
							'</div>' +
						'</div>'+
						'<h3><input type="text" id="projectContent" value="' + project.projectContent +'"readonly="readonly""></input></h3>' +
						'<h3>담당자 : ' + project.empName +'</h3>' +
						'<h3>기간 :<input type="date" id="projectStartDate" value="' + project.projectStartDate.substring(0, 10) + '" readonly="readonly"></input> ~ ' +  '<input type="date" id="projectEndDate" value="' + project.projectEndDate.substring(0, 10) + '" readonly="readonly"></input>' + '</h3>' +
						'<div class="wrapper"><h3>팀원 :</h3><div id="memberList" class="memberList">' + teamMembers.join(" ") + '<button id="addPjMemeberBtn">+</button></div></div>' + 
						'<h3>진행률</h3><div class="wrapper"><div class="progress"></div><div class="progressNo"></div></div>'
					);
					
					if(project.projectStatus === 'A0503') {
						$("#modifyProjectBtn").hide();
						$("#modifyProjectEndBtn").hide();
						$("#endProjectBtn").hide();
						$("#addPjMemeberBtn").hide();
						$("#addPjTaskBtn").hide();
						$(".deleteMember").hide();
					} else {
						$(".deleteMember").show();
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
	/* 프로젝트 상세정보 끝 */
	
	/* 프로젝트 수정 */
		// 프로젝트 수정 
		$(".projectOne").on("click", "#modifyProjectBtn", function() {
			// 프로젝트 수정 버튼 숨기고 수정완료 보여주기
			$("#modifyProjectBtn").hide();
			$("#modifyProjectEndBtn").show();
			
			// readonly 속성 해제
			$("#projectContent").prop("readonly", false); 
			$("#projectStartDate").prop("readonly", false); 
			$("#projectEndDate").prop("readonly", false); 
			$("#projectName").prop("readonly", false); 
			
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
			
			// 수정완료 버튼 숨기고 프로젝트 수정 보여주기
			$("#modifyProjectBtn").show();
			$("#modifyProjectEndBtn").hide();
			
			// readonly 속성 주기
			$("#projectName").prop("readonly", true); 
			$("#projectContent").prop("readonly", true); 
			$("#projectStartDate").prop("readonly", true); 
			$("#projectEndDate").prop("readonly", true); 
			
			const newProjectName = $("#projectName").val();
			const newProjectContent = $("#projectContent").val();
			const newProjectStartDate = $("#projectStartDate").val();
			const newProjectEndDate = $("#projectEndDate").val();
			
			
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
							title: '프로젝트 정보가 수정되었습니다',
							showConfirmButton: false,
							timer: 1000
						})
					}
				
				},
				error: function(xhr, status, error) {
					console.error("수정 중 오류가 발생했습니다.");
				}
			});
		});
	/* 프로젝트 수정 끝 */
	/* 프로젝트 완료로 상태변경 */
		$(".projectOne").on("click", "#endProjectBtn", function() {
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
										title: '프로젝트가 완료처리 되었습니다',
										showConfirmButton: false,
										timer: 1500
									})
								}
							}
						});
					}
				});
		});
	/* 프로젝트 상태 수정 끝 */
	/* 프로젝트 삭제 */
		$("#removeProjectBtn").on("click", function() {
			Swal.fire({
				title: '정말 삭제하시겠습니까?',
				text: "삭제한 프로젝트는 되돌릴 수 없습니다.",
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
									window.location.href = '/JoinTree/project/projectList';
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
						const empDept = emp.dept;
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
				alert("이미 선택한 사원입니다.");
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
				const selectedMemberName = $(this).data("name");
				const selectedMemberPosition = $(this).data("position");
				const selectedMemberInfo = selectedMemberName + " " + selectedMemberPosition + "(" + selectedMemberNo + ")";
					//console.log("selectedMemberInfo:",selectedMemberInfo);
					
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
					} else if (response === "fail") {
						alert("데이터 전송 중 오류가 발생했습니다.");
					} else if (response === "duplicate") {
						alert("이미 선택한 사원을 제외하고 추가합니다.");
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
		$(".projectOne").on("click", ".deleteMember", function() {
			const selectedMemeberNo = $(this).data("empno");
			console.log("selectedMemeberNo",selectedMemeberNo);
			if(selectedMemeberNo !== loginEmpNo) {
				$.ajax({
					type: "POST",
					url: "/JoinTree/project/removeProjectMemeber",
					data: {
						projectNo: projectNo,
						empNo: selectedMemeberNo,
						createId: loginEmpNo,
						updateId: loginEmpNo
					},
					success: function(response) {
						console.log("데이터가 성공적으로 전송되었습니다.", response);
						if (response === "success") {
							console.log("데이터가 성공적으로 전송되었습니다.");
							fetchProjectData();
						} else if (response === "fail") {
							alert("데이터 전송 중 오류가 발생했습니다.");
						} else if (response === "duplicate") {
							alert("이미 선택한 사원을 제외하고 추가합니다.");
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
			} else {
				Swal.fire(
					'Error',
					'담당자는 지울 수 없습니다.',
					'error'
				)
			}

		});
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
				
				$(".projectTesk").empty();
				projectTaskList.forEach(function (task) {
					$(".projectTesk").append(
						'<div class="stretch-card grid-margin">'+
							'<div class="card">'+
								'<div class="card-body center" data-taskno=' + task.teskNo+'>'+
									'<div>작성자 : ' + task.empNo + '</div>'+
									'<div>작성자 : ' + task.empName + '</div>'+
									'<div>' + task.taskContent + '</div>'+
									'<div>' + task.taskStatus + '</div>'+
									'<div>' + task.taskStartDate + '</div>'+
									'<div>' + task.taskEndDate + '</div>'+
									'<div>' + task.createdate + '</div>'+
									'<div>' + task.updatedate + '</div>'+
									'<div>' + task.createId + '</div>'+
									'<div>' + task.updateId + '</div>'+
								'</div>'+
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
							'</div>' 
					);
					
					$(".progressNo").append(
						'<div>' +progress.completedTasks+ "/"+progress.totalTasks+'</div>'
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
		$("#addPjTaskBtn").on("click", function() {
			alert("성공");
		});
	/* 프로젝트 작업 추가 끝 */
	}); // 마지막
</script>
	<!-- 필수 요소-->
	<div class="container-fluid page-body-wrapper">
		<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
			<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
				<a href="/JoinTree/project/projectList">돌아가기</a>
					<div class="projectOne">
						<!-- 프로젝트 상세정보 출력 -->
					</div>
				<button id="addPjTaskBtn">작업추가</button>
				<div class="projectTesk">
					<!-- 프로젝트 작업 정보 출력 -->
				</div>
				<button id="removeProjectBtn">프로젝트 삭제</button>
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
</html>
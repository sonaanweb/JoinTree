<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<!-- header -->
	<jsp:include page="/WEB-INF/view/inc/header.jsp"/> 

	<!-- jQuery 트리뷰 및 쿠키 라이브러리 -->
	<script src="/resource/lib/jquery.cookie.js" type="text/javascript"></script>
	<script src="/resource/lib/jquery.treeview.js" type="text/javascript"></script>
	
	<!-- 트리뷰 스타일 시트 -->
	<link rel="stylesheet" href="/resource/jquery.treeview.css">
	<link rel="stylesheet" href="/resource/screen.css">
<script>
	$(document).ready(function() {
		 
		// empTree 요소에 대한 데이터를 가져옴 -> 각 부서에 맞는 사원들을 가져옴
		$(".empTree").each(function() {
			const dept = $(this).data("dept"); // dept데이터는 수정될 일이 없기에 const로 저장
			const deptLi = $(this).closest("li"); // 선택된 부서와 가장 가까운 li
			
			$.ajax({
				type: "GET",
				url: "/org/orgEmpList",
				dataType: "json",
				data: { dept: dept },
				success: function(data) {
					data.forEach(function(emp) {
						const empName = emp.empName; // emp로 들어온 값들의 변수를 선언함
						const empNo = emp.empNo;
						const empDept = emp.dept;
						const empPosition = emp.positionName;
						const li = 
							'<li><a href="#" data-no="'+ empNo +'" data-name="'+ empName +'" data-position="'+ empPosition +'" class="file code">' + empName + " " + empPosition + "(" + empNo + ")" + '</a></li>';
						deptLi.find("ul").append(li); // ul을 찾아서 li를 추가
					});
				}
			});
		});
		
		// modalSingerBtn 클릭 시 결재선 모달 띄우기
		$("#modalSingerBtn").on("click", function() {
			// alert("성공");
			$("#signerModal").modal("show");
		});
		
		// modalReferBtn 클릭 시 참조자 모달 띄우기
		$("#modalReferBtn").on("click", function() {
			// alert("성공");
			$("#referModal").modal("show");
		});
		
		// modalReceiverBtn 클릭 시 수신팀 모달 띄우기
		$("#modalReceiverBtn").on("click", function() {
			// alert("성공");
			$("#receiverModal").modal("show");
		});

		// 트리구조의 결재선, 참조자, 수신팀 처리
		const signerSelectedEmps = []; // 선택한 결재자 정보를 저장하는 배열
    	const referSelectedEmps = []; // 선택한 참조자의 정보를 저장하는 배열
    	const receiverSelectedEmps = []; // 선택한 수신팀의 정보를 저장하는 배열
		
			// 결재선 모달에서 선택한 사원 처리
			$("#signerModal").on("click", ".file.code", function() {
				const selectedEmpNo = $(this).data("no");
				const selectedEmpName = $(this).data("name");
				const selectedEmpPosition = $(this).data("position");
				
				if (!signerSelectedEmps.includes(selectedEmpName + " " + selectedEmpPosition + "(" + selectedEmpNo + ")") && signerSelectedEmps.length < 2) {
					signerSelectedEmps.push(selectedEmpName + " " + selectedEmpPosition + "(" + selectedEmpNo + ")");
				
					$("#signerModal").modal("hide");
					
				} else if (signerSelectedEmps.includes(selectedEmpName + " " + selectedEmpPosition + "(" + selectedEmpNo + ")")) {
					alert("이미 선택한 번호입니다.");
				} else {
					alert("최대 두 명까지만 선택 가능합니다.");
				}
				// 업데이트
				updateSelectEmp(signerSelectedEmps, $("#selectSigner"),true);
			});
	
			// 참조자 모달에서 선택한 사원 처리
			$("#referModal").on("click", ".file.code", function() {
				const selectedEmpNo = $(this).data("no");
				const selectedEmpName = $(this).data("name");
				const selectedEmpPosition = $(this).data("position");
				const selectedEmpInfo = selectedEmpName + " " + selectedEmpPosition + "(" + selectedEmpNo + ")";
				
				if (!referSelectedEmps.includes(selectedEmpInfo)) {
					referSelectedEmps.splice(0, 1, selectedEmpInfo);
					// 업데이트
					updateSelectEmp(referSelectedEmps, $("#selectReference"),false);
					
					$("#referModal").modal("hide");
					
				} else if (referSelectedEmps.includes(selectedEmpInfo)) {
					alert("이미 선택한 번호입니다.");
				}
			});
			
			// 수신팀 모달에서 선택한 팀 처리
			// selectedDeptName을 더 넓은 스코프로 이동
			let selectedDept = ""; 

			$("#receiverModal").on("click", ".empTree.folder.code", function() {
				selectedDept = $(this).data("dept");
				const selectedDeptName = $(this).data("deptname"); // 팀 이름 가져오기
				
				if (!receiverSelectedEmps.includes(selectedDept)) {
					receiverSelectedEmps.splice(0, 1, selectedDeptName); // 선택한 팀 추가 (1개만 선택 가능)
					// 업데이트
					updateSelectEmp(receiverSelectedEmps, $("#selectReceiverTeam"),false);
					
					$("#receiverModal").modal("hide");
					
				} else {
					alert("이미 선택한 팀입니다.");
				}
			});
			
			// 선택한 결재자 삭제
				$("#deleteSignerBtn").on("click", function() {
					const checkedCheckboxes = $(".empCheckbox:checked");
					checkedCheckboxes.each(function() {
						const selectedEmp = $(this).data("no");
						const index = signerSelectedEmps.indexOf(selectedEmp);
						if (index !== -1) {
							signerSelectedEmps.splice(index, 1); // 선택한 번호 삭제
						}
					});
				// 업데이트
				updateSelectEmp(signerSelectedEmps, $("#selectSigner"), true);
			});
	
			// 위로 버튼을 클릭하면 선택한 사원을 위로 이동하는 기능 추가
			$("#moveUpBtn").on("click", function() {
				const selectedEmp = $(".empCheckbox:checked").data("no");
				const selectedIndex = signerSelectedEmps.indexOf(selectedEmp);
				if (selectedIndex > 0) {
					const temp = signerSelectedEmps[selectedIndex];
					signerSelectedEmps[selectedIndex] = signerSelectedEmps[selectedIndex - 1];
					signerSelectedEmps[selectedIndex - 1] = temp;
					// 업데이트
					updateSelectEmp(signerSelectedEmps, $("#selectSigner"), true);
				}
			});
	
			// 아래로 버튼을 클릭하면 선택한 사원을 아래로 이동하는 기능 추가
			$("#moveDownBtn").on("click", function() {
				const selectedEmp = $(".empCheckbox:checked").data("no");
				const selectedIndex = signerSelectedEmps.indexOf(selectedEmp);
				if (selectedIndex >= 0 && selectedIndex < signerSelectedEmps.length - 1) {
					const temp = signerSelectedEmps[selectedIndex];
					signerSelectedEmps[selectedIndex] = signerSelectedEmps[selectedIndex + 1];
					signerSelectedEmps[selectedIndex + 1] = temp;
					// 업데이트
					updateSelectEmp(signerSelectedEmps, $("#selectSigner"), true);
				}
			});
			
			// inputSignerBtn 버튼을 클릭하면 결재자의 값을 기안서 - 결재자1(signer1), 결재자2(signer2) 영역에 추가
			$("#inputSignerBtn").on("click", function() {
				const selectedSigner1 = signerSelectedEmps[0]; // 선택한 결재자 정보 가져오기
				const selectedSigner2 = signerSelectedEmps[1];
				
				const maskedSigner1 = selectedSigner1.substring(0, selectedSigner1.indexOf('('));
				let maskedSigner2 = "";

				if (selectedSigner2) {
					maskedSigner2 = selectedSigner2.substring(0, selectedSigner2.indexOf('('));
				}

				$("#signer1").val(maskedSigner1); // .text() 메서드를 사용하여 내용 변경 -> td에 넣어야 함
			    $("#signer2").val(maskedSigner2); // .text() 메서드를 사용하여 내용 변경
					//console.log($("#signer1").val());
					//console.log($("#signer2").val());
			});
			
			// inputReferBtn 버튼을 클릭하면 참조자 값을 기안서 - 참조자(reference) 영역에 추가
			$("#inputReferBtn").on("click", function() {
				const selectedRefer = referSelectedEmps[0]; // 선택한 수신팀 정보 가져오기
				
				const maskedRefer = selectedRefer.substring(0, selectedRefer.indexOf('('));
				$("#reference").val(maskedRefer); // -> input이라서 val
					//console.log($("#reference").val());
			});
			
			// inputReceiverBtn 버튼을 클릭하면 수신팀의 값을 기안서 - 수신팀(receiverTeam) 영역에 추가
			$("#inputReceiverBtn").on("click", function() {
			    const selectedReceiverTeam = receiverSelectedEmps; // 선택한 수신팀 정보 가져오기
			    
			    $("#receiverTeam").val(selectedReceiverTeam);
					//console.log($("#receiverTeam").val());
			});
			
			// selectEmp 업데이트 함수
			function updateSelectEmp(modalSelectedEmps, selectElement, includeCheckbox = true) {
				selectElement.empty();
				for (const emp of modalSelectedEmps) {
					if (includeCheckbox) {
						const selectedEmp = '<div class="selectedEmp">' + emp + '<input type="checkbox" class="empCheckbox" data-no="' + emp + '"></div>';
						selectElement.append(selectedEmp);
					} else {
						const selectedEmp = '<div class="selectedEmp">' + emp + '</div>';
						selectElement.append(selectedEmp);
					}
				}
			}
			
			$("#signerCodeList").treeview({ collapsed: true });
			$("#referCodeList").treeview({ collapsed: true });
			$("#receiverCodeList").treeview({ collapsed: true });
			
		// 기안서 양식 샐렉트
		// 기본 기안서로 생성
		const defaultSelectedValue = $('#slectDocument').val();
			updateSelectDocument(defaultSelectedValue);
		
		let selectedValue = 'D0101'; // 기본값 설정
		
		// slectDocument 옵션 변경시 이벤트
		$('#slectDocument').change(function(){
			selectedValue = $(this).val();
			console.log("selectedValue",selectedValue);
			updateSelectDocument(selectedValue);
		});
		
		function updateSelectDocument(selectForm){
			$.ajax({
				type: 'GET',
				url: '/document/getDocumentForm',
				data: {
					selectedForm: selectForm
				},
				success: function(data){
					$('#documentForm').html(data);
				},
				error: function(){
					console.log('Error loading document form content.');
				}
			});
		}
		$('#docFormBtn').on("click", function() {
			// 기안서 - 기본
			// 기안자 사번
			const empNo = $("#empNo").val();
				console.log("empNo:",empNo);
			// 기안자 이름
			const writer = $("#writer").val();
				console.log("writer:",writer);
			// 기안서 카테고리
			const category = selectedValue;
				console.log("category:",category);
			// 기안서 제목
			const docTitle = $("#docTitle").val();
				console.log("docTitle:",docTitle);
			// 기안서 내용(휴가사유, 퇴직사유 및 퇴직예정일)
			const docContent = $("#docContent").val();
				console.log("docContent:",docContent);
				
			// 기안서 - 연차
			// 연차 종류 leave 
			const leaveCate = $("#leaveCate").val();
				console.log("leaveCate:",leaveCate);
			// 연차 시작일
			const docLeaveStartDate = $("#docLeaveStartDate").val();
				console.log("docLeaveStartDate:",docLeaveStartDate);
			// 연차 종료일
			const docLeaveEndDate = $("#docLeaveEndDate").val();
				console.log("docLeaveEndDate:",docLeaveEndDate);
			// 기간 
			const docLeavePeriodDate = $("#docLeavePeriodDate").val();
				console.log("docLeavePeriodDate:",docLeavePeriodDate);
			// 비상연락처
			const docLeaveTel = $("#docLeaveTel").val();
				console.log("docLeaveTel:",docLeaveTel);
				
			// 기안서 - 인사이동
			// 인사이동일자 
			const docReshuffleDate = $("#docReshuffleDate").val();
				console.log("docReshuffleDate:",docReshuffleDate);
			// 주요업무
			const docReshuffleTask = $("#docReshuffleTask").val();
				console.log("docReshuffleTask:",docReshuffleTask);
			// 업무성과 
			const docReshuffleResult = $("#docReshuffleResult").val();
				console.log("docReshuffleResult:",docReshuffleResult);
			// 변경 후 부서
			const docReshuffleDept = $("#docReshuffleDept").val();
			console.log("docReshuffleDept:",docReshuffleDept);
			// 변경 후 직급
			const docReshufflePosition = $("#docReshufflePosition").val();
			console.log("docReshufflePosition:",docReshufflePosition);
			// 발령 사유
			const docReshuffleReason = $("#docReshuffleReason").val();
			console.log("docReshuffleReason:",docReshuffleReason);
			
			// 공통
			// 파일
			const docOriginFilename = $("#docOriginFilename").val();
				console.log("docOriginFilename:",docOriginFilename);
			//참조자
			let reference = "";
			if(referSelectedEmps[0]){
				reference = referSelectedEmps[0].substring(referSelectedEmps[0].indexOf('(')+1,referSelectedEmps[0].indexOf(')'));
			}
			console.log("reference:",reference);
				
			//수신팀
			const receiverTeam = selectedDept;
				console.log("receiverTeam:",receiverTeam);
				
			// 기안자 도장 정보 1
			const docStamp1 = $("#docStamp1").val();
				console.log("docStamp1:",docStamp1);
			// 작성자
			const createId = $("#createId").val();
				console.log("createId:",createId);
			// 수정자
			const updateId = $("#updateId").val();
				console.log("updateId:",updateId);

			// 결재자 1 사번
			let empSignerLevel1 = ""; // 레벨
			let signer1 = "";
			if(signerSelectedEmps[0]) {
				signer1 = signerSelectedEmps[0].substring(signerSelectedEmps[0].indexOf('(')+1,signerSelectedEmps[0].indexOf(')'));
				empSignerLevel1 = "1"
			}
			console.log("signer1:",signer1);
			
			// 결재자 2 사번
			let empSignerLevel2 = ""; // 레벨
			let signer2 = "";
			if(signerSelectedEmps[1]) {
				signer2 = signerSelectedEmps[1].substring(signerSelectedEmps[1].indexOf('(')+1,signerSelectedEmps[1].indexOf(')'));
				empSignerLevel2 = "2"
			}
				console.log("signer2:",signer2);
				
			if (!empNo || !empName || !category || !docTitle || !docContent || !reference || !receiverTeam || !docStamp1 || !createId || !updateId || !signer1) {
			   	alert("모든 필수 정보를 입력해주세요.");
			   	return;
			}
			$.ajax({
				type: 'POST',
				url: '/document/docDefault',
				data: {
					empNo: empNo,
					writer: writer,
					category: category,
					docTitle: docTitle,
					docContent: docContent,
					reference: reference,
					receiverTeam: receiverTeam,
					docStamp1: docStamp1,
					createId: createId,
					updateId: updateId
				},
				success: function(docNo){
					console.log("docNo:", docNo);
					
					alert("추가되었습니다.");
						// 결재자가 한명만 있을 경우
						$.ajax({
							type: 'POST',
							url: '/document/docSigner',
							data: {
								docNo: docNo, // 위에서 전달받은 docNo 사용
								empSignerNo: signer1,
								empSignerLevel: empSignerLevel1,
								createId: createId,
								updateId: updateId
							},
							success: function(response) {
								console.log("response:", response);
								// alert("사인이 추가되었습니다.");
								
								window.location.href = '/home'; // 홈 페이지 URL로 변경

							},
							error: function(jqXHR, textStatus, errorThrown) {
								console.log("Error:", textStatus, errorThrown);
							}
						});
						// 두번째 결재자가 있을 경우
						if(signer2) {
							$.ajax({
								type: 'POST',
								url: '/document/docSigner',
								data: {
									docNo: docNo, // 위에서 전달받은 docNo 사용
									empSignerNo: signer2,
									empSignerLevel: empSignerLevel2,
									createId: createId,
									updateId: updateId
								},
								success: function(response) {
									console.log("response:", response);
									// alert("사인이 추가되었습니다.");
									
									window.location.href = '/home'; // 홈 페이지 URL로 변경
								},
								error: function(jqXHR, textStatus, errorThrown) {
									console.log("Error:", textStatus, errorThrown);
								}
							});
						}
						
				},
				error: function(jqXHR, textStatus, errorThrown) {
					console.log("Error:", textStatus, errorThrown);
				}
			});
		});
	}); // 제일 처음
</script>
	<div class="container-fluid page-body-wrapper">
		<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
			<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
				<div class="row">	
					<!-- 기안서 -->
					<div class="col-md-3">
						<div>
							<select id="slectDocument" name="document">
								<c:forEach var="d" items="${documentCodeList}">
									<option id="category" value="${d.code}">${d.codeName}</option>
								</c:forEach>
							</select>
						</div>
						<!-- 결재선 -->
						<div>
							<h1>결재선</h1>
							<button type="button" id="modalSingerBtn"><i class="mdi mdi-account-plus"></i></button>	
							<div style="border: 1px solid #999; width:200px; height: 200px;">
								<div>
									${empInfo.empName}
								</div>
								<hr>
								<div id="selectSigner">
									<!-- 여기에 데이터를 추가하는 부분 -->
								</div>
								
							</div>
							<button type="button" id="deleteSignerBtn"><i class="mdi mdi-close"></i></button>
							<button type="button" id="moveUpBtn"><i class="mdi mdi-arrow-up"></i></button>
							<button type="button" id="moveDownBtn"><i class="mdi mdi-arrow-down"></i></button>
							<button type="button" id="inputSignerBtn"><i class="mdi mdi-plus"></i></button>
						</div>
						<div>
							<h1>참조자</h1>
							<button type="button" id="modalReferBtn"><i class="mdi mdi-account-plus"></i></button>	
							<div id="selectReference" style="border: 1px solid #999; width:200px; height: 200px;">
								<!-- 여기에 데이터를 추가하는 부분 -->
							</div>
							<button type="button" id="inputReferBtn"><i class="mdi mdi-plus"></i></button>
						</div>
						
						<div>
							<h1>수신팀</h1>
							<button type="button" id="modalReceiverBtn"><i class="mdi mdi-account-plus"></i></button>
							<div id="selectReceiverTeam" style="border: 1px solid #999; width:200px; height: 200px;">
								<!-- 여기에 데이터를 추가하는 부분 -->
							</div>
							<button type="button" id="inputReceiverBtn"><i class="mdi mdi-plus"></i></button>
						</div>
					</div><!-- col-md-3 끝 -->
					<div class="col-md-9 grid-margin stretch-card">
						<div class="card">
							<div class="card-body">
								<button type="button" id="docFormBtn">결재상신</button>
								<div id="documentForm">
									<!-- 폼데이터 추가 -->
								</div>
							</div>
						</div>
					</div><!-- col-md-9 끝 -->
				</div><!-- row 끝 -->
			</div><!-- 컨텐츠 끝 -->
	</div><!-- 컨텐츠전체 끝 -->
	<!-- footer -->
	<jsp:include page="/WEB-INF/view/inc/footer.jsp"/>
	<!-- 결재선 모달 -->
	<div class="modal" id="signerModal" tabindex="-1">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">결재선</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				
				<div class="modal-body">
					<ul id="signerCodeList"> <!-- 고유한 ID 부여 -->
						<c:forEach var="dept" items="${deptList}">
							<li>
								<span class="empTree folder code" data-dept="${dept.code}">${dept.codeName}</span>
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
	
	<!-- 참조자 모달 -->
	<div class="modal" id="referModal" tabindex="-1">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">참조자</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				
				<div class="modal-body">
					<ul id="referCodeList"> <!-- 고유한 ID 부여 -->
						<c:forEach var="dept" items="${deptList}">
						<li>
							<span class="empTree folder code" data-dept="${dept.code}">${dept.codeName}</span>
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
	
	<!-- 수신팀 모달 -->
	<div class="modal" id="receiverModal" tabindex="-1">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">수신자</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
					
				<div class="modal-body">
					<ul id="receiverCodeList"> <!-- 고유한 ID 부여 -->
						<c:forEach var="dept" items="${deptList}">
							<li>
								<span class="empTree folder code" data-dept="${dept.code}" data-deptname="${dept.codeName}">${dept.codeName}</span>
							</li>
						</c:forEach>
					</ul>
				</div>
			</div>
		</div>
	</div>
</html>

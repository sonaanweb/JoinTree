/* 기안서 결재선 */
	$(document).ready(function() {
		const loginEmpNo = $("#docApproval").data("empno");
		console.log("loginEmpNo:",loginEmpNo);
		// empTree 요소에 대한 데이터를 가져옴 -> 각 부서에 맞는 사원들을 가져옴
		$(".empTree").each(function() {
			const dept = $(this).data("dept"); // dept데이터는 수정될 일이 없기에 const로 저장
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
				const selectedEmpInfo = selectedEmpName + " " + selectedEmpPosition + "(" + selectedEmpNo + ")";
				
				if(selectedEmpNo === loginEmpNo) {
					Swal.fire(
						'Error',
						'본인은 선택할 수 없습니다.',
						'error'
					);
					return;
				}
				// 이미 참조자로 선택된 사원인지 확인
			    if (referSelectedEmps.includes(selectedEmpInfo)) {
			        Swal.fire(
			            'Error',
			            '이미 선택한 참조자는 결재자로 선택할 수 없습니다.',
			            'error'
			        );
			    } else if (!signerSelectedEmps.includes(selectedEmpInfo) && signerSelectedEmps.length < 2) {
			        signerSelectedEmps.push(selectedEmpInfo);
			        
			        $("#signerModal").modal("hide");
			    } else if (signerSelectedEmps.includes(selectedEmpInfo)) {
			        Swal.fire(
			            'Error',
			            '이미 선택한 결제자 입니다.',
			            'error'
			        );
			    } else {
			        Swal.fire(
			            'Error',
			            '최대 두 명까지만 선택 가능합니다.',
			            'error'
			        );
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
				
				// 참조가가 나일경우
				if(selectedEmpNo === loginEmpNo) {
					Swal.fire(
						'Error',
						'본인은 선택할 수 없습니다.',
						'error'
					);
					return;
				}
				// 이미 결제자로 선택된 사원인지 확인
				if (signerSelectedEmps.includes(selectedEmpInfo)) {
			 		Swal.fire(
						'Error',
						'이미 선택한 결제자는 참조자로 선택할 수 없습니다.',
						'error'
					);
				
				} else if (!referSelectedEmps.includes(selectedEmpInfo)) {
					referSelectedEmps.splice(0, 1, selectedEmpInfo);
					// 업데이트
					updateSelectEmp(referSelectedEmps, $("#selectReference"),false);
					
					$("#referModal").modal("hide");
					
				} else if (referSelectedEmps.includes(selectedEmpInfo)) {
					Swal.fire(
						'Error',
						'이미 선택한 참조자 입니다.',
						'error'
					);
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
							$(".sign1").val('');
						}
					});
					
				// 업데이트
				updateSelectEmp(signerSelectedEmps, $("#selectSigner"), true);
				updateSignerFields();
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
					updateSignerFields();
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
				updateSignerFields();
			});
			
			function updateSignerFields() {
				const selectedSigner1 = signerSelectedEmps[0]; // 선택한 결재자 정보 가져오기
				const selectedSigner2 = signerSelectedEmps[1];
				
				const maskedSigner1 = selectedSigner1 ? selectedSigner1.substring(0, selectedSigner1.indexOf('(')) : "";
				let maskedSigner2 = "";
				
				// 결재자가 1명
				if (selectedSigner1) {
					$("#signer1").val(maskedSigner1);
					$(".sign1").removeClass("hidden");
				} else {
					// 선택한 결재자1가 없을 때, 해당 값을 초기화 및 숨김
					$("#signer1").val("");
					$(".sign1").addClass("hidden");
				}
				
				// 결재자가 2명
				if (selectedSigner2) {
					maskedSigner2 = selectedSigner2.substring(0, selectedSigner2.indexOf('('));
					$("#signer2").val(maskedSigner2);
					$(".sign2").removeClass("hidden");
				} else {
					// 선택한 결재자2가 없을 때, 해당 값을 초기화 및 숨김
					$("#signer2").val("");
					$(".sign2").addClass("hidden");
				}
			}
			
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
				console.log("selectElement",selectElement);
				selectElement.empty();
				for (const emp of modalSelectedEmps) {
					if (includeCheckbox) {
						let label = emp;
						
						if (modalSelectedEmps.length > 1) {
							if (modalSelectedEmps.indexOf(emp) === 0) {
								label = '결재 | ' + emp;
							} else if (modalSelectedEmps.indexOf(emp) === 1) {
								label = '전결 | ' + emp;
							}
						} else {
							label = '전결 | ' + emp;
						}
						
						const selectedEmp = '<div class="selectedEmp margin-top10">' + label + '<input type="checkbox" class="empCheckbox" data-no="' + emp + '"></div>';
						selectElement.append(selectedEmp);
					} else if(selectElement.is($("#selectReference"))) {
						label = '참조 | ' + emp;
						const selectedEmp = '<div class="selectedEmp">' + label  + '</div>';
						selectElement.append(selectedEmp);
					} else {
						const selectedEmp = '<div class="selectedEmp">' + emp  + '</div>';
						selectElement.append(selectedEmp);
					}
				}
			}
			
			$("#signerCodeList").treeview({ collapsed: true });
			$("#referCodeList").treeview({ collapsed: true });
			$("#receiverCodeList").treeview({ collapsed: true }); // 트리구조 끝
		
		// 기안서 양식 샐렉트
		// 기본 기안서로 생성
		const defaultSelectedValue = $('#slectDocument').val();
		updateSelectDocument(defaultSelectedValue);
		
		let selectedValue = 'D0101'; // 기본값 설정
		
		// slectDocument 옵션 변경시 이벤트
		$('#slectDocument').off('change').on('change', function(){
			selectedValue = $(this).val();
			console.log("selectedValue",selectedValue);
			updateSelectDocument(selectedValue);
		});
		
		// 폼 선택시 폼 업데이트 기능
		function updateSelectDocument(selectForm){
			$.ajax({
				type: 'GET',
				url: '/JoinTree/document/getDocumentForm',
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
		
		// 기안하기 버튼 클릭시 
		$('#docFormBtn').on("click", function() {
			event.preventDefault(); // 폼 제출 방지
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
			const leaveCate = $("input[name='leaveCate']:checked").val();
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
			const docReshuffleDept = $("input[name='docReshuffleDept']:checked").val();
			console.log("docReshuffleDept:", docReshuffleDept);
			// 변경 후 직급
			const docReshufflePosition = $("input[name='docReshufflePosition']:checked").val();
			console.log("docReshufflePosition:",docReshufflePosition);
			
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
			let signer1 = $("#signer1").val();
			
			if(signer1 === "") {
				Swal.fire(
						'Error',
						'결재자를 추가해주세요.',
						'error'
					);
				return;
			} else {
				if(signerSelectedEmps[0]) {
					signer1 = signerSelectedEmps[0].substring(signerSelectedEmps[0].indexOf('(')+1,signerSelectedEmps[0].indexOf(')'));
					empSignerLevel1 = "1"
				}
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
				
			// 필수 입력값 유효성 검사
			if (docStamp1 === null || docStamp1 === "") {
				Swal.fire(
					'Error',
					'서명을 먼저 등록해주세요.',
					'error'
				);
				return;
			}
			
			if(category == "D0101" || category == "D0104"){
				if (!docTitle || !reference || !receiverTeam ||!signer1) {
					Swal.fire(
						'Error',
						'모든 필수 정보를 입력해주세요.',
						'error'
					);
					return;
				}
			}
			if(category == "D0102"){
				if(!docTitle || !reference || !receiverTeam ||!signer1 || !leaveCate || !docLeaveStartDate || !docLeaveEndDate || !docLeavePeriodDate || !docLeaveTel){
					Swal.fire(
						'Error',
						'모든 필수 정보를 입력해주세요.',
						'error'
					);
					return;
				}
			}
			if(category == "D0103"){
				if(!docTitle || !reference || !receiverTeam ||!signer1 || !docReshuffleDate || !docReshuffleTask || !docReshuffleResult || !docReshuffleDept || !docReshufflePosition){
					Swal.fire(
						'Error',
						'모든 필수 정보를 입력해주세요.',
						'error'
					);
					return;
				}
			}
		
			// 기본 기안서, 퇴직기안서 값 넘기기
			$.ajax({
				type: 'POST',
				url: '/JoinTree/document/docDefault',
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
					//alert("성공");
					
					// 문서에 첨부파일이 있는 경우
					if (docOriginFilename) {
						uploadDocument(docNo, category, writer); 
					}
					
					// 결재자가 한명만 있을 경우
					submitDocumentSigner(docNo, signer1, empSignerLevel1, createId, updateId);

					// 두번째 결재자가 있을 경우
					if(signer2) {
						submitDocumentSigner(docNo, signer2, empSignerLevel2, createId, updateId);
					}
					
					// 카테고리가 휴가 일때 
					if(category === 'D0102') {
						submitLeaveDocument(docNo, leaveCate, docLeaveStartDate, docLeaveEndDate, docLeavePeriodDate, docLeaveTel, createId, updateId);
					}
					
					// 카테고리가 인사이동 일때 
					if(category === 'D0103') {
						submitReshuffleDocument(docNo, docReshuffleDate, docReshuffleTask, docReshuffleResult, docReshuffleDept, docReshufflePosition, createId, updateId);
					}
									
					Swal.fire({
							icon: 'success',
							title: '기안이 완료되었습니다.',
							showConfirmButton: false,
							timer: 1000
						}).then(function() {
							window.location.href = '/JoinTree/document/draftDocList'; // 홈 페이지 URL로 변경					
						});
					
				},
				error: function(textStatus, errorThrown) {
					console.log("Error:", textStatus, errorThrown);
				}
			}); // 기본기안서 값 비동기 끝
			
			// 문서의 첨부파일 
			function uploadDocument(docNo, category, writer) {
				// 파일 
				let file = $("#docOriginFilename").val();
				
				// .을 제거한 확장자만 얻어내서 소문자로 변경
				file = file.slice(file.indexOf('.')+1).toLowerCase();
				
				const formData = new FormData();
				const files = $('#docOriginFilename')[0].files;
				formData.append('docNo', docNo); // 문서 번호
				formData.append('category', category); // 문서 카테고리
				formData.append('writer', writer); // 작성자
		
				if (files.length > 0) {
					formData.append('file', files[0]); // 'file'은 서버에서 기대하는 파일 파트 이름
				}
				
				console.log('files:' + files);
				console.log(files[0]);
				
				console.log(files[0].files);
					// 파일등록 하러 비동기로
					$.ajax({
						url: '/JoinTree/document/fileUpload',
						type: 'post',
						data: formData,
						contentType: false, // 비동기로 파일을 등록할 때 필수
						processData: false, // 비동기로 파일을 등록할 때 필수
						success: function(data) {
							
							if(data === 'success'){
								$('#docOriginFilename').val('');
								// alert("업로드 성공");
							} else {
								//alert("업로드 실패");
							}
						},
						error : function() {
							//alert("업로드 실패");
						}
					});
			}
			
			// 결재자 정보를 결재자 테이블에 넣어주기
			function submitDocumentSigner(docNo, empSignerNo, empSignerLevel, createId, updateId) {
				$.ajax({
					type: 'POST',
					url: '/JoinTree/document/docSigner',
					data: {
						docNo: docNo,
						empSignerNo: empSignerNo,
						empSignerLevel: empSignerLevel,
						createId: createId,
						updateId: updateId
					},
					success: function(response) {
						console.log("response:", response);
						
						if(response === 'success'){
							// alert("결재자 등록성공");
						} else {
							//alert("결재자 등록실패");
						}
					},
					error: function(textStatus, errorThrown) {
						console.log("Error:", textStatus, errorThrown);
					}
				});
			}
			
			// 휴가 기안서 비동기
			function submitLeaveDocument(docNo, leaveCate, docLeaveStartDate, docLeaveEndDate, docLeavePeriodDate, docLeaveTel, createId, updateId) {
				$.ajax({
					type: 'POST',
					url: '/JoinTree/document/docLeave',
					data: {
						docNo: docNo,
						leaveCategory: leaveCate,
						docLeaveStartDate: docLeaveStartDate,
						docLeaveEndDate: docLeaveEndDate,
						docLeavePeriodDate: docLeavePeriodDate,
						docLeaveTel: docLeaveTel,
						createId: createId,
						updateId: updateId
					},
					success: function(response) {
						if(response === 'success'){
							//alert("휴가기안 등록성공");
						} else {
							//alert("휴가기안 등록실패");
						}
					},
					error: function(textStatus, errorThrown) {
						console.log("Error:", textStatus, errorThrown);
					}
				});
			}
			
			// 인사이동 기안서 비동기
			function submitReshuffleDocument(docNo, docReshuffleDate, docReshuffleTask, docReshuffleResult, docReshuffleDept, docReshufflePosition, createId, updateId) {
				$.ajax({
					type: 'POST',
					url: '/JoinTree/document/docReshuffle',
					data: {
						docNo: docNo,
						docReshuffleDate: docReshuffleDate,
						docReshuffleTask: docReshuffleTask,
						docReshuffleResult: docReshuffleResult,
						docReshuffleDept: docReshuffleDept,
						docReshufflePosition: docReshufflePosition,
						createId: createId,
						updateId: updateId
					},
					success: function(response) {
						if(response === 'success'){
							//alert("인사이동기안 등록성공");
						} else {
							//alert("인사이동기안 등록실패");
						}
						
					},
					error: function(textStatus, errorThrown) {
						console.log("Error:", textStatus, errorThrown);
					}
				});
			}
		}); // 기안하기 버튼 클릭 시 끝
	}); // 제일 처음
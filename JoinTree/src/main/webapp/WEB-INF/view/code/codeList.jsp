<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<!-- header -->
	<jsp:include page="/WEB-INF/view/inc/header.jsp"/> 
	<script>
	$(document).ready(function() {
		/* 리스트 업데이트 function */
			// 상위코드 리스트 비동기로 받아오기
			function updateUpCodeList() {
				$.ajax({
					url: "/JoinTree/code/upCodeList",
					type: "GET",
					success: function(data) {
						$("#upCodeList").empty(); // 초기화
						
						data.forEach(function(upCode) {
							const row = $("<tr>").addClass("upCodeLink").attr("data-code", upCode.code);
							const codeCell = $("<td>").text(upCode.code); // 코드
							const codeNameCell = $("<td>").text(upCode.codeName); // 코드이름
							const toggleCell = $("<td>").text(upCode.status); // 코드이름
							
							row.append(codeCell, codeNameCell, toggleCell); // 행에 셀들 추가
							
							$("#upCodeList").append(row); // 행을 테이블에 추가
						});
					},
					error: function() {
						alert("fail");
					}
				});
			}
			
			// 하위코드 리스트 비동기로 받아오기
			function updateCodeList(upCode) {
				$.ajax({
					url: "/JoinTree/code/childCodeList",
					type: "GET",
					dataType: "json",
					data: { upCode: upCode },
					success: function(data) {
						console.log("Response Data:", data);
				
						$("#childCodeList").empty(); // 초기화
						
						if (data.length === 0) {
							$("#childCodeList").append("<tr><td colspan=3>" + "하위코드를 추가해주세요" + "</td></tr>");
							return; // 하위 코드가 없으면 여기서 처리 중단
						} else {
							
						}
						
						data.forEach(function(childCode) {
							const row = $("<tr>").addClass("codeOneLink").data("code", childCode.code); // 코드 추가
							const codeCell = $("<td>").text(childCode.code); // 코드
							const codeNameCell = $("<td>").text(childCode.codeName); // 코드이름
							const toggleCell = $("<td>").text(childCode.status); // 코드이름
							
							// 같은 열에 추가
							row.append(codeCell, codeNameCell, toggleCell); 
							
							// 추가된 열을 정적으로 해당 테이블에 추가
							$("#childCodeList").append(row);
						});
					},
					// 에러 발생시
					error: function(jqXHR, textStatus, errorThrown) {
						console.log("Error:", textStatus, errorThrown);
					}
				});
			}// 하위코드 리스트 비동기로 받아오기 끝
			
			// 상위코드 상세정보 가져오기
			function updateUpCodeDetailView(code) {
				$.ajax({
					url: "/JoinTree/code/upCodeOne",
					type: "GET",
					dataType: "JSON",
					data: {code: code},
					success: function(data) {
						$("#upCodeOneList1").empty();
						$("#upCodeOneList2").empty();
						$("#upCodeOneList3").empty();
						$("#upCodeOneList4").empty();
						$("#upCodeOneList5").empty();
						$("#upCodeOneList6").empty();
						$("#upCodeOneList7").empty();
						$("#upCodeOneList8").empty();
						
						data.forEach(function(upCodeOne) {
							currentUpCode= upCodeOne.code; // 전역변수에 값 넣기
							currentUpCodeName = upCodeOne.codeName;// 전역변수에 값 넣기
							console.log("currentUpCodeName",currentUpCodeName);
							 // 현재 상세보기 코드 업데이트
							$("#upCodeOneList1").append("<td>" + upCodeOne.upCode + "</td>");
							$("#upCodeOneList2").append("<td>" + upCodeOne.code + "</td>");
							$("#upCodeOneList3").append("<td><input type=text id=upCodeNameInput value=" + upCodeOne.codeName + "></input></td>");
							const toggleValue = upCodeOne.status;
							
							const toggleCell = $("<td>").html(
									'<label class="switch">' +
									'<input type="checkbox" class="toggleSwitch"' + (toggleValue === "Y" ? 'checked' : '') + '>' +
									'<span class="slider round"></span>' +
									'</label>'
							);
							$("#upCodeOneList4").append(toggleCell);
							
							currentUpChecked = toggleValue === "Y" ? true : false;
							
							$("#upCodeOneList5").append("<td>" + upCodeOne.createdate.slice(0,10) + "</td>");
							$("#upCodeOneList6").append("<td>" + upCodeOne.updatedate.slice(0,10) + "</td>");
							$("#upCodeOneList7").append("<td>" + upCodeOne.createId + "</td>");
							$("#upCodeOneList8").append("<td>" + upCodeOne.updateId + "</td>");
						});
					},
					error: function(jqXHR, textStatus, errorThrown) {
						console.log("Error:", textStatus, errorThrown);
					}
				});
			}
			
			// 하위코드 상세정보 가져오기
			function updateCodeDetailView(code) {
				$.ajax({
					url: "/JoinTree/code/codeOne",
					type: "GET",
					dataType: "JSON",
					data: {code: code},
					success: function(data) {
						$("#chileCodeOneList1").empty();
						$("#chileCodeOneList2").empty();
						$("#chileCodeOneList3").empty();
						$("#chileCodeOneList4").empty();
						$("#chileCodeOneList5").empty();
						$("#chileCodeOneList6").empty();
						$("#chileCodeOneList7").empty();
						$("#chileCodeOneList8").empty();
						
						data.forEach(function(codeOne) {
							currentCode = codeOne.code; // 전역변수에 값 넣기
							currentCodeName = codeOne.codeName;// 전역변수에 값 넣기
							console.log("currentCodeName",currentCodeName);
							 // 현재 상세보기 코드 업데이트
							$("#chileCodeOneList1").append("<td>" + codeOne.upCode + "</td>");
							$("#chileCodeOneList2").append("<td>" + codeOne.code + "</td>");
							$("#chileCodeOneList3").append("<td><input type=text id=codeNameInput value=" + codeOne.codeName + "></input></td>");
							const toggleValue = codeOne.status;
							
							const toggleCell = $("<td>").html(
									'<label class="switch">' +
									'<input type="checkbox" class="toggleSwitch"' + (toggleValue === "Y" ? 'checked' : '') + '>' +
									'<span class="slider round"></span>' +
									'</label>'
							);
							$("#chileCodeOneList4").append(toggleCell);
							
							currentChecked = toggleValue === "Y" ? true : false;
							
							$("#chileCodeOneList5").append("<td>" + codeOne.createdate.slice(0,10) + "</td>");
							$("#chileCodeOneList6").append("<td>" + codeOne.updatedate.slice(0,10) + "</td>");
							$("#chileCodeOneList7").append("<td>" + codeOne.createId + "</td>");
							$("#chileCodeOneList8").append("<td>" + codeOne.updateId + "</td>");
							
						});
					},
					error: function(jqXHR, textStatus, errorThrown) {
						console.log("Error:", textStatus, errorThrown);
					}
				});
			}
		/* --------- 리스트 업데이트 function 끝 --------- */
		
		/* --------- 전역변수 --------- */
		let upCode; // 상위코드를 저장하기 위해 전역변수로 선언
		const loginId = ${loginAccount.empNo}; // 로그인한 직원 아이디
		let currentUpCodeName; // 상위 - 코드네임을 담기 위해 선언
		let currentUpChecked; // 상위 - 현재 사용여부를 담기 위해 선언
		let currentCodeName; // 하위 - 코드네임을 담기 위해 선언
		let currentChecked; // 하위 - 현재 사용여부를 담기 위해 선언
		/* --------- 전역변수 끝 --------- */
		
		/* --------- 리스트 출력 --------- */
			// 로딩되자마자 상위코드 리스트 뿌리기
			updateUpCodeList();	
		
			// upCodeLink 클릭시 비동기로 childCodeList에서 값을 가져와서 보여줌 
			$(document).on("click", ".upCodeLink", function() {// 여러 개의 요소를 선택하기 위해 클래스를 사용
				// 아래에 지정한 data-code에 값을 가져와서 upCode에 저장
				upCode = $(this).data("code");
					console.log("Clicked upCode:", upCode); // 디버깅용 로그
					const code = $(this).find("td:first").text(); // 클릭된 행의 첫 번째 td에 있는 코드 가져오기

					updateCodeList(upCode);
					// 상세보기 
					updateUpCodeDetailView(upCode);
			});
		/* --------- 리스트 끝 --------- */
		/* --------- 상세보기 출력 --------- */	
			// 하위코드 클릭 시 상세보기
			// 동적으로 .codeOneLink가 동적으로 추가되어 이벤트 위임을 사용함
			// 부모요소에 이벤트를 등록하고 클릭된 요소에 codeOneLink 클래스를 가졌는지 검사
			$(".code").on("click", ".codeOneLink", function() {
				const code = $(this).find("td:first").text(); // 클릭된 행의 첫 번째 td에 있는 코드 가져오기
				
				updateCodeDetailView(code);
	
			});
		/* --------- 상세보기 끝 --------- */
		
		/* --------- 추가 --------- */
			// 상위코드 추가를 위한 입력행 추가
			$("#addUpCodeLink").on("click", function() {
				if ($("#upCodeT").find(".newRow").length === 0) {
					// 버튼 상태 변경: 코드를 추가하는 버튼은 표시 / 상세정보를 저장하는 버튼은 숨기기
					$("#saveUpCodeBtn").show();
					$("#saveUpCodeOneBtn").hide();
					
					// 입력 필드 초기화
					$("#newUpCode").val('');
					$("#newUpCodeName").val('');
					   
					// 테이블에 새로운 행 생성
					const newRow = $("<tr>").addClass("newRow");
					
					// 입력 필드를 새로운 행에 추가합니다.
					const upCodeInputCell = $("<td>").html('<input type="text" class="uppercase-text" id="newUpCode">');
					const codeNameInputCell = $("<td>").html('<input type="text" class="newUpCodeName" id="newUpCodeName">');
					
					newRow.append(upCodeInputCell);
					newRow.append(codeNameInputCell);
					
					// 새로운 행을 테이블의 본문에 추가
					$("#upCodeT").append(newRow);
				}
				$("#newUpCode").focus();
			});
			
			// 상위코드 추가 폼 값 저장
			$("#saveUpCodeBtn").on("click", function() {
				// 새로운 행에서 데이터를 가져와 변수에 저장
				const parentRow = $(this).closest("tr");
				const newUpCode = $("#newUpCode").val().toUpperCase().trim();
				const newUpCodeName = $("#newUpCodeName").val().toUpperCase().trim();
					//console.log("newUpCode:" + newUpCode);
					//console.log("newUpCodeName:" + newUpCodeName);
			
				// 빈 값 검사
				if (!newUpCode || !newUpCodeName) {
					alert("상위코드, 상위코드명을 모두 입력해주세요.");
					return; // 사용되지 않은 경우 함수 종료
				}
			
				// 입력한 upCode가 DB에 upCode에 있는 값인지 중복 확인
				const inputUpCode = $("#newUpCode").val()
				const usedUpCodes = [];
				$(".upCodeLink").each(function() {
					usedUpCodes.push($(this).data("code"));
				});
				
				if (usedUpCodes.includes(inputUpCode)) {
					alert("이미 존재하는 상위코드입니다.");
					return; // 사용되지 않은 경우 함수 종료
				}
			
				// 데이터를 서버에 저장하기 전에 필요한 유효성 검사를 수행합니다.
				$.ajax({
					url: "/JoinTree/code/addUpCommonCode",
					type: "POST",
					data: {
						code : newUpCode,
						codeName : newUpCodeName,
						createId : ${loginAccount.empNo},
						updateId : ${loginAccount.empNo}
					},
					success: function(response) {
						console.log("response:", response);
						
						// 이전 리스트 삭제
						$("#upCodeList").empty();
						
						// 코드 추가 성공 후 리스트 다시 불러오기
						updateUpCodeList();
						
						// 입력 필드 초기화
						$("#newUpCode").val('');
						$("#newUpCodeName").val('');
						
						// 입력창 숨기기
						$("#newUpCode").closest("tr").hide();

						//실패시
						if(response === "fail") {
							alert("fail");
						}
					},
					error: function(jqXHR, textStatus, errorThrown) {
						console.log("Error:", textStatus, errorThrown);
					}
				});
			});
			
			// 하위코드 추가를 위한 입력행 추가
			$("#addCodeLink").on("click", function() {
				
				if (upCode) {//상위코드가 선택되어 있을 때만 추가 가능
					if ($("#childCodeT").find(".newRow").length === 0) {
						$("#childCodeT").find("td:contains('하위코드를 추가해주세요')").remove();
						
						// 버튼 상태 변경: 코드를 추가하는 버튼은 표시 / 상세정보를 저장하는 버튼은 숨기기
						$("#saveCodeBtn").show();
						$("#saveCodeOneBtn").hide();
						
						// 입력 필드 초기화
						$("#newCode").val('');
						$("#newCodeName").val('');
						   
						// 테이블에 새로운 행 생성
						const newRow = $("<tr>").addClass("newRow");
						
						// 입력 필드를 새로운 행에 추가합니다.
						const CodeInputCell = $("<td>").html('<input type="text" class="uppercase-text" id="newCode">');
						const codeNameInputCell = $("<td>").html('<input type="text" class="newUpCodeName" id="newCodeName">');
						
						newRow.append(CodeInputCell);
						newRow.append(codeNameInputCell);
						
						// 새로운 행을 테이블의 본문에 추가
						$("#childCodeT").append(newRow);
					}
					$("#newCode").focus();
				 } else {
					 alert("상위코드를 먼저 선택해주세요");
				 }
				
			});
			
			// 하위코드 추가
			$("#saveCodeBtn").on("click", function() {
				// 새로운 행에서 데이터를 가져와 변수에 저장
				const parentRow = $(this).closest("tr");
				const newCode = $("#newCode").val().toUpperCase().trim();
				const newCodeName = $("#newCodeName").val().toUpperCase().trim();
					console.log("newCode:" + newCode);
					console.log("newCodeName:" + newCodeName);
			
				// 빈 값 검사
				if (!newCode || !newCodeName) {
					alert("코드, 코드명을 모두 입력해주세요.");
					return; // 사용되지 않은 경우 함수 종료
				}
				
				// 입력한 code가 DB에 code에 있는 값인지 중복 확인
				const inputCode = $("#newCode").val()
				const usedCodes = [];
				$(".codeOneLink").each(function() {
					usedCodes.push($(this).data("code"));
				});
				
				if (usedCodes.includes(inputCode)) {
					alert("이미 존재하는 코드입니다.");
					return; // 사용되지 않은 경우 함수 종료
				}
				console.log("하위코드 추가 upCode:",upCode);
				// 데이터를 서버에 저장하기 전에 필요한 유효성 검사를 수행합니다.
				$.ajax({
					url: "/JoinTree/code/addCommonCode",
					type: "POST",
					data: {
						upCode : upCode,
						code : newCode,
						codeName : newCodeName,
						createId : ${loginAccount.empNo},
						updateId : ${loginAccount.empNo}
					},
					success: function(response) {
						console.log("response:", response);
						
						// 이전 리스트 삭제
						$("#childCodeList").empty();
						
						// 코드 추가 성공 후 리스트 다시 불러오기
						updateCodeList(upCode);
						
						// 입력 필드 초기화
						$("#newCode").val('');
						$("#newCodeName").val('');
						
						// 입력창 숨기기
						$("#newCode").closest("tr").hide();
						
						//실패시
						if(response === "fail") {
							alert("fail");
						}
					},
					error: function(jqXHR, textStatus, errorThrown) {
						console.log("Error:", textStatus, errorThrown);
					}
				});
			});
		/* --------- 추가 끝 --------- */
		
		/* --------- 수정 --------- */
			// 상위코드 수정 -> 사용여부가 변경 될 경우 하위코드도 함께 -> 코드명/ 토글 비동기가 달라야 함 ->
			// 1. 상위코드의 값을 변경
			// 2. 해당 상위코드를 가지고 있는 하위코드의 상태값을 변경
			$("#saveUpCodeOneBtn").on("click", function() {
				const updatedUpCodeName = $("#upCodeNameInput").val();
				// 값이 변화했는지 체크
				const updateUpChecked = $("#upCodeOneList4 .toggleSwitch").prop("checked");
				
				const valueChanged = currentUpCodeName !== updatedUpCodeName || currentUpChecked !== updateUpChecked;
				console.log(" currentChecked", currentChecked);
				console.log(" updateChecked", updateUpChecked);
				if (valueChanged) {
					alert("변경되었습니다.");
					console.log("currentUpCodeName", currentUpCodeName);
					console.log("updatedUpCodeName", updatedUpCodeName);
					console.log("valueChanged currentUpChecked", currentUpChecked);
					console.log("valueChanged updateUpChecked", updateUpChecked);
					currentUpCodeName = updatedUpCodeName; // 변경된 경우에만 변수 갱신
					$.ajax({
						url: "/JoinTree/code/modifyCommonCode",
						type: "POST",
						data: { 
							code: currentUpCode,
							codeName: currentUpCodeName,
							status: updateUpChecked ? "Y" : "N",
							updateId : ${loginAccount.empNo}
						},
						success: function(response) {
								console.log("response:", response);
						
								if (response === "success") {
									updateUpCodeList();
									updateUpCodeDetailView(currentUpCode);
								} else {
									alert("fail");
								}
							},
							error: function(jqXHR, textStatus, errorThrown) {
								console.log("Error:", textStatus, errorThrown);
							}
						});
				} else {
					console.log("No change in values.");
				}
			});
			// 하위코드 수정
			$("#saveCodeOneBtn").on("click", function() {
				const updatedCodeName = $("#codeNameInput").val();
				// 값이 변화했는지 체크
				const updateChecked = $("#chileCodeOneList4 .toggleSwitch").prop("checked");
				
				const valueChanged = currentCodeName !== updatedCodeName || currentChecked !== updateChecked;
				console.log(" currentChecked", currentChecked);
				console.log(" updateChecked", updateChecked);
				if (valueChanged) {
					alert("변경되었습니다.");
					console.log("updatedCodeName", updatedCodeName);
					console.log("currentCodeName", currentCodeName);
					console.log("valueChanged currentChecked", currentChecked);
					console.log("valueChanged updateChecked", updateChecked);
					currentCodeName = updatedCodeName; // 변경된 경우에만 변수 갱신
					$.ajax({
						url: "/JoinTree/code/modifyCommonCode",
						type: "POST",
						data: { 
							code: currentCode,
							codeName: currentCodeName,
							status: updateChecked ? "Y" : "N",
							updateId : ${loginAccount.empNo}
						},
						success: function(response) {
								console.log("response:", response);
						
								if (response === "success") {
									updateCodeDetailView(currentCode);
									updateCodeList(upCode);
								} else {
									alert("fail");
								}
							},
							error: function(jqXHR, textStatus, errorThrown) {
								console.log("Error:", textStatus, errorThrown);
							}
						});
				} else {
					console.log("No change in values.");
				}
			});
		/* --------- 수정 끝 --------- */
	
	});// 마지막 
	</script>
	<!-- 필수 요소-->
	<div class="container-fluid page-body-wrapper">
		<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
			<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
			
				<!-- 컨텐츠 시작 -->
				<div class="row">
					<div class="col-md-6">
						<div class="code">
						<h1>상위코드 리스트</h1>
							<button type="button" id="addUpCodeLink" class="btn btn-sm btn-success right"><i class="mdi mdi-plus"></i></button>
							<button type="button" id="saveUpCodeBtn" class="btn btn-sm btn-success right" style="display: none"><i class="mdi mdi-content-save"></i></button>
	       					<button type="button" id="saveUpCodeOneBtn" class="btn btn-sm btn-success right"><i class="mdi mdi-content-save"></i></button>
							<div class="scrollable-tbody">
								<table class="table table-bordered" id="upCodeT">
									<thead>
										<tr>
											<td>코드</td>
											<td>코드명</td>
											<td>사용여부</td>
										</tr>
									</thead>
									<tbody id="upCodeList">
										<!-- 상위 코드들이 여기에 동적으로 추가 됨 -->
									</tbody>
								</table>
							</div>
						</div>
						<div class="code code-one">
							<h1>상위코드 상세</h1>
							<table id="upCodeOne" class="table table-bordered">
								<tbody>
									<tr>
										<th>상위코드</th>
										<td id="upCodeOneList1"></td>
										<th>코드</th>
										<td id="upCodeOneList2"></td>
									</tr>
									<tr>
										<th>코드명</th>
										<td id="upCodeOneList3"></td>
										<th>사용여부</th>
										<td id="upCodeOneList4"></td>
									</tr>
									<tr>
										<th>생성일</th>
										<td id="upCodeOneList5"></td>
										<th>생성자</th>
										<td id="upCodeOneList6"></td>
									</tr>
									<tr>
										<th>수정일</th>
										<td id="upCodeOneList7"></td>
										<th>수정자</th>
										<td id="upCodeOneList8"></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="col-md-6">
						<div class="code">
						<h1>하위코드 리스트</h1>
							<button type="button" id="addCodeLink" class="btn btn-sm btn-success right"><i class="mdi mdi-plus"></i></button>
							<button type="button" id="saveCodeBtn" class="btn btn-sm btn-success right" style="display: none"><i class="mdi mdi-content-save"></i></button>
							<button type="button" id="saveCodeOneBtn" class="btn btn-sm btn-success right"><i class="mdi mdi-content-save"></i></button>
							<div class="scrollable-tbody">
								<table class="table table-bordered" id="childCodeT">
									<thead>
										<tr>
											<th>코드</th>
											<th>코드명</th>
											<th>사용여부</th>
										</tr>
									</thead>
									
									<tbody id="childCodeList">
										<!-- 하위 코드들이 여기에 동적으로 추가 됨 -->
									</tbody>
								</table>
							</div>
						</div>
						<div class="code code-one">
							<h1>하위코드 상세</h1>
							<table id="codeOne" class="table table-bordered">
								<tbody>
									<tr>
										<th>상위코드</th>
										<td id="chileCodeOneList1"></td>
										<th>코드</th>
										<td id="chileCodeOneList2"></td>
									</tr>
									<tr>
										<th>코드명</th>
										<td id="chileCodeOneList3"></td>
										<th>사용여부</th>
										<td id="chileCodeOneList4"></td>
									</tr>
									<tr>
										<th>생성일</th>
										<td id="chileCodeOneList5"></td>
										<th>생성자</th>
										<td id="chileCodeOneList7"></td>
									</tr>
									<tr>
										<th>수정일</th>
										<td id="chileCodeOneList6"></td>
										<th>수정자</th>
										<td id="chileCodeOneList8"></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div><!-- 컨텐츠 끝 -->
		</div><!-- 컨텐츠전체 끝 -->
	<!-- footer -->
	<jsp:include page="/WEB-INF/view/inc/footer.jsp"/>
</html>
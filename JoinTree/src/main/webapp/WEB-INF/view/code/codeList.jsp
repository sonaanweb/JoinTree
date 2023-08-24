<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<!-- header -->
	<jsp:include page="/WEB-INF/view/inc/header.jsp"/> 
	<script>
		$(document).ready(function() {
			
			// 로딩되자마자 리스트 뿌리기
			fetchUpCodeList();
			
			// 업코드 리스트 비동기로 받아오기
			function fetchUpCodeList() {
				$.ajax({
					url: "/code/upCodeList",
					type: "GET",
					success: function(data) {
						data.forEach(function(upCode) {
							const row = $("<tr>").addClass("upCodeLink").attr("data-code", upCode.code);
							const codeCell = $("<td>").text(upCode.code); // 코드
							const codeNameCell = $("<td>").text(upCode.codeName); // 코드이름
							const toggleValue = upCode.status;
								
							const toggleCell = $("<td>").html(
								'<label class="switch">' +
								'<input type="checkbox" class="toggleSwitch"' + (toggleValue === "Y" ? ' checked' : '') + '>' +
								'<span class="slider round"></span>' +
								'</label>'
							);
								
							row.append(codeCell, codeNameCell, toggleCell); // 행에 셀들 추가
							
							$("#upCodeList").append(row); // 행을 테이블에 추가
						});
					},
					error: function() {
						alert("fail");
					}
				});
			}
			
			// upCodeLink 클릭시 비동기로 childCodeList에서 값을 가져와서 보여줌 
			$(document).on("click", ".upCodeLink", function() {// 여러 개의 요소를 선택하기 위해 클래스를 사용
				// 아래에 지정한 data-code에 값을 가져와서 upCode에 저장
				const upCode = $(this).data("code");
					console.log("Clicked upCode:", upCode); // 디버깅용 로그
				
				$.ajax({
					url: "/code/childCodeList",
					type: "GET",
					dataType: "json",
					data: { upCode: upCode },
					success: function(data) {
						console.log("Response Data:", data);
				
						const childCodeT = $(".childCodes");
						childCodeT.empty(); // 초기화
						
						if (data.length === 0) {
							childCodeT.append("<tr><td colspan=\"3\">하위코드가 추가해주세요</td></tr>");
							return; // 하위 코드가 없으면 여기서 처리 중단
						}
						
						data.forEach(function(childCode) {
							
						    const row = $("<tr>").addClass("codeOneLink").data("code", childCode.code); // 코드 추가
							const codeCell = $("<td>").text(childCode.code); // 코드
							const codeNameCell = $("<td>").text(childCode.codeName); // 코드이름
							const toggleValue = childCode.status;
								// console.log("toggleValue:", toggleValue); // 디버깅용 로그
							const toggleCell = $("<td>").html( // 토글 -> Y일 경우 체크 : 그렇지 않을경우 흰색
								'<label class="switch">' +
								'<input type="checkbox" class="toggleSwitch"' + (toggleValue === "Y" ? ' checked' : '') + '>' +
								'<span class="slider round"></span>' +
								'</label>'
								);
								
							// 같은 열에 추가
							row.append(codeCell); 
							row.append(codeNameCell);
							row.append(toggleCell);
							
							// 추가된 열을 정적으로 해당 테이블에 추가
							childCodeT.append(row);
							
							// 토글의 변경 이벤트 감지 -> 하위코드 상태 수정
							row.find(".toggleSwitch").on("change", function() { // 로우에 있는 토글스위치 찾기 -> 행의 사용여부를 변경하기 위해
								const isChecked = $(this).prop("checked");
								const code = row.data("code");
								console.log(code);
								const newStatus = isChecked ? "Y" : "N";
								
								// AJAX 요청을 통해 서버로 업데이트 요청 보냄
								$.ajax({
									url: "/code/modifyCommonCode",
									type: "POST",
									data: { 
										code: code,
										status: newStatus
									},
									success: function(response) {
										console.log("response:", response);
									
										if(response === "fail") {
											alert("실패");
										}
									},
									error: function(jqXHR, textStatus, errorThrown) {
										console.log("Error:", textStatus, errorThrown);
									}
								});
							});
						});
					},
					// 에러 발생시
					error: function(jqXHR, textStatus, errorThrown) {
						console.log("Error:", textStatus, errorThrown);
					}
				});
			}); // upCodeLink 끝
			
			// 하위코드 클릭 시 상세보기
			// 동적으로 .codeOneLink가 동적으로 추가되어 이벤트 위임을 사용함
			// 부모요소에 이벤트를 등록하고 클릭된 요소에 codeOneLink 클래스를 가졌는지 검사
			$(".wrapper").on("click", ".codeOneLink", function() {
				const code = $(this).find("td:first").text(); // 클릭된 행의 첫 번째 td에 있는 코드 가져오기
				
				$.ajax({
					url: "/code/codeOne",
					type: "GET",
					dataType: "JSON",
					data: {code: code},
					success: function(data) {
						const codeOneT = $(".codeOneT");
						codeOneT.empty(); // 초기화
						
						data.forEach(function(codeOne) {
							const row = $("<tr>");
							const upCodeCell =  $("<td>").text(codeOne.upCode); // 상위코드
							const codeCell = $("<td>").text(codeOne.code); // 코드
							const codeNameCell = $("<td>").text(codeOne.codeName); // 코드이름
							const statusCell = $("<td>").text(codeOne.status); // 코드 상태
							const cratedateCell = $("<td>").text(codeOne.createdate.slice(0,10));
							const updatedateCell = $("<td>").text(codeOne.updatedate.slice(0,10));
							const crateIdCell = $("<td>").text(codeOne.createId);
							const updateIdCell = $("<td>").text(codeOne.updateId);
							
							/* console.log("Clicked codeCell:", codeOne.upCode); // 디버깅용 로그
							console.log("Clicked codeCell:", code); // 디버깅용 로그
							console.log("Clicked codeNameCell:", codeOne.codeName); // 디버깅용 로그
							console.log("Clicked statusCell:", codeOne.status); // 디버깅용 로그
							console.log("Clicked cratedateCell:", codeOne.createdate); // 디버깅용 로그
							console.log("Clicked updatedateCell:", codeOne.updatedate); // 디버깅용 로그
							console.log("Clicked crateIdCell:", codeOne.createId); // 디버깅용 로그
							console.log("Clicked updateIdCell:", codeOne.updateId); // 디버깅용 로그*/
							
							// 행에 셀 추가
							row.append(upCodeCell);
							row.append(codeCell);
							row.append(codeNameCell);
							row.append(statusCell);
							row.append(cratedateCell);
							row.append(updatedateCell);
							row.append(crateIdCell);
							row.append(updateIdCell);
							
							// 추가된 행을 해당 테이블에 추가
							codeOneT.append(row);
						});
					},
					error: function(jqXHR, textStatus, errorThrown) {
						console.log("Error:", textStatus, errorThrown);
					}
				});
			});
			
			// 상위코드 추가를 위한 입력행 추가
			$("#addUpCodeLink").on("click", function() {
				// 버튼 상태 변경: "추가" 버튼을 감추고 "저장" 버튼을 표시
				$("#addUpCodeLink").hide();
				$("#saveUpCodeBtn").show();
				
				// 입력 필드 초기화
				$("#newUpCode").val('');
				$("#newUpCodeName").val('');
				   
				// 테이블에 새로운 행 생성
				const newRow = $("<tr>");
				
				// 입력 필드를 새로운 행에 추가합니다.
				const upCodeInputCell = $("<td>").html('<input type="text" class="uppercase-text" id="newUpCode">');
				const codeNameInputCell = $("<td>").html('<input type="text" class="newUpCodeName" id="newUpCodeName">');
				
				newRow.append(upCodeInputCell);
				newRow.append(codeNameInputCell);
				
				// 새로운 행을 테이블의 본문에 추가
				$("#upCodeT").append(newRow);
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
					url: "/code/addUpCommonCode",
					type: "POST",
					data: {
						code : newUpCode,
						codeName : newUpCodeName,
						createId : id,
						updateId : id
					},
					success: function(response) {
						console.log("response:", response);
						
						// 이전 리스트 삭제
				        $("#upCodeList").empty();
				        // 상위 코드 추가 성공 후 리스트 다시 불러오기
	                    fetchUpCodeList();
				    	 // 입력 필드 초기화
						$("#newUpCode").val('');
						$("#newUpCodeName").val('');
						
						// 입력창 숨기기
						$("#newUpCode").closest("tr").hide();
						
						// 버튼 상태 변경: "추가" 버튼을 보이게 하고 "저장" 버튼을 숨김
						$("#addUpCodeLink").show();
						$("#saveUpCodeBtn").hide();

						/*  // 새로운 상위 코드를 테이블에 추가합니다.
						const newRow = $("<tr>").addClass("upCodeLink").attr("data-code", newUpCode);
						const upCodeCell = $("<td>").addClass("upCode").text(newUpCode);
						const codeNameCell = $("<td>").addClass("upCodeName").text(newUpCodeName);
						const toggleCell = $("<td>").html( // 토글 -> Y일 경우 체크 : 그렇지 않을경우 흰색
							'<label class="switch">' +
							'<input type="checkbox" class="toggleSwitch" checked >' +
							'<span class="slider round"></span>' +
							'</label>'
						 );
	
						// 행에 추가
						newRow.append(upCodeCell);
						newRow.append(codeNameCell);
						newRow.append(toggleCell);
						
						// 새로운 행을 테이블의 상단에 추가합니다.
						$("#upCodeT tbody").append(newRow);
						
						// 입력 필드 초기화
						$("#newUpCode").val('');
						$("#newUpCodeName").val('');
						
						// 입력창 숨기기
						$("#newUpCode").closest("tr").hide();
						
						// 버튼 상태 변경: "추가" 버튼을 보이게 하고 "저장" 버튼을 숨김
						$("#addUpCodeLink").show();
						$("#saveUpCodeBtn").hide();
						 */
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
				// 버튼 상태 변경: "추가" 버튼을 감추고 "저장" 버튼을 표시
				$("#addCodeLink").hide();
				$("#saveCodeBtn").show();
				
				// 입력 필드 초기화
				$("#newCode").val('');
				$("#newCodeName").val('');
				   
				// 테이블에 새로운 행 생성
				const newRow = $("<tr>");
				
				// 입력 필드를 새로운 행에 추가합니다.
				const CodeInputCell = $("<td>").html('<input type="text" class="uppercase-text" id="newCode">');
				const codeNameInputCell = $("<td>").html('<input type="text" class="newUpCodeName" id="newCodeName">');
				
				newRow.append(CodeInputCell);
				newRow.append(codeNameInputCell);
				
				// 새로운 행을 테이블의 본문에 추가
				$("#childCodes").append(newRow);
				$("#newCode").focus();
			});
			
			// 하위코드 추가
			// 하위코드 추가 폼 값 저장
			/* 
			$("#saveCodeBtn").on("click", function() {
				// 새로운 행에서 데이터를 가져와 변수에 저장
				const parentRow = $(this).closest("tr");
				const upCode = $(this).data("code");
					console.log("upCode:"+upCode);
				const newUpCode = $("#newCode").val().toUpperCase().trim();
				const newUpCodeName = $("#newCodeName").val().toUpperCase().trim();
			
				// 빈 값 검사
				if (!newCode || !newCodeName) {
					alert("하위코드, 하위코드명을 모두 입력해주세요.");
					return; // 사용되지 않은 경우 함수 종료
				}
			
				// 입력한 하위코드가 DB에 있는 값인지 중복 확인
				const inputUpCode = $("#newCode").val()
				const usedUpCodes = [];
				$(".upCodeLink").each(function() {
					usedUpCodes.push($(this).data("code"));
				});
				
				if (usedUpCodes.includes(inputUpCode)) {
					alert("이미 존재하는 상위코드입니다.");
					return; // 사용되지 않은 경우 함수 종료
				}
			
				$.ajax({
					url: "/code/addCommonCode",
					type: "POST",
					data: {
						upCode : upCode,
						code : code,
						codeName : codeName,
						createId : id,
						updateId : id
					},
					success: function(response) {
						console.log("response:", response);
						
						alert("상위 코드가 추가되었습니다.");
						
						 // 새로운 상위 코드를 테이블에 추가합니다.
						const newRow = $("<tr>").addClass("upCodeLink").attr("data-code", newUpCode);
						const upCodeCell = $("<td>").addClass("upCode").text(newUpCode);
						const codeNameCell = $("<td>").addClass("upCodeName").text(newUpCodeName);
						const toggleCell = $("<td>").html( // 토글 -> Y일 경우 체크 : 그렇지 않을경우 흰색
							'<label class="switch">' +
							'<input type="checkbox" class="toggleSwitch" checked >' +
							'<span class="slider round"></span>' +
							'</label>'
						 );
	
						// 행에 추가
						newRow.append(codeCell);
						newRow.append(codeNameCell);
						newRow.append(toggleCell);
						
						// 새로운 행을 테이블의 상단에 추가합니다.
						$("#upCodeT tbody").append(newRow);
						
						// 입력 필드 초기화
						$("#newCode").val('');
						$("#newCodeName").val('');
						
						// 입력창 숨기기
						$("#newCode").closest("tr").hide();
						
						// 버튼 상태 변경: "추가" 버튼을 보이게 하고 "저장" 버튼을 숨김
						$("#addCodeLink").show();
						$("#saveCodeBtn").hide();
						
						//실패시
						if(response === "fail") {
							alert("fail");
						}
					},
					error: function(jqXHR, textStatus, errorThrown) {
						console.log("Error:", textStatus, errorThrown);
					}
				});
			}); */
			
			/* // 코드 추가 클릭시 비동기로 값을 저장
			$("#addCodeLink").on("click", function() {
				const upCode = $("#upCode").val().toUpperCase().trim(); // upcode를 대문자(toUpperCase)로 변환 및 양끝 공백을 뺀(trim) 값
				const code = $("#code").val().toUpperCase().trim(); // code를 대문자(toUpperCase)로 변환 및 양끝 공백을 뺀(trim) 값
				const codeName = $("#codeName").val().trim(); //codeName의 양끝 공백을 뺀(trim) 값
				
				// 입력한 upCode 가져오기
				const inputUpCode = $("#upCode").val().toUpperCase().trim();
				
				// upCode 값들 가져오기
				const usedUpCodes = [];
				$(".upCodeLink").each(function() {
				    usedUpCodes.push($(this).data("code"));
				});
				
				// 빈 값 검사
				if (!upCode || !code || !codeName) {
				    alert("상위코드, 코드, 코드명을 모두 입력해주세요.");
				    return; // 사용되지 않은 경우 함수 종료
				}
				
				// 입력한 upCode가 DB에 upCode 값 중 하나인지 확인
				if (!usedUpCodes.includes(inputUpCode)) {
				    alert("입력한 상위코드는 존재하지 않는 상위코드입니다.");
				    return; // 사용되지 않은 경우 함수 종료
				}
	
				$.ajax({
					url: "/code/addCommonCode",
					type: "POST",
					data: {
						upCode : upCode,
						code : code,
						codeName : codeName,
						createId : id,
						updateId : id
					},
					success: function(response) {
						console.log("response:", response);
						
						alert("공통 코드가 추가되었습니다.");
						
						if(response === "fail") {
							alert("fail");
						}
	
						// 입력 폼 초기화
						$("#upCode").val('');
						$("#code").val('');
						$("#codeName").val('');
					},
					error: function(jqXHR, textStatus, errorThrown) {
						console.log("Error:", textStatus, errorThrown);
					}
				});
			});
			 */
		    // upCodeLink를 클릭하면 추가 업코드에 내용 입력
		    $(".upCodeLink").on("click", function() {
		        // 클릭한 링크의 데이터 가져오기
		        const upCode = $(this).data("code");
	
		        // 값을 추가테이블 값 중 상위코드와 코드에 넣어주기
		        $("#upCode").val(upCode);
		        $("#code").val(upCode);
		    });
		});
	</script>
	<!-- 필수 요소-->
	<div class="container-fluid page-body-wrapper">
		<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
			<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
			
				<!-- 컨텐츠 시작 -->
				<div class="row">
					<div class="col-md-6">
						<div class="code">
						<h1>공통코드 리스트</h1>
							<button type="button" id="addUpCodeLink" class="btn btn-sm btn-success right"><i class="mdi mdi-plus"></i></button>
	       					<button type="button" id="saveUpCodeBtn" class="btn btn-sm btn-success right" style="display: none;"><i class="mdi mdi-content-save"></i></button>
							<div class="scrollable-tbody">
								<table class="table table-bordered" id="upCodeT">
									<thead>
										<tr>
											<td>상위코드</td>
											<td>상위코드명</td>
											<td>상태</td>
										</tr>
									</thead>
									<tbody id="upCodeList">
										<!-- 상위 코드들이 여기에 동적으로 추가 됨 -->
									</tbody>
								</table>
							</div>
						</div>
					</div>
					<div class="col-md-6">
						<div class="code">
						<h1>상세코드 리스트</h1>
							<button type="button" id="addCodeLink" class="btn btn-sm btn-success right"><i class="mdi mdi-plus"></i></button>
							<button type="button" id="saveCodeBtn" class="btn btn-sm btn-success right" style="display: none;"><i class="mdi mdi-content-save"></i></button>
							<div class="scrollable-tbody">
								<table class="table table-bordered" id="childCodes">
									<thead>
										<tr>
											<th>코드</th>
											<th>코드명</th>
											<th>사용여부</th>
										</tr>
									</thead>
									
									<tbody class="childCodes">
										<!-- 하위 코드들이 여기에 동적으로 추가 됨 -->
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
					<div class="">
						<div class="code-one">
							<table id="codeOne" class="table table-bordered">
								 <thead>
								 	<tr>
										<th>상위코드</th>					
										<th>코드</th>
										<th>코드명</th>
										<th>사용여부</th>
										<th>생성일</th>
										<th>수정일</th>
										<th>생성자</th>
										<th>수정자</th>
									</tr>
								 </thead>
								 <tbody class="codeOneT">
								 
								 </tbody>
								
							</table>
						</div>
					</div>
				
				
				<!-- <div class="add-code">
					<h1>코드 추가하기</h1>
					<button type="button" id="addCodeLink" class="btn btn-success left">추가</button>
					<table class="table">
						<thead>
							<tr>
								<th>상위코드</th>
								<th>코드</th>
								<th>코드명</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td> 
									<input type="text" id="upCode" class="uppercase-text">
								</td>
								<td> 
									<input type="text" id="code" class="uppercase-text">
								</td>
								<td> 
									<input type="text" id="codeName">
								</td>
							</tr>
						</tbody>
					</table>
				</div> -->
					
			</div><!-- 컨텐츠 끝 -->
		</div><!-- 컨텐츠전체 끝 -->
	<!-- footer -->
	<jsp:include page="/WEB-INF/view/inc/footer.jsp"/>
</html>
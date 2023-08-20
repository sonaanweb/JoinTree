<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>JoinTree</title>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<link rel="stylesheet" href="/resource/css/style.css">
	<link rel="stylesheet" href="/resource/css/style2.css">
<script>
	$(document).ready(function() {
		const id = "11111111";
       
		// upCodeLink 클릭시 비동기로 childCodeList에서 값을 가져와서 보여줌 
		$(".upCodeLink").on("click", function() {// 여러 개의 요소를 선택하기 위해 클래스를 사용
			
			// 아래에 지정한 data-code에 값을 가져와서 upCode에 저장
			const upCode = $(this).data("code");
				// console.log("Clicked upCode:", upCode); // 디버깅용 로그
			
			$.ajax({
				url: "/code/childCodeList",
				type: "GET",
				dataType: "json",
				data: { upCode: upCode },
				success: function(data) {
					//console.log("Response Data:", data);
			
					const childCodeT = $(".childCodes");
					childCodeT.empty(); // 초기화
					
					data.forEach(function(childCode) {
						
						const row =  $("<tr>").addClass("codeOneLink");
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
				
						// 토글의 변경 이벤트 감지 -> 수정
	                    toggleCell.find(".toggleSwitch").on("change", function() {
	                        const isChecked = $(this).prop("checked");
	                        const newStatus = isChecked ? "Y" : "N";

	                        // AJAX 요청을 통해 서버로 업데이트 요청 보냄
	                        $.ajax({
	                            url: "/code/modifyCommonCode",
	                            type: "POST",
	                            data: { code: childCode.code, 
	                            		status: newStatus, 
	                            		updateId: id},
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
							
						// 같은 열에 추가
						row.append(codeCell); 
						row.append(codeNameCell);
						row.append(toggleCell);
						
						// 추가된 열을 정적으로 해당 테이블에 추가
						childCodeT.append(row);
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
		        success: function(data) { // 오타 수정: success
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

		// 코드 추가 클릭시 비동기로 값을 저장
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
<body>
<div class="container-scroller"> <!-- 전체 스크롤 -->
	<div class="container-fluid page-body-wrapper"><!-- 상단제외 -->
	<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 위왼쪽 사이드바 -->
		<div class = "main-panel"> <!-- 컨텐츠 전체 -->
			<div class="content-wrapper"> <!-- 컨텐츠 -->
			
				<div class="wrapper">
					<div class="up-code">
						<table class="table table-bordered">
							<thead>
								<tr>
									<th>상위코드</th>
									<th>상위코드명</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="up" items="${upCodeList}">
									<tr class="upCodeLink" data-code="${up.code}">
										<!-- data-code는 data속성으로 code라는 이름으로 데이터를 가지고 있음 -->
										<td>
											${up.code}
										</td>
										<td>
											${up.codeName}
										</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
					
					<div class="child-code">
						<table id="childCodes" class="table table-bordered">
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
				
				<div class="add-code">
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
				</div>
				
			</div><!-- 컨텐츠 끝 -->
		</div><!-- 컨텐츠전체 끝 -->
	</div><!-- 상단제외 끝 -->
</div><!-- 전체 스크롤 끝 -->
<jsp:include page="/WEB-INF/view/inc/footer.jsp"/>
</body>
</html>
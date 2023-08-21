<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<!-- jQuery 라이브러리 -->
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	
	<!-- 부트스트랩 CSS CDN -->
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css">
	
	<!-- 부트스트랩 JavaScript 및 의존성 라이브러리 CDN -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"></script>
	
	<!-- jQuery 트리뷰 및 쿠키 라이브러리 -->
	<script src="/resource/lib/jquery.cookie.js" type="text/javascript"></script>
	<script src="/resource/lib/jquery.treeview.js" type="text/javascript"></script>
	
	<!-- 기타 스타일 시트 -->
	<link rel="stylesheet" href="/resource/jquery.treeview.css">
	<link rel="stylesheet" href="/resource/screen.css">
<script>
	$(document).ready(function() {
		// 트리뷰 초기 설정

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
		// modalBtn 클릭 시 모달 띄우기
		$("#modalBtn").on("click", function() {
			alert("성공");
			$("#myModal").modal("show");
		});
     
		// 클릭한 li 값에 따라 처리
		const selectedEmps = []; // 선택한 부서 번호를 저장하는 배열
				
		$("body").on("click", ".file.code", function() {
			const selectedEmpNo = $(this).data("no");
			const selectedEmpName = $(this).data("name");
			const selectedEmpPosition = $(this).data("position");
			
			if (!selectedEmps.includes(selectedEmpName + " " +selectedEmpPosition + "(" + selectedEmpNo + ")") && selectedEmps.length < 2) {
				selectedEmps.push(selectedEmpName + " " +selectedEmpPosition + "(" + selectedEmpNo + ")"); // 한 번에 추가
			
			// 선택한 번호 저장
			updateSelectEmp(); // selectEmp 업데이트
			// 모달 닫기
			$("#myModal").modal("hide");
			} else if (selectedEmps.includes(selectedEmpName + " " +selectedEmpPosition + "(" + selectedEmpNo + ")")) {
				alert("이미 선택한 번호입니다.");
			} else {
				alert("최대 두 명까지만 선택 가능합니다.");
			}
		
		});
		
		// 선택한 사원 삭제
		$("#deleteSelectedBtn").on("click", function() {
			const checkedCheckboxes = $(".empCheckbox:checked");
			checkedCheckboxes.each(function() {
				const selectedEmp = $(this).data("no");
				const index = selectedEmps.indexOf(selectedEmp);
				if (index !== -1) {
					selectedEmps.splice(index, 1); // 선택한 번호 삭제
				}
			});
			updateSelectEmp(); // selectEmp 업데이트
		});
		
		// 위로 버튼을 클릭하면 선택한 사원을 위로 이동하는 기능 추가
		$("#moveUpBtn").on("click", function() {
		    const selectedEmp = $(".empCheckbox:checked").data("no");
		    const selectedIndex = selectedEmps.indexOf(selectedEmp);
		    if (selectedIndex > 0) {
		        const temp = selectedEmps[selectedIndex];
		        selectedEmps[selectedIndex] = selectedEmps[selectedIndex - 1];
		        selectedEmps[selectedIndex - 1] = temp;
		        updateSelectEmp();
		    }
		});

		// 아래로 버튼을 클릭하면 선택한 사원을 아래로 이동하는 기능 추가
		$("#moveDownBtn").on("click", function() {
		    const selectedEmp = $(".empCheckbox:checked").data("no");
		    const selectedIndex = selectedEmps.indexOf(selectedEmp);
		    if (selectedIndex >= 0 && selectedIndex < selectedEmps.length - 1) {
		        const temp = selectedEmps[selectedIndex];
		        selectedEmps[selectedIndex] = selectedEmps[selectedIndex + 1];
		        selectedEmps[selectedIndex + 1] = temp;
		        updateSelectEmp();
		    }
		});
   
		// selectEmp 업데이트 함수
		function updateSelectEmp() {
			const selectEmp = $("#selectEmp");
			selectEmp.empty();
			for (const emp of selectedEmps) {
				const selectedEmpItem =  '<div class="selectedEmp">'+ emp +'<input type="checkbox" class="empCheckbox" data-no="'+ emp +'"></div>';
				selectEmp.append(selectedEmpItem);
			}
		}
		
		$("#codeList").treeview({ collapsed: true });

	}); // 제일 처음
</script>
</head>
<body>
<div class="container-scroller"> <!-- 전체 스크롤 -->
	<div class="container-fluid page-body-wrapper"><!-- 상단제외 -->
	<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 위왼쪽 사이드바 -->
		<div class = "main-panel"> <!-- 컨텐츠 전체 -->
			<div class="content-wrapper"> <!-- 컨텐츠 -->
			
				<div>
					<button type="button" id="modalBtn">결재선 추가</button>	
				</div>
				
				<div id="selectEmp" style="border: 1px solid #999; width:200px; height: 200px;"><!-- 여기에 데이터를 추가하는 부분 --></div>
				<button type="button" id="deleteSelectedBtn">삭제</button>
				<button type="button" id="moveUpBtn">위로</button>
				<button type="button" id="moveDownBtn">아래로</button>
				
			</div><!-- 컨텐츠 끝 -->
		</div><!-- 컨텐츠전체 끝 -->
	</div><!-- 상단제외 끝 -->
</div><!-- 전체 스크롤 끝 -->

<div class="modal" id="myModal" tabindex="-1">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">결재선</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				
				<div class="modal-body">
					<ul id="codeList">
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
    
</body>
</html>

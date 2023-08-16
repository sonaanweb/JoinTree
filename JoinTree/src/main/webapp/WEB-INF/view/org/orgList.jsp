<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/resource/jquery.treeview.css" />
<link rel="stylesheet" href="/resource/screen.css" />

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="/resource/lib/jquery.cookie.js" type="text/javascript"></script>
<script src="/resource/lib/jquery.treeview.js" type="text/javascript"></script>
<script>
	$(document).ready(function() {
		// 트리뷰 초기 설정
		$("#codeList").treeview({ collapsed: true });
		
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
						const li = '<li><a href="#" data-no="'+ empNo +'" class="file code">' + empName + "(" + empNo +  ", " + empPosition + ")" + '</a></li>';
						deptLi.find("ul").append(li); // ul을 찾아서 li를 추가
					});
				}
			});
		});
		// 사원 클릭 시 이벤트 추가
		// 온클릭으로 클래스가 .file.code를 가진 a태그를 찾아 처리
	    $("body").on("click", ".file.code", function() {
	        const empNo = $(this).data("no"); // data-no 속성 값을 가져옴
	        // 클릭한 사원의 empNo를 이용하여 원하는 동작을 수행
	        alert("선택한 사원번호: " + empNo);
	    });
	});
</script>
</head>
<body>
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
</body>
</html>

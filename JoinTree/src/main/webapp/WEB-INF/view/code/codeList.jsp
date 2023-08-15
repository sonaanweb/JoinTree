<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JoinTree</title>
<style>
    /* 스위치 스타일 */
    .switch {
        position: relative;
        display: inline-block;
        width: 40px;
        height: 20px;
    }
    
    .switch input {
        opacity: 0;
        width: 0;
        height: 0;
    }
    
    .slider {
        position: absolute;
        cursor: pointer;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background-color: #ccc;
        -webkit-transition: .4s;
        transition: .4s;
    }
    
    .slider:before {
        position: absolute;
        content: "";
        height: 16px;
        width: 16px;
        left: 2px;
        bottom: 2px;
        background-color: white;
        -webkit-transition: .4s;
        transition: .4s;
    }
    
    input:checked + .slider {
        background-color: #2196F3;
    }
    
    input:focus + .slider {
        box-shadow: 0 0 1px #2196F3;
    }
    
    input:checked + .slider:before {
        -webkit-transform: translateX(20px);
        -ms-transform: translateX(20px);
        transform: translateX(20px);
    }
    
    /* 원형 스위치 */
    .slider.round {
        border-radius: 34px;
    }
    
    .slider.round:before {
        border-radius: 50%;
    }
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
	$(document).ready(function() {
		// upCodeLink 클릭시 비동기로 childCodeList에서 값을 가져와서 보여줌 
		$(".upCodeLink").on("click", function() {// 여러 개의 요소를 선택하기 위해 클래스를 사용
			// 아래에 지정한 data-code에 값을 가져와서 upCode에 저장
			const upCode = $(this).data("code");
			console.log("Clicked upCode:", upCode); // 디버깅용 로그
		
			$.ajax({
				url: '/code/childCodeList',
				type: "GET",
				dataType: "json",
				data: { upCode: upCode },
				success: function(data) {
					console.log("Response Data:", data);
			
					const childCodes = $(".childCodes");
					childCodes.empty();
					
					data.forEach(function(childCode) {
						const row = $("<tr>"); // 열 변경
						const codeCell = $("<td>").text(childCode.code); // 코드
						const codeNameCell = $("<td>").text(childCode.codeName); // 코드이름
						const toggleCell = $("<td>").html( // 토글
							'<label class="switch">' +
							'<input type="checkbox" class="toggleSwitch">' +
							'<span class="slider round"></span>' +
							'</label>'
						  );
						// 같은 열에 추가
						row.append(codeCell); 
						row.append(codeNameCell);
						row.append(toggleCell);
						
						// 추가된 열을 최정적으로 해당 테이블에 추가
						childCodes.append(row);
					});
				},
				// 에러 발생시
				error: function(jqXHR, textStatus, errorThrown) {
				console.log("Error:", textStatus, errorThrown);
				}
			});
		}); // upCodeLink 끝
	});
</script>
<body>
<div>	
	<div style="float: left;">
		<table border="1">
			<thead>
				<tr>
					<th>상위코드</th>
					<th>상위코드명</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="up" items="${upCodeList}">
					<tr>
						<!-- data-code는 data속성으로 code라는 이름으로 데이터를 가지고 있음 -->
						<td>
							<a href="#" class="upCodeLink" data-code="${up.code}">${up.code}</a>
						</td>
						<td>
							<a href="#" class="upCodeLink" data-code="${up.code}">${up.codeName}</a>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
	
	<div style="float: left; margin-left:10px;">
		<table border="1" id="childCodes">
			<thead>
				<tr>
					<th>코드</th>
					<th>코드명</th>
					<!-- 사용여부는 y/n으로 변경예정 -->
					<th>사용여부</th>
				</tr>
			</thead>
			
			<tbody class="childCodes">
				<!-- 하위 코드들이 여기에 동적으로 추가 됨 -->
			</tbody>
		</table>
	</div>
</div>
</body>
</html>
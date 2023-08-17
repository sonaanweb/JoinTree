<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>[경영지원]회의실 관리</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<!--------- 관리 회의실 리스트 ---------->
	<a href="/equipment/addMeetRoom">추가</a>
	<table>
		<thead><!-- 열 제목 -->
			<tr>
				<td>회의실 번호</td>
				<td>기자재카테고리</td><!-- 추후 view에서 삭제 -->
				<td>회의실이름</td>
				<td>수용인원</td>
				<td>사용여부</td>
			</tr>
		</thead>
		<tbody>
		    <c:forEach var="m" items="${meetRoomList}">
		        <tr data-roomNo="${m.roomNo}" class="data-row"> <!-- 데이터 식별 -->
		            <td>${m.roomNo}</td>
		            <td>${m.equipCategory}</td>
		            <td>
		                <span class="normal">${m.roomName}</span>
		                <input type="text" class="edit-input" name="editedRoomName" value="${m.roomName}" style="display: none;">
		            </td>
		            <td>
		                <span class="normal">${m.roomCapacity}명</span>
		                <input type="text" class="edit-input" name="editedRoomCapacity" value="${m.roomCapacity}" style="display: none;">
		            </td>
		            <td>
		                <span class="normal">
		                    <c:choose>
		                        <c:when test="${m.roomStatus == 1}">사용가능</c:when>
		                        <c:when test="${m.roomStatus == 0}">사용불가</c:when>
		                    </c:choose>
		                </span>
						<select class="edit-select" name="editedRoomStatus" style="display: none;">
						    <c:choose>
						        <c:when test="${m.roomStatus == 1}">
						            <option value="1" selected>사용가능</option>
						            <option value="0">사용불가</option>
						        </c:when>
						        <c:otherwise>
						            <option value="1">사용가능</option>
						            <option value="0" selected>사용불가</option>
						        </c:otherwise>
						    </c:choose>
						</select>
		            </td>
		            <td>
		                <button class="edit-button" data-roomNo="${m.roomNo}">수정</button>
		                <button class="save-button" data-roomNo="${m.roomNo}" style="display: none;">저장</button>
		            </td>
		        </tr>
		    </c:forEach>
		</tbody>
	</table>
<script>
    const dataRows = document.querySelectorAll('.data-row'); // tr 내로 묶인 data-row 요소 모두 선택
    
    dataRows.forEach(row => {
        const editButton = row.querySelector('.edit-button');
        const saveButton = row.querySelector('.save-button');
        const normalCells = row.querySelectorAll('.normal');
        const editInputs = row.querySelectorAll('.edit-input');
        const editSelects = row.querySelectorAll('.edit-select');
        
        // 수정 버튼을 클릭했을 때
        editButton.addEventListener('click', function() {
        	// 목록 조회시 나타났던 데이터를 숨김
            normalCells.forEach(cell => cell.style.display = 'none');
         	// 수정용 입력 필드와 선택 필드 표시
            editInputs.forEach(input => input.style.display = 'block');
            editSelects.forEach(select => select.style.display = 'block');
         	// 수정 버튼을 숨기고 저장 버튼 표시
            editButton.style.display = 'none';
            saveButton.style.display = 'block';
        });
        
     	// 수정된 데이터를 서버로 전송하는 로직
        saveButton.addEventListener('click', function() {
            
            // 일반 데이터를 표시하고     
            normalCells.forEach(cell => cell.style.display = 'block');
         	// 수정용 입력 필드와 선택 필드를 숨김 ( 위와 반대 )
            editInputs.forEach(input => input.style.display = 'none');
            editSelects.forEach(select => select.style.display = 'none');
            
         	// 저장 버튼을 숨기고 수정 버튼을 표시
            editButton.style.display = 'block';
            saveButton.style.display = 'none';
            
            const roomNo = row.getAttribute('data-roomNo');
            const editedRoomName = row.querySelector('input[name="editedRoomName"]').value;
            const editedRoomCapacity = row.querySelector('input[name="editedRoomCapacity"]').value;
            const editedRoomStatus = row.querySelector('select[name="editedRoomStatus"]').value;
            
            const xhr = new XMLHttpRequest();
            xhr.open('POST', '/equipment/meetRoomList', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    // 서버로부터 응답을 받았을 때의 로직
                    // 예를 들어, 성공 시 메시지를 표시하거나 다시 목록으로 리다이렉트 등
                    console.log('데이터가 수정되었습니다.');
                    location.reload(); // 수정 후 새로고침
                }
            };
            const formData = `roomNo=${roomNo}&editedRoomName=${editedRoomName}&editedRoomCapacity=${editedRoomCapacity}&editedRoomStatus=${editedRoomStatus}`;
            xhr.send(formData);
        });
    });
</script>
</body>
</html>

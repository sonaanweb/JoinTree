<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>[경영관리]회의실 추가</title>
</head>
<body>
   <form action="${pageContext.request.contextPath}/equipment/addMeetRoom" method="post">
   <input type="hidden" name="createId" value="1111"> <!-- testId -->
   <input type="hidden" name="updateId" value="1111">
   
        <label for="roomName">회의실명:</label>
        <input type="text" id="roomName" name="roomName" required><br>
        
        <label for="roomCapacity">수용인원:</label>
        <input type="number" id="roomCapacity" name="roomCapacity" required><br>
        
        <label for="roomStatus">상태:</label>
        <select id="roomStatus" name="roomStatus" required>
        	<option value="1">사용 가능</option>
            <option value="0">사용 불가</option>
        </select><br>
        
        <input type="submit" value="추가">
    </form>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>modifyFreeComm</title>
	</head>
	<body>
		<a href="/community/freeCommList/freeCommOne?boardNo=${comm.boardNo}">이전</a>
	
		<h1>게시글 수정</h1>
		
		<!-- 추후 삭제 -->
		<div>
			부서코드: ${dept}
		</div>		
		
		<div>
			카테고리: 자유게시판
		</div>
		
		<form action="/community/freeCommList/modifyFreeComm" method="post">
			<input type="hidden" name="boardNo" value="${comm.boardNo}">
			<input type="hidden" name="empNo" value="${loginAccount.empNo}">
			<input type="hidden" name="boardCategory" value="B0103">
			<div>
				<c:if test="${dept eq 'D0202'}">	
					게시판 상단고정 <input type="checkbox" name="boardPinned" <c:if test="${comm.boardPinned eq '1'}">checked</c:if>> <!-- 기존 상단고정 상태일 경우 체크박스 선택하여 출력 -->
				</c:if>
			</div>
			<table border="1">
				<tr>
					<!-- <th>제목</th> -->
					<td><input type="text" name="boardTitle" value="${comm.boardTitle}"></td>
				</tr>
				<tr>
					<!-- <th>내용</th> -->
					<td>
						<textarea name="boardContent" rows="4" cols="50">${comm.boardContent}</textarea>
					</td>
				</tr>
				<tr>
					<!-- <th>첨부파일</th> -->
					<td>
				    	<c:choose>
					        <c:when test="${boardFile.boardSaveFilename eq null or boardFile.boardSaveFilename == '이미지 없음'}">
					        	<input type="file">
					        	<button type="button">이미지 추가</button>
					        </c:when>
					        <c:otherwise>
					            <img src="${pageContext.request.contextPath}/commImg/${boardFile.boardSaveFilename}" style="width: 300px; height: auto;"><br>
					       	    <button type="button">이미지 삭제</button>
					        </c:otherwise>
					    </c:choose>
					</td>
				</tr>
			</table>
			<div>
				<button type="submit" id="modifyFreeCommBtn">수정</button>
			</div>
		</form>
	</body>
</html>
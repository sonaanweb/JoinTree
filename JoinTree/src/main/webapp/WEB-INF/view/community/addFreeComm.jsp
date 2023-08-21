<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>addFreeComm</title>
		<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
	    <script>
	        $(document).ready(function() {
	        	const urlParams = new URL(location.href).searchParams;
				const msg = urlParams.get("msg");
					if (msg != null) {
						alert(msg);
					}
					
				const fileInput = $('#fileInput');
		        const previewImage = $('#previewImage');
		            
		        // 파일 선택 시 미리보기
	            fileInput.change(function() {
	                const file = fileInput.prop('files')[0]; // 선택한 파일 객체 가져오기
	                if (file) {
	                    const reader = new FileReader(); // FileReader 객체 생성
	                    reader.onload = function(e) { // 파일 읽기 완료 후 실행될 함수 정의
	                    	// 미리보기 이미지의 'src' 속성을 읽은 파일 내용으로 설정
	                        previewImage.attr('src', e.target.result); 
	                    };
	                    reader.readAsDataURL(file); // 파일을 데이터 URL로 읽기 시작
	                } else {
	                    previewImage.attr('src', ''); // 파일이 선택되지 않았을 때 미리보기 초기화
	                }
	            });
	        	
				// textarea에 placeholder과 비슷한 기능 적용
	            function setPlaceholder(element, placeholder) {
	                element.val(placeholder).css('color', 'gray');
	                
	                element.focus(function() {
	                    if (element.val() === placeholder) {
	                        element.val('').css('color', 'black');
	                    }
	                });
	                
	                element.blur(function() {
	                    if (element.val() === '') {
	                        element.val(placeholder).css('color', 'gray');
	                    }
	                });
	            }
	            
	            setPlaceholder($('#content'), '내용을 입력해주세요.');
	        });
	    </script>
	</head>
	<body>
		<h1>게시글 입력</h1>
		<div>
			부서코드: ${dept}
		</div>		
		
		<div>
			카테고리: 자유게시판
		</div>
		<form action="/community/freeCommList/addFreeComm" method="post" enctype="multipart/form-data" id="addFreeComm">
			<div>
				<c:if test="${dept eq 'D0202'}">	
					게시판 상단고정 <input type="checkbox" name="boardPinned"> <!-- value 지정하지 않았을 경우 체크박스 선택 시 boardPinned="on" 과 같이 넘어감 -->
 				</c:if>
			</div>
			<input type="hidden" name="empNo" value="${loginAccount.empNo}">
			<input type="hidden" name="boardCategory" value="B0103">
			<table border="1">
				<tr>
					<td><input type="text" name="boardTitle" placeholder="제목을 입력해주세요."></td>
				</tr>
				<tr>
					<td>
						<textarea id="content" name="boardContent" rows="4" cols="50">
						</textarea>
					</td>
				</tr>
				<tr>
					<td>
						<input type="file" name="multipartFile" id="fileInput">
						<button type="button" id="removeBtn">파일 삭제</button>
						파일 첨부 (3MB 이하의 이미지 파일만 가능합니다.)<br>
						<img id="previewImage" src="" style="max-width: 300px; max-height: 300px;">
					
					</td>
				</tr>
			</table>
			<button type="submit">게시글 등록</button>
		</form>
	</body>
</html>
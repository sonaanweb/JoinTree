<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>testDocument</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
</head>
<body>
	<div>
		<select id="slectDocument" name="document">
			<option value="">선택하세요</option>
			<c:forEach var="d" items="${documentCodeList}">
				<option value="${d.code}">${d.codeName}</option>
			</c:forEach>
		</select>
	</div>
	
	<div id="documentForm">
		
	</div>
</body>
<script>
	
	// slectDocument 옵션 변경시 이벤트
	$('#slectDocument').change(function(){
		let selectedValue = $(this).val();
		console.log(selectedValue);
		updateSelectDocument(selectedValue);
	});
	
	function updateSelectDocument(selectForm){
		$.ajax({
			type: 'GET',
			url: '/document/getDocumentForm',
			data: {
				selectedForm: selectForm
			},
			success: function(data){
				$('#documentForm').html(data);
			},
			error: function(){
				console.log('Error loading document form content.');
			}
		});
	}
</script>
</html>
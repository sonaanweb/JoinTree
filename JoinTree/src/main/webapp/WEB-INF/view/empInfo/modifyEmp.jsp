<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>modifyEmp</title>
		<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script>
		// 입력폼 유효성 검사
		$(document).ready(function(){
			$('#btn').click(function(){
				if($('#sample6_postcode').val() == ''){
					alert('우편번호를 입력해주세요');
				} else if($('#sample6_address').val() == ''){
					alert('주소를 입력해주세요');
				} else if($('#sample6_detailAddress').val() == ''){
					alert('상세주소를 입력해주세요');
				} else {
					$('#modifyAddress').submit();
				}
			});
		});
		
		// 주소API
		var themeObj = {
		 		   searchBgColor: "#F24182", 
		 		   queryTextColor: "#FFFFFF" 
		 		};
	    function sample6_execDaumPostcode() {
	        new daum.Postcode({
	            oncomplete: function(data) {
	                var addr = ''; 
	                var extraAddr = ''; 
	                if (data.userSelectedType === 'R') { 
	                    addr = data.roadAddress;
	                } else { 
	                    addr = data.jibunAddress;
	                }
	                if(data.userSelectedType === 'R'){
	                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
	                        extraAddr += data.bname;
	                    }
	                    if(data.buildingName !== '' && data.apartment === 'Y'){
	                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
	                    }
	                    if(extraAddr !== ''){
	                        extraAddr = ' (' + extraAddr + ')';
	                    }
	                    document.getElementById("sample6_extraAddress").value = extraAddr;
	                
	                } else {
	                    document.getElementById("sample6_extraAddress").value = '';
	                }
	                document.getElementById('sample6_postcode').value = data.zonecode;
	                document.getElementById("sample6_address").value = addr;
	                document.getElementById("sample6_detailAddress").focus();
	            },
	            theme: themeObj
	        }).open();
	    }
	</script>
	</head>
	<body>
		<h1>나의 정보 수정</h1>
		<table border="1">
			<tr>
				<td>이름</td>
				<td></td>
			</tr>
			<tr>
				<td>사진</td>
				<td><input type="file"></td>
			</tr>
			<tr>
				<td>주소</td>
				<td>
				<section class="bg0 p-t-75 p-b-116">
				<div class="container">
					<div class="size-210 bor10 p-lr-70 p-t-55 p-b-70 p-lr-15-lg w-full-md cen">
						<form action="" method="post" id="modifyAddress">
							<div class="bor8 m-b-20 how-pos4-parent">
								<input class="mtext-107 cl2 plh3 size-116 p-l-62 p-r-30"  type="text" id="sample6_postcode" name="postcode" placeholder="우편번호">
							</div>
							<div class="bor8 m-b-20 how-pos4-parent">
								<input class="mtext-107 cl2 plh3 size-116 p-l-62 p-r-30"  type="button" onclick="sample6_execDaumPostcode()" value="우편번호 찾기">
							</div>
							<div class="bor8 m-b-20 how-pos4-parent">
								<input class="mtext-107 cl2 plh3 size-116 p-l-62 p-r-30"  type="text" id="sample6_address" name="address" placeholder="주소">
							</div>
							<div class="bor8 m-b-20 how-pos4-parent">
								<input class="mtext-107 cl2 plh3 size-116 p-l-62 p-r-30"  type="text" id="sample6_detailAddress" name="detailAddress" placeholder="상세주소">
							</div>
							<div class="bor8 m-b-20 how-pos4-parent">
								<input class="mtext-107 cl2 plh3 size-116 p-l-62 p-r-30"  type="text" id="sample6_extraAddress" name="extraAddress" placeholder="참고항목">
							</div>
						</form>
						<br>
					</div>
				</div>
			</section>
						
				</td>
			</tr>
			<tr>
				<td>주민등록번호</td>
				<td>
					<input type="text"> &#45;  <input type="text">
				</td>
			</tr>
			<tr>
				<td>연락처</td>
				<td>
					<input type="text"> &#45;  <input type="text"> &#45;  <input type="text">
				</td>
			</tr>
		</table>
		<button id="modifyEmpBtn">정보 수정</button>
		
		<div>
			<a href="/empInfo/empInfo">이전</a>
		</div>
	</body>
</html>
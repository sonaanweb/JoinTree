<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>modifyEmp</title>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
		<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
		<script>
			// 입력폼 유효성 검사
			$(document).ready(function(){
				const urlParams = new URL(location.href).searchParams;
				const msg = urlParams.get("msg");
					if (msg != null) {
						alert(msg);
					}
					
				// 사진 등록 버튼 클릭 시 팝업 창 열기
				$('#uploadImgBtn').click(function() {
					console.log("사진 등록 버튼이 클릭되었습니다."); 
				    openUploadImgPopup();
				});
			
				let uploadPopup; // 팝업 창을 함수 외부에 선언
				// 사진 등록 팝업 열기 함수
				function openUploadImgPopup() {
					uploadPopup = window.open("", "UploadImgPopup", "width=500,height=400,scrollbars=yes,resizable=yes");
				    
				    // 팝업 내용 작성
				    var uploadPopupContent = "<h2>사진 등록</h2>" +
				    				   "<p>파일 크기는 3MB 이하로 제한됩니다.</p>" +
				                       "<form id='uploadImgForm' enctype='multipart/form-data'>" +
				                       "   <input type='file' name='uploadImg' accept='image/jpg, image/jpeg, image/png'>" +
				                       "   <img id='previewImg' src='' alt='Image Preview' style='max-width: 300px; max-height: 300px; display: none;'>" +
				                       "   <button type='button' onclick='uploadImage()''>등록</button>" +
				                       "</form>";
				    
                    uploadPopup.document.write(uploadPopupContent);
				    uploadPopup.document.close();
				}
				
				// 파일 선택 시 미리보기 (사진 등록)
				$('#uploadImg').change(function() {
				    var input = this;
				    if (input.files && input.files[0]) {
				        var reader = new FileReader();
				        reader.onload = function(e) {
				        	console.log("미리보기 이미지가 업데이트되었습니다."); // 디버그 메시지
				            // 미리보기 이미지 업데이트
				            $('#previewImg').attr('src', e.target.result).show();
				        };
				        reader.readAsDataURL(input.files[0]);
				    }
				});
				
				// 사진 등록 처리 함수
				function uploadImage() {
					 console.log("사진 업로드 함수가 호출되었습니다."); // 디버그 메시지
				    // var formData = new FormData(popup.document.getElementById('uploadImgForm'));
				    
				    var formData = new FormData();
				    var fileInput = document.getElementById('uploadImg');
				    formData.append('newImgFile', fileInput.files[0]);
				    
				    
				    // AJAX 요청
				    $.ajax({
				    	url: '/myJoinTree/empInfo/modifyEmp/uploadEmpImg',
				    	type: 'post', 
				    	data: formData, 
				    	processData: false, // false로 선언 시 formData를 string으로 변환하지 않음
				    	contentType: false, // false로 선언 시 content-type 헤더가 multipart/form-data로 전송되게 함
				    	success: function(response) {
				    		if (response === "success") {
				    			alert("사진 등록이 완료되었습니다.");
				    			location.reload(); // 현재 메인 페이지 새로고침(팝업 X)
				    		} else {
				    			alert("사진 등록 중 오류가 발생했습니다.");
				    		}
				    	},
				    	error: function(error) {
				    		alert("서버 오류 발생");
				    	}
				    	
				    });
				    
				    // 이미지 업로드 후 팝업 창을 닫습니다
				    uploadPopup.close();
				}
				
				// 사진 변경 버튼 클릭 시 팝업 창 열기
				$('#modifyImgBtn').click(function() {
					 console.log("정보 수정 버튼이 클릭되었습니다."); // 디버그 메시지
				    openModifyImgPopup();
				});
				
				let modifyPopup;
				
			  	// 사진 변경 팝업 열기 함수
			    function openModifyImgPopup() {
			    	modifyPopup = window.open("", "ModifyImgPopup", "width=500,height=400,scrollbars=yes,resizable=yes");
			
			        // 팝업 내용 작성
			        var modifypopupContent = "<h2>사진 변경</h2>" +
			        				   "<p>파일 크기는 3MB 이하로 제한됩니다.</p>" +
			                           "<form id='modifyImgForm' enctype='multipart/form-data'>" +
			                           "   <img id='modifyPreviewImage' src='' alt='Image Preview' style='max-width: 300px; max-height: 300px; display: none;'>" +
			                           "   <input type='file' name='modifyImage' accept='image/jpg, image/jpeg, image/png'>" +
			                           "   <input type='button' value='등록' onclick='uploadImgModify()'>" +
			                           "</form>";
			
                    modifyPopup.document.write(modifypopupContent);
                    modifyPopup.document.close();
				}
			  	
			 	// 파일 선택 시 미리보기 (사진 변경)
			    $('#newImageInput').change(function() {
			        var input = this;
			        if (input.files && input.files[0]) {
			            var reader = new FileReader();
			            reader.onload = function(e) {
			                // 미리보기 이미지 업데이트
			                $('#modifyPreviewImage').attr('src', e.target.result).show();
			            };
			            reader.readAsDataURL(input.files[0]);
			        }
			    });
				
			  	
			    // 사진 변경 업로드 처리 함수
			    function uploadImgModify() {
			        var formData = new FormData(popup.document.getElementById('modifyImgForm'));
			        
			        // AJAX 요청
			        $.ajax({
			        	url: '/myJoinTree/empInfo/modifyEmp/modifyEmpImg',
			        	type: 'POST',
			        	data: formData,
			        	processData: false,
			        	contentType: false,
			        	success: function(response) {
			        		if (response === "success") {
			        			alert("사진 변경이 완료되었습니다.");
			        		} else {
			        			alert("사진 변경 중 오류가 발생했습니다.");
			        		}
			        		
			        	},
			        	error: function(error) {
			        		alert("서버 오류 발생");
			        	}
			        });
			        
			        // 이미지 업로드 후 팝업 창을 닫기
			        modifyPopup.close();
			        
		            // 이미지 미리보기 업데이트
		            var modifyPreviewImage = $('#modifyPreviewImage');
		            modifyPreviewImage.attr('src', ''); // 기존 이미지 초기화
		            modifyPreviewImage.hide(); // 미리보기 숨김

		            // empInfo/empInfo 페이지 새로고침
		            location.reload();
			    }	
				
				// 이름 칸은 문자만 입력 허용
				$("#empName").on("keypress", function(event) {
				    // ASCII 코드 값이 숫자 범위(48~57)인 경우 입력 막음
				    if (event.which >= 48 && event.which <= 57) {
				        event.preventDefault();
				    }
				});
				
				// 주민번호, 연락처 칸은 숫자만 입력 허용
		       	$("[id^='empJuminNo'], [id^='empPhone']").on("keypress", function(event) {
		       		if ((event.which < 48 || event.which > 57) && event.which !== 8) {
		                return false;
		            }
		        });
				
				// 정보 수정 버튼 클릭 시 
				$("#modifyEmpBtn").click(function() {
					if ($("#empName").val() == "") {
						alert("이름을 입력해주세요.");
						$("#empName").focus();
					} else if ($("#sample6_postcode").val() == "") {
						alert("우편번호를 입력해주세요.");
						$("#sample6_postcode").focus();
					} else if ($("#sample6_address").val() == "") {
						alert("주소를 입력해주세요.");
						$("#sample6_address").focus();
					} else if ($("#sample6_detailAddress").val() == "") {
						alert("상세주소를 입력해주세요.");
						$("#sample6_detailAddress").focus();
					} else if ($("#sample6_extraAddress").val() == "") {
						alert("참고항목을 입력해주세요.");
						$("#sample6_extraAddress").focus();
					} else if ($("#empJuminNo1").val() == "") {
						alert("주민등록번호 앞자리를 입력해주세요.");
						$("#empJuminNo1").focus();
					} else if ($("#empJuminNo2").val() == "") {
						alert("주민등록번호 뒷자리를 입력해주세요.");
						$("#empJuminNo2").focus();
					} else if ($("#empPhone1").val() == "") {
						alert("연락처 첫 번째 칸을 입력해주세요.");
						$("#empPhone1").focus();
					} else if ($("#empPhone2").val() == "") {
						alert("연락처 두 번째 칸을 입력해주세요.");
						$("#empPhone2").focus();
					} else if ($("#empPhone3").val() == "") {
						alert("연락처 세 번째 칸을 입력해주세요.");
						$("#empPhone3").focus();
					} else {
						$("#modifyEmp").submit();
					}
				});
		
				
			});
			
			// 주소API
			var themeObj = {
			 		  // searchBgColor: "#F24182", 
			 		  // queryTextColor: "#FFFFFF" 
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
		<form action="/empInfo/modifyEmp" method="post" id="modifyEmp">
			<table border="1">
				<tr>
					<td>이름</td>
					<td><input type="text" name="empName" value="${empInfo.empName}" id="empName"></td>
				</tr>
				<tr>
					<td>사진</td>
					<td>
						
						<img id="imgPreview" src="" alt="image preview" style="max-width: 300px; max-height: 300px; display: none;">
						
						<!-- type="button" 없을 경우 액션 폼 제출되는 현상 주의  -->
						<c:choose>
							<c:when test="${empty empInfo.empSaveImgName or empInfo.empSaveImgName == '이미지 없음'}">
								<input type="file" id="newImageInput" accept="image/jpg, image/jpeg, image/png" style="display: none;"> &nbsp;
								<button type="button" id="uploadImgBtn">사진 등록</button>
							</c:when>
							<c:otherwise>
								<img src="${pageContext.request.contextPath}/empImg/${empInfo.empSaveImgName}" alt="employee image"><br>
								<span>변경 전 이미지</span><br>
								<input type="file" id="newImageInput" accept="image/jpg, image/jpeg, image/png" style="display: none;"> &nbsp;
								<button type="button" id="modifyImgBtn">사진 변경</button>	
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
				<tr>
					<!-- 주소 문자열을 address에 저장  -->
					<c:set var="address" value="${empInfo.empAddress}"/>
					<!-- 첫 번째 '-'의 위치를 찾아 firstDashIndex에 저장-->
				    <c:set var="firstDashIndex" value="${fn:indexOf(address, '-')}"/>
				    <!-- firstDashIndex 위치부터 첫 번째 '-'의 위치를 찾아 secondDashIndex에 저장 -->
				    <c:set var="secondDashIndex" value="${address.indexOf('-', firstDashIndex + 1)}"/>
				    <!-- 6번째 문자열부터 두 번째 '-'이전까지 추출하여 extractedAddress에 저장 -->
				    <c:set var="extractedAddress" value="${address.substring(6, secondDashIndex)}"/>
				    <!-- 두 번째 '-' + 1의 자리부터 마지막까지의 부분을 extractedAddress2에 저장 -->
					<c:set var="extractedAddress2" value="${address.substring(secondDashIndex + 1)}"/>
					<!-- extractedAddress2에서 '-' 이전까지만 추출 후 양쪽 공백을 제거하여 finalExtractedAddress에 저장 -->
					<c:set var="finalExtractedAddress" value="${fn:substringBefore(extractedAddress2, '-').trim()}" />
					<td>주소</td>
					<td>
					<section class="bg0 p-t-75 p-b-116">
					<div class="container">
						<div class="size-210 bor10 p-lr-70 p-t-55 p-b-70 p-lr-15-lg w-full-md cen">
	
								<div class="bor8 m-b-20 how-pos4-parent">
									<input class="mtext-107 cl2 plh3 size-116 p-l-62 p-r-30" type="text" value="${empInfo.empAddress.substring(0, 5)}" id="sample6_postcode" name="zip" placeholder="우편번호">
								</div>
								<div class="bor8 m-b-20 how-pos4-parent">
									<input class="mtext-107 cl2 plh3 size-116 p-l-62 p-r-30" type="button" onclick="sample6_execDaumPostcode()" value="우편번호 찾기">
								</div>
								<div class="bor8 m-b-20 how-pos4-parent">
								    <input class="mtext-107 cl2 plh3 size-116 p-l-62 p-r-30" type="text" value="${extractedAddress}" id="sample6_address" name="add1" placeholder="주소">
								</div>
								<div class="bor8 m-b-20 how-pos4-parent">
									<input class="mtext-107 cl2 plh3 size-116 p-l-62 p-r-30" type="text" value="${finalExtractedAddress}" id="sample6_detailAddress" name="add2" placeholder="상세주소">
								</div>
								<div class="bor8 m-b-20 how-pos4-parent">
									<input class="mtext-107 cl2 plh3 size-116 p-l-62 p-r-30" type="text" value="${empInfo.empAddress.substring(empInfo.empAddress.indexOf('('))}" id="sample6_extraAddress" name="add3" placeholder="참고항목">
								</div>
							<br>
						</div>
					</div>
				</section>
							
					</td>
				</tr>
				<tr>
					<td>주민등록번호</td>
					<td>
						<input type="text" value="${empInfo.empJuminNo.substring(0, 6)}" name="empJuminNo1" id="empJuminNo1" maxlength="6"> 
						<span id="empJuminNoMsg" style="color: red; display: none;">주민등록번호 앞자리는 6자리까지 입력 가능합니다.</span>&#45;
					  	<input type="text" value="${empInfo.empJuminNo.substring(7)}" name="empJuminNo2" id="empJuminNo2" maxlength="7">
					</td>
				</tr>
				<tr>
					<td>연락처</td>
					<td>
						<input type="text" value="${empInfo.empPhone.substring(0, 3)}" name="empPhone1" id="empPhone1" maxlength="3"> &#45;  
						<input type="text" value="${empInfo.empPhone.substring(4, 8)}" name="empPhone2" id="empPhone2" maxlength="4"> &#45;  
						<input type="text" value="${empInfo.empPhone.substring(9)}" name="empPhone3" id="empPhone3" maxlength="4">
					</td>
				</tr>
			</table>
			<br>
			<button type="button" id="modifyEmpBtn">정보 수정</button>
		</form>
		
		<div>
			<a href="/empInfo/empInfo">이전</a>
		</div>
	</body>
</html>
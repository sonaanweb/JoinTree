<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
	<!-- header -->
	<jsp:include page="/WEB-INF/view/inc/header.jsp"/> 
		<script src="https://cdnjs.cloudflare.com/ajax/libs/signature_pad/1.5.3/signature_pad.min.js"></script>
		<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
		<script>
			// 입력폼 유효성 검사
			$(document).ready(function(){
				const urlParams = new URL(location.href).searchParams;
				const msg = urlParams.get("msg");
					if (msg != null) {
						alert(msg);
					}
					
				const fileInput = $('#fileInput');
		        const previewImage = $('#previewImage');	
		        const currentImage = $('#currentImage');
		        const currentImageTxt = $('#currentImageTxt');
		        
		        const removeBtn = $('#removeBtn');
				
		     	// 초기에 파일 삭제 버튼 숨기기
		     	removeBtn.hide();
		    
		     	// 파일 선택 시 미리보기, 파일 크기 검사, 파일 확장자 검사
		        fileInput.change(function() {
		            const file = fileInput.prop('files')[0]; // 선택한 파일 객체 가져오기
		            if (file) {
		                const reader = new FileReader();
		                reader.onload = function(e) {
		                    previewImage.attr('src', e.target.result);
		                    currentImage.hide(); // 기존 이미지 감추기
		                    // currentImageTxt.hide(); // 기존 이미지 글씨 감추기
		                    // previewImage.show(); // 미리보기 이미지 보이기
		                    previewImage.attr('src', e.target.result); 
		                };
		                reader.readAsDataURL(file); // 파일을 데이터 URL로 읽기 시작
		            
		            	// 파일 크기, 확장자 검사
		            	const fileSize = file.size;
		            	const maxSize = 3 * 1024 * 1024; // 3MB
		            	const allowedExtensions = ['.jpg', '.jpeg', '.png', 'gif', '.bmp'];
		            	const fileExtensions = file.name.substr(file.name.lastIndexOf('.')).toLowerCase();
		            	
		            	if (fileSize > maxSize) {
		            		alert("파일 크기가 3MB를 초과합니다.");
		            		fileInput.val(''); // 파일 선택 초기화
		            		previewImage.attr('src', ''); // 미리보기 초기화
		            	} else if (!allowedExtensions.includes(fileExtensions)) {
		            		alert("이미지 파일만 첨부 가능합니다.");
	                    	fileInput.val(''); // 파일 선택 초기화
	                    	previewImage.attr('src', ''); // 미리보기 초기화
		            	} else {
		            		// 파일 선택 시 파일 삭제 버튼 표시
		            		removeBtn.show();
		            	}
		            
		            } else {
		                previewImage.attr('src', '');
		                currentImage.show(); // 기존 이미지 보이기
		                // currentImageTxt.show(); // 기존 이미지 글씨 보이기
		                previewImage.hide(); // 미리보기 이미지 감추기
		                
		            }
		        });
		     	
		     	// 파일 삭제 버튼 클릭 시 파일 선택 초기화
		     	removeBtn.click(function() {
		     		fileInput.val(''); // 파일 선택 초기화
		     		previewImage.attr('src', ''); // 미리보기 초기화
		     		removeBtn.hide(); // 파일 삭제 버튼 숨기기
		     	});
		        
		        // 사진 등록 버튼 클릭되었을 때
		        $("#uploadImgBtn").click(function() {
		        	console.log("사진 등록 버튼 클릭");
		        	// 입력 요소에서 선택한 파일 가져옴
		        	const file = $("#fileInput")[0].files[0];
		        	
		        	if (file) {
		        		const formData = new FormData();
		        		formData.append("uploadImg", file); // FormData 객체에 파일 추가
		        	
		        	
			        	// 서버로 AJAX 요청
			        	$.ajax({
			        		url: "/JoinTree/empInfo/modifyEmp/uploadEmpImg",
			        		type: "POST",
			        		data: formData, 
			        		processData: false, // false로 선언 시 formData를 string으로 변환하지 않음
			        		contentType: false, // false로 선언 시 content-type 헤더가 multipart/form-data로 전송되게 함
			        		success: function(response) {
			        			console.log(response);
			        	 		if (response === "success") {
					    			alert("사진이 등록되었습니다.");
					    			// 서버에서 새로 업데이트된 이미지 경로로 뷰 업데이트
					                $("#currentImage").attr("src", response.newImagePath);
					    			location.reload(); // 현재 메인 페이지 새로고침
					    		} else {		
			        	 			alert("사진 등록 중 오류가 발생했습니다.");
					    		}
			        		}, 
			        		error: function(error) {
			        			alert("서버 오류 발생");
			        		}	
			        	});
		        	} else {
		        		alert("업로드할 사진을 선택해주세요.");
		        	}
		        });
		        
		        // 사진 삭제 버튼 클릭되었을 때
		        $("#removeImgBtn").click(function() {
		        	console.log("사진 삭제 버튼 클릭");
		        	if (confirm("사진이 완전히 삭제됩니다.")) {
		        		 $.ajax({
				                url: "/JoinTree/empInfo/modifyEmp/removeEmpImg", // 적절한 서버 엔드포인트로 변경
				                type: "POST",
				                success: function(response) {
				                    console.log(response);
				                    if (response === "success") {
				                        alert("사진이 삭제되었습니다.");
				                        // 서버에서 삭제된 이미지 경로로 뷰 업데이트
				                        $("#currentImage").attr("src", "");
				                        $("#currentImage").hide();
				                        $("#currentImageTxt").hide();
				                        
				                        location.reload(); // 페이지 새로고침
				                    } else {
				                        alert("사진 삭제 중 오류가 발생했습니다.");
				                    }
				                },
				                error: function(error) {
				                    alert("서버 오류 발생");
				                }
				            });
		        		}
		        });
		       	  
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
						alert("사원 정보가 변경되었습니다.");
						$("#modifyEmp").submit();
					}
				});
				
				// 서명 그리기 기능
		        let goal = $("#goal")[0]; // goal의 첫 번째 배열값
		        let uploadSignImg = new SignaturePad(goal, {minWidth: 2, maxWidth: 2, penColor: 'rgb(0, 0, 0)'});
		        
		    	$("#clear").click(function() {
		    		console.log("clear 버튼 클릭");
		    		uploadSignImg.clear();
				});
		    	
		    	$("#save").click(function() { // 이미지 보여주기
		    		console.log("save 버튼 클릭");
					if (uploadSignImg.isEmpty()) {
						alert("내용이 없습니다.");
					} else {
						let data = uploadSignImg.toDataURL("image/png"); // 캐시 URL 가져오기
						$("#target").attr("src", data); // 이미지 파일의 경로를 위 URL로 설정
					}
				});
		    	
				$("#send").click(function() { // 저장
					console.log("send 버튼 클릭");
					if (uploadSignImg.isEmpty()) {
						alert("내용이 없습니다.");
					} else {
						if (confirm("서명을 등록하시겠습니까? 서명은 최초 1회만 등록 가능합니다.")) {
							$.ajax({
								url : "/JoinTree/empInfo/modifyEmp/uploadSignImg",
								data : {uploadSignImg : uploadSignImg.toDataURL("image/png", 1.0)},
								type : "post",
								success : function(jsonData) { // jsonData: 서버로부터 받아온 응답 데이터 (변수명 변경 가능)
									alert("서명 저장 성공 " + jsonData);
									location.reload(); // 현재 화면 새로고침
								}
							});
						}
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

		<div class="container-fluid page-body-wrapper">
		<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
			<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
				<div class="col-lg-12 grid-margin stretch-card">
              	<div class="card">
                <div class="card-body">
				<h2 class="card-title">게시글 작성</h2>
	
				<div>
					<a href="/JoinTree/empInfo/empInfo" class="btn btn-outline-success btn-sm">이전</a>
				</div>
				<h1>나의 정보 수정</h1>
				<form action="/JoinTree/empInfo/modifyEmp" method="post" id="modifyEmp">
					<table class="table">
						<tr>
							<td>이름</td>
							<td><input type="text" name="empName" value="${empInfo.empName}" id="empName" class="form-control w-25"></td>
						</tr>
						<tr>
							<td>사진</td>
							<td>
								<!-- type="button" 없을 경우 액션 폼 제출되는 현상 주의  -->
								<c:choose>
									<c:when test="${empty empInfo.empSaveImgName or empInfo.empSaveImgName == '이미지 없음'}">
										<input type="file" name="multipartFile" id="fileInput" accept="image/jpg, image/jpeg, image/png, image/gif, image/bmp"><br>
										<img id="previewImage" src="" style="max-width: 300px; max-height: 300px;"><br>
										<button type="button" id="removeBtn">파일 삭제</button>
										<button type="button" id="uploadImgBtn">사진 등록</button>
										<div>
											* 사진 선택 후 사진 등록 버튼을 클릭해야 사진이 저장됩니다. 
										</div>
									</c:when>
									<c:otherwise>
										<img src="${pageContext.request.contextPath}/empImg/${empInfo.empSaveImgName}" alt="employee image" id="currentImage" style="max-width: 300px; max-height: 300px;"><br>
										<!-- <span id="currentImageTxt">기존 이미지</span><br> -->
										<!-- <img id="previewImage" src="" style="max-width: 300px; max-height: 300px;"><br> -->
										<br>
										<button type="button" id="removeImgBtn">사진 삭제</button>	
										<div>
											* 사진 삭제 버튼 클릭 시 등록된 사진이 완전히 삭제됩니다. 
										</div>
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
											<input class="mtext-107 cl2 plh3 size-116 p-l-62 p-r-30 form-control w-25" type="text" value="${empInfo.empAddress.substring(0, 5)}" id="sample6_postcode" name="zip" placeholder="우편번호">
										</div>
										<div class="bor8 m-b-20 how-pos4-parent">
											<input class="mtext-107 cl2 plh3 size-116 p-l-62 p-r-30 btn btn-success w-25" type="button" onclick="sample6_execDaumPostcode()" value="우편번호 찾기">
										</div>
										<div class="bor8 m-b-20 how-pos4-parent">
										    <input class="mtext-107 cl2 plh3 size-116 p-l-62 p-r-30 form-control w-25" type="text" value="${extractedAddress}" id="sample6_address" name="add1" placeholder="주소">
										</div>
										<div class="bor8 m-b-20 how-pos4-parent">
											<input class="mtext-107 cl2 plh3 size-116 p-l-62 p-r-30 form-control w-25" type="text" value="${finalExtractedAddress}" id="sample6_detailAddress" name="add2" placeholder="상세주소">
										</div>
										<div class="bor8 m-b-20 how-pos4-parent">
											<input class="mtext-107 cl2 plh3 size-116 p-l-62 p-r-30 form-control w-25" type="text" value="${empInfo.empAddress.substring(empInfo.empAddress.indexOf('('))}" id="sample6_extraAddress" name="add3" placeholder="참고항목">
										</div>
									<br>
								</div>
							</div>
						</section>
									
							</td>
						</tr>
						<tr>
							<td>주민등록번호</td>
							<td class="form-inline">
								<input type="text" value="${empInfo.empJuminNo.substring(0, 6)}" name="empJuminNo1" id="empJuminNo1" maxlength="6" class="form-control w-25"> 
								<span id="empJuminNoMsg" style="color: red; display: none;">주민등록번호 앞자리는 6자리까지 입력 가능합니다.</span>&#45;
							  	<input type="text" value="${empInfo.empJuminNo.substring(7)}" name="empJuminNo2" id="empJuminNo2" maxlength="7" class="form-control w-25">
							</td>
						</tr>
						<tr>
							<td>연락처</td>
							<td class="form-inline">
								<input type="text" value="${empInfo.empPhone.substring(0, 3)}" name="empPhone1" id="empPhone1" maxlength="3" class="form-control w-25"> &#45;  
								<input type="text" value="${empInfo.empPhone.substring(4, 8)}" name="empPhone2" id="empPhone2" maxlength="4" class="form-control w-25"> &#45;  
								<input type="text" value="${empInfo.empPhone.substring(9)}" name="empPhone3" id="empPhone3" maxlength="4" class="form-control w-25">
							</td>
						</tr>
						<tr>
							<td>서명</td>
							<td>						
								<c:choose>
									<c:when test="${empty empInfo.signSaveImgName or empInfo.signSaveImgName == '이미지 없음'}">
										<canvas id="goal" width="500" height="200" style="border: 1px solid black"></canvas>
										<div>
											<!-- <img id="target" src="" style="width: 500px; height: 200px;">	 -->	
										</div>
										<div>
											* 서명 등록은 최초 1회만 가능합니다. 
										</div>
										<img id="previewImage2" src="" style="max-width: 300px; max-height: 300px;"><br>
										<!-- <button type="button" id="save">미리보기</button> --> <!-- 이미지 보여주기  -->
										<button type="button" id="clear">입력란 지우기</button> <!-- 이미지 삭제   -->
										<button type="button" id="send">서명 등록</button>
										<!-- <button type="button" id="uploadSignImgBtn">서명 등록(전송)</button> -->
									</c:when>
									<c:otherwise>
										<img src="${pageContext.request.contextPath}/signImg/${empInfo.signSaveImgName}" alt="sign image" id="currentSignImage" style="max-width: 300px; max-height: 300px;"><br>
										<!-- <span id="currentImageTxt">기존 이미지</span><br> -->
										<img id="previewImage2" src="" style="max-width: 300px; max-height: 300px;"><br>
										<!-- <button type="button" id="remove">서명 삭제</button>	 -->
									</c:otherwise>
								</c:choose>
							</td>
						</tr>
					</table>
					<br>
					<button type="button" id="modifyEmpBtn" class="btn btn-success btn-fw">정보 수정</button>
				</form>
				
				
				</div>
				</div>
				</div>
		</div>
	</div>
</html>
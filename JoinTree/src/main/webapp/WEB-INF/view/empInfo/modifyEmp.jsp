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
		<script src="/JoinTree/resource/js/empInfo/modifyEmp.js"></script>
		<script>
			
		</script>

		<div class="container-fluid page-body-wrapper">
		<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
			<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
				<div class="col-lg-12 grid-margin stretch-card">
              	<div class="card">
                <div class="card-body">
			
				<div>
					<a href="/JoinTree/empInfo/empInfo" class="btn btn-outline-success btn-sm">이전</a>
				</div><br>
				<div class="col d-flex align-items-center">
					<h3>나의 정보 수정</h3>
				</div><br>
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
										<button type="button" id="removeBtn" class="btn btn-success btn-sm">미리보기 삭제</button>
										<button type="button" id="uploadImgBtn" class="btn btn-success btn-sm">사진 등록</button><br>
										
										<div>
											* 사진 선택 후 사진 등록 버튼을 클릭해야 사진이 저장됩니다. 
										</div>
									</c:when>
									<c:otherwise>
										<img src="${pageContext.request.contextPath}/empImg/${empInfo.empSaveImgName}" alt="employee image" id="currentImage" style="max-width: 300px; max-height: 300px;"><br>
										<!-- <span id="currentImageTxt">기존 이미지</span><br> -->
										<!-- <img id="previewImage" src="" style="max-width: 300px; max-height: 300px;"><br> -->
										<br>
										<button type="button" id="removeImgBtn" class="btn btn-success btn-sm">사진 삭제</button>	
										<br>
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
						    <c:set var="firstDashIndex" value="${fn:indexOf(address, '/')}"/>
						    <!-- firstDashIndex 위치부터 첫 번째 '-'의 위치를 찾아 secondDashIndex에 저장 -->
						    <c:set var="secondDashIndex" value="${address.indexOf('/', firstDashIndex + 1)}"/>
						    <!-- 6번째 문자열부터 두 번째 '-'이전까지 추출하여 extractedAddress에 저장 -->
						    <c:set var="extractedAddress" value="${address.substring(6, secondDashIndex)}"/>
						    <!-- 두 번째 '-' + 1의 자리부터 마지막까지의 부분을 extractedAddress2에 저장 -->
							<c:set var="extractedAddress2" value="${address.substring(secondDashIndex + 1)}"/>
							<!-- extractedAddress2에서 '-' 이전까지만 추출 후 양쪽 공백을 제거하여 finalExtractedAddress에 저장 -->
							<c:set var="finalExtractedAddress" value="${fn:substringBefore(extractedAddress2, '/').trim()}" />
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
										<canvas id="goal" width="500" height="250" style="border: 1px solid #ebedf2"></canvas>
									<!-- 	<div>
											<img id="target" src="" style="width: 500px; height: 200px;">		
										</div> -->
										<br>
										<div>
											* 서명 등록은 최초 1회만 가능합니다. 
										</div>
										<img id="previewImage2" src="" style="max-width: 300px; max-height: 300px;"><br>
										<!-- <button type="button" id="save">미리보기</button> --> <!-- 이미지 보여주기  -->
										<button type="button" id="clear" class="btn btn-success btn-sm">입력란 지우기</button> <!-- 이미지 삭제   -->
										<button type="button" id="send" class="btn btn-success btn-sm">서명 등록</button>
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
	<!-- footer -->
	<jsp:include page="/WEB-INF/view/inc/footer.jsp"/>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>	
	<!-- css - 우선순위를 위해 한 번 더 -->
	<link rel="stylesheet" href="/JoinTree/resource/css/style2.css">
	<link rel="stylesheet" href="/JoinTree/resource/css/style.css">
	<script>
		$(document).ready(function() {
			const today = new Date();
			const year = today.getFullYear();
			const month = String(today.getMonth() + 1).padStart(2, '0'); // 0부터 시작하므로 1을 더해준다
			const day = String(today.getDate()).padStart(2, '0');
			const formattedDate = year + "-" + month + "-" + day;
			
			$("#draftDate").val(formattedDate); // 오늘날짜 출력
			
			$('#docOriginFilename').on("change", function() {
				const selectedFile = event.target.files[0];
				console.log("selectedFile", selectedFile);
			
				if (selectedFile) {
					const allowedFormats = ['jpg', 'jpeg', 'png', 'zip', 'pdf'];
					const fileExtension = selectedFile.name.slice(selectedFile.name.lastIndexOf('.') + 1).toLowerCase();
					console.log("파일 들어옴",fileExtension);
				
					if (allowedFormats.includes(fileExtension)) {
						console.log("파일 정상");
					} else {
						$('#docOriginFilename').val('');
						console.log("파일 비정상");
					}
				}
			});
		});
	</script>
<div class="doc">
	<h1 class="center">인사이동신청서</h1>
	<table class="table doc-title">
		<tbody>
			<tr>
				<td rowspan="4">
					<table class="table">
						<tbody>
							<tr>
								<td>문서번호</td>
								<td><input type="text" readonly="readonly"></td>
							</tr>
							
							<tr>
								<td>기안부서</td>
								<td><input type="text" readonly="readonly" value="${empInfo.dept}"></td>
							</tr>
							
							<tr>
								<td>기안일</td>
								<td><input type="text" readonly="readonly" id="draftDate"></td>
							</tr>
							
							<tr>
								<td>기안자</td>
								<td><input type="text" readonly="readonly" value="${empInfo.empName}"></td>
							</tr>
						</tbody>
					</table>
				</td>
				
				<td class="blank"></td>
				
				<td class="sign">
					<input type="hidden" id="createId" name="createId" readonly="readonly" value="${empInfo.empNo}">
					<input type="hidden" id="updateId" name="updateId" readonly="readonly" value="${empInfo.empNo}">
					<input type="hidden" id="empNo" name="empNo" readonly="readonly" value="${empInfo.empNo}">
					<input type="text" id="empName" name="writer" readonly="readonly" value="${empInfo.empName}&nbsp;${empInfo.position}">
				</td>
				<td class="sign"><input type="text" id="signer1" readonly="readonly"></td>
				<td class="sign"><input type="text" id="signer2" readonly="readonly"></td>
			</tr>
			<tr>
				<td class="blank"></td>
				<td class="sign" rowspan="3" style="width: 100px; height: 100px;">
					<input type="hidden" id="docStamp1" name="docStamp1" value="${signImg}">
					<img src="${pageContext.request.contextPath}/signImg/${signImg}" style="width: 100px; height: 70px;">
				</td>
				<td class="sign" rowspan="3" style="width: 100px; height: 100px;">
					<input type="hidden" id="docStamp2" name="docStamp2">
				</td>
				<td class="sign" rowspan="3" style="width: 100px; height: 100px;">
					<input type="hidden" id="docStamp3" name="docStamp3">
				</td>
			</tr>
			<tr></tr>
			<tr></tr>
		</tbody>
	</table>
 
	
	<!-- 내용 -->
	<table class="table doc-comment">
		<tbody>
			<!-- 직접 입력불가 -->
			<tr>
				<td>
					참조자
				</td>
				<td>
					<input type="text" readonly="readonly" id="reference">
				</td>
			</tr>
			
			<tr>
				<td>
					수신팀
				</td>
				<td>
					<input type="text" readonly="readonly" id="receiverTeam">
				</td>
			</tr>
			<!-- 이동일자 -->
			<tr>
				<td>
					이동일자
				</td>
				<td>
					<input type="date" id="docReshuffleDate">
				</td>
			</tr>
		</tbody>
	</table>
	
	<h4>[직급변경]</h4>
	<table class="table doc-comment">
		<tbody>
			<tr>
				<td>
					사원명
				</td>
				<!-- 사원명 -->
				<td>
					${empInfo.empName}
				</td>
			<tr>
				<td>
					변경 전 직급
				</td>
				<!-- 변경 전 직급 -->
				<td>
					${empInfo.position}
				</td>
				
			</tr>
			<tr>
				<td>
					변경 후 직급
				</td>
				<!-- 변경 후 직급 -->
				<td>
					<c:forEach var="p" items="${positionList}">
						<input type="radio" name="docReshufflePosition" id="docReshufflePosition" value="${p.code}" style="display: inline-block; margin-right: 10px;">${p.codeName}
					</c:forEach>
				</td>
			</tr>
		</tbody>
	</table>

	<h4>[부서변경]</h4>
	<table class="table doc-comment">
		<tbody>
			<tr>
				<td>
					사원명
				</td>
				<!-- 사원명 -->
				<td>
					${empInfo.empName}
				</td>
			</tr>
			<tr>
				<td>
					변경 전 부서
				</td>
				<!-- 변경 전 부서 -->
				<td>
					${empInfo.dept}
				</td>
				
			</tr>
				
			<tr>
				<td>
					변경 후 부서
				</td>
				<!-- 변경 후 부서 -->
				<td>
					<c:forEach var="d" items="${deptList}">
						<input type="radio" name="docReshuffleDept" id="docReshuffleDept" value="${d.code}" style="display: inline-block; margin-right: 10px;">${d.codeName}
					</c:forEach>
				</td>
			</tr>
		</tbody>
	</table>

	<table class="table doc-comment">
	<!-- 주요 업무 -->
		<tr>
			<td>
				주요 업무
			</td>
			<td>
				<textarea id="docReshuffleTask"></textarea> 
			</td>
		</tr>

	<!-- 업무 성과 -->
		<tr>
			<td>
				업무 성과
			</td>
			<td>
				<textarea id="docReshuffleResult"></textarea> 
			</td>
		</tr>

	<!-- 발령사유 -->
		<tr>
			<td>
				발령 사유
			</td>
			<td>
				<textarea id="docReshuffleReason"></textarea> 
			</td>
		</tr>

	<!-- 첨부파일 추가 -->
		<tr>
			<td>
				첨부파일
			</td>
			<td>
				<input type="file" id="docOriginFilename"><br>
			</td>
		</tr>
	</table>
</div>
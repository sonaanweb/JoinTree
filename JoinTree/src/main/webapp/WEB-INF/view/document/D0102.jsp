<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>	
	<!-- css - 우선순위를 위해 한 번 더 -->
	<link rel="stylesheet" href="/JoinTree/resource/css/style2.css">
	<link rel="stylesheet" href="/JoinTree/resource/css/style.css">
	<!-- document js파일 -->
	<script src="/JoinTree/resource/js/document/document.js"></script>
	<script>
		$(document).ready(function() {
			// 선택된 휴가카테고리값을 저장할 변수
			let leaveCate = "";

			// 라디오 버튼 값이 변경될 때마다 선택된 값을 업데이트
			$("input[name='leaveCate']").change(function() {
				leaveCate = $("input[name='leaveCate']:checked").val();
				console.log("leaveCate:", leaveCate);
			});
		});
	</script>
<div class="doc">
	<h1 class="center">휴가신청서</h1>
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
								<td><input type="text" id="writer" name="writer" readonly="readonly" value="${empInfo.empName}"></td>
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
				<td class="sign1 hidden"><input type="text" id="signer1" readonly="readonly"></td>
				<td class="sign2 hidden"><input type="text" id="signer2" readonly="readonly"></td>
			</tr>
			<tr>
				<td class="blank"></td>
				<td class="sign" rowspan="3" style="width: 100px; height: 100px;">
					<input type="hidden" id="docStamp1" name="docStamp1" value="${signImg}">
				    <c:choose>
				        <c:when test="${empty signImg or signImg eq null}">
				            <!-- signImg가 비어있는 경우 기본 이미지 출력 -->
				            <img src="${pageContext.request.contextPath}/empImg/JoinTree.png" style="width: 100px; height: 70px;">
				        </c:when>
				        <c:otherwise>
				            <!-- signImg가 비어있지 않은 경우 이미지 출력 -->
				            <img src="${pageContext.request.contextPath}/signImg/${signImg}" style="width: 100px; height: 70px;">
				        </c:otherwise>
				    </c:choose>
				</td>
				<td class="sign1 hidden" rowspan="3" style="width: 100px; height: 100px;">
					<input type="hidden" id="docStamp2" name="docStamp2">
				</td>
				<td class="sign2 hidden" rowspan="3" style="width: 100px; height: 100px;">
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
			
			<!-- 제목 입력 -->
			<tr>
				<td>
					제목
				</td>
				<td>
					<input type="text" id="docTitle">
				</td>
			</tr>
			<!-- 연차종류 -->
			<tr>
				<td>
					연차종류
				</td>
			
				<td >
					<c:forEach var="l" items="${leaveList}">
						<input type="radio" name="leaveCate" value="${l.code}" style="display: inline-block; margin-right: 10px;">
						${l.codeName}
					</c:forEach>
				</td>		
			</tr>
			<!-- 연차기간 -->
			<tr>
				<td>
					기간
				</td>
				<td>
					<input type="date" id="docLeaveStartDate"> ~ <input type="date" id="docLeaveEndDate">
					<input type="number" id="docLeavePeriodDate" min="0.5" style="width: 50px">&nbsp;일
				</td>
			</tr>
			<!-- 연차사유 -->
			<tr>
				<td>
					휴가사유
				</td>
				<td>
					<textarea id="docContent"></textarea> 
				</td>
			</tr>
			<!-- 비상연락처 -->
			<tr>
				<td>
					비상연락처
				</td>
				<td>
					<input type="text" id="docLeaveTel" placeholder="000-0000-0000">
				</td>
			</tr>
			<tr>
				<td colspan="2" style="text-align: left;">
					<br>
					1. 연차의 사용은 근로기준법에 따라 전년도에 발생한 개인별 잔여 연차에 한하여 사용함을 원칙으로 한다. 단, 최초 입사시에는 근로 기준법에 따라 발생 예정된 연차를 차용하여 월 1회 사용 할 수 있다.
					<br> 2. 경조사 휴가는 행사일을 증명할 수 있는 가족 관계 증명서 또는 등본, 청첩장 등 제출
					<br> 3. 공가(예비군/민방위)는 사전에 통지서를, 사후에 참석증을 반드시 제출 
					<br>4. 병가는 추후에 진단서를 반드시 제출
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
	</tbody>
</table>
	
</div>
</html>
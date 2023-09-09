<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>	
<div class="doc">
	<h1 class="center">휴가신청서</h1>
	<table class="table doc-title">
		<tbody>
			<tr>
				<td rowspan="4">
					<table class="table">
						<tbody>
							<tr>
								<td width="15%">문서번호</td>
								<td id="docNo"></td>
							</tr>
							
							<tr>
								<td>기안부서</td>
								<td class="dept"></td>
							</tr>
							
							<tr>
								<td>기안일</td>
								<td id="createdate"></td>
							</tr>
							
							<tr>
								<td>기안자</td>
								<td class="writer"></td>
							</tr>
						</tbody>
					</table>
				</td>
				
				<td class="blank"></td>
				<td class="sign"><span class="writer"></span>&nbsp;<span class="position"></span></td>
				<td class="sign1"><span id="signer1Name"></span>&nbsp;<span id="signer1Position"></span></td>
				<td class="sign2 hidden"><span id="signer2Name"></span>&nbsp;<span id="signer2Position"></span></td>
			</tr>
			<tr>
				<td class="blank"></td>
				<td class="sign" rowspan="3" style="width: 100px; height: 100px;">
					<img id="docStamp1" src="" style="width: 100px; height: 70px;">
				</td>
				<td class="sign1" rowspan="3" style="width: 100px; height: 100px;">
					<img id="docStamp2" src="" style="width: 100px; height: 70px;">
				</td>
				<td class="sign2 hidden" rowspan="3" style="width: 100px; height: 100px;">
					<img id="docStamp3" src="" style="width: 100px; height: 70px;">
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
				<td width="17%">참조자</td>
				<td id="reference"></td>
			</tr>
			<tr>
				<td>수신팀</td>
				<td id="receiverTeam"></td>
			</tr>
			
			<!-- 제목 입력 -->
			<tr>
				<td>제목</td>
				<td id="docTitle"></td>
			</tr>
			<!-- 연차종류 -->
			<tr>
				<td>연차종류</td>
				<td id="leaveType"></td>		
			</tr>
			<!-- 연차기간 -->
			<tr>
				<td>기간</td>
				<td>
					<span id="docLeaveStartDate"></span>&nbsp;&#126;&nbsp;<span id="docLeaveEndDate"></span>
					&nbsp;&#40; <span id="docLeavePeriodDate"></span>&nbsp;일&#41; 
				</td>
			</tr>
			<!-- 연차사유 -->
			<tr>
				<td>휴가사유</td>
				<td>
					<textarea id="docContent"></textarea> 
				</td>
			</tr>
			<!-- 비상연락처 -->
			<tr>
				<td>비상연락처</td>
				<td id="docLeaveTel"></td>
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
			<!-- 첨부파일 다운로드 -->
			<tr>
				<td>첨부파일</td>
				<td>
					<a id="docSaveFileName" href="${pageContext.request.contextPath}/docFile/" download></a>
				</td>
			</tr>
	</tbody>
</table>
	
</div>
</html>
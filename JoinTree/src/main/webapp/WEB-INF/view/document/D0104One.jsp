<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>	
<div class="doc">
	<h1 class="center">퇴직신청서</h1>
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
				<td class="sign"><span class="writer"></span>&nbsp;<span id="position"></span></td>
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
			<!-- 퇴직사유 -->
			<tr>
				<td>퇴직사유 및 퇴직예정일</td>
				<td>
					<textarea id="docContent"></textarea> 
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
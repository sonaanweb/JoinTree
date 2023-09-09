<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>	
<div class="doc">
	<h1 class="center">인사이동신청서</h1>
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
			
			<!-- 이동일자 -->
			<tr>
				<td>이동일자</td>
				<td id="docReshuffleDate"></td>
			</tr>
		</tbody>
	</table>
	
	<h4>[직급변경]</h4>
	<table class="table doc-comment">
		<tbody>
			<!-- 사원명 -->
			<tr>
				<td width="17%">사원명</td>
				<td class="writer"></td>
			<tr>
			<!-- 변경 전 직급 -->
			<tr>	
				<td>변경 전 직급</td>
				<td class="position"></td>
				
			</tr>
			<!-- 변경 후 직급 -->
			<tr>
				<td>변경 후 직급</td>
				<td id="docReshufflePosition"></td>
			</tr>
		</tbody>
	</table>

	<h4>[부서변경]</h4>
	<table class="table doc-comment">
		<tbody>
			<!-- 사원명 -->
			<tr>
				<td width="17%">사원명</td>
				<td class="writer"></td>
			</tr>
			<!-- 변경 전 부서 -->
			<tr>
				<td>변경 전 부서</td>
				<td class="dept"></td>	
			</tr>
			<!-- 변경 후 부서 -->	
			<tr>
				<td>변경 후 부서</td>
				<td id="docReshuffleDept"></td>
			</tr>
		</tbody>
	</table>

	<table class="table doc-comment">
		<!-- 제목 -->
		<tr>
			<td width="17%">제목</td>
			<td id="docTitle"></td>
		</tr>
		
		<!-- 주요 업무 -->
		<tr>
			<td>주요 업무</td>
			<td>
				<textarea id="docReshuffleTask"></textarea> 
			</td>
		</tr>

		<!-- 업무 성과 -->
		<tr>
			<td>업무 성과</td>
			<td>
				<textarea id="docReshuffleResult"></textarea> 
			</td>
		</tr>

		<!-- 발령사유 -->
		<tr>
			<td>발령 사유</td>
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
	</table>
</div>
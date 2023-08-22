<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<!-- css - 우선순위를 위해 한 번 더 -->
	<link rel="stylesheet" href="/resource/css/style2.css">
	<link rel="stylesheet" href="/resource/css/style.css">
	<script>
		$(document).ready(function() {
			const today = new Date();
		    const year = today.getFullYear();
		    const month = String(today.getMonth() + 1).padStart(2, '0'); // 0부터 시작하므로 1을 더해준다
		    const day = String(today.getDate()).padStart(2, '0');
		    const formattedDate = year + "-" + month + "-" + day;
		    
		    $("#draftDate").val(formattedDate); // 오늘날짜 출력
		});
	</script>
<div class="doc">
	<h1 class="center">기안서</h1>
<form action="/document/docDefault" method="post">
	<table class="table doc-title">
		<tbody>
			<tr>
				<td rowspan="4">
					<table class="table">
						<tbody>
							<tr>
								<td>문서번호</td>
								<td><input type="text" name="docNo" readonly="readonly"></td>
							</tr>
							
							<tr>
								<td>기안부서</td>
								<td><input type="text" name="receiverTeam" readonly="readonly" value="${empInfo.dept}"></td>
							</tr>
							
							<tr>
								<td>기안일</td>
								<td><input type="text" name="createdate" readonly="readonly" id="draftDate"></td>
							</tr>
							
							<tr>
								<td>기안자</td>
								<td><input type="text" name="writer" readonly="readonly" value="${empInfo.empName}"></td>
							</tr>
						</tbody>
					</table>
				</td>
				
				<td class="blank"></td>
				
				<td class="sign">
					<input type="hidden" id="empNo" name="empNo" readonly="readonly" value="${empInfo.empNo}">
					<input type="text" id="empName" name="writer" readonly="readonly" value="${empInfo.empName}">
				</td>
				<td class="sign"><input type="text" id="signer1" readonly="readonly"></td>
				<td class="sign"><input type="text" id="signer2" readonly="readonly"></td>
			</tr>
			<tr>
				<td class="blank"></td>
				<td class="sign" rowspan="3"><img src="${pageContext.request.contextPath}/signImg/${signImg}" alt="sign image" style="max-width: 100%; height: auto;">[기안자 서명]</td>
				<td class="sign" rowspan="3"><img src="${pageContext.request.contextPath}/signImg/${signImg}" alt="sign image" style="max-width: 100%; height: auto;">[결재자1 서명]</td>
				<td class="sign" rowspan="3"><img src="${pageContext.request.contextPath}/signImg/${signImg}" alt="sign image" style="max-width: 100%; height: auto;">[결재자2 서명]</td>
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
					<input type="text">
				</td>
			</tr>
			<!-- 상세 내용입력 -->
			<tr>
				<td>
					상세내용
				</td>
				<td>
					<textarea></textarea> 
				</td>
			</tr>
			<!-- 첨부파일 추가 -->
			<tr>
				<td>
					첨부파일
				</td>
				<td>
					<input type="file"><br>
				</td>
			</tr>
		</tbody>
	</table>
<button type="submit">결재하기</button>
</form>
</div>
</html>
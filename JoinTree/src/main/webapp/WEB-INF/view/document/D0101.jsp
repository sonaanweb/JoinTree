<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<!-- css - 우선순위를 위해 한 번 더 -->
	<link rel="stylesheet" href="/resource/css/style2.css">
	<link rel="stylesheet" href="/resource/css/style.css">
<div class="doc">
	<h1>기&nbsp;&nbsp;안&nbsp;&nbsp;서</h1>
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
								<td><input type="text" readonly="readonly"></td>
							</tr>
							
							<tr>
								<td>기안일</td>
								<td><input type="text" readonly="readonly"></td>
							</tr>
							
							<tr>
								<td>기안자</td>
								<td><input type="text" readonly="readonly"></td>
							</tr>
						</tbody>
					</table>
				</td>
				
				<td class="blank"></td>
				
				<td class="sign"><input type="text" id="tom" readonly="readonly"></input></td>
				<td class="sign"><input type="text" id="signer1" readonly="readonly"></td>
				<td class="sign"><input type="text" id="signer2" readonly="readonly"></td>
			</tr>
			<tr>
				<td class="blank"></td>
				<td class="sign" rowspan="3">[기안자 도장]</td>
				<td class="sign" rowspan="3">[결재자1 도장]</td>
				<td class="sign" rowspan="3">[결재자2 도장]</td>
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
	
</div>
</html>
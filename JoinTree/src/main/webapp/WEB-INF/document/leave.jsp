<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>leave</title>
</head>
<body>  
<div style="text-align: center; width: 800px;">
<h1>연차신청서</h1>
<table style="border: 0px solid rgb(0, 0, 0); width: 800px; font-family: malgun gothic, dotum, arial, tahoma; margin-top: 1px; border-collapse: collapse;"><!-- Header --> 
   <colgroup> 
    <col width="310"> 
    <col width="490"> 
   </colgroup> 
   	
	<tbody>
		<tr>
			<td style="background: white; padding: 0px !important; border: currentColor; text-align: left; color: black; font-size: 12px; font-weight: normal; vertical-align: top;">
				
		<table style="border: 1px solid rgb(0, 0, 0); font-family: &quot;malgun gothic&quot;, dotum, arial, tahoma; margin-top: 1px; border-collapse: collapse; width: 318px;"><!-- User --> 
		      <colgroup> 
		       <col width="90"> 
		       <col width="120"> 
		      </colgroup> 
		      
			<tbody>
				<tr>
					<td style="background: rgb(221, 221, 221); padding: 5px; border: 1px solid black; height: 18px; text-align: center; color: rgb(0, 0, 0); font-size: 12px; font-weight: bold; vertical-align: middle;">
						<!-- 직접 입력불가 -->				
						 문서번호 
					</td>
					<td style="background: rgb(255, 255, 255); padding: 5px; border: 1px solid black; text-align: left; color: rgb(0, 0, 0); font-size: 12px; font-weight: normal; vertical-align: middle; width: 269px;">
						<input type="text" readonly="readonly">
					</td>
				</tr>
				<tr style="height: 32px;">
					<td style="background: rgb(221, 221, 221); padding: 5px; border: 1px solid black; height: 18px; text-align: center; color: rgb(0, 0, 0); font-size: 12px; font-weight: bold; vertical-align: middle;">
						<!-- 직접 입력불가 -->
						부&nbsp;&nbsp;&nbsp;서
					</td>
					<td style="background: rgb(255, 255, 255); padding: 5px; border: 1px solid black; height: 18px; text-align: left; color: rgb(0, 0, 0); font-size: 12px; font-weight: normal; vertical-align: middle; width: 269px;">
						<input type="text" readonly="readonly">
					</td>
				</tr>
				<tr>
					<td style="background: rgb(221, 221, 221); padding: 5px; border: 1px solid black; height: 18px; text-align: center; color: rgb(0, 0, 0); font-size: 12px; font-weight: bold; vertical-align: middle;">
						<!-- 직접 입력불가 -->				
						기&nbsp;안&nbsp;일
					</td>
					<td style="background: rgb(255, 255, 255); padding: 5px; border: 1px solid black; text-align: left; color: rgb(0, 0, 0); font-size: 12px; font-weight: normal; vertical-align: middle; width: 269px;">
						<input type="date" readonly="readonly"> 	
					</td>
				</tr>
				<tr>
					<td style="background: rgb(221, 221, 221); padding: 5px; border: 1px solid black; height: 18px; text-align: center; color: rgb(0, 0, 0); font-size: 12px; font-weight: bold; vertical-align: middle;">
						<!-- 직접 입력불가 -->				
						기 안 자
					</td>
					<td style="background: rgb(255, 255, 255); padding: 5px; border: 1px solid black; text-align: left; color: rgb(0, 0, 0); font-size: 12px; font-weight: normal; vertical-align: middle; width: 269px;">
						<input type="text" readonly="readonly">
					</td>
				</tr>
			</tbody>
		</table>
			<!-- 도장칸 -->
			</td>
				<td style="background: white; width:300px; margin-left: 10px; padding: 0px !important;  text-align: right; color: black; font-size: 12px; font-weight: normal; vertical-align: top;">
				</td>
			
				<td style="background: white; width:300px; margin-left: 10px; border: 1px solid #000; padding: 0px !important;  text-align: right; color: black; font-size: 12px; font-weight: normal; vertical-align: top;">					
					[기안자]
					<hr style=" border: none; border-top: 1px solid black;">
					<span>[기안자 도장]</span>
					
					<td style="background: white; width:300px; margin-left: 10px; border: 1px solid #000; padding: 0px !important;  text-align: right; color: black; font-size: 12px; font-weight: normal; vertical-align: top;">
					<span>[결재자 1]</span>
					<hr style=" border: none; border-top: 1px solid black;">
					[결재자1 도장]
					</td>
					
					<td style="background: white; width:300px; margin-left: 10px; border: 1px solid #000; padding: 0px !important;  text-align: right; color: black; font-size: 12px; font-weight: normal; vertical-align: top;">
					<span>[결재자 2]</span>
					<hr style=" border: none; border-top: 1px solid black;">
					[결재자2 도장]
					</td>
				</td>
			
			</tr>
	</tbody>
</table>
 
 
<table style="border: 2px solid; width: 800px; font-family: &quot;malgun gothic&quot;, dotum, arial, tahoma; margin-top: 10px; border-collapse: collapse; height: 385px;"><colgroup> 
   <col width="140px"> 
   <col width="660px"> 
  </colgroup> 
  	<!-- 내용 테이블 -->
	<tbody>
		<!-- 참조자 -->
		<tr>
			<td style="background: rgb(221, 221, 221); padding: 5px; border: 1px solid black; height: 18px; text-align: center; color: rgb(0, 0, 0); font-size: 12px; font-weight: bold; vertical-align: middle;">
				참&nbsp;&nbsp;조&nbsp;&nbsp;자
			</td>
			<td style="background: rgb(255, 255, 255); padding: 5px;border:1px solid black; height: 18px; text-align: left; color: rgb(0, 0, 0); font-size: 12px; font-weight: normal; vertical-align: middle;">
				<input type="text" readonly="readonly"><br>
			</td>
		</tr>
		<!-- 제목 -->
		<tr>
			<td style="background: rgb(221, 221, 221); padding: 5px; border: 1px solid black; height: 18px; text-align: center; color: rgb(0, 0, 0); font-size: 12px; font-weight: bold; vertical-align: middle;">
				제&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;목
			</td>
			<td style="background: rgb(255, 255, 255); padding: 5px;border:1px solid black; height: 18px; text-align: left; color: rgb(0, 0, 0); font-size: 12px; font-weight: normal; vertical-align: middle;">
				<input type="text"><br>
			</td>
		</tr>
		<!-- 연차종류 -->
		<tr>
			<td style="background: rgb(221, 221, 221); padding: 5px;border:1px solid black; height: 18px; text-align: center; color: rgb(0, 0, 0); font-size: 12px; font-weight: bold; vertical-align: middle;">
				연&nbsp;&nbsp;차&nbsp;&nbsp;종&nbsp;&nbsp;류
			</td>
			<td style="background: rgb(255, 255, 255); padding: 5px;border:1px solid black; height: 18px; text-align: left; color: rgb(0, 0, 0); font-size: 12px; font-weight: normal; vertical-align: middle;">
				<input type="radio">오전반차
				<input type="radio">오후반차
				<input type="radio">연차
				<input type="radio">공가
			</td>
		</tr>
		<!-- 연차기간 -->
		<tr>
			<td style="background: rgb(221, 221, 221); padding: 5px; border: 1px solid black; height: 18px; text-align: center; color: rgb(0, 0, 0); font-size: 12px; font-weight: bold; vertical-align: middle;">
				기간
			</td>
			<td style="background: rgb(255, 255, 255); padding: 5px;border:1px solid black; height: 18px; text-align: left; color: rgb(0, 0, 0); font-size: 12px; font-weight: normal; vertical-align: middle;">
				<input type="date"> ~ <input type="date">
				<input type="number" style="width: 40px">&nbsp;일
			</td>
		</tr>
		<!-- 연차사유 -->
		<tr>
			<td style="background: rgb(221, 221, 221); padding: 5px; border: 1px solid black; height: 18px; text-align: center; color: rgb(0, 0, 0); font-size: 12px; font-weight: bold; vertical-align: middle;">
				휴가사유
			</td>
			<td style="background: rgb(255, 255, 255); padding: 5px;border:1px solid black; height: 18px; text-align: left; color: rgb(0, 0, 0); font-size: 12px; font-weight: normal; vertical-align: middle;" colspan="2">
				<textarea rows="10" cols="80"></textarea>
			</td>
		</tr>
		<!-- 비상연락처 -->
		<tr>
			<td style="background: rgb(221, 221, 221); padding: 5px; border: 1px solid black; height: 18px; text-align: center; color: rgb(0, 0, 0); font-size: 12px; font-weight: bold; vertical-align: middle;">
				비상연락처
			</td>
			<td style="background: rgb(255, 255, 255); padding: 5px;border:1px solid black; height: 18px; text-align: left; color: rgb(0, 0, 0); font-size: 12px; font-weight: normal; vertical-align: middle;">
				<input type="text"> - <input type="number"> - <input type="number">
			</td>
		</tr>
		<tr>
			<td style="background: rgb(221, 221, 221); padding: 5px; border: 1px solid black; height: 18px; text-align: left; color: rgb(0, 0, 0); font-size: 12px; vertical-align: middle;" colspan="2">
				<br>
				1. 연차의 사용은 근로기준법에 따라 전년도에 발생한 개인별 잔여 연차에 한하여 사용함을 원칙으로 한다. 단, 최초 입사시에는 근로 기준법에 따라 발생 예정된 연차를 차용하여 월 1회 사용 할 수 있다.
				<br> 2. 경조사 휴가는 행사일을 증명할 수 있는 가족 관계 증명서 또는 등본, 청첩장 등 제출
				<br> 3. 공가(예비군/민방위)는 사전에 통지서를, 사후에 참석증을 반드시 제출 
				<br>&nbsp;
			</td>
		</tr>
		<tr>
			<td style="background: rgb(221, 221, 221); padding: 5px; border: 1px solid black; height: 18px; text-align: center; color: rgb(0, 0, 0); font-size: 12px; font-weight: bold; vertical-align: middle;">
				첨&nbsp;&nbsp;부&nbsp;&nbsp;파&nbsp;&nbsp;일
			</td>
			<td style="background: rgb(255, 255, 255); padding: 5px;border:1px solid black; height: 18px; text-align: left; color: rgb(0, 0, 0); font-size: 12px; font-weight: normal; vertical-align: middle;">
				<input type="file"><br>
			</td>
		</tr>
	</tbody>
</table>

<p style="font-family: &quot;맑은 고딕&quot;; font-size: 10pt; line-height: 20px; margin-top: 0px; margin-bottom: 0px;"><br></p>
</div>
</body>
</html>
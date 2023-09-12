<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link rel="stylesheet" type="text/css" href="/JoinTree/resource/css/custom.css">
 <div id="empOneInfoModalContent">
	 <!-- Modal Header -->
	 <div class="modal-header d-flex align-items-center">
		<h4 class="modal-title">사원 상세 정보</h4>
		<button type="button" class="btn btn-close" data-bs-dismiss="modal" aria-label="Close" id="empOneModalClose">
			<span>x</span>
		</button>
	 </div>
	 
	 <!-- Modal body -->
	 <div class="modal-body">
		<div class="col card " style="padding-top: 35px; padding-bottom: 35px;">
		<!-- 사원 상세정보, 인사이동이력 탭 이동 버튼 -->
		<div class="w3-bar w3-border-bottom">
			<button class="tablink w3-bar-item w3-button" data-target="empInfoOne">사원상세정보</button>
			<button class="tablink w3-bar-item w3-button" data-target="reshuffleHistoryOne">인사이동이력</button>
		</div>
		<br>
		<!-- 사원 상세정보 -->	
		<div id="empInfoOne" class="w3-container empOne">
			<table class="table">
				<tr>
					<td rowspan="4" style="width: 20%">
						<img src="" class="empImgOne" style="width: 200px; height: 170px;">
					</td>
					<td class="font-weight-bold" style="width: 10%">사번</td>
					<td style="width: 35%"><span class="empNoOne"></span></td>
					
					<td class="font-weight-bold" style="width: 10%">부서</td>
					<td><span id="deptOne"></span></td>
				</tr>
				<tr>
					<td class="font-weight-bold">사원명</td>
					<td><span class="empNameOne"></span></td>
					
					<td class="font-weight-bold">직급</td>
					<td><span id="positionOne"></span></td>
				</tr>
				<tr>
					<td class="font-weight-bold">주민번호</td>
					<td><span class="empJuminNoOne"></span></td>
					
					<td class="font-weight-bold">내선번호</td>
					<td><span id="empExtensionNoOne"></span></td>
				</tr>
				<tr>
					<td class="font-weight-bold">연락처</td>
					<td><span class="empPhoneOne"></span></td>
					
					<td class="font-weight-bold">입사일</td>
					<td><span id="empHireDateOne"></span></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td class="font-weight-bold">주소</td>
					<td><span class="empoAddressOne"></span></td>
					
					<td class="font-weight-bold">퇴사일</td>
					<td><span id="empLastDateOne"></span></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td class="font-weight-bold">재직상태</td>
					<td><span id="empActiveOne"></span></td>
				</tr>
			</table>
			<br>	
			<!-- 수정버튼 -->
			<div class="text-center">
				<button type="button" id="modifyEmpBtn" class="btn btn-dark btn-md">수정</button>
			</div>	
		</div>

		<!-- 인사이동이력 -->
		<div id="reshuffleHistoryOne" class="w3-container empOne">
		 	<table class="table">
		 		<thead>
			 		<tr>
			 			<th class="font-weight-bold" style="width: 20%">발령일</th>
			 			<th class="font-weight-bold">이전부서</th>
			 			<th class="font-weight-bold">발령부서</th>
			 			<th class="font-weight-bold">이전직급</th>
			 			<th class="font-weight-bold">발령직급</th>
			 		</tr>
		 		</thead>
		 		<tbody id="reshuffleHistoryList">
		 		
		 		</tbody>
		 	</table>
		</div>
		</div>
	 </div>
 </div>

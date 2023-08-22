<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<style>
.empOne {display:none}
</style>
</head>
<body>
	 
	 
	 <div id="empOneInfoModalContent">
		 <!-- Modal Header -->
		 <div class="modal-header">
			<h4 class="modal-title">사원 상세 정보</h4>
			<button type="button" class="btn-close" data-bs-dismiss="modal" id="empOneModalClose"></button>
		 </div>
		 
		 <!-- Modal body -->
		 <div class="modal-body">
			 
			<!-- 사원 상세정보, 인사이동이력 탭 이동 버튼 -->
			<div class="w3-bar w3-border-bottom">
				<button class="tablink w3-bar-item w3-button" data-target="empInfoOne">사원상세정보</button>
				<button class="tablink w3-bar-item w3-button" data-target="reshuffleHistoryOne">인사이동이력</button>
			</div>
			
			<!-- 사원 상세정보 -->	
			<div id="empInfoOne" class="w3-container empOne">
			<div>
				<div class="empImgOne">
					<img alt="" src="#">
				</div>
			</div>
			<div>
				<div>사번</div>
				<div>
					<span class="empNoOne"></span>
				</div>
			</div>
			<div>
				<div>사원명</div>
				<div>
					<span class="empNameOne"></span>
				</div>
			</div>
			<div>
				<div>주민번호</div>
				<div>
					<span class="empJuminNoOne"></span> 
				</div>  
			</div>
			<div>
				<div>연락처</div>
				<div>
					<span class="empPhoneOne"></span>
				</div>
			</div>
			<div>
				<div>주소</div>
				<div>
					<span class="empoAddressOne"></span>
				</div>
			</div>
			<div>
				<div>부서</div>
				<div>
					<span id="deptOne"></span>
				</div>
			</div>
			<div>
				<div>직급</div>
				<div>
					<span id="positionOne"></span>
				</div>
			</div>
			<div>
				<div>내선번호</div>
				<div>
					<span id="empExtensionNoOne"></span>
				</div>
			</div>
			<div>
				<div>입사일</div>
				<div>
					<span id="empHireDateOne"></span>
				</div>
			</div>
			<div>
				<div>퇴사일</div>
				<div>
					<span id="empLastDateOne"></span>
				</div>
			</div>
			<div>
				<div>재직상태</div>
				<div>
					<span id="empActiveOne"></span>
				</div>
			</div>
			<div class="text-center">
				<button type="button" id="modifyEmpBtn">수정</button>
			</div>
			</div>
			
			<!-- 인사이동이력 -->
			<div id="reshuffleHistoryOne" class="w3-container empOne">
			 	<table>
			 		<thead>
				 		<tr>
				 			<th>발령일</th>
				 			<th>이전부서</th>
				 			<th>발령부서</th>
				 			<th>이전직급</th>
				 			<th>발령직급</th>
				 		</tr>
			 		</thead>
			 		<tbody id="reshuffleHistoryList">
			 		
			 		</tbody>
			 	</table>
			</div>
		 </div>
	 </div>
	 
	 
</body>
</html>
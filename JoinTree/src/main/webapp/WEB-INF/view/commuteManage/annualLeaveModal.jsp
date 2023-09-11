<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="modal" id="annualLeaveModal">
	<div class="modal-dialog">
		<div class="modal-content">
			<!-- Modal Header -->
			<div class="modal-header d-flex align-items-center">
				<h4 class="modal-title">연차 관리</h4>
				<button type="button" class="btn btn-close" data-bs-dismiss="modal" aria-label="Close">
					<span>x</span>
				</button>
			</div>
			
			<!-- Modal body -->
			<div class="modal-body">
				<div class="col card " style="padding-top: 35px; padding-bottom: 35px;">
					<form id="addAnnualLeaveForm" method="post">
						<input type="hidden" id="annualEmpNo" name="docEmpNo" value="">
						<input type="hidden" name="addAnnualCount" value="">
						<input type="hidden" name="addAnnualDate" value="">
						<table class="table">
							<tr>
								<th width="22%">사원명</th>
								<td id="empName"></td>
							</tr>
							<tr>
								<th>입사일</th>
								<td id="empHireDate"></td>
							</tr>
							<tr>
								<th>근속일수</th>
								<td><span id="yearsAndMonths"></span><span id="workDays"></span></td>
							</tr>
							<tr>
								<th>근로시간</th>
								<td id="workTime"></td>
							</tr>
							<tr>
								<th>발생연차</th>
								<td id="addAnnualCount"></td>
							</tr>
							<tr>
								<th>연차발생일</th>
								<td id="addAnnualDate"></td>
							</tr>
						</table>
					</form>
					<br>
					<div class="center">
						<button id="addAnnualLeaveBtn" class="btn btn-dark btn-md">연차등록</button>
					</div>
				</div>	
			</div>
			
		</div>
	</div>
</div>		
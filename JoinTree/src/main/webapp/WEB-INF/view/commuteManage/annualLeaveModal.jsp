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
				<table class="table">
					<tr>
						<th width="20%">사원명</th>
						<td id="empName"></td>
					</tr>
					<tr>
						<th>입사일</th>
						<td id="empHireDate"></td>
					</tr>
					<tr>
						<th>근속일 수</th>
						<td id="workDay"></td>
					</tr>
				</table>
			</div>
			
		</div>
	</div>
</div>		
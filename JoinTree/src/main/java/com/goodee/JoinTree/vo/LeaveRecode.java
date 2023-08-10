package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class LeaveRecode {
	private int leaveNo;
	private int empNo;
	private int docNo;
	private String leaveStartDate;
	private String leaveEndDate;
	private double leavePeriodDate;
	private String leaveReason;
	private String leaveType;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
}
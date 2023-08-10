package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class DocumentLeave {

	private int docNo;
	private int leave;
	private String docLeaveStartDate;
	private String docLeaveEndDate;
	private String docLeavePeriodDate;
	private String docLeaveReason;
	private String docLeaveTel;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
}

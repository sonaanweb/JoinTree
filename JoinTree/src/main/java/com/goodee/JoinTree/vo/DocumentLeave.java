package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class DocumentLeave {
	private int docLeaveNo;
	private int docCategoryNo;
	private int empNo;
	private String docLeaveCategoryName;
	private String docCategoryName;
	private String docLeaveStartDate;
	private String docLeaveEndDate;
	private Double docLeavePeriodDate;
	private String docLeaveReason;
	private String docLeaveTel;
	private String writer;
	private String reference;
	private String recieverTeam;
	private String docLeaveStatus;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
	
}

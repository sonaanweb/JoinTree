package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class DocumentAbsence {
	private int docAbsenceNo;
	private int docCategoryNo;
	private int empNo;
	private String docAbsenceTitle;
	private String docAbsenceStartDate;
	private String docAbsenceEndDate;
	private String docAbsenceReason;
	private String docLeaveTel;
	private String writer;
	private String reference;
	private String recieverTeam;
	private String docAbsenceStatus;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
	
}

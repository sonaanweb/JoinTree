package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class DocumentReturn {
	private int docReturnNo;
	private int docCategoryNo;
	private int empNo;
	private String docAbsenceTitle;
	private String docAbsenceStartDate;
	private String docAbsenceEndDate;
	private String docAbsenceReason;
	private String docReturnDate;
	private String writer;
	private String reference;
	private String recieverTeam;
	private String docReturnStatus;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;

}

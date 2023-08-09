package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class DocumentResign {
	private int docResignNo;
	private int docCategoryNo;
	private int empNo;
	private String docResignTitle;
	private String docResignDate;
	private String docResignReason;
	private String writer;
	private String reference;
	private String receiverTeam;
	private String docResignStatus;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
	
}

package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class DocumentSigner {
	private int docNo;
	private int docCategoryNo;
	private int empSignerNo;
	private int empSignerLevel;
	private String docSignerStatus;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;

}

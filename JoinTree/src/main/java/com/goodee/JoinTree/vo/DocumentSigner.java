package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class DocumentSigner {
	private int docNo;
	private int empSignerNo;
	private int empSignerLevel;
	private String docStatus;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
}
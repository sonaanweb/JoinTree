package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class DocumentFile {

	private int docNo;
	private String docCategoryNo;
	private String docOriginFilename;
	private String docSaveFilename;
	private String docFiletype;
	private long docFilesize;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
}

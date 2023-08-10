package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class EmpInfoImg {
	private int empImgNo;
	private int empNo;
	private String empOriginImgName;
	private String empSaveImgName;
	private String empFiletype;
	private long empFilesize;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
}
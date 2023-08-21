package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class SignImg {
	private int signImgNo;
	private int empNo;
	private String signSaveImgname;
	private String signFiletype;
	private long signFilesize;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
}
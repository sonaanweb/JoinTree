package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class BoardFile {
	private int boardFileNo;
	private int boardNo;
	private String boardOriginFilename;
	private String boardSaveFilename;
	private String boardFiletype;
	private long boardFilesize;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
}
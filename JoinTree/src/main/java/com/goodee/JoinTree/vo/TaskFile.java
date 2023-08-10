package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class TaskFile {

	private int taskNo;
	private String taskOriginFilename;
	private String taskSaveFilename;
	private String taskFiletype;
	private long taskFilesize;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
}

package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class TaskComment {
	private int taskCommentNo;
	private int taskNo;
	private int empNo;
	private int commentGroupNo;
	private String taskCommentContent;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;

}

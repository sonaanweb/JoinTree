package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class TaskComment {

	private int taskCommentNo;
	private int taskNo;
	private int empNo;
	private String empName; // 하위 empName조인용
	private int tcChildCnt; // 대댓글 카운트
	private int commentParentNo;
	private String taskCommentContent;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
}

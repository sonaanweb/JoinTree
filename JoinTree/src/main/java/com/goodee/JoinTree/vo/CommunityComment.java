package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class CommunityComment {

	private int commentNo;
	private int boardNo;
	private int empNo;
	private int  commentGroupNo;
	private String commCommentContent;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
}

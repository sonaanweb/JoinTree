package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class CommunityComment {
	private int commCommentNo;
	private int commNo;
	private int empNo;
	private int commentGrouNo;
	private String commCommentContent; 
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
}

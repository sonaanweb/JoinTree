package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class Comment {
	private int commentNo;
	private int boardNo;
	private int parentCommentNo;
	private int empNo;
	private String commentContent;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
	
	private String category; // DB에 없음, 카테고리명 기반 리다이렉트를 위해 추가
	private String empName; // DB에 없음, 댓글 작성자 이름 출력을 위해 추가	
}
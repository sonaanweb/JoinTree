package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class Community {
	private int commNo;
	private int boardCategoryNo;
	private int empNo;
	private String commTtitle;
	private String commContent;
	private String commPinned;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
}
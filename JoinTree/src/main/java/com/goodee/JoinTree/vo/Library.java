package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class Library {
	private int libNo;
	private int boardCategoryNo;
	private int empNo;
	private String libTitle;
	private String libContent;
	private String libPinned;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
}
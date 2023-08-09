package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class Notice {
	private int noticeNo;
	private int boardCategoryNo;
	private int empNo;
	private String noticeTitle;
	private String noticeContent;
	private String noticePinned;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
}

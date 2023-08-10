package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class Board {
	private int boardNo;
	private int empNo;
	private String boardCategory;
	private String boardTitle;
	private String boardContent;
	private String boardPinned;
	private int boardCount;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
}

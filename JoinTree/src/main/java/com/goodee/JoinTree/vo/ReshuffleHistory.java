package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class ReshuffleHistory {
	private int empNo;
	private int departNo;
	private int position;
	private int departBeforeNo;
	private int positionBeforeLevel;
	private String creatdate;
	private String updatedate;
	private int createId;
	private int updateId;
}
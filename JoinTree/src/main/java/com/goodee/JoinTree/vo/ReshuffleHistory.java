package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class ReshuffleHistory {
	private int reshuffle_history_no;
	private int empNo;
	private String departNo;
	private String position;
	private String departBeforeNo;
	private String positionBeforeLevel;
	private String creatdate;
	private String updatedate;
	private int createId;
	private int updateId;
}
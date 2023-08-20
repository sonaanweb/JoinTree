package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class ReshuffleHistory {
	private int reshuffleHistoryNo;
	private int empNo;
	private String departNo;
	private String position;
	private String departBeforeNo;
	private String positionBeforeLevel;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
}
package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class ReshuffleHistory {
	private int empNo;
	private int departNo;
	private int positionLevel;
	private int departBeforeNo;
	private int positionBeforeNo;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
}

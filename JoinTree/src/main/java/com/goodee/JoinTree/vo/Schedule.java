package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class Schedule {
	private int scheduleNo;
	private int empNo;
	private String empName;
	private String scheduleCategory;
	private String scheduleTitle;
	private String scheduleContent;
	private String scheduleLocation;
	private String scheduleStart;
	private String scheduleEnd;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
}
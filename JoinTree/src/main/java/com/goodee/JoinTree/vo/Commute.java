package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class Commute {
	private int commuteNo;
	private int empNo;
	private String commute;
	private String empOnOffDate;
	private String empOnTime;
	private String empOffTime;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
}
package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class Commute {
	private int commutNo;
	private int empNo;
	private String empNoOffDate;
	private String empOnTime;
	private String empOffTime;
	private String empStatus;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
}

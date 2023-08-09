package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class CarReservation {
	private int carRevNo;
	private int carNo;
	private int empNo;
	private String carRevApplyDate;
	private String carRevStartTime;
	private String carRevEndTime;
	private String carRevStatus;
	private String carRevReason;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
}
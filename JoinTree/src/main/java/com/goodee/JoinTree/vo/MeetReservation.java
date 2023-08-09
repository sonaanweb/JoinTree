package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class MeetReservation {
	private int roomRevNo;
	private int roomNo;
	private int empNo;
	private String roomRevApplyDate;
	private String roomRevStartTime;
	private String roomRevEndTime;
	private String roomRevStatus;
	private String roomRevReason;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
}
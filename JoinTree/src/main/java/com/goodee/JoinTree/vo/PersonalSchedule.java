package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class PersonalSchedule {
	private int pScheduleNo;
	private int empNo;
	private String pScheduleTitle;
	private String pScheduleContent;
	private String pScheduleLocation;
	private String pScheduleStart;
	private String pScheduleEnd;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
}

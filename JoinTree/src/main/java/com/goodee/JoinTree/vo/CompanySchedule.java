package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class CompanySchedule {
	private int coScheduleNo;
	private int empNo;
	private String coScheduleTitle;
	private String coScheduleContent;
	private String coScheduleLocation;
	private String coScheduleStart;
	private String coScheduleEnd;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
}

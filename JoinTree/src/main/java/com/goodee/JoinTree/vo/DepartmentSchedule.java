package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class DepartmentSchedule {
	private int deptScheduleNo;
	private int empNo;
	private String deptScheduleTitle;
	private String deptScheduleContent;
	private String deptScheduleLocation;
	private String deptScheduleStart;
	private String deptScheduleEnd;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
}

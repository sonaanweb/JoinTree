package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class ProjectTask {

	private int taskNo;
	private int projectNo;
	private int empNo;
	private String empName; // emp정보 join용
	private String taskTitle;
	private String taskStartDate;
	private String taskEndDate;
	private String taskContent;
	private String taskStatus;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
}

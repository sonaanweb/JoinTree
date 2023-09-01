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
	private String totalTasks; // 전체 작업수
	private String completedTasks; // 완료된 작업수
	private String progressRate; // 작업률
	private String taskOriginFilename; // 작업 파일 이름 join용
	private String taskSaveFilename;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
}

package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class Project {

	private int projectNo;
	private int empNo;
	private String empName; // emp정보 join용
	private int EmpCnt; // 인원 확인용
	private String projectName;
	private String projectColor;
	private String projectStartDate;
	private String projectEndDate;
	private String projectContent;
	private String projectStatus;
	private String projectStatusName; // 코드 join용
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
}

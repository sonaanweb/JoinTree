package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class Project {
	private int projectNo;
	private int empNo;
	private String projectName;
	private String projectStartDate;
	private String projectEndDate;
	private Double projectContent;
	private String projectStatus;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;

}

package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class ProjectMember {

	private int projectNo;
	private int empNo;
	private String empName; // emp정보 join용
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
}

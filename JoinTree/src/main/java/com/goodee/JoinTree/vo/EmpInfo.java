package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class EmpInfo {
	private int empNo;
	private String position;
	private String positionName; // 코드 join용
	private String dept;
	private String deptName; // 코드 join용
	private String empName;
	private String empAddress;
	private String empPhone;
	private String empJuminNo;
	private String empExtensionNo;
	private String empHireDate;
	private String empLastDate;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
}
package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class Todo {
	private int todoNo;
	private int empNo; 
	private String todoContent;
	private String todoStatus;
	private String createdate;
	private String updatedate;
	private int createId;
	private int updateId;
}
package com.goodee.JoinTree.vo;

import lombok.Data;

@Data
public class AccountList {
	private int empNo;
	private String active;
	private String empPw;
	private String creatdate;
	private String updatedate;
	private int createId;
	private int updateId;
	
	private String newPw; // 테이블에 컬럼 존재 X, 비밀번호 변경 시 임시 사용
}
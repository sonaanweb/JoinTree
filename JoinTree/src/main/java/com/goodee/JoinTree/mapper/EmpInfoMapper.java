package com.goodee.JoinTree.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.JoinTree.vo.AccountList;
import com.goodee.JoinTree.vo.EmpInfo;

@Mapper
public interface EmpInfoMapper {
	// 비밀번호 변경
	int modifyPw(AccountList account);
	
	// 나의 정보 조회
	EmpInfo selectEmpOne(int empNo);
	
	// 비밀번호 일치 체크
	int selectCheckPw(int empNo, String empPw);
	
	// 나의 정보 수정
	int modifyEmp(EmpInfo empInfo);
}
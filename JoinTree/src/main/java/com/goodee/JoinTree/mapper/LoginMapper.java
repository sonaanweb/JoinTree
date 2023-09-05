package com.goodee.JoinTree.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.JoinTree.vo.AccountList;
import com.goodee.JoinTree.vo.EmpInfo;

@Mapper
public interface LoginMapper {
	// 로그인 액션
	AccountList selectAccount(AccountList account);
	
	// 로그인 성공 시 empNo로 empName 출력
	String selectEmpName(int empNo);
	
	// 로그인 성공 시 empNo로 dept 출력
	String selectDept(int empNo);
	
	// 로그인 성공 시 empNo로 empSaveImgName 출력
	String selectEmpImg(int empNo);
	
	// 로그인 성공 시 empNo로 signSaveImgName 출력
	String selectSignImg(int empNo);
	
	// 사번, 주민등록번호 뒷자리 체크
	int selectEmpNoJumin(int empNo, String juminNo);
	
	// 비밀번호 재설정 (분실)
	int modifyForgetPw(int empNo, String newPw);
}
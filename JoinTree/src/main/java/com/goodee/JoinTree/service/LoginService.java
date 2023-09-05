package com.goodee.JoinTree.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.goodee.JoinTree.mapper.LoginMapper;
import com.goodee.JoinTree.vo.AccountList;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
public class LoginService {
	static final String CYAN = "\u001B[46m";
	static final String RESET = "\u001B[0m";
	
	@Autowired
	private LoginMapper loginMapper;
	
	// 로그인
	public AccountList login(AccountList account) {
		AccountList accountEmp = loginMapper.selectAccount(account);
		return accountEmp;
	}
	
	// 로그인 성공 시 empNo로 empName 출력
	public String getEmpName(int empNo) {
		return loginMapper.selectEmpName(empNo);
	}
	
	// 로그인 성공 시 empNo로 dept 출력
	public String getEmpDept(int empNo) {
		return loginMapper.selectDept(empNo);
	}
	
	// 로그인 성공 시 empNo로 empImg 출력
	public String getEmpImg(int empNo) {
		return loginMapper.selectEmpImg(empNo);
	}
	
	// 로그인 성공 시 empNo로 signImg 출력
	public String getSignImg(int empNo) {
		return loginMapper.selectSignImg(empNo);
	}
	
	// 사원, 주민번호 뒷자리 일치 체크 (비밀번호 분실 시)
	public int selectEmpNoJumin(int empNo, String juminNo) {
		int row = loginMapper.selectEmpNoJumin(empNo, juminNo);
		log.debug(CYAN + row + " <-- row(LoginService-selectEmpNoJumin)" + RESET);
		
		return row;
	}
	
	// 비밀번호 변경 (비밀번호 분실 시)
	public int modifyForgetPw(int empNo, String newPw) {
		int row = loginMapper.modifyForgetPw(empNo, newPw);
		log.debug(CYAN + row + " <-- row(LoginService-modifyForgetPw)" + RESET);
		
		return row;
	}
	
}
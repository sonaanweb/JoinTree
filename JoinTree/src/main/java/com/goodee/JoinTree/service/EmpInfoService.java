package com.goodee.JoinTree.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.goodee.JoinTree.mapper.EmpInfoMapper;
import com.goodee.JoinTree.vo.AccountList;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
public class EmpInfoService {
	static final String CYAN = "\u001B[46m";
	static final String RESET = "\u001B[0m";
	
	@Autowired
	private EmpInfoMapper empInfoMapper;
	
	// 비밀번호 변경
	public int modifyPw(AccountList account) {
		int row = empInfoMapper.modifyPw(account);
		log.debug(CYAN + row + " <-- row(EmpInfoService-modifyPw)" + RESET);
		
		return row;
	}
	
	// 나의 정보 조회
	
	// 비밀번호 일치 체크 (나의 정보 변경 전)
	public int selectCheckPw(int empNo, String empPw) {
		int row = empInfoMapper.selectCheckPw(empNo, empPw);
		log.debug(CYAN + row + " <-- row(EmpInfoService-selectCheckPw)" + RESET);
		
		return row;
	}
}
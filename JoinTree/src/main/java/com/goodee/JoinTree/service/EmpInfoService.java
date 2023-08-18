package com.goodee.JoinTree.service;

import java.util.HashMap;
import java.util.Map;

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
	public Map<String, Object> getEmpOne(int empNo) {
		Map<String, Object> map = new HashMap<>();
		map = empInfoMapper.selectEmpOne(empNo);
		log.debug(CYAN + map + " <-- map(EmpInfoService-getEmpOne)" + RESET);
		
		return map;
	}
	
	// 비밀번호 일치 체크 (나의 정보 변경 전)
	public int selectCheckPw(int empNo, String empPw) {
		int row = empInfoMapper.selectCheckPw(empNo, empPw);
		log.debug(CYAN + row + " <-- row(EmpInfoService-selectCheckPw)" + RESET);
		
		return row;
	}
	
	// 나의 정보 수정
	public int modifyEmp(Map<String, Object> empInfo) {
		// 주소
		String zip = (String) empInfo.get("zip");
		String add1 = (String) empInfo.get("add1");
	    String add2 = (String) empInfo.get("add2");
	    String add3 = (String) empInfo.get("add3");
      
	    // 주소 합쳐서 저장
        String empAddress = String.join("-", zip, add1, add2, add3);
        log.debug(CYAN + empAddress + " <-- empAddress(EmpInfoService-modifyEmp)" + RESET);
      
        // 연락처
        String empPhone1 = (String)empInfo.get("empPhone1");
        String empPhone2 = (String)empInfo.get("empPhone2");
        String empPhone3 = (String)empInfo.get("empPhone3");
        
        // 연락처 합쳐서 저장
        String empPhone = String.join("-", empPhone1, empPhone2, empPhone3);
        log.debug(CYAN + empPhone+ " <-- empPhone(EmpInfoService)" + RESET);
      
        // 주민번호
        String empJuminNo1 = (String)empInfo.get("empJuminNo1");
        String empJuminNo2 = (String)empInfo.get("empJuminNo2");
        
        // 주민번호 합쳐서 저장
        String empJuminNo = String.join("-", empJuminNo1, empJuminNo2);
        log.debug(CYAN + empJuminNo + " <-- empJuminNo(EmpInfoService)" + RESET);
      
        // empInfo 값 저장(사번, 주소, 연락처, 주민번호)
        // empInfo.put("empNo", empNo);
        empInfo.put("empAddress", empAddress);
        empInfo.put("empPhone", empPhone);
	    empInfo.put("empJuminNo", empJuminNo);
	
		int row = empInfoMapper.modifyEmp(empInfo);
		log.debug(CYAN + row + " <-- row(EmpInfoService)" + RESET);

		return row;
	}
}
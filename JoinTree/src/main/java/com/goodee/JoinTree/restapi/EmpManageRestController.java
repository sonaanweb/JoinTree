package com.goodee.JoinTree.restapi;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.goodee.JoinTree.service.EmpManageService;
import com.goodee.JoinTree.vo.AccountList;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
public class EmpManageRestController {
	
	@Autowired
	EmpManageService empManageService;
	
	// 검색별 사원 리스트 조회
	@GetMapping("/empManage/searchEmpList")
	public Map<String, Object> searchEmpList(@RequestParam Map<String, Object> searchEmpListMap) {
		
		Map<String, Object> searchEmpListResult = empManageService.searchEmpList(searchEmpListMap);
		log.debug(searchEmpListResult +"<-- EmpManageRestController searchEmpListResult");
		
		return searchEmpListResult;
	}
	
	// 사원 상세정보 조회
	@GetMapping("/empManage/selectEmpOne")
	public Map<String, Object> selectEmpOne(@RequestParam int empNo) {
		
		Map<String, Object> selectEmpOne = empManageService.selectEmpOne(empNo);
		log.debug(selectEmpOne+"<-- EmpManageController selectEmpOne");
		
		return selectEmpOne;
	}
	
	// 사원 계정, 정보, 인사이동 이력 수정
	@PostMapping("/empManage/modifyEmp")
	public Map<String, Object> modifyEmpInfo(HttpSession session,
											 @RequestParam Map<String, Object> modifyEmpOneMap) {
		
		// 세션에서 사번 가져오기
		AccountList loginAccount = (AccountList)session.getAttribute("loginAccount");
		
		// 기본값 설정
		int createId = 0;
		int updateId = 0;
		
		if(loginAccount != null) {
			createId = loginAccount.getEmpNo();
			updateId = loginAccount.getEmpNo();
		}
		
        // updateId를 modifyEmpOneMap에 추가
        modifyEmpOneMap.put("createId", createId);
		modifyEmpOneMap.put("updateId", updateId);
        
        // 사원정보 수정
        Map<String, Object> modifyEmpRow = empManageService.modifyEmpInfo(modifyEmpOneMap);
		
        return modifyEmpRow;
	}
}

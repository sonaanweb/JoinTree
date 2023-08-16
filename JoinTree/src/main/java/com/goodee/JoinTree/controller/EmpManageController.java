package com.goodee.JoinTree.controller;

import java.util.*;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.goodee.JoinTree.service.EmpManageService;
import com.goodee.JoinTree.vo.CommonCode;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class EmpManageController {
	
	@Autowired
	private EmpManageService empManageService;
	
	// selectEmpList.jsp 
	@GetMapping("/empManage/selectEmpList")
	public String selectEmpList(Model model) {
		
		// 부서 조회
		List<CommonCode> deptCodeList = empManageService.deptCodeList();
		log.debug(deptCodeList+"<-- EmpManageController deptCodeList");
		
		// 직급 조회
		List<CommonCode> positionCodeList = empManageService.positionCodeList();
		log.debug(positionCodeList+"<-- EmpManageController empDeptCodeList");
		
		// 사원 상태 조회
		List<CommonCode> activeCodeList = empManageService.activeCodeList();
		log.debug(activeCodeList+"<-- EmpManageController activeCodeList");
		
		// view 전달
		model.addAttribute("deptCodeList", deptCodeList);
		model.addAttribute("positionCodeList", positionCodeList);
		model.addAttribute("activeCodeList", activeCodeList);
		
		return "/empManage/selectEmpList";
	}
	
	// 검색별 사원 리스트 조회
	@GetMapping("/empManage/searchEmpList")
	@ResponseBody
	public List<Map<String, Object>> searchEmpList(@RequestParam(name = "searchEmpList") String searchEmpList) {
		
		// JSON 형식의 검색 조건을 Map으로 반환
		ObjectMapper objectMapper = new ObjectMapper();
		Map<String, Object> searchEmpListMap = null;
		try {
			searchEmpListMap = objectMapper.readValue(searchEmpList, new TypeReference<Map<String, Object>>(){});
			log.debug(searchEmpListMap+"<-- EmpManageController searchEmpListMap");
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		} 
		
		// 검색 결과
		List<Map<String, Object>> searchEmpListResult = empManageService.searchEmpList(searchEmpListMap);
		log.debug(searchEmpListResult+"<-- EmpManageController searchEmpListResult");
		
		return searchEmpListResult;
	}
	
	// 사원 계정, 정보, 인사이동 이력 등록
	@PostMapping("/empManage/addEmp")
	public String addAccountList(Model model,
								 HttpSession session,
								 @RequestParam Map<String, Object> empInfo) {
		
		/* 세션에서 사번 가져오기
		Object loginAccount = (Object)session.getAttribute("loginAccount");
		
		// 기본값 설정
		int createId = 0; 
		int updateId = 0;
		
		if(loginAccount != null) {
			
			createId = loginAccount.getEmpNo();
			updateId = loginAccount.getEmpNo();
		}
		*/
		
		int createId = 20230001;
		int updateId = 20230001;
		
		// createId, updateId를 empInfo에 추가
		empInfo.put("createId", createId);
		empInfo.put("updateId", updateId);
		
		// 사원 정보 등록
		int addEmpInfoRow = empManageService.addEmpInfo(empInfo);
		
		// row 값의 따른 분기
		if(addEmpInfoRow  == 0) {
			
			// 사원등록 실패 시 errorMsg
			// String errorMsg = "사원 등록에 실패하였습니다."; // errorMsg
            // model.addAttribute("errorMsg", errorMsg); // 모델에 실패 메시지 추가
			
		} 
		
		return "redirect:/empManage/selectEmpList";
		
	}
	
}

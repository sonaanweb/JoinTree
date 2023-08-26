package com.goodee.JoinTree.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.*;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.goodee.JoinTree.service.EmpManageService;
import com.goodee.JoinTree.vo.AccountList;
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
	public Map<String, Object> searchEmpList(@RequestParam(name = "searchEmpList") String searchEmpList,
			 								 @RequestParam(name = "currentPage") int currentPage,
			 								 @RequestParam(name = "rowPerPage") int rowPerPage) {
		
		ObjectMapper objectMapper = new ObjectMapper();
		Map<String, Object> searchEmpListResult = null;
		
		try {
	        Map<String, Object> searchEmpListMap = objectMapper.readValue(searchEmpList, new TypeReference<Map<String, Object>>(){});
	        // 검색, 페이징 리스트
	        searchEmpListResult = empManageService.searchEmpList(searchEmpListMap, currentPage, rowPerPage);
	        
	    } catch (JsonProcessingException e) {
	        e.printStackTrace();
	        
	    } 
		
		return searchEmpListResult;
	}
	
	// 사원 상세정보 조회
	@GetMapping("/empManage/selectEmpOne")
	@ResponseBody
	public Map<String, Object> selectEmpOne(@RequestParam(name="empNo") int empNo) {
		
		Map<String, Object> selectEmpOne = empManageService.selectEmpOne(empNo);
		log.debug(selectEmpOne+"<-- EmpManageController selectEmpOne");
		
		return selectEmpOne;
	}
	
	// 사원 계정, 정보, 인사이동 이력 등록
	@PostMapping("/empManage/addEmp")
	public String addEmpInfo(Model model,
							 HttpSession session,
							 @RequestParam Map<String, Object> empInfo) throws UnsupportedEncodingException {
		
		//세션에서 사번 가져오기
		AccountList loginAccount = (AccountList)session.getAttribute("loginAccount");
		
		// 기본값 설정
		int createId = 0; 
		int updateId = 0;
		
		if(loginAccount != null) {
			
			createId = loginAccount.getEmpNo();
			updateId = loginAccount.getEmpNo();
		}
		
		// createId, updateId를 empInfo에 추가
		empInfo.put("createId", createId);
		empInfo.put("updateId", updateId);
		
		// 사원 정보 등록
		int addEmpInfoRow = empManageService.addEmpInfo(empInfo);
		log.debug(addEmpInfoRow+"<-- EmpManageController addEmpInfoRow");
		
		// 사원 등록, 실패 msg
		String msg = "";
		// row 값의 따른 분기
		if(addEmpInfoRow  == 0) {
			
			// 사원등록 실패 시 msg
			msg = "사원 등록에 실패하였습니다"; // msg
			msg = URLEncoder.encode(msg, "UTF-8");
			
		} else {
			
			// 사원등록 성공 시 msg
			msg = "사원 등록 성공"; // msg
			msg = URLEncoder.encode(msg, "UTF-8");
		}
		
		return "redirect:/empManage/selectEmpList?msg="+ msg;
		
	}
	
	// 사원 계정, 정보, 인사이동 이력 수정
	@PostMapping("/empManage/modifyEmp")
	@ResponseBody
	public Map<String, Object> modifyEmpInfo(HttpSession session,
											 @RequestBody Map<String, Object> modifyEmpOneMap) {
		log.debug(modifyEmpOneMap+"<-- EmpManageController modifyEmpOneMap");
		
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

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
		
		// 재직 사원 수 조회
		int empCnt = empManageService.getEmpCnt();
		log.debug(empCnt+"<-- EmpManageController empCnt");
		// view 전달
		model.addAttribute("deptCodeList", deptCodeList);
		model.addAttribute("positionCodeList", positionCodeList);
		model.addAttribute("activeCodeList", activeCodeList);
		model.addAttribute("empCnt", empCnt);
		
		return "/empManage/selectEmpList";
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
			msg = "사원 정보가 등록되었습니다"; // msg
			msg = URLEncoder.encode(msg, "UTF-8");
		}
		
		return "redirect:/empManage/selectEmpList?msg=" + msg + "&addEmpInfoRow=" + addEmpInfoRow;
		
	}
	
}

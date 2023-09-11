package com.goodee.JoinTree.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.goodee.JoinTree.service.CommuteManageService;
import com.goodee.JoinTree.service.EmpManageService;
import com.goodee.JoinTree.vo.AccountList;
import com.goodee.JoinTree.vo.CommonCode;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class CommuteManageController {
	
	@Autowired
	private EmpManageService empManageService;
	@Autowired
	private CommuteManageService commuteManageService;
	
	// commuteFullList.jsp(출퇴근 목록 조회)
	@GetMapping("/commuteManage/commuteFullList")
	public String selectCommuteFullList(Model model) {
		
		// 부서 조회
		List<CommonCode> deptCodeList = empManageService.deptCodeList();
		log.debug(deptCodeList+"<-- CommuteManageController deptCodeList");
		
		model.addAttribute("deptCodeList", deptCodeList);
		
		return "/commuteManage/commuteFullList";
	}
	
	// annualLeaveList.jsp(연차 조회)
	@GetMapping("/commuteManage/annualLeaveList")
	public String selectAnnualLeaveList(Model model) {
		
		// 부서 조회
		List<CommonCode> deptCodeList = empManageService.deptCodeList();
		log.debug(deptCodeList+"<-- CommuteManageController deptCodeList");
		
		model.addAttribute("deptCodeList", deptCodeList);
		
		return "/commuteManage/annualLeaveList";
	}
	
	// leaveRecodeList.jsp(연가 조회)
	@GetMapping("/commuteManage/leaveList")
	public String selectLeaveRecodeList(Model model) {
		
		// 연가 조회
		List<CommonCode> leaveCodeList = empManageService.leaveCodeList();
		log.debug(leaveCodeList+"<-- CommuteManageController leaveCodeList");
		
		// 직원 상태 조회
		List<CommonCode> activeCodeList = empManageService.activeCodeList();
		log.debug(activeCodeList+"<-- CommuteManageController activeCodeList");
		
		model.addAttribute("leaveCodeList",leaveCodeList);
		model.addAttribute("activeCodeList",activeCodeList);
		
		return "/commuteManage/leaveList";
	}
	
	// 연차 등록
	@PostMapping("/commuteManage/addAnnualLeave")
	public String addAnnualLeave(HttpSession session,
								 @RequestParam Map<String, Object> annualInfo) {
		
		log.debug(annualInfo+"<-- CommuteManageController param annualInfo");
		
		AccountList loginAccount = (AccountList)session.getAttribute("loginAccount");
		
		// 기본값 설정
		int empNo = 0; // 생성자, 수정자
		
		if(loginAccount != null) {
			
			empNo = loginAccount.getEmpNo();
		}
		
		// empNo를 annualInfo에 추가
		annualInfo.put("empNo", empNo);
		
		// 발생 연차 등록
		int addAnnualLeaveRow = commuteManageService.addAnnualLeave(annualInfo);
		log.debug(addAnnualLeaveRow+"<-- CommuteManageController addAnnualLeaveRow");
		
		return "redirect:/commuteManage/annualLeaveList";
	}
	
}

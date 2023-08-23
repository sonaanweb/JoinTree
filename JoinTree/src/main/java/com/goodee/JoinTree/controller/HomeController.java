package com.goodee.JoinTree.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.goodee.JoinTree.service.EmpInfoService;
import com.goodee.JoinTree.service.ProjectService;
import com.goodee.JoinTree.vo.AccountList;
import com.goodee.JoinTree.vo.Project;

@Controller
public class HomeController {
	@Autowired
	private EmpInfoService empInfoService;
	@Autowired
	private ProjectService projectService;
	
	@GetMapping("/home") 
	public String home(Model model,HttpSession session) {
		// 로그인 유저
		AccountList loginAccount = (AccountList) session.getAttribute("loginAccount");
		
		int empNo = loginAccount.getEmpNo();
		
		// 로그인한 사원 정보 
		Map<String, Object> empInfo = empInfoService.getEmpOne(empNo);
		
		// 서비스 레이어에서 가져온 참여중인 프로젝트 5개 조회 및 리스트 저장 
		List<Project> homeProejctList = projectService.selectProjectListByHome(empNo);
				
		model.addAttribute("empInfo", empInfo); // 로그인한 사원 정보 
		model.addAttribute("homeProejctList", homeProejctList); // 프로젝트 정보
		
		return "home"; // 포워딩
	}
	
}

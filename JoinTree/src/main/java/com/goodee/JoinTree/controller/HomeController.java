package com.goodee.JoinTree.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.goodee.JoinTree.service.BoardService;
import com.goodee.JoinTree.service.DocumentListService;
import com.goodee.JoinTree.service.EmpInfoService;
import com.goodee.JoinTree.service.ProjectService;
import com.goodee.JoinTree.vo.AccountList;
import com.goodee.JoinTree.vo.CommonCode;
import com.goodee.JoinTree.vo.DocumentDefault;
import com.goodee.JoinTree.vo.Project;

@Controller
public class HomeController {
	@Autowired
	private EmpInfoService empInfoService;
	@Autowired
	private ProjectService projectService;
	@Autowired
	private BoardService boardService;
	@Autowired
	private DocumentListService documentListService;
	
	@GetMapping("/home") 
	public String home(Model model,HttpSession session) {
		// 로그인 유저
		AccountList loginAccount = (AccountList) session.getAttribute("loginAccount");
		
		int empNo = loginAccount.getEmpNo();
		
		// 로그인한 사원 정보 
		Map<String, Object> empInfo = empInfoService.getEmpOne(empNo);
		
		// 서비스 레이어에서 가져온 참여중인 프로젝트 5개 조회 및 리스트 저장 
		List<Project> homeProejctList = projectService.selectProjectListByHome(empNo);
		
		// 최신 공지 목록 조회
		List<Map<String, Object>> getRecentNotice = boardService.getRecentNotice();
		
		// 기안문서 목록 조회
		List<DocumentDefault> getDraftDocList = documentListService.getDraftDocList(empNo);
		
		// 결재함 목록 조회
		List<DocumentDefault> getApprovalDocList = documentListService.getApprovalDocList(empNo);
				
		model.addAttribute("empInfo", empInfo); // 로그인한 사원 정보 
		model.addAttribute("homeProejctList", homeProejctList); // 프로젝트 정보
		model.addAttribute("getRecentNotice", getRecentNotice); // 최신 공지 목록
		model.addAttribute("getDraftDocList", getDraftDocList); // home.jsp 기안문서 목록
		model.addAttribute("getApprovalDocList", getApprovalDocList); // home.jsp 결재함 목록 조회
		
		return "home"; // 포워딩
	}
	
	// 사이드바 값 출력
	@GetMapping("/sideContent")
	public String sideContect(HttpSession session) {
		
		List<CommonCode> childCodeList = (List<CommonCode>) session.getAttribute("childCodeList");
		
		session.setAttribute("childCodeList", childCodeList);
		return "inc/sideContent";
	}
	
}

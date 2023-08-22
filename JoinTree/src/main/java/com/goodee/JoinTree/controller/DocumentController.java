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
import org.springframework.web.servlet.ModelAndView;

import com.goodee.JoinTree.service.DocumentService;
import com.goodee.JoinTree.service.EmpInfoService;
import com.goodee.JoinTree.service.OrgChartService;
import com.goodee.JoinTree.vo.AccountList;
import com.goodee.JoinTree.vo.CommonCode;
import com.goodee.JoinTree.vo.DocumentDefault;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class DocumentController {
	
	@Autowired
	private DocumentService documentService;
	@Autowired
	private OrgChartService orgChartService;
	@Autowired
	private EmpInfoService empInfoService;
	
	// document.jsp
	@GetMapping("/document/document")
	public String testDocument(Model model,HttpSession session) {
		
		// 결제문서양식 조회
		List<CommonCode> documentCodeList = documentService.documentCodeList();
		log.debug(documentCodeList+"<-- TestDocumentController documentCodeList");
		
		// 결재선 리스트
		List<CommonCode> deptList = orgChartService.selectOrgDept();
		
		// 로그인 유저
		AccountList loginAccount = (AccountList) session.getAttribute("loginAccount");
		
		int empNo = loginAccount.getEmpNo();
		
		// 로그인한 사원 정보 
		Map<String, Object> empInfo = empInfoService.getEmpOne(empNo);
		
		// 뷰에서 사용할 수 있도록 모델에 추가
		model.addAttribute("documentCodeList", documentCodeList);
		model.addAttribute("deptList", deptList); // 결재선 리스트
		model.addAttribute("empInfo", empInfo); // 로그인한 사원 정보 
		
		return "/document/document";
	}
	
	@GetMapping("/document/getDocumentForm")
	public ModelAndView getDocumentForm(Model model, HttpSession session, @RequestParam String selectedForm) {
		
		String path = "document/" + selectedForm;
		// 로그인 유저
		AccountList loginAccount = (AccountList) session.getAttribute("loginAccount");
		
		int empNo = loginAccount.getEmpNo();
		
		// 로그인한 사원 정보 
		Map<String, Object> empInfo = empInfoService.getEmpOne(empNo);
		
		// 뷰에서 사용할 수 있도록 모델에 추가
		model.addAttribute("empInfo", empInfo);
		
		return new ModelAndView(path);
	}
	
	@PostMapping("/document/docDefault")
	public String docDefault(DocumentDefault documentDefault) {
		int row = documentService.addDocDefault(documentDefault);	
		log.debug(row+"<--docDefault row ");
		
		if(row == 1) {
			
		return "/home";
		}else {
			return "/home";
		}
	}

}

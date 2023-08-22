package com.goodee.JoinTree.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.goodee.JoinTree.service.DocumentService;
import com.goodee.JoinTree.service.OrgChartService;
import com.goodee.JoinTree.service.TestDocumentService;
import com.goodee.JoinTree.vo.CommonCode;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class DocumentController {
	
	@Autowired
	private DocumentService documentService;
	@Autowired
	private OrgChartService orgChartService;
	
	// testDocument.jsp
	@GetMapping("/document/document")
	public String testDocument(Model model) {
		
		// 결제문서양식 조회
		List<CommonCode> documentCodeList = documentService.documentCodeList();
		log.debug(documentCodeList+"<-- TestDocumentController documentCodeList");
		
		// 결재선 리스트
		List<CommonCode> deptList = orgChartService.selectOrgDept();
		
		// 뷰에서 사용할 수 있도록 모델에 추가
		model.addAttribute("documentCodeList", documentCodeList);
		model.addAttribute("deptList", deptList); // 결재선 리스트
		
		return "/document/document";
	}
	
	@GetMapping("/document/getDocumentForm")
	public ModelAndView getDocumentForm(@RequestParam String selectedForm) {
		
		String path = "document/" + selectedForm;
		
		return new ModelAndView(path);
	}

}

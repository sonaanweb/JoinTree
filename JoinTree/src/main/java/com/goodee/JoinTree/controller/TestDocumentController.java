package com.goodee.JoinTree.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.goodee.JoinTree.service.TestDocumentService;
import com.goodee.JoinTree.vo.CommonCode;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class TestDocumentController {
	
	@Autowired
	private TestDocumentService testDocumentService;
	
	// testDocument.jsp
	@GetMapping("/document/testDocument")
	public String testDocument(Model model) {
		
		
		// 결제문서양식 조회
		List<CommonCode> documentCodeList = testDocumentService.documentCodeList();
		log.debug(documentCodeList+"<-- TestDocumentController documentCodeList");
		
		// view 전달
		model.addAttribute("documentCodeList", documentCodeList);
		
		return "/testDocument/testDocument";
	}
	
	@RequestMapping("/document/getDocumentForm")
	public ModelAndView getDocumentForm(@RequestParam String selectedForm) {
		
		String path = "testDocument/" + selectedForm;
		
		return new ModelAndView(path);
	}
}

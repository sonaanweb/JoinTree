package com.goodee.JoinTree.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.goodee.JoinTree.mapper.DocumentFileMapper;
import com.goodee.JoinTree.service.CodeService;
import com.goodee.JoinTree.service.DocumentListService;
import com.goodee.JoinTree.service.DocumentService;
import com.goodee.JoinTree.service.EmpInfoService;
import com.goodee.JoinTree.service.OrgChartService;
import com.goodee.JoinTree.vo.AccountList;
import com.goodee.JoinTree.vo.CommonCode;
import com.goodee.JoinTree.vo.DocumentDefault;
import com.goodee.JoinTree.vo.DocumentLeave;
import com.goodee.JoinTree.vo.DocumentReshuffle;
import com.goodee.JoinTree.vo.DocumentSigner;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class DocumentController {
	
	String yellow = "\u001B[33m";
	String reset = "\u001B[0m";
	
	@Autowired
	private DocumentService documentService;
	@Autowired
	private OrgChartService orgChartService;
	@Autowired
	private EmpInfoService empInfoService;
	@Autowired
	private CodeService codeService;
	@Autowired
	DocumentListService documentListService;
	
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
	// 문서양식 컨트롤러
	@GetMapping("/document/getDocumentForm")
	public ModelAndView getDocumentForm(Model model, HttpSession session, @RequestParam String selectedForm) {
		
		String path = "document/" + selectedForm;
		// 로그인 유저
		AccountList loginAccount = (AccountList) session.getAttribute("loginAccount");
		
		int empNo = loginAccount.getEmpNo();
		
		// 로그인한 사원 정보 
		Map<String, Object> empInfo = empInfoService.getEmpOne(empNo);
		
		// 휴가 리스트
		List<CommonCode> leaveList = codeService.selectChildCode("L01");
		
		// 직급 리스트
		List<CommonCode> positionList = codeService.selectChildCode("P01");
		
		// 부서 리스트
		List<CommonCode> deptList = codeService.selectChildCode("D02");
		
		// 뷰에서 사용할 수 있도록 모델에 추가
		model.addAttribute("empInfo", empInfo);
		model.addAttribute("leaveList", leaveList);
		model.addAttribute("positionList", positionList);
		model.addAttribute("deptList", deptList);
		
		return new ModelAndView(path);
	}
	
	// 기본 기안서, 퇴직기안서
	@PostMapping("/document/docDefault")
	@ResponseBody
	public int docDefault(DocumentDefault documentDefault) {
		
		int row = documentService.addDocDefault(documentDefault);
			
		log.debug(row+"<--docDefault row ");
		
		if(row != 1) { // 실패
			return 0;
		}
		
		return documentDefault.getDocNo();
	}
	
	// 휴가 기안서
	@PostMapping("/document/docLeave")
	@ResponseBody
	public String docLeave(DocumentLeave documentLeave) {
		
		int row = documentService.addDocLeave(documentLeave);
			
		log.debug(row+"<--docDefault row ");
		
		if(row != 1) { // 실패
			return "fail";
		}
		
		return "success";
	}
	
	// 인사이동 기안서
	@PostMapping("/document/docReshuffle")
	@ResponseBody
	public String docReshuffle(DocumentReshuffle documentReshuffle) {
		
		int row = documentService.addDocReshuffle(documentReshuffle);
			
		log.debug(row+"<--docDefault row ");
		
		if(row != 1) { // 실패
			return "fail";
		}
		
		return "success";
	}
	
	// 사인
	@PostMapping("/document/docSigner")
	@ResponseBody
	public String docSigner(DocumentSigner documentSigner) {
		int row = documentService.addDocSigner(documentSigner);

		if(row != 1) { // 실패
			return "fail";
		}
		
		return "success";
		
	}
	
	// 문서 파일 업로드
	@PostMapping("/document/fileUpload")
	@ResponseBody
	public String fileUpload(HttpSession session, HttpServletRequest request,
								@RequestParam("file") MultipartFile file, 
								@RequestParam("docNo") int docNo,
								@RequestParam("category") String category) {
		
		// 서비스 메서드 호출
		String fileUpload = documentService.fileUpload(session, request, file, docNo, category);
		
		return fileUpload;

	}
	
	// draftDocList.jsp
	@GetMapping("/document/draftDocList")
	public String documentList() {
		
		return "/document/draftDocList";
	}
	
	// approvalDocList.jsp
	@GetMapping("/document/approvalDocList")
	public String documentLeaveList() {
		
		return "/document/approvalDocList";
	}
	
	// documentReshuffletList.jsp
	@GetMapping("/document/individualDocList")
	public String documentReshuffletList() {
		
		return "/document/individualDocList";
	}
	
	// teamDocList.jsp
	@GetMapping("/document/teamDocList")
	public String documentResignList() {
		
		return "/document/teamDocList";
	}
	
	// 결재문서 상세 조회 폼 업로드
	@GetMapping("/document/getDocumentOneForm")
	public ModelAndView getDocumentOneForm(@RequestParam String docCode) {
		
		String path = "document/" + docCode + "One";
		
		return new ModelAndView(path);
	}
}

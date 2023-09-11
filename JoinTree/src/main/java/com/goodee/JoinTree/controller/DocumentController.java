package com.goodee.JoinTree.controller;

import java.util.HashMap;
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

import com.goodee.JoinTree.service.CodeService;
import com.goodee.JoinTree.service.CommuteManageService;
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
	private CommuteManageService commuteManageService;
	
	// document.jsp
	@GetMapping("/document/documentDraft")
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
		
		return "/document/documentDraft";
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
	
	
	// 결재자 결재 & 결재자 수에 따른 문서 결재 상태 변경 메서드(cnt 체크 추가)
	@PostMapping("/document/approveDocument")
	@ResponseBody
	public String approve(Model model, HttpServletRequest request, @RequestParam int docNo) {
		HttpSession session = request.getSession();
		AccountList loginAccount = (AccountList) session.getAttribute("loginAccount");

	    int empNo = loginAccount.getEmpNo();
        log.debug("empNo:" + empNo);

	    String signImg = (String) session.getAttribute("signImg");
        log.debug("signImg:" + signImg);
        
        if (signImg == null || signImg == "") {
        	return "fail";
        }

	    DocumentDefault docDefault = new DocumentDefault();
	    docDefault.setDocNo(docNo);
	    docDefault.setUpdateId(empNo);
	    
	    log.debug("docNo:" + docNo);

		DocumentSigner docSigner = new DocumentSigner();
		docSigner.setDocNo(docNo);
		docSigner.setEmpSignerNo(empNo);
		int signerLevel = documentService.getSignerLevel(docSigner);
		model.addAttribute("signerLevel", signerLevel);
		
		log.debug("signerLevel:" + signerLevel);
	      
	    int signerCnt = documentService.getSignerCnt(docNo);
	    model.addAttribute("signerCnt", signerCnt);
	    
	    log.debug("signerCnt:" + signerCnt);
	    
	    int row = 0;
	    
	    // 문서 결재 상태 A0201 대기(default) A0202 결재중 A0203 결재완료 A0204 반려
	    if (signerCnt == 1) {
	        // 한 명의 결재자가 있을 때, 첫 번째 결재자의 승인 시 결재완료 상태로 변경
	        docDefault.setDocStatus("A0203");
	        docDefault.setDocStamp2(signImg); // 결재자의 서명 이미지 저장
	        docSigner.setEmpSignerLevel(signerCnt);
	        docSigner.setDocStatus("A0203"); // 승인 시 signer 테이블 상태도 변경
	        row = documentService.approveDocDefault1(docDefault); // 결재 처리
	        row += documentService.modifySignerStatus(docSigner); // signer 테이블 변경
	        log.debug("row:" + row);
	        row ++; // 한명일 때도 ++
	        
	    } else if (signerCnt == 2) {
	        if (signerLevel == 1) {
	            // 두 명의 결재자가 있을 때, 첫 번째 결재자의 승인 시 결재중 상태로 변경
	            docDefault.setDocStatus("A0202");
	            docDefault.setDocStamp2(signImg); // 첫 번째 결재자의 서명 이미지 저장
	            
	            docSigner.setEmpSignerLevel(signerLevel);
	            docSigner.setDocStatus("A0203"); // 승인 시 signer 테이블 상태도 변경
	            
	            row += documentService.approveDocDefault1(docDefault);
	            row += documentService.modifySignerStatus(docSigner); // 상태 변경
	            log.debug("row:" + row);
	            
	            DocumentSigner secondSigner = new DocumentSigner();
	            secondSigner.setDocNo(docNo);
	            secondSigner.setEmpSignerLevel(2);
	            secondSigner.setDocStatus("A0202"); // 두 번째 결재자의 상태를 결재중으로 변경
	            row += documentService.modifySignerStatus(secondSigner);
	            log.debug("row:" + row);
	            
	        } else if (signerLevel == 2) {
	            // 두 명의 결재자가 있을 때, 두 번째 결재자의 승인 시 결재완료 상태로 변경
	            docDefault.setDocStatus("A0203");
	            docDefault.setDocStamp3(signImg); // 두 번째 결재자의 서명 이미지 저장
	            
	            docSigner.setEmpSignerLevel(signerLevel);
	            docSigner.setDocStatus("A0203"); // 승인 시 signer 테이블 상태도 변경
	            
	            row += documentService.approveDocDefault2(docDefault);
	            row += documentService.modifySignerStatus(docSigner); // 상태 변경
	            
	            row++; // 두번째 결재의 경우에도 row를 같이 증가시켜줘야 함
	            log.debug("row:" + row);
	        }
	    }

	    if (row == 3) {
	    	
	    	// DocumentDefault Map
	    	Map<String, Object> docDefaultOne = documentService.getDocumentDefaultOne(docNo);
	    	
	    	// DocumentLeave Map
	    	Map<String, Object> documentLeave = null;
	    	
	    	// 변수에 값 저장
	    	int docEmpNo = (Integer) docDefaultOne.get("empNo"); // 기안문서 사번
	    	String docCategory = (String) docDefaultOne.get("category"); // 문서 카테고리
	    	String docStatus = (String) docDefaultOne.get("docStatus"); // 문서 상태
	    	
	    	// 문서 카테고리 휴가('D0102'), 문서상태 결재완료('A0203') 연가 사용 등록, 연차 일 수 차감(공가 제외)
	    	if(docCategory.equals("D0102")) {
	    		
	    		if(docStatus.equals("A0203")) {
	    			
	    			documentLeave = new HashMap<>();
	    			documentLeave = documentService.getDocumentLeave(docNo); // DocumentLeave 값 저장
	    			documentLeave.put("docEmpNo", docEmpNo); // 기안문서 사번
	    			documentLeave.put("empNo", empNo); // 생성자, 수정자
	    			
	    			commuteManageService.addLeaveRecode(empNo, docEmpNo, documentLeave); // 연가 기록 등록
	    			commuteManageService.addAnnualLeave(documentLeave); // 사용연차 등록
	    		}
	    	}
	    	
	        return "success";
	    } else {
	        return "fail";
	    }
	}
	
	
	// 결재자 문서 반려
	@PostMapping("/document/reject")
	@ResponseBody
	public String reject(HttpSession session, int docNo) {
	    // 로그인 유저
	    AccountList loginAccount = (AccountList) session.getAttribute("loginAccount");
	    int empNo = loginAccount.getEmpNo();
	    
	    // 문서 상태 변경
	    DocumentDefault docDefault = new DocumentDefault();
	    docDefault.setDocNo(docNo);
	    docDefault.setUpdateId(empNo);
	    docDefault.setDocStatus("A0204"); // 반려 코드
	    int docDefaultRow = documentService.rejectDocDefault(docDefault);

	    // 결재자 테이블 상태 변경
	    DocumentSigner docSigner = new DocumentSigner();
	    docSigner.setDocNo(docNo);
	    docSigner.setEmpSignerNo(empNo);

	    // empSignerLevel 값을 가져와서 설정
	    int empSignerLevel = documentService.getSignerLevel(docSigner);
	    docSigner.setEmpSignerLevel(empSignerLevel);
	    docSigner.setDocStatus("A0204");
	    int docSignerRow = documentService.modifySignerStatus(docSigner);

	   
	    int signerCnt = documentService.getSignerCnt(docNo);
	    
	    if(signerCnt == 1) {
	    	if (docDefaultRow ==1 && docSignerRow == 1) {
	    		return "success";
	    	}
	    } else if (signerCnt ==2) {
	    // 결재자 수가 2명이고 현재 반려한 결재자가 첫 번째 결재자인 경우,
	    // 두 번째 결재자의 문서 상태도 반려로 변경합니다.
	    if (empSignerLevel == 1) {
	        DocumentSigner secondSigner = new DocumentSigner();
	        secondSigner.setDocNo(docNo);
	        secondSigner.setEmpSignerLevel(2); // 두 번째 결재자의 레벨
	        secondSigner.setDocStatus("A0204"); // 반려 코드
	        int secondSignerRow = documentService.modifySignerStatus(secondSigner);

	        if (docDefaultRow == 1 && docSignerRow == 1 && secondSignerRow == 1) {
	            return "success";
	        }
	    } else { // 결재자 수가 1명이거나 현재 반려한 결재자가 두 번째 결재자인 경우
	        if (docDefaultRow == 1 && docSignerRow == 1) {
	            return "success";
	        }
	    }
	 }

	    return "fail";
	}


}

package com.goodee.JoinTree.restapi;

import java.util.*;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.goodee.JoinTree.service.DocumentListService;
import com.goodee.JoinTree.vo.AccountList;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
public class DocumentRestController {
	
	@Autowired
	private DocumentListService documentListService;
	
	// 검색별 문서 리스트 조회
	@GetMapping("/getDocumentList")
	public Map<String, Object> getDocumentList(HttpSession session,
											   @RequestParam Map<String, Object> docMap) {
		
		log.debug(docMap+"<-- DocumentListRestController docMap");
		
		// 세션에서 사번 가져오기
		AccountList loginAccount = (AccountList)session.getAttribute("loginAccount");
		
		// 기본값 설정
		int empNo = 0; // 사번
		String dept = null; // 부서
		
		if(loginAccount != null) {
			
			empNo = loginAccount.getEmpNo();
			dept = (String)session.getAttribute("dept");
		}
		
		docMap.put("empNo", empNo);
		docMap.put("dept", dept);
		
		// 문서함 별 문서 목록 조회
		Map<String, Object> getDocumentListResult = documentListService.getDocList(docMap);
		log.debug(getDocumentListResult +"<-- DocumentListRestController getDocumentListResult");
		
		return getDocumentListResult;
	}
}

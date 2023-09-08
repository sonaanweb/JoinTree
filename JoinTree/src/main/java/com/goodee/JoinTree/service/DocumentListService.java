package com.goodee.JoinTree.service;

import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.goodee.JoinTree.mapper.DocumentListMapper;
import com.goodee.JoinTree.vo.DocumentDefault;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class DocumentListService {
	
	@Autowired
	private DocumentListMapper documentListMapper;
	
	// 문서함 별 목록 조회
	public Map<String, Object> getDocList(Map<String, Object> docMap) {
		
		// 문서함 id값 저장
		String listId = (String)docMap.get("listId");
		
		// 반환값1 (검색 조건 별 행의 수)
		int searchDocListCnt = 0;
		
		// 문서함 id값에 따른 분기
		if(listId.equals("draftDocList")) { // 기안문서목록
			
			searchDocListCnt = documentListMapper.getDraftDocListCnt(docMap);
			
		} else if(listId.equals("approvalDocList")) { // 결재함
			
			searchDocListCnt = documentListMapper.getApprovalDocListCnt(docMap);
			
		} else if(listId.equals("individualDocList")) { // 개인문서함
			
			searchDocListCnt = documentListMapper.getIndividualDocListCnt(docMap);
			
		} else if(listId.equals("teamDocList")){ // 팀별문서함
			
			searchDocListCnt = documentListMapper.getTeamDocListCnt(docMap);
		}
		
		// 페이징
		int currentPage = Integer.parseInt((String) docMap.get("currentPage")); // 현재 페이지
		int rowPerPage = Integer.parseInt((String) docMap.get("rowPerPage")); // 페이지당 행의 수
		
		// 시작 행번호
		int beginRow = (currentPage-1)*rowPerPage;
		
		// 마지막 페이지
		int lastPage = searchDocListCnt / rowPerPage;
		if(searchDocListCnt % rowPerPage !=0) {
			lastPage +=1;
		}
		
		// 페이지 블럭
		int currentblock = 0; // 현제 페이지 블럭(currentPage / pageLength)
		int pageLength = 10; // 현제 페이지 블럭의 들어갈 페이지 수
		if(currentPage % pageLength == 0) {
			currentblock = currentPage / pageLength;
		} else {
			currentblock = (currentPage / pageLength) +1;
		}
		
		int startPage = (currentblock -1) * pageLength +1; // 블럭의 시작페이지
		int endPage = startPage + pageLength -1; // 블럭의 마지막 페이지
		if(endPage > lastPage) {
			endPage = lastPage;
		}
		
		// docMap에 값 저장
		docMap.put("beginRow", beginRow);
		docMap.put("rowPerPage", rowPerPage);
		
		// 반환값2 (검색 조건 별 목록)
		List<Map<String, Object>> searchDocListbyPage = null;
		
		// 문서함 id 값에 따른 분기
		if(listId.equals("draftDocList")) { // 기안문서목록
			
			searchDocListbyPage = documentListMapper.getDraftDocList(docMap);
			
		} else if(listId.equals("approvalDocList")) { // 결재함
			
			searchDocListbyPage = documentListMapper.getApprovalDocList(docMap);
			
		} else if(listId.equals("individualDocList")) { // 개인문서함
			
			searchDocListbyPage = documentListMapper.getIndividualDocList(docMap);
			
		} else if(listId.equals("teamDocList")){ // 팀별문서함
			
			searchDocListbyPage = documentListMapper.getTeamDocList(docMap);
		}
		
		log.debug(searchDocListbyPage+"<-- DocumentListService searchDocListbyPage");
		
		
		Map<String, Object> searchDocListResult = new HashMap<>();
		searchDocListResult.put("searchDocListbyPage", searchDocListbyPage);
		searchDocListResult.put("startPage", startPage);
		searchDocListResult.put("endPage", endPage);
		searchDocListResult.put("lastPage", lastPage);
		searchDocListResult.put("pageLength", pageLength);
		searchDocListResult.put("currentPage", currentPage);
		
		return searchDocListResult;
	}
	
	// home.jsp 기안문서 목록 조회
	public List<DocumentDefault> getDraftDocList(int empNo){
		
		List<DocumentDefault> getDraftDocList = documentListMapper.getDraftDocListHome(empNo);
		log.debug(getDraftDocList+"<-- DocumentListService getDraftDocList");
		
		return getDraftDocList;
	}

	// home.jsp 결재함 목록 조회
	public List<DocumentDefault> getApprovalDocList(int empNo){
		
		List<DocumentDefault> getApprovalDocList = documentListMapper.getApprovalDocListHome(empNo);
		log.debug(getApprovalDocList+"<-- DocumentListService getApprovalDocList");
		
		return getApprovalDocList;
	}
	
	// 기안문서 목록 행의 수
	public int getgetDraftDocCnt(int empNo) {
		
		Map<String, Object> mapEmpNo = new HashMap<>();
		mapEmpNo.put("empNo", empNo);
		
		int getDraftDocCnt = documentListMapper.getDraftDocListCnt(mapEmpNo);
		log.debug(getDraftDocCnt+"<-- DocumentListService getDraftDocCnt");
		
		return getDraftDocCnt;
	}
	
	// 결재함 목록 행의 수
	public int getApprovalDocCnt(int empNo) {
		
		Map<String, Object> mapEmpNo = new HashMap<>();
		mapEmpNo.put("empNo", empNo);
		
		int getApprovalDocCnt = documentListMapper.getApprovalDocListCnt(mapEmpNo);
		log.debug(getApprovalDocCnt+"<-- DocumentListService getApprovalDocCnt");
		
		return getApprovalDocCnt;
	}

}

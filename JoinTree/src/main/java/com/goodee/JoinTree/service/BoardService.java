package com.goodee.JoinTree.service;

import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.goodee.JoinTree.mapper.BoardMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class BoardService {
	
	@Autowired
	private BoardMapper boardMapper;
	
	// 게시판 글 등록
	public int addBoard(Map<String, Object> boardMap) {
		
		return 0;
	}
	
	// 게시판 목록 조회
	public Map<String, Object> getBoardList(Map<String, Object> boardListMap) {
		
		// 반환값1(검색 조건 별 행의 수)
		int boardListCnt = boardMapper.boardListCnt(boardListMap);
		log.debug(boardListCnt + "<-- BoardService boardListCnt");
		
		// 페이징
		int currentPage = Integer.parseInt((String) boardListMap.get("currentPage")); // 현재 페이지
		int rowPerPage = Integer.parseInt((String) boardListMap.get("rowPerPage")); // 페이지당 행의 수
		
		// 시작 행번호
		int beginRow = (currentPage-1)*rowPerPage;
		
		// 마지막 페이지
		int lastPage = boardListCnt / rowPerPage;
		if(boardListCnt % rowPerPage !=0) {
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
		
		// boardListMap에 값 저장
		boardListMap.put("beginRow", beginRow);
		boardListMap.put("rowPerPage", rowPerPage);
		
		// 반환값2(검색 조건 별 게시판 글 목록)
		List<Map<String, Object>> getBoardList = boardMapper.getBoardList(boardListMap);
		log.debug(getBoardList+"BoardService getBoardList");
		
		// 반환값 Map에 저장
		Map<String,Object> getBoardListResult = new HashMap<>();
		getBoardListResult.put("getBoardList", getBoardList);
		getBoardListResult.put("startPage", startPage);
		getBoardListResult.put("endPage", endPage);
		getBoardListResult.put("lastPage", lastPage);
		getBoardListResult.put("pageLength", pageLength);
		
		return getBoardListResult;
	}
	
	// 게시판 상단고정 목록 조회
	public List<Map<String, Object>> getBoardPinnedList(String boardCategory) {
		
		List<Map<String,Object>> getBoardPinnedList = boardMapper.getBoardPinnedList(boardCategory);
		log.debug(getBoardPinnedList+"BoardService getBoardPinnedList");
		
		return getBoardPinnedList;
	}

}

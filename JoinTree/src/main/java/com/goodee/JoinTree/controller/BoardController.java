package com.goodee.JoinTree.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.goodee.JoinTree.service.BoardService;
import com.goodee.JoinTree.vo.AccountList;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class BoardController {
	@Autowired
	BoardService boardService;
	
	// noticeList.jsp
	@GetMapping("/board/noticeList")
	public String noticeList(Model model, HttpSession session) {
		
		// 세션 값 가져오기
		AccountList loginAccount = (AccountList)session.getAttribute("loginAccount");
		
		String dept = (String)session.getAttribute("dept"); // 부서
		
		int empNo = 0; // 사번
		if(loginAccount != null) {
			empNo = loginAccount.getEmpNo();
		}
		
		String boardCategory = "B0101"; // 게시판 카테고리 코드 
		
		model.addAttribute("empNo", empNo);
		model.addAttribute("dept", dept);
		model.addAttribute("boardCategory", boardCategory);
		
		return "/board/noticeList";
	}
	
	// addBoard.jsp
	@GetMapping("/board/addBoardForm")
	public String addBoardForm(Model model, 
							   @RequestParam String boardCategory) {
		
		// boardCategory 값에 따른 게시판 카테고리 분기
		if(boardCategory.equals("B0101")){
			boardCategory = "공지사항";
		} else {
			boardCategory = "자료실";
		}
		
		model.addAttribute("boardCategory", boardCategory);
		
		return "/board/addBoard";
	}
	
	// 게시글 등록
	@GetMapping("/board/addBoard")
	public String addBoard(HttpSession session,
						   @RequestParam Map<String, Object> boardMap) throws UnsupportedEncodingException {
		
		// 세션 값 가져오기
		AccountList loginAccount = (AccountList)session.getAttribute("loginAccount");
		
		// 기본 값 설정
		int createId = 0; // 생성자
		int updateId = 0; // 수정자
		
		// 세션값이 비어 있지 않을 경우 생성자, 수정자 id 값 저장
		if(loginAccount != null) { 
			
			createId = loginAccount.getEmpNo();
			updateId = loginAccount.getEmpNo();
		}
		
		// boardMap에 값 추가
		boardMap.put("createId", createId);
		boardMap.put("updateId", updateId);
		
		// 게시글 등록 후 반환 값 저장
		int addBoardRow = boardService.addBoard(boardMap);
		log.debug(addBoardRow + "<-- BoardController addBoardRow");
		
		// 게시글 등록, 실패 msg
		String msg = "";
		// row 값의 따른 분기
		if(addBoardRow  == 0) {
			
			// 게시글 등록 실패 시 msg
			msg = "게시글 등록 실패"; // msg
			msg = URLEncoder.encode(msg, "UTF-8");
			
		} else {
			
			// 사원등록 성공 시 msg
			msg = "게시글 등록 성공"; // msg
			msg = URLEncoder.encode(msg, "UTF-8");
		}
		
		return "redirect:/board/addBoard?msg="+msg;
	}
}

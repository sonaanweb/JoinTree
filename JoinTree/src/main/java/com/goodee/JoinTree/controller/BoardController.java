package com.goodee.JoinTree.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.goodee.JoinTree.service.BoardService;
import com.goodee.JoinTree.service.CommunityService;
import com.goodee.JoinTree.vo.AccountList;
import com.goodee.JoinTree.vo.Board;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class BoardController {
	
	@Autowired
	private BoardService boardService;
	@Autowired
	private CommunityService communityService;
	
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
		String boardCategoryName = "공지사항"; // 게시판 카테고리명
		
		model.addAttribute("empNo", empNo);
		model.addAttribute("dept", dept);
		model.addAttribute("boardCategory", boardCategory);
		model.addAttribute("boardCategoryName", boardCategoryName);
		
		return "/board/noticeList";
	}
	
	// libraryList.jsp
	@GetMapping("/board/libraryList")
	public String libraryList(Model model, HttpSession session) {
		
		// 세션 값 가져오기
		AccountList loginAccount = (AccountList)session.getAttribute("loginAccount");
		
		String dept = (String)session.getAttribute("dept"); // 부서
		
		int empNo = 0; // 사번
		if(loginAccount != null) {
			empNo = loginAccount.getEmpNo();
		}
		
		String boardCategory = "B0102"; // 게시판 카테고리 코드
		String boardCategoryName = "자료실"; // 게시판 카테고리명
		
		model.addAttribute("empNo", empNo);
		model.addAttribute("dept", dept);
		model.addAttribute("boardCategory", boardCategory);
		model.addAttribute("boardCategoryName", boardCategoryName);
		
		return "/board/libraryList";
	}
	
	// addBoard.jsp
	@GetMapping("/board/addBoardForm")
	public String addBoardForm(Model model, 
							   @RequestParam String boardCategory) {
		String boardCategoryName = null;
		
		// boardCategory 값에 따른 게시판 카테고리 분기
		if(boardCategory.equals("B0101")){
			boardCategory = "B0101";
			boardCategoryName = "공지사항";
		} else {
			boardCategory = "B0102";
			boardCategoryName = "자료실";
		}
		
		model.addAttribute("boardCategory", boardCategory);
		model.addAttribute("boardCategoryName",boardCategoryName);
		
		return "/board/addBoard";
	}
	
	// boardOne.jsp
	@GetMapping("/board/boardOne")
	public String boardOne(Model model, @RequestParam int boardNo) {
		
		Map<String, Object> board = boardService.getBoardOne(boardNo); // 게시글 상세조회 반환 값
		log.debug(board + "<-- BoardController boardOne board");
		
		// 조회 수 증가 쿼리 실행
		communityService.increaseCommCount(boardNo);
		
		String boardCategory = (String) board.get("boardCategory");// 게시판 카테고리 코드명
		String categoryCode = (String) board.get("categoryCode"); // 게시판 카테고리 코드
		log.debug(boardCategory + "<-- BoardController boardOne boardCategory");
		log.debug(categoryCode + "<-- BoardController boardOne categoryCode");
		
		// 카테고리명 별 값 저장
		if(boardCategory.equals("공지사항")) {
			boardCategory = "noticeList";
			
		} else {
			boardCategory = "libraryList";
		}
		
		// 이전 글 번호 조회
		Integer preBoardNo = boardService.getPreBoard(boardNo, categoryCode);
		log.debug(preBoardNo + "<-- BoardController preBoardNo");
		
		// 다음 글 번호 조회
		Integer nextBoardNo = boardService.getNextBoard(boardNo, categoryCode);
		log.debug(nextBoardNo + "<-- BoardController nextBoardNo");
		
		model.addAttribute("board", board);
		model.addAttribute("boardCategory", boardCategory);
		model.addAttribute("preBoardNo", preBoardNo);
		model.addAttribute("nextBoardNo", nextBoardNo);
		
		return "/board/boardOne";
	}
	
	// modifyBoard.jsp
	@GetMapping("/board/modifyBoardForm")
	public String modifyBoardForm(Model model, @RequestParam int boardNo) {
		
		Map<String, Object> board = boardService.getBoardOne(boardNo); // 게시글 상세조회 반환 값
		
		model.addAttribute("board", board);
		
		return "/board/modifyBoard";
	}
	
	// 게시글 등록
	@PostMapping("/board/addBoard")
	public String addBoard(HttpSession session, HttpServletRequest request, 
			           	   Board board) throws UnsupportedEncodingException {
		
		// 파일 저장 경로 설정
		String path = request.getServletContext().getRealPath("/boardFile/");
		
		// 세션 값 가져오기
		AccountList loginAccount = (AccountList)session.getAttribute("loginAccount");
		
		// 기본 값 설정
		int empNo = 0; // 사번
		
		// 세션값이 비어 있지 않을 경우 사번 저장
		if(loginAccount != null) { 
			empNo = loginAccount.getEmpNo();
		}
		
		// Board vo에 값 저장
		board.setEmpNo(empNo);
		
		// 게시글 등록 후 반환 값 저장
		int addBoardRow = boardService.addBoard(board, path);
		log.debug(addBoardRow + "<-- BoardController addBoardRow");
		
		// 게시글 등록, 실패 msg
		String msg = "";
		
		// addBoardRow 값의 따른 분기
		if(addBoardRow  == 0) {
			
			// 게시글 등록 실패 시 msg
			msg = "게시글 등록 실패"; 
			msg = URLEncoder.encode(msg, "UTF-8");
			
			// 게시판 카테고리 별 경로 분기
			if(board.getBoardCategory().equals("B0101")) {
				return "redirect:/board/addBoardForm?boardCategory=B0101&msg="+msg;
			} else {
				return "redirect:/board/addBoardForm?boardCategory=B0102&msg="+msg;
			}
			
		} else {
			// 게시글 등록 성공 시 msg
			msg = "게시글이 등록되었습니다"; 
			msg = URLEncoder.encode(msg, "UTF-8");
			
			// 게시판 카테고리 별 경로 분기
			if(board.getBoardCategory().equals("B0101")) {
				return "redirect:/board/noticeList?msg=" + msg;
			} else {
				return "redirect:/board/libraryList?msg=" + msg;
			}
		}
		
	}
	
	// 게시글 수정
	@PostMapping("/board/modifyBoard")
	public String modifyBoard(HttpSession session, HttpServletRequest request, 
							  Board board) throws UnsupportedEncodingException {
		
		// 게시글 번호 저장
		int boardNo = board.getBoardNo();
		
		// 파일 저장 경로 설정
		String path = request.getServletContext().getRealPath("/boardFile/");
		
		// 세션 값 가져오기
		AccountList loginAccount = (AccountList)session.getAttribute("loginAccount");
		
		// 기본 값 설정
		int empNo = 0; // 사번
		
		// 세션값이 비어 있지 않을 경우 사번 저장
		if(loginAccount != null) { 
			empNo = loginAccount.getEmpNo();
		}
		
		// Board vo에 값 저장
		board.setEmpNo(empNo);
		
		// 게시글 수정 후 반환 값 저장
		int modifyBoardRow = boardService.modifyBoard(board, path);
		log.debug(modifyBoardRow + "<-- BoardController modifyBoardRow");
		
		// 게시글 수정, 실패 msg
		String msg = "";
		
		// modifyBoardRow 값의 따른 분기
		if(modifyBoardRow == 0) {
			
			// 게시글 수정 실패 시 msg
			msg = "게시글 수정 실패";
			msg = URLEncoder.encode(msg, "UTF-8");
			
			return "redirect:/board/modifyBoard?boardNo=" + boardNo +"&msg=" + msg;
			
		} else {
			
			// 게시글 수정 성공 시 msg
			msg = "게시글이 수정 되었습니다"; 
			msg = URLEncoder.encode(msg, "UTF-8");
			
			return "redirect:/board/boardOne?boardNo=" + boardNo +"&msg=" + msg;
		}
	}
	
	// 게시글 삭제
	@GetMapping("/board/removeBoard")
	public String removeBoard(HttpServletRequest request, int boardNo) throws UnsupportedEncodingException {
		
		// 파일 저장 경로 설정
		String path = request.getServletContext().getRealPath("/boardFile/");
		
		// 게시판 카테고리 코드
		Map<String, Object> board = boardService.getBoardOne(boardNo);
		String categoryCode = (String) board.get("categoryCode");
		
		// 게시글 삭제 반환 값
		int removeBoardRow = boardService.removeBoard(boardNo, path);
		log.debug(removeBoardRow + "<-- BoardController removeBoardRow");
		
		// 게시글 수정, 실패 msg
		String msg = "";
		
		// 반환 값의 따른 경로 분기
		if(removeBoardRow == 0) {
			// 게시글 삭제 실패 시 msg
			msg = "게시글 삭제 실패"; 
			msg = URLEncoder.encode(msg, "UTF-8");
			
			return "redirect:/board/boardOne?boardNo=" + boardNo +"&msg=" + msg + "&removeBoardRow=" + removeBoardRow;
		} else {
			
			// 게시글 삭제 실패 시 msg
			msg = "게시글이 삭제되었습니다"; 
			msg = URLEncoder.encode(msg, "UTF-8");
			
			if(categoryCode.equals("B0101")) {
				return "redirect:/board/noticeList?msg=" + msg;
			} else {
				return "redirect:/board/libraryList?msg=" + msg;
			}	
		}
	}
}

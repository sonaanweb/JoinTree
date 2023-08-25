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

import com.goodee.JoinTree.controller.CommunityController;
import com.goodee.JoinTree.service.CommunityService;
import com.goodee.JoinTree.vo.Board;
import com.goodee.JoinTree.vo.BoardFile;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class CommunityController {
	static final String CYAN = "\u001B[46m";
	static final String RESET = "\u001B[0m";
	
	String msg = "";
	
	@Autowired
	private CommunityService communityService;
	
	// 자유 게시판 게시글 목록
	@GetMapping("/community/freeCommList")
	public String freeCommList(Model model, @RequestParam(name = "currentPage", defaultValue = "1") int currentPage,
			@RequestParam(name = "rowPerPage", defaultValue = "10") int rowPerPage, 
			@RequestParam(name = "category", defaultValue = "B0103") String category) {
		
		Map<String, Object> resultMap = communityService.getCommList(category, currentPage, rowPerPage);
		
		log.debug(CYAN + resultMap.get("commList") + " <-- commList(CommunityController-freeCommList)" + RESET);
		log.debug(CYAN + resultMap.get("pinnedCommList") + " <-- pinnedCommList(CommunityController-freeCommList)" + RESET);
		
		// view로 값 넘길 때는 분리
		model.addAttribute("category", category);
		model.addAttribute("pinnedCommList", resultMap.get("pinnedCommList"));
		model.addAttribute("commList", resultMap.get("commList"));
		
		model.addAttribute("lastPage", resultMap.get("lastPage"));
		model.addAttribute("currentPage", currentPage);
		
		return "/community/freeCommList";
	}
	
	// 익명 게시판 게시글 목록
	@GetMapping("/community/anonymousCommList")
	public String anonymousCommList(Model model, @RequestParam(name = "currentPage", defaultValue = "1") int currentPage,
			@RequestParam(name = "rowPerPage", defaultValue = "10") int rowPerPage, 
			@RequestParam(name = "category", defaultValue = "B0104") String category) {
		
		Map<String, Object> resultMap = communityService.getCommList(category, currentPage, rowPerPage);
		
		log.debug(CYAN + resultMap.get("commList") + " <-- commList(CommunityController-freeCommList)" + RESET);
		
		// view로 값 넘길 때는 분리
		model.addAttribute("category", category);
		model.addAttribute("commList", resultMap.get("commList"));
		
		model.addAttribute("lastPage", resultMap.get("lastPage"));
		model.addAttribute("currentPage", currentPage);
		
		return "/community/anonymousCommList";
	}
	
	// 중고장터 게시판 게시글 목록
	@GetMapping("/community/secondhandCommList")
	public String secondhandCommList(Model model, @RequestParam(name = "currentPage", defaultValue = "1") int currentPage,
			@RequestParam(name = "rowPerPage", defaultValue = "10") int rowPerPage, 
			@RequestParam(name = "category", defaultValue = "B0105") String category) {
		
		Map<String, Object> resultMap = communityService.getCommList(category, currentPage, rowPerPage);
		
		log.debug(CYAN + resultMap.get("commList") + " <-- commList(CommunityController-freeCommList)" + RESET);
		
		// view로 값 넘길 때는 분리
		model.addAttribute("category", category);
		model.addAttribute("commList", resultMap.get("commList"));
		
		model.addAttribute("lastPage", resultMap.get("lastPage"));
		model.addAttribute("currentPage", currentPage);
		
		return "/community/secondhandCommList";
	}
	
	// 경조사 게시판 게시글 목록
	@GetMapping("/community/lifeEventCommList")
	public String lifeEventCommList(Model model, @RequestParam(name = "currentPage", defaultValue = "1") int currentPage,
			@RequestParam(name = "rowPerPage", defaultValue = "10") int rowPerPage, 
			@RequestParam(name = "category", defaultValue = "B0106") String category) {
		
		Map<String, Object> resultMap = communityService.getCommList(category, currentPage, rowPerPage);
		
		log.debug(CYAN + resultMap.get("commList") + " <-- commList(CommunityController-freeCommList)" + RESET);
		
		// view로 값 넘길 때는 분리
		model.addAttribute("category", category);
		model.addAttribute("commList", resultMap.get("commList"));
		
		model.addAttribute("lastPage", resultMap.get("lastPage"));
		model.addAttribute("currentPage", currentPage);
		
		return "/community/lifeEventCommList";
	}
	
	
	// 자유 게시판 게시글 상세보기
	@GetMapping("/community/freeCommList/freeCommOne")
	public String freeCommOne(Model model, @RequestParam(name="boardNo") int boardNo) {
		// 게시글 정보 가져오기
		Map<String, Object> map = communityService.getCommOne(boardNo);
		log.debug(CYAN + map + " <-- map(CommunityController-freeCommOne)" + RESET);
		
		Board comm = (Board) map.get("comm");
		BoardFile boardFile = (BoardFile)map.get("boardFile");
		
		// 조회수 증가 처리
		communityService.increaseCommCount(boardNo);
		
		model.addAttribute("comm", comm);
		model.addAttribute("boardFile", boardFile);
		
		log.debug(CYAN + comm + " <-- comm(CommunityController-freeCommOne)" + RESET);
		log.debug(CYAN + boardFile + " <-- boardFile(CommunityController-freeCommOne)" + RESET);
		
		return "/community/freeCommOne";
	}

	// 자유 게시판 게시글 작성
	@GetMapping("/community/freeCommList/addFreeComm")
	public String addFreeComm() {
		
		return "/community/addFreeComm";
	}
	
	// 자유게시판 게시글 작성 액션
	@PostMapping("/community/freeCommList/addFreeComm")
	public String addFreeComm(HttpServletRequest request, Board board) throws UnsupportedEncodingException {
		String path = request.getServletContext().getRealPath("/commImg/");
		
		// 세션에서 dept 값을 가져오기 위해 HttpSession 객체 사용
		HttpSession session = request.getSession();
		String dept = (String) session.getAttribute("dept");
		log.debug(CYAN + dept + " <-- row(CommunityController-addFreeComm)" + RESET);
		
		// 로그인 세션 부서값이 경영팀이고 상단고정 체크박스 선택했을 경우
		if (dept.equals("D0202") && request.getParameter("boardPinned") != null) {
			board.setBoardPinned("1");
		} else {
			board.setBoardPinned("0");
		}
		
		int row = communityService.addComm(board, path);
		
		log.debug(CYAN + row + " <-- row(CommunityController-addFreeComm)" + RESET);
		
		if (row == 1) {
			msg = URLEncoder.encode("게시글이 등록되었습니다.", "UTF-8");
			
			return "redirect:/community/freeCommList?msg=" + msg;
		} else {
			msg = URLEncoder.encode("게시글 등록에 실패했습니다. 관리자에게 문의해주세요.", "UTF-8");
			return "redirect:/community/freeCommList/addFreeComm?msg=" + msg;
		}
	}
	
	// 자유 게시판 게시글 수정
	@GetMapping("/community/freeCommList/modifyFreeComm")
	public String modifyFreeComm(Model model, int boardNo) {
		// 게시글 정보 가져오기
		Map<String, Object> map = communityService.getCommOne(boardNo);
		log.debug(CYAN + map + " <-- map(CommunityController-freeCommOne)" + RESET);
		
		Board comm = (Board) map.get("comm");
		BoardFile boardFile = (BoardFile)map.get("boardFile");
		
		model.addAttribute("comm", comm);
		model.addAttribute("boardFile", boardFile);
		
		log.debug(CYAN + comm + " <-- comm(CommunityController-freeCommOne)" + RESET);
		log.debug(CYAN + boardFile + " <-- boardFile(CommunityController-freeCommOne)" + RESET);
		
		return "/community/modifyFreeComm";
	}
	
	// 자유게시판 게시글 수정 액션
	@PostMapping("/community/freeCommList/modifyFreeComm") 
	public String modifyFreeComm(HttpServletRequest request, Board board) throws UnsupportedEncodingException {
		// 세션에서 dept 값을 가져오기 위해 HttpSession 객체 사용
		HttpSession session = request.getSession();
		String dept = (String) session.getAttribute("dept");
		log.debug(CYAN + dept + " <-- row(CommunityController-addFreeComm)" + RESET);
		
		// 로그인 세션 부서값이 경영팀이고 상단고정 체크박스 선택했을 경우
		if (dept.equals("D0202") && request.getParameter("boardPinned") != null) {
			board.setBoardPinned("1");
		} else {
			board.setBoardPinned("0");
		}
		
		int row = communityService.modifyComm(board);
		log.debug(CYAN + row + " <-- row(CommunityController-modifyFreeComm)" + RESET);
		
		if (row == 1) {
			msg = URLEncoder.encode("게시글이 수정되었습니다.", "UTF-8");
			
			return "redirect:/community/freeCommList/freeCommOne?boardNo=" + board.getBoardNo() + "&msg=" + msg;
		} else {
			msg = URLEncoder.encode("게시글 수정에 실패했습니다. 관리자에게 문의해주세요.", "UTF-8");
			return "redirect:/community/freeCommList/freeCommOne?boardNo=" + board.getBoardNo() + "&msg=" + msg;
		}
		
	
	}
	
	// 자유 게시판 게시글 삭제
	@GetMapping("/community/freeCommList/removeFreeComm")
	public String removeFreeComm(HttpServletRequest request, int boardNo) throws UnsupportedEncodingException {
		String path = request.getServletContext().getRealPath("/commImg/");
		int row = communityService.removeComm(boardNo, path);
		log.debug(CYAN  + row + " <-- row(CommunityController-removeFreeComm)" + RESET);
		
		if (row == 1) {
			msg = URLEncoder.encode("게시글이 삭제되었습니다.", "UTF-8");
			
			return "redirect:/community/freeCommList?msg=" + msg;
		} else {
			msg = URLEncoder.encode("게시글 삭제에 실패했습니다. 관리자에게 문의해주세요.", "UTF-8");
			return "redirect:/community/freeCommList/freeCommOne?boardNo=" + boardNo + "&msg=" + msg;
		}	
	}
}

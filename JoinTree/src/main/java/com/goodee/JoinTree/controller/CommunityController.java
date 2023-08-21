package com.goodee.JoinTree.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

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
		
		// view로 값 넘길 때는 분리
		model.addAttribute("category", category);
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
	public String freeCommOne(Model model, int boardNo) {
		Map<String, Object> map = communityService.getCommOne(boardNo);
		log.debug(CYAN + map + " <-- map(CommunityController-freeCommOne)" + RESET);
		
		Board comm = (Board) map.get("comm");
		BoardFile boardFile = (BoardFile)map.get("boardFile");
		
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
	public String addFreeComm(HttpServletRequest request, Board board) {
		String path = request.getServletContext().getRealPath("/commImg/");
		int row = communityService.addComm(board, path);
		
		log.debug(CYAN + row + " <-- row(CommunityController-addFreeComm)" + RESET);
		
		
		return "redirect:/community/freeCommList";
	}
	
	// 자유 게시판 게시글 수정
	@GetMapping("/community/freeCommList/modifyFreeComm")
	public String modifyFreeComm() {
		
		return "/community/modifyFreeComm";
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
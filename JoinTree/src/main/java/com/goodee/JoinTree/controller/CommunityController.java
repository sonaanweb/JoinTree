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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.goodee.JoinTree.controller.CommunityController;
import com.goodee.JoinTree.service.CommunityService;
import com.goodee.JoinTree.vo.AccountList;
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
	
	// 자유 게시판 검색된 게시글 목록
	@GetMapping("/community/searchFreeCommList")
	public String searchFreeCommList() {
		
		return "";
	}

	
	
	// 익명 게시판 게시글 목록
	@GetMapping("/community/anonymousCommList")
	public String anonymousCommList(Model model, @RequestParam(name = "currentPage", defaultValue = "1") int currentPage,
			@RequestParam(name = "rowPerPage", defaultValue = "10") int rowPerPage, 
			@RequestParam(name = "category", defaultValue = "B0104") String category) {
		
		Map<String, Object> resultMap = communityService.getCommList(category, currentPage, rowPerPage);
		
		log.debug(CYAN + resultMap.get("commList") + " <-- commList(CommunityController-anonymousCommList)" + RESET);
		
		// view로 값 넘길 때는 분리
		model.addAttribute("category", category);
		model.addAttribute("pinnedCommList", resultMap.get("pinnedCommList"));
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
		
		log.debug(CYAN + resultMap.get("commList") + " <-- commList(CommunityController-secondhandCommList)" + RESET);
		
		// view로 값 넘길 때는 분리
		model.addAttribute("category", category);
		model.addAttribute("pinnedCommList", resultMap.get("pinnedCommList"));
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
		
		log.debug(CYAN + resultMap.get("commList") + " <-- commList(CommunityController-lifeEventCommList)" + RESET);
		
		// view로 값 넘길 때는 분리
		model.addAttribute("category", category);
		model.addAttribute("pinnedCommList", resultMap.get("pinnedCommList"));
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

	// 익명 게시판 게시글 상세보기
	@GetMapping("/community/anonymousCommList/anonymousCommOne")
	public String anonymousCommOne(Model model, @RequestParam(name="boardNo") int boardNo) {
		// 게시글 정보 가져오기
		Map<String, Object> map = communityService.getCommOne(boardNo);
		log.debug(CYAN + map + " <-- map(CommunityController-anonymousCommOne)" + RESET);
		
		Board comm = (Board) map.get("comm");
		BoardFile boardFile = (BoardFile)map.get("boardFile");
		
		// 조회수 증가 처리
		communityService.increaseCommCount(boardNo);
		
		model.addAttribute("comm", comm);
		model.addAttribute("boardFile", boardFile);
		
		log.debug(CYAN + comm + " <-- comm(CommunityController-anonymousCommOne)" + RESET);
		log.debug(CYAN + boardFile + " <-- boardFile(CommunityController-anonymousCommOne)" + RESET);
		
		return "/community/anonymousCommOne";
	}
	
	// 중고장터 게시판 게시글 상세보기
	@GetMapping("/community/secondhandCommList/secondhandCommOne")
	public String secondhandCommOne(Model model, @RequestParam(name="boardNo") int boardNo) {
		// 게시글 정보 가져오기
		Map<String, Object> map = communityService.getCommOne(boardNo);
		log.debug(CYAN + map + " <-- map(CommunityController-secondhandCommOne)" + RESET);
		
		Board comm = (Board) map.get("comm");
		BoardFile boardFile = (BoardFile)map.get("boardFile");
		
		// 조회수 증가 처리
		communityService.increaseCommCount(boardNo);
		
		model.addAttribute("comm", comm);
		model.addAttribute("boardFile", boardFile);
		
		log.debug(CYAN + comm + " <-- comm(CommunityController-secondhandCommOne)" + RESET);
		log.debug(CYAN + boardFile + " <-- boardFile(CommunityController-secondhandCommOne)" + RESET);
		
		return "/community/secondhandCommOne";
	}
	
	// 경조사 게시판 게시글 상세보기
	@GetMapping("/community/lifeEventCommList/lifeEventCommOne")
	public String lifeEventCommOne(Model model, @RequestParam(name="boardNo") int boardNo) {
		// 게시글 정보 가져오기
		Map<String, Object> map = communityService.getCommOne(boardNo);
		log.debug(CYAN + map + " <-- map(CommunityController-lifeEventCommOne)" + RESET);
		
		Board comm = (Board) map.get("comm");
		BoardFile boardFile = (BoardFile)map.get("boardFile");
		
		// 조회수 증가 처리
		communityService.increaseCommCount(boardNo);
		
		model.addAttribute("comm", comm);
		model.addAttribute("boardFile", boardFile);
		
		log.debug(CYAN + comm + " <-- comm(CommunityController-lifeEventCommOne)" + RESET);
		log.debug(CYAN + boardFile + " <-- boardFile(CommunityController-lifeEventCommOne)" + RESET);
		
		return "/community/lifeEventCommOne";
	}
	
	// 자유 게시판 게시글 작성 view
	@GetMapping("/community/freeCommList/addFreeComm")
	public String addFreeComm() {
		
		return "/community/addFreeComm";
	}
	
	// 익명 게시판 게시글 작성 view
	@GetMapping("/community/anonymousCommList/addAnonymousComm")
	public String addAnonymousComm() {
		
		return "/community/addAnonymousComm";
	}
	
	// 중고장터 게시판 게시글 작성 view
	@GetMapping("/community/secondhandCommList/addSecondhandComm")
	public String addSecondhandComm() {
		
		return "/community/addSecondhandComm";
	}
	
	// 경조사 게시판 게시글 작성 view
	@GetMapping("/community/lifeEventCommList/addLifeEventComm")
	public String addLifeEventComm() {
		
		return "/community/addLifeEventComm";
	}
	
	/*
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
	*/
	
	// 게시판 게시글 작성 액션
	@PostMapping("/community/addComm")
	public String addLifeEventComm(HttpServletRequest request, Board board) throws UnsupportedEncodingException {
		String path = request.getServletContext().getRealPath("/commImg/");
		
		// 세션에서 dept 값을 가져오기 위해 HttpSession 객체 사용
		HttpSession session = request.getSession();
		String dept = (String) session.getAttribute("dept");
		log.debug(CYAN + dept + " <-- row(CommunityController-addLifeEventComm)" + RESET);
		
		// 로그인 세션 부서값이 경영팀이고 상단고정 체크박스 선택했을 경우
		if (dept.equals("D0202") && request.getParameter("boardPinned") != null) {
			board.setBoardPinned("1");
		} else {
			board.setBoardPinned("0");
		}
		
		int row = communityService.addComm(board, path);
		
		log.debug(CYAN + row + " <-- row(CommunityController-addLifeEventComm)" + RESET);
		
		if (row == 1) {
			msg = URLEncoder.encode("게시글이 등록되었습니다.", "UTF-8");
			
			if (board.getBoardCategory().equals("B0103")) {
				return "redirect:/community/freeCommList?msg=" + msg;
			} else if (board.getBoardCategory().equals("B0104")) {
				return "redirect:/community/anonymousCommList?msg=" + msg;
			} else if (board.getBoardCategory().equals("B0105")) {
				return "redirect:/community/secondhandCommList?msg=" + msg;
			} else {
				return "redirect:/community/lifeEventCommList?msg=" + msg;
			}
			
			
		} else {
			msg = URLEncoder.encode("게시글 등록에 실패했습니다. 관리자에게 문의해주세요.", "UTF-8");
			
			if (board.getBoardCategory().equals("B0103")) {
				return "redirect:/community/lifeEventCommList/addFreeComm?msg=" + msg;
			} else if (board.getBoardCategory().equals("B0104")) {
				return "redirect:/community/anonymousEventCommList/addAnonymousComm?msg=" + msg;
			} else if (board.getBoardCategory().equals("B0105")) {
				return "redirect:/community/secondhandEventCommList/addSecondhandComm?msg=" + msg;
			} else {
				return "redirect:/community/lifeEventCommList/addLifeEventComm?msg=" + msg;
			}
		}
	}
	
	// 자유 게시판 게시글 수정 view
	@GetMapping("/community/freeCommList/modifyFreeComm")
	public String modifyFreeComm(Model model, int boardNo) {
		// 게시글 정보 가져오기
		Map<String, Object> map = communityService.getCommOne(boardNo);
		log.debug(CYAN + map + " <-- map(CommunityController-modifyFreeComm)" + RESET);
		
		Board comm = (Board) map.get("comm");
		BoardFile boardFile = (BoardFile)map.get("boardFile");
		
		model.addAttribute("comm", comm);
		model.addAttribute("boardFile", boardFile);
		
		log.debug(CYAN + comm + " <-- comm(CommunityController-modifyFreeComm)" + RESET);
		log.debug(CYAN + boardFile + " <-- boardFile(CommunityController-modifyFreeComm)" + RESET);
		
		return "/community/modifyFreeComm";
	}
	
	// 익명게시판 게시글 수정 view
	@GetMapping("/community/anonymousCommList/modifyAnonymousComm")
	public String modifyAnonymousComm(Model model, int boardNo) {
		// 게시글 정보 가져오기
		Map<String, Object> map = communityService.getCommOne(boardNo);
		log.debug(CYAN + map + " <-- map(CommunityController-modifyAnonymousComm)" + RESET);
		
		Board comm = (Board) map.get("comm");
		BoardFile boardFile = (BoardFile)map.get("boardFile");
		
		model.addAttribute("comm", comm);
		model.addAttribute("boardFile", boardFile);
		
		log.debug(CYAN + comm + " <-- comm(CommunityController-modifyAnonymousComm)" + RESET);
		log.debug(CYAN + boardFile + " <-- boardFile(CommunityController-modifyAnonymousComm)" + RESET);
		
		return "/community/modifyAnonymousComm";
	}
	
	// 중고장터 게시판 게시글 수정 view
	@GetMapping("/community/secondhandCommList/modifySecondhandComm")
	public String modifySecondhandComm(Model model, int boardNo) {
		// 게시글 정보 가져오기
		Map<String, Object> map = communityService.getCommOne(boardNo);
		log.debug(CYAN + map + " <-- map(CommunityController-freeCommOne)" + RESET);
		
		Board comm = (Board) map.get("comm");
		BoardFile boardFile = (BoardFile)map.get("boardFile");
		
		model.addAttribute("comm", comm);
		model.addAttribute("boardFile", boardFile);
		
		log.debug(CYAN + comm + " <-- comm(CommunityController-freeCommOne)" + RESET);
		log.debug(CYAN + boardFile + " <-- boardFile(CommunityController-freeCommOne)" + RESET);
		
		return "/community/modifySecondhandComm";
	}
	
	// 경조사 게시판 게시글 수정 view
	@GetMapping("/community/lifeEventCommList/modifyLifeEventComm")
	public String modifyLifeEventComm(Model model, int boardNo) {
		// 게시글 정보 가져오기
		Map<String, Object> map = communityService.getCommOne(boardNo);
		log.debug(CYAN + map + " <-- map(CommunityController-modifyLifeEventComm)" + RESET);
		
		Board comm = (Board) map.get("comm");
		BoardFile boardFile = (BoardFile)map.get("boardFile");
		
		model.addAttribute("comm", comm);
		model.addAttribute("boardFile", boardFile);
		
		log.debug(CYAN + comm + " <-- comm(CommunityController-modifyLifeEventComm)" + RESET);
		log.debug(CYAN + boardFile + " <-- boardFile(CommunityController-modifyLifeEventComm)" + RESET);
		
		return "/community/modifyLifeEventComm";
	}
	
	
	/*
	// (자유)게시판 게시글 수정 액션
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
	*/
	
	
	// 게시판 게시글 수정 액션
	@PostMapping("/community/modifyComm") 
	public String modifyFreeComm(HttpServletRequest request, Board board) throws UnsupportedEncodingException {
		// 세션에서 dept 값을 가져오기 위해 HttpSession 객체 사용
		HttpSession session = request.getSession();
		String dept = (String) session.getAttribute("dept");
		log.debug(CYAN + dept + " <-- row(CommunityController-modifyComm)" + RESET);
		
		// 로그인 세션 부서값이 경영팀이고 상단고정 체크박스 선택했을 경우
		if (dept.equals("D0202") && request.getParameter("boardPinned") != null) {
			board.setBoardPinned("1");
		} else {
			board.setBoardPinned("0");
		}
		
		int row = communityService.modifyComm(board);
		log.debug(CYAN + row + " <-- row(CommunityController-modifyComm)" + RESET);
		
		if (row == 1) {
			msg = URLEncoder.encode("게시글이 수정되었습니다.", "UTF-8");
			
			if (board.getBoardCategory().equals("B0103")) {
				return "redirect:/community/freeCommList/freeCommOne?boardNo=" + board.getBoardNo() + "&msg=" + msg;
			} else if (board.getBoardCategory().equals("B0104")) {
				return "redirect:/community/anonymousList/anonymousCommOne?boardNo=" + board.getBoardNo() + "&msg=" + msg;
			} else if (board.getBoardCategory().equals("B0105")) {
				return "redirect:/community/secondhandList/secondhandCommOne?boardNo=" + board.getBoardNo() + "&msg=" + msg;
			} else {
				return "redirect:/community/lifeEventCommList/lifeEventCommOne?boardNo=" + board.getBoardNo() + "&msg=" + msg;
			}
			
		} else {
			msg = URLEncoder.encode("게시글 수정에 실패했습니다. 관리자에게 문의해주세요.", "UTF-8");
			
			if (board.getBoardCategory().equals("B0103")) {
				return "redirect:/community/freeCommList/freeCommOne?boardNo=" + board.getBoardNo() + "&msg=" + msg;
			} else if (board.getBoardCategory().equals("B0104")) {
				return "redirect:/community/anonymousList/anonynousCommOne?boardNo=" + board.getBoardNo() + "&msg=" + msg;
			} else if (board.getBoardCategory().equals("B0105")) {
				return "redirect:/community/secondhandList/secondhandCommOne?boardNo=" + board.getBoardNo() + "&msg=" + msg;
			} else {
				return "redirect:/community/lifeEventCommList/lifeEventCommOne?boardNo=" + board.getBoardNo() + "&msg=" + msg;
			}
		}
	}
	
	// 게시판 게시글 수정 - 이미지 추가 액션 (AJAX)
	@PostMapping("/community/uploadFile")
	@ResponseBody
	public String uploadFile(@RequestParam("uploadImg") MultipartFile newImg, HttpServletRequest request, HttpSession session, 
			@RequestParam(name="boardNo") int boardNo) {
		log.debug(CYAN + newImg + " <-- newImgFile(CommunityController-uploadImg)" + RESET);
		AccountList loginAccount = (AccountList) session.getAttribute("loginAccount");
		
		int empNo = loginAccount.getEmpNo();
		
		// 파일 저장 경로 설정
		String path = request.getServletContext().getRealPath("/commImg/"); // 실제 파일 시스템 경로
		
		int row = communityService.uploadImg(empNo, boardNo, newImg, path);
		log.debug(CYAN + row + " <-- row(CommunityController-uploadFile)" + RESET);
		if (row == 2) { // 2 출력 시 DB, 로컬에 이미지 저장 완료 
			return "success";
		} else {
			return "error";
		}
	}
	
	// 게시판 게시글 수정 - 이미지 삭제 액션(AJAX)
	@PostMapping("/community/removeFile")
	@ResponseBody
	public String removeFile(HttpServletRequest request, @RequestParam(name="boardNo") int boardNo) {
		// AccountList loginAccount = (AccountList) session.getAttribute("loginAccount");
		
		// int empNo = loginAccount.getEmpNo();
		
		// 저장된 파일 경로
		String path = request.getServletContext().getRealPath("/commImg/"); // 실제 파일 시스템 경로
		
		int row = communityService.removeImg(boardNo, path);
		log.debug(CYAN + row + " <-- row(CommunityController-removeFile)" + RESET);
		
		if (row == 1) { // 파일 이미지 삭제 시
			return "success";
		} else {
			return "error";
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

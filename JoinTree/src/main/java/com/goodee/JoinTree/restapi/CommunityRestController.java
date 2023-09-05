package com.goodee.JoinTree.restapi;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.goodee.JoinTree.service.CommentService;
import com.goodee.JoinTree.service.CommunityService;
import com.goodee.JoinTree.vo.AccountList;
import com.goodee.JoinTree.vo.Board;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
public class CommunityRestController {
	static final String CYAN = "\u001B[46m";
	static final String RESET = "\u001B[0m";
	
	String msg = "";
	
	@Autowired
	private CommunityService communityService;
	
	@Autowired
	private CommentService commentService;
	
	// JSON 데이터를 반환하는 컨트롤러 메소드
	@GetMapping("/community/freeCommListData")
	@ResponseBody // JSON 형식으로 응답을 처리
	public Map<String, Object> freeCommListData(Model model, 
	        @RequestParam(name = "currentPage", defaultValue = "1") int currentPage,
	        @RequestParam(name = "rowPerPage", defaultValue = "10") int rowPerPage, 
	        @RequestParam(name = "category", defaultValue = "B0103") String category, 
	        @RequestParam(name = "searchOption", required = false) String searchOption,
	        @RequestParam(name = "searchText", required = false) String searchText) {
	    
	    Map<String, Object> resultMap = communityService.getCommList(category, currentPage, rowPerPage, searchOption, searchText);
	    
	    	// 댓글 개수 추가
	 		List<Board> pinnedCommList = (List<Board>) resultMap.get("pinnedCommList");
	 		for (Board comm : pinnedCommList) {
	 			int commentCnt = commentService.getCommentsCnt(comm.getBoardNo());
	 			comm.setCommentCnt(commentCnt);
	 		}
	 		
	 		List<Board> commList = (List<Board>) resultMap.get("commList"); // 게시글 목록 가져오는 로직
	 		for (Board comm : commList) {
	 			int commentCnt = commentService.getCommentsCnt(comm.getBoardNo());
	 			comm.setCommentCnt(commentCnt);
	 		}
	 		
	 		log.debug(CYAN + resultMap.get("commList") + " <-- commList(CommunityRestController-freeCommList)" + RESET);
	 		log.debug(CYAN + resultMap.get("pinnedCommList") + " <-- pinnedCommList(CommunityRestController-freeCommList)" + RESET);
	 		
			// 페이지 블럭
			int currentBlock = 0; // 현재 페이지 블럭 (currenetPage / pageLength)
			int pageLength = 10; // 현재 페이지 블럭에 들어갈 페이지 수 (1~10 / 다음)
			if (currentPage % pageLength == 0) {
				currentBlock = currentPage / pageLength;
			} else {
				currentBlock = (currentPage / pageLength) + 1;
			}
			
			int startPage = (currentBlock - 1) * pageLength + 1; // 블럭의 시작페이지 (1, 11, 21, ...)
			int endPage = startPage + pageLength - 1; // 블럭의 마지막 페이지 (10, 20, 30, ...)
			int lastPage = (int) resultMap.get("lastPage");
			if (endPage > lastPage) {
				endPage = lastPage;
			}
			
			// JSON 데이터에 startPage와 lastPage 값을 추가
		    resultMap.put("startPage", startPage); // 블럭(페이징) 버튼 시작 페이지 정보 추가
		    resultMap.put("lastPage", lastPage); // 서버에서 계산한 lastPage 값
		    resultMap.put("endPage", endPage); // 블럭(페이징) 버튼 끝 페이지 정보 추가
		    resultMap.put("currentPage", currentPage); 
		    resultMap.put("category", category); 
	 		
	    return resultMap;
	}
	
	@GetMapping("/community/anonymousCommListData")
	@ResponseBody // JSON 형식으로 응답을 처리
	public Map<String, Object> anonymousCommListData(Model model, HttpSession session, HttpServletRequest request,
	        @RequestParam(name = "currentPage", defaultValue = "1") int currentPage,
	        @RequestParam(name = "rowPerPage", defaultValue = "10") int rowPerPage, 
	        @RequestParam(name = "category", defaultValue = "B0104") String category, 
	        @RequestParam(name = "searchOption", required = false) String searchOption,
	        @RequestParam(name = "searchText", required = false) String searchText) {
		
		Map<String, Object> resultMap = communityService.getCommList(category, currentPage, rowPerPage, searchOption, searchText);
	    
	    	// 댓글 개수 추가
	 		List<Board> pinnedCommList = (List<Board>) resultMap.get("pinnedCommList");
	 		for (Board comm : pinnedCommList) {
	 			int commentCnt = commentService.getCommentsCnt(comm.getBoardNo());
	 			comm.setCommentCnt(commentCnt);
	 		}
	 		
	 		List<Board> commList = (List<Board>) resultMap.get("commList"); // 게시글 목록 가져오는 로직
	 		for (Board comm : commList) {
	 			int commentCnt = commentService.getCommentsCnt(comm.getBoardNo());
	 			comm.setCommentCnt(commentCnt);
	 		}
	 		
	 		log.debug(CYAN + resultMap.get("commList") + " <-- commList(CommunityRestController-freeCommList)" + RESET);
	 		log.debug(CYAN + resultMap.get("pinnedCommList") + " <-- pinnedCommList(CommunityRestController-freeCommList)" + RESET);
	 		
			// 페이지 블럭
			int currentBlock = 0; // 현재 페이지 블럭 (currenetPage / pageLength)
			int pageLength = 10; // 현재 페이지 블럭에 들어갈 페이지 수 (1~10/다음)
			if (currentPage % pageLength == 0) {
				currentBlock = currentPage / pageLength;
			} else {
				currentBlock = (currentPage / pageLength) + 1;
			}
			
			int startPage = (currentBlock - 1) * pageLength + 1; // 블럭의 시작페이지 (1, 11, 21, ...)
			int endPage = startPage + pageLength - 1; // 블럭의 마지막 페이지 (10, 20, 30, ...)
			int lastPage = (int) resultMap.get("lastPage");
			if (endPage > lastPage) {
				endPage = lastPage;
			}
			
			session = request.getSession();
			AccountList loginAccount = (AccountList) session.getAttribute("loginAccount");
			int empNo = loginAccount.getEmpNo();
			
			// JSON 데이터에 startPage와 lastPage 값을 추가
		    resultMap.put("startPage", startPage); // 블럭(페이징) 버튼 시작 페이지 정보 추가
		    resultMap.put("lastPage", lastPage); // 서버에서 계산한 lastPage 값
		    resultMap.put("endPage", endPage); // 블럭(페이징) 버튼 끝 페이지 정보 추가
		    resultMap.put("currentPage", currentPage); 
		    resultMap.put("category", category); 
		    resultMap.put("empNo", empNo); // 로그인 세션 아이디 정보
	 		
	    return resultMap;
	}
	
	@GetMapping("/community/secondhandCommListData")
	@ResponseBody // JSON 형식으로 응답을 처리
	public Map<String, Object> secondhandCommListData(Model model, 
	        @RequestParam(name = "currentPage", defaultValue = "1") int currentPage,
	        @RequestParam(name = "rowPerPage", defaultValue = "10") int rowPerPage, 
	        @RequestParam(name = "category", defaultValue = "B0105") String category, 
	        @RequestParam(name = "searchOption", required = false) String searchOption,
	        @RequestParam(name = "searchText", required = false) String searchText) {
	    
	    Map<String, Object> resultMap = communityService.getCommList(category, currentPage, rowPerPage, searchOption, searchText);
	    
	    	// 댓글 개수 추가
	 		List<Board> pinnedCommList = (List<Board>) resultMap.get("pinnedCommList");
	 		for (Board comm : pinnedCommList) {
	 			int commentCnt = commentService.getCommentsCnt(comm.getBoardNo());
	 			comm.setCommentCnt(commentCnt);
	 		}
	 		
	 		List<Board> commList = (List<Board>) resultMap.get("commList"); // 게시글 목록 가져오는 로직
	 		for (Board comm : commList) {
	 			int commentCnt = commentService.getCommentsCnt(comm.getBoardNo());
	 			comm.setCommentCnt(commentCnt);
	 		}
	 		
	 		log.debug(CYAN + resultMap.get("commList") + " <-- commList(CommunityRestController-freeCommList)" + RESET);
	 		log.debug(CYAN + resultMap.get("pinnedCommList") + " <-- pinnedCommList(CommunityRestController-freeCommList)" + RESET);
	 		
			// 페이지 블럭
			int currentBlock = 0; // 현재 페이지 블럭 (currenetPage / pageLength)
			int pageLength = 10; // 현재 페이지 블럭에 들어갈 페이지 수 (1~10/다음)
			if (currentPage % pageLength == 0) {
				currentBlock = currentPage / pageLength;
			} else {
				currentBlock = (currentPage / pageLength) + 1;
			}
			
			int startPage = (currentBlock - 1) * pageLength + 1; // 블럭의 시작페이지 (1, 11, 21, ...)
			int endPage = startPage + pageLength - 1; // 블럭의 마지막 페이지 (10, 20, 30, ...)
			int lastPage = (int) resultMap.get("lastPage");
			if (endPage > lastPage) {
				endPage = lastPage;
			}
			
			// JSON 데이터에 startPage와 lastPage 값을 추가
		    resultMap.put("startPage", startPage); // 블럭(페이징) 버튼 시작 페이지 정보 추가
		    resultMap.put("lastPage", lastPage); // 서버에서 계산한 lastPage 값
		    resultMap.put("endPage", endPage); // 블럭(페이징) 버튼 끝 페이지 정보 추가
		    resultMap.put("currentPage", currentPage); 
		    resultMap.put("category", category); 
	 		
	    return resultMap;
	}
	
	@GetMapping("/community/lifeEventCommListData")
	@ResponseBody // JSON 형식으로 응답을 처리
	public Map<String, Object> lifeEventCommListData(Model model, 
	        @RequestParam(name = "currentPage", defaultValue = "1") int currentPage,
	        @RequestParam(name = "rowPerPage", defaultValue = "10") int rowPerPage, 
	        @RequestParam(name = "category", defaultValue = "B0106") String category, 
	        @RequestParam(name = "searchOption", required = false) String searchOption,
	        @RequestParam(name = "searchText", required = false) String searchText) {
	    
	    Map<String, Object> resultMap = communityService.getCommList(category, currentPage, rowPerPage, searchOption, searchText);
	    
	    	// 댓글 개수 추가
	 		List<Board> pinnedCommList = (List<Board>) resultMap.get("pinnedCommList");
	 		for (Board comm : pinnedCommList) {
	 			int commentCnt = commentService.getCommentsCnt(comm.getBoardNo());
	 			comm.setCommentCnt(commentCnt);
	 		}
	 		
	 		List<Board> commList = (List<Board>) resultMap.get("commList"); // 게시글 목록 가져오는 로직
	 		for (Board comm : commList) {
	 			int commentCnt = commentService.getCommentsCnt(comm.getBoardNo());
	 			comm.setCommentCnt(commentCnt);
	 		}
	 		
	 		log.debug(CYAN + resultMap.get("commList") + " <-- commList(CommunityRestController-freeCommList)" + RESET);
	 		log.debug(CYAN + resultMap.get("pinnedCommList") + " <-- pinnedCommList(CommunityRestController-freeCommList)" + RESET);
	 		
			// 페이지 블럭
			int currentBlock = 0; // 현재 페이지 블럭 (currenetPage / pageLength)
			int pageLength = 10; // 현재 페이지 블럭에 들어갈 페이지 수 (1~10/다음)
			if (currentPage % pageLength == 0) {
				currentBlock = currentPage / pageLength;
			} else {
				currentBlock = (currentPage / pageLength) + 1;
			}
			
			int startPage = (currentBlock - 1) * pageLength + 1; // 블럭의 시작페이지 (1, 11, 21, ...)
			int endPage = startPage + pageLength - 1; // 블럭의 마지막 페이지 (10, 20, 30, ...)
			int lastPage = (int) resultMap.get("lastPage");
			if (endPage > lastPage) {
				endPage = lastPage;
			}
			
			// JSON 데이터에 startPage와 lastPage 값을 추가
		    resultMap.put("startPage", startPage); // 블럭(페이징) 버튼 시작 페이지 정보 추가
		    resultMap.put("lastPage", lastPage); // 서버에서 계산한 lastPage 값
		    resultMap.put("endPage", endPage); // 블럭(페이징) 버튼 끝 페이지 정보 추가
		    resultMap.put("currentPage", currentPage); 
		    resultMap.put("category", category); 
	 		
	    return resultMap;
	}
}
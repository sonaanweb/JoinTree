package com.goodee.JoinTree.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.goodee.JoinTree.service.CommentService;
import com.goodee.JoinTree.service.CommunityService;
import com.goodee.JoinTree.vo.Comment;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class CommentController {
	static final String CYAN = "\u001B[46m";
	static final String RESET = "\u001B[0m";
	
	String msg = "";
	
	@Autowired
	private CommentService commentService;
	
	@Autowired
	private CommunityService communityService;
	
	// 댓글 작성 액션
	@PostMapping("/comment/addComment")
	public String addComment(@RequestParam("boardNo") int boardNo, @RequestParam("empNo") int empNo, 
			@RequestParam("category") String category, @RequestParam("commentGroupNo") int commentGroupNo, 
			@RequestParam("commentContent") String commentContent) throws UnsupportedEncodingException {
		Comment comment = new Comment();
		comment.setBoardNo(boardNo);
		comment.setEmpNo(empNo);
		comment.setCategory(category);
		comment.setCommentGroupNo(commentGroupNo);
		comment.setCommentContent(commentContent);
		
		int row = commentService.addComment(comment);
		log.debug(CYAN + row + "<-- row(CommentController-addComment)" + RESET);
		
		if (row == 1) {
			msg = URLEncoder.encode("댓글이 등록되었습니다.", "UTF-8");
			
			// 댓글 작성 성공 시 리다이렉트할 URL 생성
			String redirectUrl = "/community/";
			
			if (category.equals("B0103")) {
				redirectUrl += "freeCommList/freeCommOne?boardNo=" + boardNo;
			} else if (category.equals("B0104")) {
				redirectUrl += "anonymousCommList/anonymousCommOne?boardNo=" + boardNo;
			} else if (category.equals("B0105")) {
				redirectUrl += "secondhandCommList/secondhandCommOne?boardNo=" + boardNo;
			} else if (category.equals("B0106")) {
				redirectUrl += "lifeEventCommList/lifeEventCommOne?boardNo=" + boardNo;
			}
			
			 return "redirect:" + redirectUrl + "&msg=" + msg;
		} else {
			msg = URLEncoder.encode("댓글 등록에 실패했습니다. 관리자에게 문의해주세요.", "UTF-8");
			
			// 댓글 작성 성공 시 리다이렉트할 URL 생성
			String redirectUrl = "/community/";
			
			if (category.equals("B0103")) {
				redirectUrl += "freeCommList/freeCommOne?boardNo=" + boardNo;
			} else if (category.equals("B0104")) {
				redirectUrl += "anonymousCommList/anonymousCommOne?boardNo=" + boardNo;
			} else if (category.equals("B0105")) {
				redirectUrl += "secondhandCommList/secondhandCommOne?boardNo=" + boardNo;
			} else if (category.equals("B0106")) {
				redirectUrl += "lifeEventCommList/lifeEventCommOne?boardNo=" + boardNo;
			}
			
			 return "redirect:" + redirectUrl + "&msg=" + msg;
			
		}		
		
	}
	
	// 댓글 삭제 액션
	@GetMapping("/comment/removeComment")
	public String removeComment(@RequestParam("commentNo") int commentNo, @RequestParam("boardNo") int boardNo) throws UnsupportedEncodingException {
		String category = communityService.getBoardCategory(boardNo);
		
		// 댓글 삭제 성공 시 리다이렉트할 URL 생성
		String redirectUrl = "/community/";
		
		int row = commentService.removeCommentReply(commentNo);
		log.debug(CYAN + row + "<-- row(CommentController-removeComment)" + RESET);
		
		if (row == 1) {
			msg = URLEncoder.encode("댓글이 삭제되었습니다.", "UTF-8");
			
			if (category.equals("B0103")) {
				redirectUrl += "freeCommList/freeCommOne?boardNo=" + boardNo;
			} else if (category.equals("B0104")) {
				redirectUrl += "anonymousCommList/anonymousCommOne?boardNo=" + boardNo;
			} else if (category.equals("B0105")) {
				redirectUrl += "secondhandCommList/secondhandCommOne?boardNo=" + boardNo;
			} else if (category.equals("B0106")) {
				redirectUrl += "lifeEventCommList/lifeEventCommOne?boardNo=" + boardNo;
			}
			
			 return "redirect:" + redirectUrl + "&msg=" + msg;
		} else {
			msg = URLEncoder.encode("댓글 삭제에 실패했습니다. 관리자에게 문의해주세요.", "UTF-8");
			
			if (category.equals("B0103")) {
				redirectUrl += "freeCommList/freeCommOne?boardNo=" + boardNo;
			} else if (category.equals("B0104")) {
				redirectUrl += "anonymousCommList/anonymousCommOne?boardNo=" + boardNo;
			} else if (category.equals("B0105")) {
				redirectUrl += "secondhandCommList/secondhandCommOne?boardNo=" + boardNo;
			} else if (category.equals("B0106")) {
				redirectUrl += "lifeEventCommList/lifeEventCommOne?boardNo=" + boardNo;
			}
			
			
			return "redirect:" + redirectUrl + "&msg=" + msg;
		}
		
		
	}
}

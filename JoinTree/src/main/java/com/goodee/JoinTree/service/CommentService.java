package com.goodee.JoinTree.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.goodee.JoinTree.mapper.CommentMapper;
import com.goodee.JoinTree.mapper.CommunityMapper;
import com.goodee.JoinTree.vo.Comment;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class CommentService {
	static final String CYAN = "\u001B[46m";
	static final String RESET = "\u001B[0m";
	
	@Autowired
	private CommentMapper commentMapper;
	
	@Autowired
	private CommunityMapper communityMapper;
	
	// 게시글별 댓글 목록 조회
	public List<Comment> getCommentsByBoardNo(int boardNo) {
		List<Comment> comments = commentMapper.selectCommentsByBoardNo(boardNo);
		// log.debug(CYAN + comments + "<-- comments(CommentService-getCommentsByBoardNo)" + RESET);
		
	    // 디버깅
        for (Comment comment : comments) {
        	log.debug(CYAN + comment.getCommentContent() + " <-- Comment(CommentService-getCommentsByBoardNo) " + RESET); // 댓글 내용을 로그로 출력
        }
	
		return comments;
	}
	
	// 게시글별 댓글 목록 조회 new
	public List<Comment> getComments(int boardNo) {
		List<Comment> comments = commentMapper.selectComments(boardNo);
		
        return comments;
    }
	
	// 게시글별 댓글 개수
	public int getCommentsCnt(int boardNo) {
		int row = commentMapper.selectCommentsCnt(boardNo);
		log.debug(CYAN + row + " <-- row(CommentService-getCommentsCnt)" + RESET);
		
		return row;
	}
	
	// 댓글 입력
	public int addComment(Comment comment) {
		int row = commentMapper.addComment(comment);
		log.debug(CYAN + row + " <-- row(CommentService-addComment)" + RESET);
		
		return row;
	}
	
	// 대댓글 입력
	public int addReply(Comment comment) {
		int row = commentMapper.addReply(comment);
		log.debug(CYAN + row + " <-- row(CommentService-addReply)" + RESET);
		
		return row;
	}
	
	// 댓글/대댓글 삭제
	public int removeCommentReply(int commentNo) {
		int row = commentMapper.removeCommentReply(commentNo);
		log.debug(CYAN + row + " <-- row(CommentService-removeCommentReply)" + RESET);
		
		return row;
	}
	
	// 댓글/대댓글 삭제 시 카테고리 조회
	public String getBoardCategory(int boardNo) {
		String category = communityMapper.selectBoardCategory(boardNo); 
		
		return category;
	}
	
	// 댓글 작성자 출력
	public String getEmpName(int empNo) {
		String empName = commentMapper.selectEmpName(empNo);
		
		return empName;
	}
}

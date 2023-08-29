package com.goodee.JoinTree.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.JoinTree.vo.Comment;

@Mapper
public interface CommentMapper {
	// 게시글별 댓글 목록 조회
	List<Comment> selectCommentsByBoardNo(int boardNo); 
	
	// 게시글별 댓글 목록 조회 new
	List<Comment> selectComments(int boardNo);
	
	// 게시글별 댓글 개수
	int selectCommentsCnt(int boardNo);
	
	// 댓글 입력
	int addComment(Comment comment);
	
	// 대댓글 입력
	int addReply(Comment comment);
	
	// 댓글/대댓글 삭제
	int removeCommentReply(int commentNo);
	
	// 댓글 작성자 출력
	String selectEmpName(int empNo);
}

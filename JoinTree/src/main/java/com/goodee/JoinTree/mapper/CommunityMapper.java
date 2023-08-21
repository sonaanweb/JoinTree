package com.goodee.JoinTree.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.JoinTree.vo.Board;

@Mapper
public interface CommunityMapper {
	// 게시판 게시글 목록
		List<Board> selectCommListByPage(Map<String, Object> map);
		
		// 전체 행 개수(카테고리별)
		int selectCommCnt(String category);
		
		// 전체 행 개수(자유)
		// int selectComm03Cnt();
		
		// 전체 행 개수(익명)
		// int selectComm04Cnt();
		
		// 전체 행 개수(중고장터)
		// int selectComm05Cnt();
		
		// 전체 행 개수(경조사)
		// int selectComm06Cnt();
		
		// 게시글 상세정보(자유)
		
		// 게시글 상세정보(익명)
		
		// 게시글 상세정보(중고장터)
		
		// 게시글 상세정보(경조사)
		
		// 게시판 게시글 상세정보(통일)
		Board selectCommOne(int boardNo);
		
		// 게시판 게시글 입력
		int addComm(Board board);
		
		// 게시판 게시글 수정
		int modifyComm(Board board);
		
		// 게시판 게시글 삭제
		int removeComm(int boardNo);
}

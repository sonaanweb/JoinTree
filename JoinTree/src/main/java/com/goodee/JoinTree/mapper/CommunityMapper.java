package com.goodee.JoinTree.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.JoinTree.vo.Board;

@Mapper
public interface CommunityMapper {
	// 게시판 상단고정 게시글 목록
	List<Board> selectPinnedCommList(String category);
	
	// 하나의 메서드로 게시글 목록 조회
    List<Board> selectCommListByPageWithSearch(Map<String, Object> map);
	
	// 게시판 목록(기존)
	List<Board> searchCommListByPage(Map<String, Object> map);
	
    
    // 행 개수 구하기 (통일)
    int selectCommCntWithSearch(Map<String, Object> params); // category, searchOption, searchText
    
	// 전체 행 개수(카테고리별)
	int selectCommCnt(String category);
	
	// 검색 조건별 행의 수
	int searchCommCnt(Board searchBoard);
	
	// 게시글 조회수 증가
	int increaseCommCount(int boardNo);

	// 게시판 게시글 상세정보(통일)
	Board selectCommOne(int boardNo);
	
	// 이전 글 조회
	Board selectPreBoard(Map<String, Object> params); // boardNo, boardCategory
	
	// 다음 글 조회
	Board selectNextBoard(Map<String, Object> params); // boardNo, boardCategory
	
	// 게시판 게시글 입력
	int addComm(Board board);
	
	// 게시판 게시글 수정
	int modifyComm(Board board);
	
	// 게시판 게시글 삭제
	int removeComm(int boardNo);
	
	// 게시판 카테고리 조회
	String selectBoardCategory(int boardNo);
}

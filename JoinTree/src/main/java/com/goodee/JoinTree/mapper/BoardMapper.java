package com.goodee.JoinTree.mapper;

import java.util.*;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.JoinTree.vo.Board;

@Mapper
public interface BoardMapper {

	int boardListCnt(Map<String, Object> boardListMap); // 게시판 목록 행의 수

	List<Map<String, Object>> getBoardList(Map<String, Object> boardListMap); // 게시판 목록

	List<Map<String, Object>> getBoardPinnedList(String boardCategory); // 게시판 상단고정 목록

	int addBoard(Board board); // 게시판 글 등록

	Map<String, Object> getBoardOne(int boardNo); // 게시글 상세 조회

	int modifyBoard(Board board); // 게시글 수정

	Integer getPreBoard(Map<String, Object> preBoardMap); // 이전글 번호 조회

	Integer getNextBoard(Map<String, Object> nextBoardMap); // 다음글 번호 조회

	int removeBoard(int boardNo); // 게시글 삭제
	
	List<Map<String, Object>> getRecentNotice(); // 최신 공지 조회

}

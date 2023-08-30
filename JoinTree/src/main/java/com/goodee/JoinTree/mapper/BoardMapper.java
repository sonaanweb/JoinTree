package com.goodee.JoinTree.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface BoardMapper {

	int boardListCnt(Map<String, Object> boardListMap); // 게시판 목록 행의 수

	List<Map<String, Object>> getBoardList(Map<String, Object> boardListMap); // 게시판 목록

	List<Map<String, Object>> getBoardPinnedList(String boardCategory); // 게시판 상단고정 목록

}

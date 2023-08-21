package com.goodee.JoinTree.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.JoinTree.vo.BoardFile;

@Mapper
public interface BoardFileMapper {
	// 파일 업로드
	int insertBoardFile(BoardFile boardFile);
	
	// 업로드 파일 상세정보
	BoardFile selectBoardFile(int boardNo);
	
	// 게시글 내 파일 삭제
	int removeBoardFile(int boardNo);
	
	// 게시글 내 첨부파일 수 (0, 1)
	int selectBoardFileCnt(int boardNo);
}

package com.goodee.JoinTree.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.JoinTree.vo.DocumentDefault;

@Mapper
public interface DocumentMapper {
	// 기본 기안서 입력
		int insertDocDefault(DocumentDefault documentDefault);
		
		// 기본 기안서 상세보기
		DocumentDefault selectDocDefaultOne(int docDefaultNo);

}

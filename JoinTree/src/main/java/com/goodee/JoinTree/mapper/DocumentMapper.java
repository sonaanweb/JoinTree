package com.goodee.JoinTree.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.JoinTree.vo.CommonCode;
import com.goodee.JoinTree.vo.DocumentDefault;

@Mapper
public interface DocumentMapper {
		// 기본 기안서 입력
		int insertDocDefault(DocumentDefault documentDefault);
		
		// 기본 기안서 상세보기
		DocumentDefault selectDocDefaultOne(int docDefaultNo);
		
		// 문서결제양식 코드 조회
		List<CommonCode> selectDocumentCodeList();
}

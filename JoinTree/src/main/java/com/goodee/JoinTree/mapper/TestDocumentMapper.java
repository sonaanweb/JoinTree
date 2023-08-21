package com.goodee.JoinTree.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.JoinTree.vo.CommonCode;

@Mapper
public interface TestDocumentMapper {
	
	// 문서결제양식 코드 조회
	List<CommonCode> selectDocumentCodeList();

}

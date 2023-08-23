package com.goodee.JoinTree.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.JoinTree.vo.DocumentSigner;
@Mapper
public interface DocumentSignerMapper {
	// 결재자 추가
	int insertDocSigner(DocumentSigner documentSigner);
}

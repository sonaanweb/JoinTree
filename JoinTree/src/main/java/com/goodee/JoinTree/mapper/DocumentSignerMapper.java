package com.goodee.JoinTree.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.JoinTree.vo.DocumentSigner;
@Mapper
public interface DocumentSignerMapper {
	// 결재자 추가
	int addDocSigner(DocumentSigner documentSigner);
	
	// 결재자 수 체크
	int signerCnt(int docNo); 
	
	// 결제자 레벨 체크
	int signerLevel(DocumentSigner documentSigner);
	
	// 결재자 상태 변경
	int modifySignerStatus(DocumentSigner documentSigner);
	
	
}

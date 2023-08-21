package com.goodee.JoinTree.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.goodee.JoinTree.mapper.TestDocumentMapper;
import com.goodee.JoinTree.vo.CommonCode;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class TestDocumentService {
	@Autowired
	private TestDocumentMapper documentMapper;
	
	// 문서결제양식 코드 조회
	public List<CommonCode> documentCodeList() {
		
		List<CommonCode> documentCodeList = documentMapper.selectDocumentCodeList();
		log.debug(documentCodeList+"<-- TestDocumentService documentCodeList");
		
		return documentCodeList;
	}
}

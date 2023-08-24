package com.goodee.JoinTree.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.goodee.JoinTree.mapper.DocumentMapper;
import com.goodee.JoinTree.mapper.DocumentSignerMapper;
import com.goodee.JoinTree.vo.CommonCode;
import com.goodee.JoinTree.vo.DocumentDefault;
import com.goodee.JoinTree.vo.DocumentLeave;
import com.goodee.JoinTree.vo.DocumentSigner;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class DocumentService {
	@Autowired
	private DocumentMapper documentMapper;
	@Autowired
	private DocumentSignerMapper documentSignerMapper;
	
	// 문서결제양식 코드 조회
	public List<CommonCode> documentCodeList() {
		
		List<CommonCode> documentCodeList = documentMapper.selectDocumentCodeList();
		log.debug(documentCodeList+"<-- DocumentService documentCodeList");
		
		return documentCodeList;
	}
	
	// 기본 기안서에 정보추가
	public int addDocDefault(DocumentDefault documentDefault) {
		
		int row = documentMapper.addDocDefault(documentDefault);
			
		log.debug(row +"<-- DocumentService documentDefault row");
		
		return row;	
	}
	
	public int addDocSigner(DocumentSigner documentSigner) {
		return documentSignerMapper.addDocSigner(documentSigner);
	}


}

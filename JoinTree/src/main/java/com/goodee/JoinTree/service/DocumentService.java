package com.goodee.JoinTree.service;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.goodee.JoinTree.mapper.DocumentFileMapper;
import com.goodee.JoinTree.mapper.DocumentMapper;
import com.goodee.JoinTree.mapper.DocumentSignerMapper;
import com.goodee.JoinTree.vo.CommonCode;
import com.goodee.JoinTree.vo.DocumentDefault;
import com.goodee.JoinTree.vo.DocumentFile;
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
	@Autowired
	private DocumentFileMapper documentFileMapper;
	
	// 문서결제양식 코드 조회
	public List<CommonCode> documentCodeList() {
		
		List<CommonCode> documentCodeList = documentMapper.selectDocumentCodeList();
		log.debug(documentCodeList+"<-- DocumentService documentCodeList");
		
		return documentCodeList;
	}
	
	// 기본 기안서에 정보추가
	public int addDocDefault(DocumentDefault documentDefault, String path) {
		
		int row = documentMapper.addDocDefault(documentDefault);
			
		log.debug(row +"<-- DocumentService documentDefault row");
		
		// 추가한 정보가 1개 이상인 경우와 파일이 첨부되었을 때
	    if (row > 0 && documentDefault.getMultipartFile() != null && documentDefault.getMultipartFile().getSize() > 0) {
	        int docNo = documentDefault.getDocNo(); // 추가한 정보의 documentNo 가져오기
	        
	        MultipartFile file = documentDefault.getMultipartFile();
	        
	        if (file.getSize() > 0) {
	            DocumentFile df = new DocumentFile();
	            df.setDocNo(docNo);
	            df.setDocOriginFilename(file.getOriginalFilename()); // 파일 원본 이름
	            df.setDocFilesize(file.getSize()); // 파일 사이즈
	            df.setDocFiletype(file.getContentType()); // 파일 타입(MIME)
	            df.setCreateId(documentDefault.getEmpNo());
	            df.setUpdateId(documentDefault.getEmpNo());
	            
	            // 확장자
	            String ext = file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf("."));
	            
	            // 새로운 이름 + 확장자
	            String newFilename = UUID.randomUUID().toString().replace("-", "") + ext; // - 를 공백으로 바꿈
	            df.setDocSaveFilename(newFilename);
	            
	            // 테이블에 저장
	            documentFileMapper.addDocFile(df);
	            
	            // 파일 저장 (저장 위치: path)
	            File f = new File(path + df.getDocSaveFilename()); // path 위치에 저장 파일 이름으로 빈 파일을 생성
	            
	            // 빈 파일에 첨부된 파일의 스트림을 주입
	            try {
	                file.transferTo(f);
	            } catch (IllegalStateException | IOException e) {
	                e.printStackTrace();
	                // 트랜잭션 작동을 위해 예외(try-catch를 강요하지 않는 예외 -> ex: RuntimeException) 발생 필요
	                throw new RuntimeException();
	            }
	        }
	    }
	    return row;
	}
	
	public int addDocSigner(DocumentSigner documentSigner) {
		return documentSignerMapper.addDocSigner(documentSigner);
	}


}

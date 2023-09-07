package com.goodee.JoinTree.service;

import java.io.File;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.goodee.JoinTree.mapper.DocumentFileMapper;
import com.goodee.JoinTree.mapper.DocumentMapper;
import com.goodee.JoinTree.mapper.DocumentSignerMapper;
import com.goodee.JoinTree.vo.AccountList;
import com.goodee.JoinTree.vo.CommonCode;
import com.goodee.JoinTree.vo.DocumentDefault;
import com.goodee.JoinTree.vo.DocumentFile;
import com.goodee.JoinTree.vo.DocumentLeave;
import com.goodee.JoinTree.vo.DocumentReshuffle;
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
	
	String yellow = "\u001B[33m";
	String reset = "\u001B[0m";
	
	// 문서결제양식 코드 조회
	public List<CommonCode> documentCodeList() {
		
		List<CommonCode> documentCodeList = documentMapper.selectDocumentCodeList();
		log.debug(documentCodeList+"<-- DocumentService documentCodeList");
		
		return documentCodeList;
	}
	
	// 기본(퇴직) 기안서에 정보추가
	public int addDocDefault(DocumentDefault documentDefault) {
		
		int row = documentMapper.addDocDefault(documentDefault);
			
		log.debug(row +"<-- DocumentService documentDefault row");
	    return row;
	}
	
	// 휴가 기안서에 정보추가
	public int addDocLeave(DocumentLeave documentLeave) {
		
		int row = documentMapper.addDocLeave(documentLeave);
			
		log.debug(row +"<-- DocumentService documentLeave row");
	    return row;
	}
	
	// 인사이동 기안서에 정보추가
	public int addDocReshuffle(DocumentReshuffle documentReshuffle) {
		
		int row = documentMapper.addDocReshuffle(documentReshuffle);
			
		log.debug(row +"<-- DocumentService documentReshuffle row");
	    return row;
	}
	
	
	public String fileUpload(HttpSession session, HttpServletRequest request, MultipartFile file, int docNo, String category) {
	    // 세션에서 로그인 유저 정보 가져오기
		AccountList loginAccount = (AccountList) session.getAttribute("loginAccount");
		
		// 업로드 경로 설정
		String uploadPath = request.getServletContext().getRealPath("/docFile/");
		
		// 고유한 파일명 생성
		UUID uuid = UUID.randomUUID();
		String uuids = uuid.toString().replaceAll("-", "");
		
		// 파일명과 확장자 추출
		String fileOreginName = file.getOriginalFilename();
		String fileExtension = fileOreginName.substring(fileOreginName.lastIndexOf("."));
		
			// 로그 출력
		log.debug(yellow + "저장할 폴더 경로 : " + uploadPath+ reset);
		log.debug(yellow +"실제 파일 명 : " + fileOreginName+ reset);
		log.debug(yellow +"확장자 : " + fileExtension+ reset);
		log.debug(yellow +"고유 랜덤 문자 : " + uuids + reset);
		
		// 새로운 파일명 생성 // 새로운 이름 + 확장자
		String fileSaveName = uuids + fileExtension;
		File saveFile = new File(uploadPath + "/" + fileSaveName);
		
		if (file.getSize() > 0) {
			// DocumentFile 객체 생성 및 정보 설정
			DocumentFile documentFile = new DocumentFile();
			documentFile.setDocNo(docNo);
			documentFile.setDocCategoryNo(category);        
			documentFile.setDocOriginFilename(file.getOriginalFilename());
			documentFile.setDocSaveFilename(fileSaveName);
			documentFile.setDocFilesize(file.getSize());
			documentFile.setDocFiletype(file.getContentType());
			documentFile.setCreateId(loginAccount.getEmpNo());
			documentFile.setUpdateId(loginAccount.getEmpNo());
			
			log.debug(yellow +"넘버 : " + documentFile.getDocNo() + reset);
			log.debug(yellow +"카테고리 : " + documentFile.getDocCategoryNo() + reset);
			log.debug(yellow +"오리진네임 : " + documentFile.getDocOriginFilename() + reset);
			log.debug(yellow +"세이브네임 : " + documentFile.getDocSaveFilename() + reset);
			log.debug(yellow +"사이즈 : " + documentFile.getDocFilesize() + reset);
			log.debug(yellow +"타입 : " + documentFile.getDocFiletype() + reset);
			log.debug(yellow +"작성자 : " + documentFile.getCreateId() + reset);
			log.debug(yellow +"수정자 : " + documentFile.getUpdateId() + reset);
			
			// DocumentFileMapper를 통해 DB에 파일 정보 저장
		    documentFileMapper.addDocFile(documentFile);
		}
		
		try {
			// 파일 저장
			file.transferTo(saveFile);
		} catch (Exception e) {
			e.printStackTrace();
		return "fail"; // 업로드 실패 시
		}
		
	return "success"; // 업로드 성공 시
	}

	public int addDocSigner(DocumentSigner documentSigner) {
		return documentSignerMapper.addDocSigner(documentSigner);
	}
	
	
	// 문서결재 상세 조회
	public Map<String, Object> getDocumentOne(int docNo, String docCode) {
		
		// 문서결재 상세 조회
		Map<String, Object> getDocumentOne = null; 
				
		if(docCode.equals("D0101") || docCode.equals("D0104")) { // 기본기안서, 퇴직신청서
			getDocumentOne = documentMapper.getDocumentDefaultOne(docNo);
		} else if(docCode.equals("D0102")) { // 휴가신청서
			getDocumentOne = documentMapper.getDocumentLeaveOne(docNo);
		} else if(docCode.equals("D0103")) { // 인사이동신청서
			getDocumentOne = documentMapper.getDocumentReshuffleOne(docNo);
		} 	
		
		log.debug(getDocumentOne + "<-- DocumentService getDocumentOne");
		
		return getDocumentOne;
	}
	
	// 첫 번째 결재자가 결재
	public int approveDocDefault1(DocumentDefault documentDefault) {
		int row = documentMapper.approveDocDefault1(documentDefault);
		
		return  row;
		
	}
	
	// 두 번째 결재자가 결재
	public int approveDocDefault2(DocumentDefault documentDefault) {
		int row = documentMapper.approveDocDefault2(documentDefault);
		
		return  row;
	}
	
	// 결재자가 반려 처리
	public int rejectDocDefault(DocumentDefault documentDefault) {
		int row = documentMapper.rejectDocDefault(documentDefault);
		
		return row;
	}
	
	// 결재자 수 확인
	public int getSignerCnt(int docNo) {
		int row = documentSignerMapper.signerCnt(docNo);
		
		return row;
	}
	
	// 결재자 레벨 확인
	public int getSignerLevel(DocumentSigner documentSigner) {
		int row = documentSignerMapper.signerLevel(documentSigner);
		
		return row;
	}
	
	// 결재, 반려 시 signer 테이블 변경
	public int modifySignerStatus(DocumentSigner documentSigner) {
		int row = documentSignerMapper.modifySignerStatus(documentSigner);
	
		return row;	
	}
	
	// 연가 기록 조회
	public Map<String, Object> getDocumentLeave(int docNo) {
		
		Map<String, Object> documentLeave = documentMapper.getDocumentLeaveOne(docNo);
		log.debug(documentLeave+"<-- DocumentService documentLeave");
		return documentLeave;
	}
	
	// 기본 기안서 조회
	public Map<String, Object> getDocumentDefaultOne(int docNo) {
		
		Map<String, Object> docDefaultOne = documentMapper.getDocumentDefaultOne(docNo);
		return docDefaultOne;
	}	

}

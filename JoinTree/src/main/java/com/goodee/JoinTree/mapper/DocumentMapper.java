package com.goodee.JoinTree.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.JoinTree.vo.CommonCode;
import com.goodee.JoinTree.vo.DocumentDefault;
import com.goodee.JoinTree.vo.DocumentLeave;
import com.goodee.JoinTree.vo.DocumentReshuffle;

@Mapper
public interface DocumentMapper {
	
	// 기안서 입력
	// 기본(퇴직) 기안서 입력
	int addDocDefault(DocumentDefault documentDefault);
	
	// 휴가 기안서 입력
	int addDocLeave(DocumentLeave documentLeave);
	
	// 인사이동 기안서 입력
	int addDocReshuffle(DocumentReshuffle documentReshuffle);
			
	
	// 기안서 수정
	// 기본(퇴직) 기안서 수정
	int modifyDocDefault(DocumentDefault documentDefault);
	
	// 휴가 기안서 수정
	int modifyDocLeave(DocumentLeave documentLeave);
	
	// 인사이동 기안서 수정
	int modifyDocReshuffle(DocumentReshuffle documentReshuffle);
			
	
	// 기안서 삭제
	// 기본(퇴직) 기안서 삭제
	int removeDocDefault(DocumentDefault documentDefault);
	
	// 휴가 기안서 삭제
	int removeDocLeave(DocumentLeave documentLeave);
	
	// 인사이동 기안서 삭제
	int removeDocReshuffle(DocumentReshuffle documentReshuffle);
			
	// 기안서 결재상태 변경 (결재)
	int approveDocDefault1(DocumentDefault documentDefault);
	int approveDocDefault2(DocumentDefault documentDefault);
	
	// 기안서 결재상태 변경 (반려)
	int rejectDocDefault(DocumentDefault documentDefault);
	
	// 기안서 상세보기 
	// 기본 기안서 상세보기
	DocumentDefault selectDocDefaultOne(int docNo);
	
	// 휴가 기안서 상세보기
	DocumentLeave selectDocLeaveOne(int docNo);
	
	// 인사이동 기안서 상세보기
	DocumentReshuffle selectDocReshuffleOne(int docNo);
	
			
	
	// 문서결제양식 코드 조회
	List<CommonCode> selectDocumentCodeList();
	
	// 문서결재 기본기안서, 퇴직신청서 상세 조회
	Map<String, Object> getDocumentDefaultOne(int docNo);
	
	// 문서결재 휴가신청서 상세 조회
	Map<String, Object> getDocumentLeaveOne(int docNo);
	
	// 문서결재 인사이동신청서 상세 조회
	Map<String, Object> getDocumentReshuffleOne(int docNo);
	
}

package com.goodee.JoinTree.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.JoinTree.vo.DocumentDefault;

@Mapper
public interface DocumentListMapper {

	int getDraftDocListCnt(Map<String, Object> docMap); // 검색별 기안문서목록 행의 수

	int getApprovalDocListCnt(Map<String, Object> docMap); // 검색별 결제함 행의 수

	int getIndividualDocListCnt(Map<String, Object> docMap); // 검색별 개인문서함 행의 수

	int getTeamDocListCnt(Map<String, Object> docMap); // 검색별 팀별문서함 행의 수

	List<Map<String, Object>> getDraftDocList(Map<String, Object> docMap); // 기안문서목록 조회

	List<Map<String, Object>> getApprovalDocList(Map<String, Object> docMap); // 결재함 조회

	List<Map<String, Object>> getIndividualDocList(Map<String, Object> docMap); // 개인문서함 조회

	List<Map<String, Object>> getTeamDocList(Map<String, Object> docMap); // 팀별문서함 조회
	
	List<DocumentDefault> getDraftDocListHome(int empNo); // home.jsp 기안문서 목록 조회
	
	List<DocumentDefault> getApprovalDocListHome(int empNo); // home.jsp 결재함 목록 조회

}

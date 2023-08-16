package com.goodee.JoinTree.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.goodee.JoinTree.mapper.CodeMapper;
import com.goodee.JoinTree.vo.CommonCode;

@Service
public class CodeService {
	@Autowired
	private CodeMapper codeMapper;
	
	// 공통코드 중 상위코드 출력
	public List<CommonCode> selectUpCode() {
		// db에서 가져온 상위 코드 조회
        List<CommonCode> upCodeList = codeMapper.selectUpCode();

		return upCodeList;
	}
	
	// 상위코드에 해당하는 하위코드만 리스트 출력
	public List<CommonCode> selectChildCode(String upCode) {
		// db에서 가져온 하위 코드 조회
        List<CommonCode> childCodeList = codeMapper.selectChildCode(upCode);
        
        // 리스트 반환
		return childCodeList;
	}
	
	// 공통코드 추가
	public int addCommonCode(CommonCode commenCode) {
		return codeMapper.addCommonCode(commenCode);
	}
	
	// 공통코드 수정
	public int modifyCommonCode(CommonCode commenCode) {
		return codeMapper.modifyCommonCode(commenCode);
	}
}
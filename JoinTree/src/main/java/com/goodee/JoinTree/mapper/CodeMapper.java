package com.goodee.JoinTree.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.JoinTree.vo.CommonCode;

@Mapper
public interface CodeMapper {	
	
	// 공통코드 중 상위코드만 출력
	List<CommonCode> selectUpCode();
	
	// 공통코드 중 하위코드만 출력 
	List<CommonCode> selectChildCode(String upCode);
	
	// 공통코드 추가
	int addCommonCode(CommonCode commenCode);
	
	// 공통코드 수정
	int modifyCommonCode(CommonCode commenCode);

}

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
	
	// 상위코드 상세정보 출력
	List<CommonCode> selectUpCodeOne(String code);
		
	// 하위코드 상세정보 출력 
	List<CommonCode> selectCodeOne(String code);
	
	// 상위코드 추가
	int addUpCommonCode(CommonCode commenCode);
	
	// 하위코드 추가
	int addCommonCode(CommonCode commenCode);

	// 공통코드 수정(상위)
	int modifyCommonCode(CommonCode commenCode);
	
	// 공통코드 수정(상위)
	int modifyUpCommonCode(CommonCode commenCode);
}

package com.goodee.JoinTree.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.JoinTree.vo.EmpInfoImg;

@Mapper
public interface EmpInfoImgMapper {
	// 사원 이미지 정보 추가
	int insertEmpImg(EmpInfoImg empInfoImg);
	
	// 사원 이미지 상세정보
	EmpInfoImg selectEmpImg(int empNo);
		
	// 사원 이미지 정보 삭제
	int removeEmpImg(int empNo);
}

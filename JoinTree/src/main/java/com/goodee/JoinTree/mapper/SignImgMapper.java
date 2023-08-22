package com.goodee.JoinTree.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.JoinTree.vo.SignImg;

@Mapper
public interface SignImgMapper {
	// 서명 이미지 정보 추가
	public int insertSignImg(SignImg signImg);
	
	// 서명 이미지 상세정보
	SignImg selectSignImg(int empNo);
	
	// 서명 이미지 정보 삭제
	int removeSignImg(int empNo);
}

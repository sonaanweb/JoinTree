package com.goodee.JoinTree.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.JoinTree.vo.SignImg;

@Mapper
public interface SignImgMapper {
	public int insertSignImg(SignImg signimg);
}

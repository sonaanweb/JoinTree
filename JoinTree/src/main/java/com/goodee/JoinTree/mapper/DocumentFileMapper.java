package com.goodee.JoinTree.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.JoinTree.vo.DocumentFile;

@Mapper
public interface DocumentFileMapper {
	int addDocFile(DocumentFile documentFile);
}

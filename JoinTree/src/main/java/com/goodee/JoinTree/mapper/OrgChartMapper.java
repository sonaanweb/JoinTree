package com.goodee.JoinTree.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.JoinTree.vo.CommonCode;
import com.goodee.JoinTree.vo.EmpInfo;

@Mapper
public interface OrgChartMapper {
	
	// 공통코드 중 부서코드만 출력 
	List<CommonCode> selectOrgDept();
	
	// 직원테이블에서 직원이름 출력 
	List<EmpInfo> selectOrgEmp(String dept);
}

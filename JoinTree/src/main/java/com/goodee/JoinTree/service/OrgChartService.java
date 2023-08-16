package com.goodee.JoinTree.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.goodee.JoinTree.mapper.OrgChartMapper;
import com.goodee.JoinTree.vo.CommonCode;
import com.goodee.JoinTree.vo.EmpInfo;

@Service
public class OrgChartService {
	@Autowired
	private OrgChartMapper orgChartMapper;
	
	// 공통코드 중 부서만 출력 
	public List<CommonCode> selectOrgDept() {
		// db에서 가져온 부서코드 조회
        List<CommonCode> deptList = orgChartMapper.selectOrgDept();
        
        return deptList;
	}
	
	// 직원테이블에서 부서 내 직원 정보 출력 
	public List<EmpInfo> selectOrgEmp(String dept){
		// db에서 가져온 부서에 맞는 직원정보 조회
		List<EmpInfo> empList = orgChartMapper.selectOrgEmp(dept);
	
		return empList;
	}
}

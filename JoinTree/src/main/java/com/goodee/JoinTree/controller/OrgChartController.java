package com.goodee.JoinTree.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.goodee.JoinTree.service.OrgChartService;
import com.goodee.JoinTree.vo.CommonCode;
import com.goodee.JoinTree.vo.EmpInfo;

@Controller
public class OrgChartController {
	@Autowired
	private OrgChartService orgChartService;
	
	// 부서에 맞는 직원 정보를 전달하는 컨트롤러
	@GetMapping("org/orgEmpList")
	@ResponseBody // json 형태로 전달을 위해 사용
	public List<EmpInfo> selectOrgEmp(@RequestParam(name = "dept") String dept) {
		List<EmpInfo> empList = orgChartService.selectOrgEmp(dept);
		
		return empList;
	}

}

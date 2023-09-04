package com.goodee.JoinTree.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.goodee.JoinTree.service.EmpManageService;
import com.goodee.JoinTree.vo.CommonCode;

@Controller
public class EmpTelController {

	@Autowired
	private EmpManageService empManageService;
	
	@GetMapping("/empTel/empTelList")
	public String selectEmpTelList(Model model) {
		
		// 부서 조회
		List<CommonCode> deptCodeList = empManageService.deptCodeList();
		
		// view 전달
		model.addAttribute("deptCodeList", deptCodeList);
		
		return "/empTel/empTelList";
	}
	
}

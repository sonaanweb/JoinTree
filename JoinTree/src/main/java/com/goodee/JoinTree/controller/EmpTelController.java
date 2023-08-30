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
	
	// 검색별 사원 리스트 조회
	@GetMapping("/empTel/searchEmpTelList")
	@ResponseBody
	public Map<String, Object> searchEmpTelList(@RequestParam(name = "searchEmpList") String searchEmpList,
			 								 @RequestParam(name = "currentPage") int currentPage,
			 								 @RequestParam(name = "rowPerPage") int rowPerPage) {
		
		ObjectMapper objectMapper = new ObjectMapper();
		Map<String, Object> searchEmpListResult = null;
		
		try {
	        Map<String, Object> searchEmpListMap = objectMapper.readValue(searchEmpList, new TypeReference<Map<String, Object>>(){});
	        // 검색, 페이징 리스트
	        searchEmpListResult = empManageService.searchEmpList(searchEmpListMap, currentPage, rowPerPage);
	        
	    } catch (JsonProcessingException e) {
	        e.printStackTrace();
	        
	    } 
		
		return searchEmpListResult;
	}
}

package com.goodee.JoinTree.restapi;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.goodee.JoinTree.service.EmpManageService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
public class EmpManageRestController {
	
	@Autowired
	EmpManageService empManageService;
	
	// 검색별 사원 리스트 조회
	@GetMapping("/empManage/searchEmpList")
	@ResponseBody
	public Map<String, Object> searchEmpList(@RequestParam Map<String, Object> searchEmpListMap,
			 								 @RequestParam(name = "currentPage") int currentPage,
			 								 @RequestParam(name = "rowPerPage") int rowPerPage) {
		
		
		Map<String, Object> searchEmpListResult = empManageService.searchEmpList(searchEmpListMap, currentPage, rowPerPage);
		log.debug(searchEmpListResult +"<-- EmpManageRestController searchEmpListResult");
		
		return searchEmpListResult;
	}
}

package com.goodee.JoinTree.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.goodee.JoinTree.service.ProjectService;
import com.goodee.JoinTree.vo.AccountList;
import com.goodee.JoinTree.vo.Project;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class ProjectController {
	@Autowired
	private ProjectService projectService;
	
	String yellow = "\u001B[33m";
	String reset = "\u001B[0m";
	
	// "project/projectList" 보내는 컨트롤러
	@GetMapping("project/projectList")
	public String ProejectList(){
		
		return "project/projectList";
	}
    
	// 프로젝트 검색별 행의 수
	@GetMapping("/project/count")
	public int projectCountRows(@RequestParam(required = false) String title, // required = false 필수 X
								@RequestParam(required = false) String startDate,
								@RequestParam(required = false) String endDate) {
		
		return projectService.projectCountRows(title, startDate, endDate);
	}

					
	// 프로젝트 전체 리스트 출력 컨트롤러
	@GetMapping("project/projectListAll")
	@ResponseBody
	public Map<String, Object> selectProjectListAll(@RequestParam(name="startRow") int startRow,
											@RequestParam(name="rowPerPage") int rowPerPage,
											@RequestParam(required = false) String title, // required = false 필수 X
											@RequestParam(required = false) String startDate,
											@RequestParam(required = false) String endDate) {
		// 서비스 레이어에서 가져온 프로젝트 리스트를 조회하여 리스트에 저장
		// 프로젝트 리스트는 projectList라는 이름으로 resultMap에 들어가있기에 추후 호출할 때 projectList로 호출해야함
		Map<String, Object> resultMap = projectService.selectProejectList(startRow, rowPerPage);
		int totalCnt = projectService.projectCountRows(title, startDate, endDate);
		
		log.debug(yellow + "startRow:" + startRow + reset);
		log.debug(yellow + "rowPerPage:" + rowPerPage + reset);
		log.debug(yellow + "resultMap:" + resultMap + reset);
		log.debug(yellow + "totalCnt:" + totalCnt + reset);
		
		// 뷰로 전달을 위해 맵에 담기
		resultMap.put("totalCnt", totalCnt);
		
		return resultMap;
	}
	
	// 프로젝트 개인별 참여 중 프로젝트 출력 -> 자신의 사번이 있고 프로젝트 상태가 진행중인거(A0502)
	// json
	@GetMapping("project/personalProjectList")
	@ResponseBody
	public Map<String, Object> selectProjectListByPersonal(HttpSession session,
												@RequestParam(name="startRow")int startRow, 
												@RequestParam(name="rowPerPage")int rowPerPage,
												@RequestParam(required = false) String title, // required = false 필수 X
												@RequestParam(required = false) String startDate,
												@RequestParam(required = false) String endDate){
		// 로그인 유저
		AccountList loginAccount = (AccountList) session.getAttribute("loginAccount");
		
		int empNo = loginAccount.getEmpNo();
		log.debug(yellow + "empNo:" + empNo + reset);
		
		// 서비스 레이어에서 가져온 프로젝트 리스트를 조회하여 맵에 저장 및 cnt저장
		// 프로젝트 리스트는 personalProjectList라는 이름으로 resultMap에 들어가있기에 추후 호출할 때 personalProjectList로 호출해야함
		Map<String, Object> resultMap = projectService.selectProjectListByPersonal(empNo, startRow, rowPerPage);
		int totalCnt = projectService.projectCountRows(title, startDate, endDate);

		resultMap.put("totalCnt", totalCnt);
		
		return resultMap;
	}
	
	// 프로젝트 종료된 프로젝트 출력 -> 프로젝트 상태가 완료(A0503)
	// json
	@GetMapping("project/endProjectList")
	@ResponseBody
	public Map<String, Object> selectEndProjectList(@RequestParam(name="startRow")int startRow, 
												@RequestParam(name="rowPerPage")int rowPerPage,
												@RequestParam(required = false) String title, // required = false 필수 X
												@RequestParam(required = false) String startDate,
												@RequestParam(required = false) String endDate) {
		// 서비스 레이어에서 가져온 프로젝트 리스트를 조회하여 맵에 저장 및 cnt저장
		// 프로젝트 리스트는 endProjectList라는 이름으로 resultMap에 들어가있기에 추후 호출할 때 endProjectList로 호출해야함
		Map<String, Object> resultMap = projectService.selectEndProjectList(startRow, rowPerPage);
		int totalCnt = projectService.projectCountRows(title, startDate, endDate);

		resultMap.put("totalCnt", totalCnt);
		
		return resultMap;
	}
}
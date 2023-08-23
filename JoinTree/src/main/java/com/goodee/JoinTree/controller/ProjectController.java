package com.goodee.JoinTree.controller;

import java.util.List;

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
	
	// 프로젝트 전체 리스트 출력 컨트롤러
	@GetMapping("project/projectList")
	public String selectProejectList(Model model, 
											@RequestParam(name="startRow") int startRow,
											@RequestParam(name="rowPerPage") int rowPerPage) {
		// 서비스 레이어에서 가져온 프로젝트 리스트를 조회하여 리스트에 저장
		List<Project> projectList = projectService.selectProejectList(startRow, rowPerPage);
		
		// 뷰에서 사용할 수 있도록 모델에 추가
		model.addAttribute("projectList", projectList);
		
		// 뷰로 전달
		return "project/projectList";
	}
	
	// 프로젝트 개인별 참여 중 프로젝트 출력 -> 자신의 사번이 있고 프로젝트 상태가 진행중인거(A0502)
	// json
	@GetMapping("project/personalProjectList")
	@ResponseBody
	public List<Project> selectProjectListByPersonal(@RequestParam(name="empNo")int empNo,
												@RequestParam(name="startRow")int startRow, 
												@RequestParam(name="rowPerPage")int rowPerPage){
		// 서비스 레이어에서 가져온 참여중인 프로젝트 조회 및 리스트 저장 
		List<Project> personalProjectList = projectService.selectProjectListByPersonal(empNo, startRow, rowPerPage);
		
		return personalProjectList;
	}
	
	// 프로젝트 종료된 프로젝트 출력 -> 프로젝트 상태가 완료(A0503)
	// json
	@GetMapping("project/endProjectList")
	@ResponseBody
	public List<Project> selectEndProjectList(int startRow, int rowPerPage) {
		// 서비스 레이어에서 가져온 종료된 프로젝트 조회 및 리스트 저장 
		List<Project> endProjectList = projectService.selectEndProjectList(startRow, rowPerPage);
		
		return endProjectList;
	}
}

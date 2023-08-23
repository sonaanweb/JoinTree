package com.goodee.JoinTree.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.goodee.JoinTree.mapper.ProjectMapper;
import com.goodee.JoinTree.vo.Project;

@Service
public class ProjectService {
	@Autowired
	private ProjectMapper projectMapper;
	
	// 프로젝트 전체 리스트 출력
	public List<Project> selectProejectList(int startRow, int rowPerPage) {
		// db에서 가져온 프로젝트 리스트
		List<Project> projectList = projectMapper.selectProejectList(startRow, rowPerPage);
		
		return projectList;
	}
	
	// 프로젝트 개인별 참여 중 프로젝트 출력 -> 자신의 사번이 있고 프로젝트 상태가 진행중인거(A0502)
	public List<Project> selectProjectListByPersonal(int empNo, int startRow, int rowPerPage){
		// db에서 가져온 참여중인 프로젝트 리스트
		List<Project> personalProjectList = projectMapper.selectProjectListByPersonal(empNo, startRow, rowPerPage);
		
		return personalProjectList;
	}
	
	// 프로젝트 종료된 프로젝트 출력 -> 프로젝트 상태가 완료(A0503)
	public List<Project> selectEndProjectList(int startRow, int rowPerPage) {
		// db에서 가져온 종료된 프로젝트 리스트
		List<Project> endProjectList = projectMapper.selectEndProjectList(startRow, rowPerPage);
		
		return endProjectList;
	}
	
	// 홈에서 참여중인 프로젝트 출력 -> 참여중인 프로젝트5개만
	public List<Project> selectProjectListByHome(int empNo) {
	// db에서 가져온 참여중인 프로젝트 5개
		List<Project> homeProejctList = projectMapper.selectProjectListByHome(empNo);
		
		return homeProejctList;	
	}
}

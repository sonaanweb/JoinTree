package com.goodee.JoinTree.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.goodee.JoinTree.mapper.ProjectMapper;
import com.goodee.JoinTree.vo.Project;
import com.goodee.JoinTree.vo.ProjectMember;
import com.goodee.JoinTree.vo.ProjectTask;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ProjectService {
	@Autowired
	private ProjectMapper projectMapper;
	
	String yellow = "\u001B[33m";
	String reset = "\u001B[0m";
	
	// 프로젝트 검색별 행의 수
	public int projectCountRows(String searchName, String startDate, String endDate) {
		
		return projectMapper.projectCountRows(searchName, startDate, endDate);
	}

	// 프로젝트 전체 리스트 출력
	public Map<String, Object> selectProejectList(int startRow, int rowPerPage, String searchName, String startDate, String endDate) {
		Map<String, Object> projectWithCnt = new HashMap<>();
		
		// db에서 가져온 프로젝트 리스트
		List<Project> projectList = projectMapper.selectProejectList(startRow, rowPerPage, searchName, startDate, endDate);
		
			// empcnt에 프로젝트번호 값 넣기
			for (Project project : projectList) {
				int projectMemberCount = projectMapper.selectProejectMemberCnt(project.getProjectNo());
				project.setEmpCnt(projectMemberCount);
			}
		
		// 전체 행의 수 가져오기
		int totalRows = projectMapper.projectCountRows(searchName, startDate, endDate);  
		
		projectWithCnt.put("projectList", projectList); // projectWithCnt맵에 저장되서 컨트롤러로 전송
		projectWithCnt.put("totalRows", totalRows);
		
		return projectWithCnt;
	}
	
	// 프로젝트 개인별 참여 중 프로젝트 출력 -> 자신의 사번이 있고 프로젝트 상태가 진행중인거(A0502)
	public Map<String, Object> selectProjectListByPersonal(int empNo, int startRow, int rowPerPage, String searchName, String startDate, String endDate){
		Map<String, Object> personalProjectWithCnt = new HashMap<>();
		
		// db에서 가져온 참여중인 프로젝트 리스트
		List<Project> personalProjectList = projectMapper.selectProjectListByPersonal(empNo, startRow, rowPerPage, searchName, startDate, endDate);
		
			// empcnt에 프로젝트번호 값 넣기
			for (Project project : personalProjectList) {
				int projectMemberCount = projectMapper.selectProejectMemberCnt(project.getProjectNo());
				project.setEmpCnt(projectMemberCount);
			}
		// 전체 행의 수 가져오기
		int totalRows = projectMapper.projectCountRows(searchName, startDate, endDate); 
		
		personalProjectWithCnt.put("personalProjectList", personalProjectList); // personalProjectWithCnt맵에 저장되서 컨트롤러로 전송
		personalProjectWithCnt.put("totalRows", totalRows);
		
		return personalProjectWithCnt;
	}
	
	// 프로젝트 종료된 프로젝트 출력 -> 프로젝트 상태가 완료(A0503)
	public Map<String, Object> selectEndProjectList(int startRow, int rowPerPage, String searchName, String startDate, String endDate) {
		Map<String, Object> endProjectWithCnt = new HashMap<>();
		
		// db에서 가져 종료된 프로젝트 리스트
		List<Project> endProjectList = projectMapper.selectEndProjectList(startRow, rowPerPage, searchName, startDate, endDate);
		
			// empcnt에 프로젝트번호 값 넣기
			for (Project project : endProjectList) {
				int projectMemberCount = projectMapper.selectProejectMemberCnt(project.getProjectNo());
				project.setEmpCnt(projectMemberCount);
			}
		// 전체 행의 수 가져오기
		int totalRows = projectMapper.projectCountRows(searchName, startDate, endDate);   
		
		endProjectWithCnt.put("endProjectList", endProjectList); // endProjectWithCnt맵에 저장되서 컨트롤러로 전송
		endProjectWithCnt.put("totalRows", totalRows);
		
		return endProjectWithCnt;
	}
	
	// 홈에서 참여중인 프로젝트 출력 -> 참여중인 프로젝트5개만
	public List<Project> selectProjectListByHome(int empNo) {
		// db에서 가져온 참여중인 프로젝트 5개
		List<Project> homeProejctList = projectMapper.selectProjectListByHome(empNo);
		
		return homeProejctList;	
	}
	
	// 프로젝트 상세
	public Project selectProejctOne(Project project) {
		return projectMapper.selectProjectOne(project);
	}
	
	// 프로젝트 추가
	public int addProject(Project project) {
		return projectMapper.addProject(project);
	}
	/* 프로젝트 하위작업 */
	public List<ProjectTask> selectProejectTaskList(int projectNo) {
		// db에서 가져온 ProjectTask 정보
		List<ProjectTask> projectTaskList = projectMapper.selectProejectTaskList(projectNo);
		
		return projectTaskList;
	}
	/* 프로젝트 멤버 */
	// 프로젝트 참여 명단 출력
	public List<ProjectMember> selectProejectMember(int projectNo) {
		return projectMapper.selectProejectMember(projectNo);
	}
	
	// 프로젝트 멤버 추가
	public int addProjectMember(ProjectMember projectMember) {
		return projectMapper.addProjectMemeber(projectMember);
	}
	
	// 프로젝트 멤버 삭제
	public int romoveProjectMemeber(int empNo, int projectNo) {
		return projectMapper.romoveProjectMemeber(empNo, projectNo);
	}
}

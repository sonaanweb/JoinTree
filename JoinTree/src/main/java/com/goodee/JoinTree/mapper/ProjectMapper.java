package com.goodee.JoinTree.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.goodee.JoinTree.vo.Project;
import com.goodee.JoinTree.vo.ProjectMember;

@Mapper
public interface ProjectMapper {
	
	// 프로젝트 검색 별 행 카운트
	int projectCountRows(String searchName, String startDate, String endDate);
	
	// 프로젝트 멤버 카운트 출력 
	int selectProejectMemberCnt(int projectNo);
		
	// 프로젝트 전체 리스트 출력
	List<Project> selectProejectList(int startRow, int rowPerPage, String searchName, String startDate, String endDate);
	
	// 프로젝트 개인별 참여 중 프로젝트 출력 -> 자신의 사번이 있고 프로젝트 상태가 진행중인거(A0502)
	List<Project> selectProjectListByPersonal(int empNo, int startRow, int rowPerPage, String searchName, String startDate, String endDate);
	
	// 프로젝트 종료된 프로젝트 출력 -> 프로젝트 상태가 완료(A0503)
	List<Project> selectEndProjectList(int startRow, int rowPerPage, String searchName, String startDate, String endDate);
	
	// 홈에서 참여중인 프로젝트 출력 -> 참여중인 프로젝트5개만
	List<Project> selectProjectListByHome(int empNo);
	
	// 프로젝트 상세보기
	Project selectProjectOne(Project project);
	
	// 프로젝트 멤버 리스트
	List<ProjectMember> selectProejectMember(int projectNo);
}

package com.goodee.JoinTree.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.goodee.JoinTree.mapper.ProjectMapper;
import com.goodee.JoinTree.service.OrgChartService;
import com.goodee.JoinTree.service.ProjectService;
import com.goodee.JoinTree.vo.AccountList;
import com.goodee.JoinTree.vo.CommonCode;
import com.goodee.JoinTree.vo.EmpInfo;
import com.goodee.JoinTree.vo.Project;
import com.goodee.JoinTree.vo.ProjectMember;
import com.goodee.JoinTree.vo.ProjectTask;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class ProjectController {
	@Autowired
	private ProjectService projectService;
	@Autowired
	private OrgChartService orgChartService;
	@Autowired
	private ProjectMapper projectMapper;
	String yellow = "\u001B[33m";
	String reset = "\u001B[0m";
	
	// "project/projectList" 보내는 컨트롤러
	@GetMapping("project/projectList")
	public String proejectList(){
		
		return "project/projectList";
	}

	// 프로젝트 검색별 행의 수
	@GetMapping("/project/count")
	public int projectCountRows(@RequestParam(name="searchName", required = false) String searchName, // required = false 필수 X
								@RequestParam(name="startDate", required = false) String startDate,
								@RequestParam(name="endDate", required = false) String endDate) {
		
		return projectService.projectCountRows(searchName, startDate, endDate);
	}
	/* 프로젝트 */
	// 프로젝트 전체 리스트 출력 컨트롤러
	@GetMapping("project/projectListAll")
	@ResponseBody
	public Map<String, Object> selectProjectListAll(@RequestParam(name="startRow") int startRow,
											@RequestParam(name="rowPerPage") int rowPerPage,
											@RequestParam(name="searchName") String searchName, // required = false 필수 X
											@RequestParam(name="startDate") String startDate,
											@RequestParam(name="endDate") String endDate) {
		// 서비스 레이어에서 가져온 프로젝트 리스트를 조회하여 리스트에 저장
		// 프로젝트 리스트는 projectList라는 이름으로 resultMap에 들어가있기에 추후 호출할 때 projectList로 호출해야함
		Map<String, Object> resultMap = projectService.selectProejectList(startRow, rowPerPage, searchName, startDate, endDate);
		int totalCnt = projectService.projectCountRows(searchName, startDate, endDate);
		//log.debug(yellow + "startRow:" + startRow + reset);
		//log.debug(yellow + "rowPerPage:" + rowPerPage + reset);
		//log.debug(yellow + "resultMap:" + resultMap + reset);
		//log.debug(yellow + "totalCnt:" + totalCnt + reset);
		
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
												@RequestParam(name="searchName", required = false) String searchName, // required = false 필수 X
												@RequestParam(name="startDate", required = false) String startDate,
												@RequestParam(name="endDate", required = false) String endDate){
		// 로그인 유저
		AccountList loginAccount = (AccountList) session.getAttribute("loginAccount");
		
		int empNo = loginAccount.getEmpNo();
			//log.debug(yellow + "empNo:" + empNo + reset);
		
		// 서비스 레이어에서 가져온 프로젝트 리스트를 조회하여 맵에 저장 및 cnt저장
		// 프로젝트 리스트는 personalProjectList라는 이름으로 resultMap에 들어가있기에 추후 호출할 때 personalProjectList로 호출해야함
		Map<String, Object> resultMap = projectService.selectProjectListByPersonal(empNo, startRow, rowPerPage, searchName, startDate, endDate);
		int totalCnt = projectService.projectCountRows(searchName, startDate, endDate);

		resultMap.put("totalCnt", totalCnt);
		
		return resultMap;
	}
	
	// 프로젝트 종료된 프로젝트 출력 -> 프로젝트 상태가 완료(A0503)
	// json
	@GetMapping("project/endProjectList")
	@ResponseBody
	public Map<String, Object> selectEndProjectList(@RequestParam(name="startRow")int startRow, 
												@RequestParam(name="rowPerPage")int rowPerPage,
												@RequestParam(name="searchName", required = false) String searchName, // required = false 필수 X
												@RequestParam(name="startDate", required = false) String startDate,
												@RequestParam(name="endDate", required = false) String endDate) {
		// 서비스 레이어에서 가져온 프로젝트 리스트를 조회하여 맵에 저장 및 cnt저장
		// 프로젝트 리스트는 endProjectList라는 이름으로 resultMap에 들어가있기에 추후 호출할 때 endProjectList로 호출해야함
		Map<String, Object> resultMap = projectService.selectEndProjectList(startRow, rowPerPage, searchName, startDate, endDate);
		int totalCnt = projectService.projectCountRows(searchName, startDate, endDate);

		resultMap.put("totalCnt", totalCnt);
		
		return resultMap;
	}
	
	// 프로젝트 상세 projectOne 페이지로 이동
	@GetMapping("project/projectOne")
	public String projectOne(Model model,
							@RequestParam(name="projectNo")int projectNo){
		// 직원 리스트
		List<CommonCode> deptList = orgChartService.selectOrgDept();
				
		model.addAttribute("deptList",deptList); // 사원정보 리스트
		
		return "project/projectOne";
	}
	
	// 프로젝트 상세
	@GetMapping("project/projectOneInfo")
	@ResponseBody
	public Map<String, Object> projectOneInfo(@RequestParam(name="projectNo")int projectNo){
		log.debug(yellow + "projectNo:" + projectNo + reset);
		// db에서 가져온 프로젝트 상세정보
		Project project = new Project();
		project.setProjectNo(projectNo);
		project = projectService.selectProejctOne(project);
		
		// 팀원 리스트
		List<ProjectMember> projectMemeber= projectService.selectProejectMember(projectNo);
			log.debug(yellow + "projectMemeber:" + projectMemeber + reset);
		Map<String, Object> resultMap = new HashMap<>();
		
		resultMap.put("project", project);
		resultMap.put("projectMemeber", projectMemeber);
		
		return resultMap;
	}
	
	// 프로젝트 추가 
	@PostMapping("project/addProject")
	@ResponseBody
	public int addProject(Project project) {
		int row = projectService.addProject(project);
		
		if(row != 1) {
			return 0;
		} 
		return project.getProjectNo();
	}
	/* 프로젝트 끝 */
	/* 프로젝트 하위작업 */
	// 하위작업 리스트 출력
	@GetMapping("project/projectTask")
	@ResponseBody
	public List<ProjectTask> selectProejectTaskList(@RequestParam(name="projectNo") int projectNo) {
		List<ProjectTask> projectTaskList = projectService.selectProejectTaskList(projectNo);
		log.debug(yellow + "projectTaskList:" + projectTaskList + reset);
		
		return projectTaskList;
	}
	/* 프로젝트 하위작업 끝 */
	/*프로젝트 멤버*/
	// 프로젝트 멤버 추가
	@PostMapping("project/addProjectMember")
	@ResponseBody
	public String addProjectMembers(@RequestParam(value = "empNo[]") List<Integer> memberNo,
									@RequestParam(name="projectNo") int projectNo) {
			//log.debug(yellow + "memberNo:" + memberNo + reset);
			//log.debug(yellow + "projectNo:" + projectNo + reset);
		int successCount = 0; // 성공 횟수
		int duplicateCount = 0; // 중복 사원
		
		// memberNo 리스트에 있는 각각의 사원 번호를 empNo에 저장하며 반복
		for (int empNo : memberNo) { 
			// 프로젝트 멤버 테이블에서 해당 사원번호와 프로젝트 번호의 중복 여부 확인
			int empCnt = projectMapper.checkDuplicateProjectMember(empNo, projectNo);
			
			if (empCnt == 0) { // 중복이 없을 경우
				// 프로젝트 멤버 객체 생성 및 설정
				ProjectMember projectMember = new ProjectMember();
				projectMember.setProjectNo(projectNo);
				projectMember.setEmpNo(empNo);
					//log.debug(yellow + "projectMember:" + projectMember + reset);
				// 프로젝트 멤버 추가
				int row = projectService.addProjectMember(projectMember);
				if (row == 1) {
					successCount++;
				}
			} else {
				duplicateCount++; // 중복이 있을 경우 카운트 증가
			}
		}
		
		if (duplicateCount > 0) {
			return "duplicate";
		} else if (successCount > 0) {
			return "success";
		} else {
			return "fail";
		}
	}
	// 프로젝트 멤버 삭제 
	
	/* 프로젝트 멤버 끝 */
	@PostMapping("project/romoveProjectMemeber")
	@ResponseBody
	public String romoveProjectMemeber(@RequestParam(name="empNo") int empNo,
									@RequestParam(name="projectNo") int projectNo) {
		int row = projectService. romoveProjectMemeber(empNo, projectNo);
		
		if(row != 1) {
			return "fail";
		} 
		return "success";
	}
}

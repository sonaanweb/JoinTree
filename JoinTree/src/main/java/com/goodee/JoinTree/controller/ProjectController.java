package com.goodee.JoinTree.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.goodee.JoinTree.mapper.ProjectMapper;
import com.goodee.JoinTree.service.OrgChartService;
import com.goodee.JoinTree.service.ProjectService;
import com.goodee.JoinTree.vo.AccountList;
import com.goodee.JoinTree.vo.CommonCode;
import com.goodee.JoinTree.vo.EmpInfo;
import com.goodee.JoinTree.vo.Project;
import com.goodee.JoinTree.vo.ProjectMember;
import com.goodee.JoinTree.vo.ProjectTask;
import com.goodee.JoinTree.vo.TaskComment;

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
								@RequestParam(name="endDate", required = false) String endDate,
								@RequestParam(name="empNo",required = false) Integer empNo,
								@RequestParam(name="projectStatus", required = false) String projectStatus) {
		
		return projectService.projectCountRows(empNo, projectStatus, searchName, startDate, endDate);
	}
	
	/* 프로젝트 */
	// 프로젝트 전체 리스트 출력 컨트롤러
	@GetMapping("project/projectListAll")
	@ResponseBody
	public Map<String, Object> selectProjectListAll(@RequestParam(name="startRow") int startRow,
											@RequestParam(name="rowPerPage") int rowPerPage,
											@RequestParam(name="searchName") String searchName,
											@RequestParam(name="startDate") String startDate,
											@RequestParam(name="endDate") String endDate,
											@RequestParam(name="empNo", required = false) Integer empNo,
											@RequestParam(name="projectStatus", required = false) String projectStatus) {
		// 서비스 레이어에서 가져온 프로젝트 리스트를 조회하여 리스트에 저장
		// 프로젝트 리스트는 projectList라는 이름으로 resultMap에 들어가있기에 추후 호출할 때 projectList로 호출해야함
		Map<String, Object> resultMap = projectService.selectProejectList(empNo, projectStatus, startRow, rowPerPage, searchName, startDate, endDate);
		int totalCnt = projectService.projectCountRows(empNo, projectStatus, searchName, startDate, endDate);
		//log.debug(yellow + "startRow:" + startRow + reset);
		//log.debug(yellow + "rowPerPage:" + rowPerPage + reset);
		//log.debug(yellow + "resultMap:" + resultMap + reset);
		//log.debug(yellow + "totalCnt:" + totalCnt + reset);
		
		// 뷰로 전달을 위해 맵에 담기
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
			//log.debug(yellow + "projectNo:" + projectNo + reset);
		// db에서 가져온 프로젝트 상세정보
		Project project = new Project();
		project.setProjectNo(projectNo);
		project = projectService.selectProejctOne(project);
		
		// 팀원 리스트
		List<ProjectMember> projectMemeber= projectService.selectProejectMember(projectNo);
		
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
	
	// 프로젝트 수정
	@PostMapping("project/modifyProject")
	@ResponseBody
	public String modifyProject(@RequestParam(name="projectNo") int projectNo,
								@RequestParam(name="projectName") String projectName,
								@RequestParam(name="projectContent") String projectContent,
								@RequestParam(name="projectStartDate") String projectStartDate,
								@RequestParam(name="projectEndDate") String projectEndDate,
								@RequestParam(name="updateId") int updateId) {
		log.debug(yellow + "projectNo:" + projectNo + reset);
		Project project = new Project();
		project.setProjectNo(projectNo);
		project.setProjectName(projectName);
		project.setProjectContent(projectContent);
		project.setProjectStartDate(projectStartDate);
		project.setProjectEndDate(projectEndDate);
		project.setUpdateId(updateId);
		
		int row = projectService.modifyProject(project);
		log.debug(yellow + "project:" + project + reset);
		if(row != 1) {
			return "fail";
		}
		return "success";
	}
	
	// 프로젝트 완료 처리
	@PostMapping("project/endProject")
	@ResponseBody
	public String endProject(@RequestParam(name="projectNo") int projectNo) {
		
		int row = projectService.endProject(projectNo);
			log.debug(yellow + "projectNo:" + projectNo + reset);
		if(row != 1) {
			return "fail";
		}
		return "success";
	}
	
	// 프로젝트 삭제
	@PostMapping("project/removeProject")
	@ResponseBody
	public String removeProject(@RequestParam(name="projectNo") int projectNo) {
		int row = projectService.removeProject(projectNo);
		
		if(row != 1) {
			return "fail";
		}
		return "success";
	}
	
	/* 프로젝트 끝 */
	/* 프로젝트 하위작업 */
	// 하위작업 리스트 출력
	@GetMapping("project/projectTask")
	@ResponseBody
	public Map<String, Object>selectProejectTaskList(@RequestParam(name="projectNo") int projectNo) {
		Map<String, Object> projectTaskMap = projectService.selectProejectTaskList(projectNo);
		
		log.debug(yellow + "projectTaskMap:" + projectTaskMap + reset);
		
		return projectTaskMap;
	}
	
	// 하위작업 추가 
	@PostMapping("project/addProjectTask")
	@ResponseBody
	public int addProjectTask(ProjectTask projectTask) {
		int row = projectService.addProjectTask(projectTask);
		
		if(row != 1) {
			return 0;
		} 
		return projectTask.getTaskNo();
	}
	
	// 하위작업 파일 업로드
	@PostMapping("project/fileUpload")
	@ResponseBody
	public String addTaskFileUpload(HttpSession session, HttpServletRequest request,
								@RequestParam("file") MultipartFile file, 
								@RequestParam("taskNo") int taskNo) {
		
		// 서비스 메서드 호출
		String fileUpload = projectService.addTaskFileUpload(session, request, file, taskNo);
		
		return fileUpload;

	}
	// 프로젝트 작업 완료 처리
	@PostMapping("project/endProjectTask")
	@ResponseBody
	public String endProjectTask(@RequestParam(name="taskNo") int taskNo) {
		log.debug(yellow + "taskNo:" + taskNo + reset);
		int row = projectService.endProjectTask(taskNo);

		if(row != 1) {
			return "fail";
		}
		return "success";
	}
	
	// 프로젝트 작업 삭제 처리
	@PostMapping("project/removeProjectTask")
	@ResponseBody
	public String removeProjectTask(@RequestParam(name="taskNo") int taskNo,
									@RequestParam(name="projectNo") int projectNo,
									@RequestParam(required = false) String taskSaveFilename) {
		int row = projectService.removeProjectTask(taskNo, projectNo, taskSaveFilename);
		
		if(row != 1) {
			return "fail";
		}
		return "success";
	}
	/* 프로젝트 하위작업 끝 */
	/* 프로젝트 하위작업 댓글 */
	// 대댓글 카운트 
	@GetMapping("project/taskCommentChildCnt")
	@ResponseBody
	public int taskCommentChildCnt(@RequestParam(name="commentParentNo") int commentParentNo) {
		int taskCommentChildCnt = projectMapper.taskCommentChildCnt(commentParentNo);
		
		return taskCommentChildCnt;
	}
	// 댓글 리스트
	@GetMapping("project/selectTaskComment")
	@ResponseBody
	public List<TaskComment> selectTaskComment(@RequestParam(name="taskNo") int taskNo) {
		List<TaskComment> taskCommentList = projectService.selectTaskComment(taskNo);
		
		return taskCommentList;
	}
	// 댓글 추가
	@PostMapping("project/addTaskComment")
	@ResponseBody
	public String addTaskComment(TaskComment taskComment) {
		int row = projectService.addTaskComment(taskComment);
		
		if(row != 1) {
			return "fail";
		}
		return "success";
	}
		
	// 대댓글 추가
	@PostMapping("project/addTaskCommentChild")
	@ResponseBody
	public String addTaskCommentChild(TaskComment taskComment) {
		int row = projectService.addTaskCommentChild(taskComment);
		
		if(row != 1) {
			return "fail";
		}
		return "success";
	}
	
	// 댓글 삭제
	@PostMapping("project/removeTaskComment")
	@ResponseBody
	public String removeTaskComment(int taskCommentNo) {
		int row = projectService.removeTaskComment(taskCommentNo);
		
		if(row != 1) {
			return "fail";
		}
		return "success";
	}
	/* 프로젝트 하위작업 댓글 끝 */
	/* 프로젝트 멤버 */
	// 프로젝트 멤버 포함되는지 확인
	@PostMapping("project/projectMemberDup")
	@ResponseBody
	public String projectMemberDup(@RequestParam(name = "empNo") int empNo,
									@RequestParam(name="projectNo") int projectNo) {
			
		// 프로젝트 멤버 테이블에서 해당 사원번호와 프로젝트 번호의 중복 여부 확인
		int empCnt = projectMapper.checkDuplicateProjectMember(empNo, projectNo);
		
		if (empCnt == 0) { // 프로젝트 내 내가 존재하지 않을경우
			return "fail";
		}
		return "success";
	}
	// 프로젝트 멤버 추가
	@PostMapping("project/addProjectMember")
	@ResponseBody
	public String addProjectMembers(@RequestParam(value = "empNo[]") List<Integer> memberNo,
									@RequestParam(name="projectNo") int projectNo,
									@RequestParam(name="createId") int createId,
									@RequestParam(name="updateId") int updateId) {
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
				projectMember.setCreateId(createId);
				projectMember.setUpdateId(updateId);
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
	@PostMapping("project/removeProjectMemeber")
	@ResponseBody
	public String removeProjectMemeber(@RequestParam(value = "empNo[]") List<Integer> memberNo,
									@RequestParam(name="projectNo") int projectNo) {
		int row = 0;
		int totalDeleted = 0; // 삭제된 인원의 수를 저장할 변수
		// memberNo 리스트에 있는 각각의 사원 번호를 empNo에 저장하며 반복
		for (int empNo : memberNo) { 
			// 프로젝트 멤버 삭제
			row = projectService.removeProjectMemeber(empNo, projectNo);
			totalDeleted += row; // 삭제 성공한 경우에만 totalDeleted 증가
		}
		
		if (totalDeleted > 1) {
			return "successAll";
		} else if(totalDeleted == 1){
			return "success";
		} else {
			return "fail";
		}
	}
	/* 프로젝트 멤버 끝 */

}

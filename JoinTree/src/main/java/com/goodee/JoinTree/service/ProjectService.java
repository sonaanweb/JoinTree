package com.goodee.JoinTree.service;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.goodee.JoinTree.mapper.ProjectMapper;
import com.goodee.JoinTree.vo.AccountList;
import com.goodee.JoinTree.vo.DocumentFile;
import com.goodee.JoinTree.vo.Project;
import com.goodee.JoinTree.vo.ProjectMember;
import com.goodee.JoinTree.vo.ProjectTask;
import com.goodee.JoinTree.vo.TaskComment;
import com.goodee.JoinTree.vo.TaskFile;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ProjectService {
	@Autowired
	private ProjectMapper projectMapper;
	
	String yellow = "\u001B[33m";
	String reset = "\u001B[0m";
	
	// 프로젝트 검색별 행의 수
	public int projectCountRows(int empNo, String projectStatus, String searchName, String startDate, String endDate) {
		
		return projectMapper.projectCountRows(empNo, projectStatus, searchName, startDate, endDate);
	}

	// 프로젝트 전체 리스트 출력
	public Map<String, Object> selectProejectList(int empNo, String projectStatus, int startRow, int rowPerPage, String searchName, String startDate, String endDate) {
		Map<String, Object> projectWithCnt = new HashMap<>();
		
		// db에서 가져온 프로젝트 리스트
		List<Project> projectList = projectMapper.selectProejectList(empNo, projectStatus, startRow, rowPerPage, searchName, startDate, endDate);
		
			// empcnt에 프로젝트번호 값 넣기
			for (Project project : projectList) {
				int projectMemberCount = projectMapper.selectProejectMemberCnt(project.getProjectNo());
				project.setEmpCnt(projectMemberCount);
			}
		
		// 전체 행의 수 가져오기
		int totalRows = projectMapper.projectCountRows(empNo, projectStatus, searchName, startDate, endDate);  
		
		projectWithCnt.put("projectList", projectList); // projectWithCnt맵에 저장되서 컨트롤러로 전송
		projectWithCnt.put("totalRows", totalRows);
		
		return projectWithCnt;
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
	
	// 프로젝트 수정 
	public int modifyProject(Project project) {
		return projectMapper.modifyProject(project);
	}
	
	// 프로젝트 완료 처리
	public int endProject(int projectNo) {
		return projectMapper.endProject(projectNo);
	}
	
	// 프로젝트 삭제 
	public int removeProject(int projectNo) {
		return projectMapper.removeProject(projectNo);
	}
	
	/* 프로젝트 하위작업 */
	// 프로젝트 하위작업 리스트 추가
	public Map<String, Object> selectProejectTaskList(int projectNo) {
		// db에서 가져온 ProjectTask 정보
		List<ProjectTask> projectTaskList = projectMapper.selectProejectTaskList(projectNo);
		List<ProjectTask> projectProgress = projectMapper.projectProgress(projectNo);
		
		Map<String, Object> projectTaskMap = new HashMap<>();
		projectTaskMap.put("projectTaskList", projectTaskList);
		projectTaskMap.put("projectProgress", projectProgress);

		return projectTaskMap;
	}
	
	// 프로젝트 하위작업 추가
	public int addProjectTask(ProjectTask projectTask) {
		return projectMapper.addProjectTask(projectTask);
	}
	
	// 프로젝트 하위작업 파일 업로드
	public String addTaskFileUpload(HttpSession session, HttpServletRequest request, MultipartFile file, int taskNo) {
		// 세션에서 로그인 유저 정보 가져오기
		AccountList loginAccount = (AccountList) session.getAttribute("loginAccount");
		
		// 업로드 경로 설정
		String uploadPath = request.getServletContext().getRealPath("/taskFile/");
		
		// 고유한 파일명 생성
		UUID uuid = UUID.randomUUID();
		String uuids = uuid.toString().replaceAll("-", "");
		
		// 파일명과 확장자 추출
		String fileOreginName = file.getOriginalFilename();
		String fileExtension = fileOreginName.substring(fileOreginName.lastIndexOf("."));
		
		// 로그 출력
		log.debug(yellow + "저장할 폴더 경로 : " + uploadPath+ reset);
		log.debug(yellow +"실제 파일 명 : " + fileOreginName+ reset);
		log.debug(yellow +"확장자 : " + fileExtension+ reset);
		log.debug(yellow +"고유 랜덤 문자 : " + uuids + reset);
		
		// 새로운 파일명 생성 // 새로운 이름 + 확장자
		String fileSaveName = uuids + fileExtension;
		File saveFile = new File(uploadPath + "/" + fileSaveName);
		
		if (file.getSize() > 0) {
			// TaskFile 객체 생성 및 정보 설정
			TaskFile taskFile = new TaskFile();
			taskFile.setTaskNo(taskNo);
			taskFile.setTaskOriginFilename(file.getOriginalFilename());
			taskFile.setTaskSaveFilename(fileSaveName);
			taskFile.setTaskFilesize(file.getSize());
			taskFile.setTaskFiletype(file.getContentType());
			taskFile.setCreateId(loginAccount.getEmpNo());
			taskFile.setUpdateId(loginAccount.getEmpNo());
			
			log.debug(yellow +"넘버 : " + taskFile.getTaskNo() + reset);
			log.debug(yellow +"오리진네임 : " + taskFile.getTaskOriginFilename() + reset);
			log.debug(yellow +"세이브네임 : " + taskFile.getTaskSaveFilename() + reset);
			log.debug(yellow +"사이즈 : " + taskFile.getTaskFilesize() + reset);
			log.debug(yellow +"타입 : " + taskFile.getTaskFiletype() + reset);
			log.debug(yellow +"작성자 : " + taskFile.getCreateId() + reset);
			log.debug(yellow +"수정자 : " + taskFile.getUpdateId() + reset);
			
			// projectMapper를 통해 DB에 파일 정보 저장
			projectMapper.addTaskFileUpload(taskFile);
		}
		
		try {
			// 파일 저장
			file.transferTo(saveFile);
		} catch (Exception e) {
			e.printStackTrace();
			return "fail"; // 업로드 실패 시
		}
		return "success"; // 업로드 성공 시
	}
	
	// 프로젝트 하위작업 완료 처리
	public int endProjectTask(int taskNo) {
		return projectMapper.endProjectTask(taskNo);
	}
		
	// 프로젝트 하위작업 삭제
	public int removeProjectTask(int taskNo, int projectNo, String taskSaveFilename) {
		int row = 0;
		
		if (taskSaveFilename != null && !taskSaveFilename.isEmpty()) {
			String filePath = "/taskFile/" + taskSaveFilename;
			log.debug(yellow + "삭제할 파일 경로 : " + filePath+ reset);
			File file = new File(filePath);
			
			if (file.exists()) {
				if (file.delete()) {
					row = projectMapper.removeProjectTask(taskNo, projectNo);
				} 
			}
		} else {
			row = projectMapper.removeProjectTask(taskNo, projectNo);
		}
		log.debug(yellow + "row : " + row+ reset);
		return row;
	}
	/* 프로젝트 하위작업 끝 */
	/* 프로젝트 하위작업 댓글 */
	// 댓글 출력
	public List<TaskComment> selectTaskComment(int taskNo) {
		
		List<TaskComment> selectTaskComment = projectMapper.selectTaskComment(taskNo);
		
		return selectTaskComment;
	}

	// 댓글 추가
	public int addTaskComment(TaskComment taskComment) {
		return projectMapper.addTaskComment(taskComment);
	}
	
	// 대댓글 추가
	public int addTaskCommentChild(TaskComment taskComment) {
		return projectMapper.addTaskCommentChild(taskComment);
	}
		
	// 댓글 및 대댓글 삭제
	public int removeTaskComment(int taskCommentNo) {
		return projectMapper.removeTaskComment(taskCommentNo);
	}
	
	/* 프로젝트 하위작업 댓글 끝 */
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
	public int removeProjectMemeber(int empNo, int projectNo) {
		return projectMapper.removeProjectMemeber(empNo, projectNo);
	}
}

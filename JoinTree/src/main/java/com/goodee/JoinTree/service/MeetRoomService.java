package com.goodee.JoinTree.service;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.goodee.JoinTree.mapper.MeetRoomMapper;
import com.goodee.JoinTree.vo.MeetRoomFile;
import com.goodee.JoinTree.vo.MeetingRoom;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class MeetRoomService {
	static final String AN = "\u001B[34m";
	static final String RE = "\u001B[0m";
	
	@Autowired
	private MeetRoomMapper meetRoomMapper;

	// 회의실 목록 조회 메서드
	public List<MeetingRoom> getMeetRoomList(Map<String, Object> map) {
			return meetRoomMapper.selectMeetRoomAll(map);
	}

	// 회의실 추가 메서드
	public int addMeetRoom(MeetingRoom meetingRoom, String path) {
		log.debug(AN + "패스.getMultipartFile : " + path+ RE);
		// 회의실 추가
		int row = meetRoomMapper.insertMeetRoom(meetingRoom);
		log.debug(AN + "회의실.row : " + row+ RE);
		
		//이미지 파일이 존재하는 경우
		MultipartFile file = meetingRoom.getMultipartFile(); // vo에 추가
		log.debug(AN + "서비스.getMultipartFile : " + file+ RE);
		if (row == 1 && file != null && meetingRoom.getMultipartFile().getSize() > 0) {

			int RoomNo = meetingRoom.getRoomNo();

			MeetRoomFile m = new MeetRoomFile();
			m.setRoomNo(RoomNo);
			m.setRoomOriginFilename(file.getOriginalFilename());
			m.setRoomFilesize(file.getSize());
			m.setRoomFiletype(file.getContentType());
			m.setCreateId(meetingRoom.getEmpNo());
			m.setUpdateId(meetingRoom.getEmpNo());

			// 확장자
			String ext = file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf("."));

			// 새로운 이름 + 확장자
			String newFilename = UUID.randomUUID().toString().replace("-", "") + ext; // - 를 공백으로 바꿈
			m.setRoomSaveFilename(newFilename);

			// 테이블에 저장
			meetRoomMapper.insertMeetRoomFile(m);

			// 파일 저장 (저장 위치: path)
			File f = new File(path + m.getRoomSaveFilename()); // path 위치에 저장 파일 이름으로 빈 파일 생성

			// 빈 파일에 첨부된 파일의 스트림을 주입
			try {
				file.transferTo(f);
			} catch (IllegalStateException | IOException e) {
				e.printStackTrace();
				// 트랜잭션 작동을 위해 예외(try-catch를 강요하지 않는 예외 -> ex: RuntimeException) 발생 필요
				throw new RuntimeException();
			}
			log.debug(file.getOriginalFilename() + " <-- RoomService originFilename");
			log.debug(file.getSize() + " <-- RoomService filesize");
			log.debug(file.getContentType() + " <-- RoomService contentType");

		}

		return row;
	}

	// 회의실 수정 메서드
	public int modifyMeetRoom(MeetingRoom meetingRoom, String path) { // 메서드 이름이랑 db mapper이름 혼동 주의
		
		int roomNo = meetingRoom.getRoomNo();
		
		meetRoomMapper.updateMeetRoom(meetingRoom);
		
		int modifyMeetRoom = meetRoomMapper.updateMeetRoom(meetingRoom); // 회의실 수정 성공 int 
		
		// 수정시 첨부파일이 있으면 파일 저장
		MultipartFile file = meetingRoom.getMultipartFile();
		
		int removeMeetRoomFileRow = 0;
		if(modifyMeetRoom == 1 && file != null && meetingRoom.getMultipartFile().getSize() > 0) {
			
			// 기존 첨부파일 있을시 조회
			MeetRoomFile meetRoomFile = meetRoomMapper.selectMeetRoomFile(roomNo);
			
			if (meetRoomFile != null) { 
				String saveFilename = meetRoomFile.getRoomSaveFilename();
				String realPath = path + saveFilename;
				File f = new File(realPath);
				
				if (f.exists()) {
					f.delete();
					log.debug("회의실 기존 이미지 삭제");
				}
				
				// DB 첨부파일 삭제
				removeMeetRoomFileRow = meetRoomMapper.removeMeetRoomFile(roomNo);
				log.debug("기존 회의실 이미지 파일 삭제 완료:"+removeMeetRoomFileRow);
				
			}
			
			MeetRoomFile m = new MeetRoomFile();
			m.setRoomNo(roomNo);
			m.setRoomOriginFilename(file.getOriginalFilename());
			m.setRoomFilesize(file.getSize());
			m.setRoomFiletype(file.getContentType());
			m.setCreateId(meetingRoom.getEmpNo());
			m.setUpdateId(meetingRoom.getEmpNo());

			// 확장자
			String ext = file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf("."));

			// 새로운 이름 + 확장자
			String newFilename = UUID.randomUUID().toString().replace("-", "") + ext; // - 를 공백으로 바꿈
			m.setRoomSaveFilename(newFilename);

			// 테이블에 저장
			meetRoomMapper.insertMeetRoomFile(m);

			// 파일 저장 (저장 위치: path)
			File f = new File(path + m.getRoomSaveFilename()); // path 위치에 저장 파일 이름으로 빈 파일 생성

			// 빈 파일에 첨부된 파일의 스트림을 주입
			try {
				file.transferTo(f);
			} catch (IllegalStateException | IOException e) {
				e.printStackTrace();
				// 트랜잭션 작동을 위해 예외(try-catch를 강요하지 않는 예외 -> ex: RuntimeException) 발생 필요
				throw new RuntimeException();
			}
			log.debug(file.getOriginalFilename() + " <-- RoomService modi originFilename");
			log.debug(file.getSize() + " <-- RoomService modi filesize");
			log.debug(file.getContentType() + " <-- RoomService modi contentType");

		}

		return modifyMeetRoom;
	}
	
	
	// 회의실 이미지 삭제 메서드(이미지만 따로 삭제할 때 사용)
	public int removeImg(int roomNo, String path) {
		MeetRoomFile meetRoomFile = meetRoomMapper.selectMeetRoomFile(roomNo);
		
		if (meetRoomFile != null) {
			String saveFilename = meetRoomFile.getRoomSaveFilename();
			String realPath = path + saveFilename;
			File f = new File(realPath);
			
			if (f.exists()) {
				f.delete();
				log.debug(AN + "기존 이미지 삭제 완료(회의실)" + RE);
			}
		}
		
		// DB에서 이미지 정보 삭제
		int row = meetRoomMapper.removeMeetRoomFile(roomNo);
		
		log.debug(AN + " 회의실 이미지 삭제 row:" + row + RE);
		
		return row;		
	}
	
		
	// 회의실명 중복검사 메서드
	public int getRoomNameCnt(MeetingRoom meetingRoom) {
		int cnt = meetRoomMapper.selectRoomName(meetingRoom);
		return cnt;
	}

	// 회의실 수정 객체
	public MeetingRoom getMeetRoomNo(MeetingRoom meetingRoom) {
		MeetingRoom modiMeetingRoom = meetRoomMapper.selectMeetRoomOne(meetingRoom);
		MeetRoomFile meetRoomFile = meetRoomMapper.selectMeetRoomFile(meetingRoom.getRoomNo());
		if (meetRoomFile != null) {
	        // 파일이 있는 경우에만 값을 설정해서 null값 오류 해결
	        modiMeetingRoom.setMeetRoomFile(meetRoomFile.getRoomSaveFilename());
	    }
		log.debug(AN+"savefile 수정객체:"+meetRoomFile);
		log.debug(AN+"savefile modi:"+modiMeetingRoom);
		return modiMeetingRoom;
		
	}

	// 회의실 삭제
	public int removeMeetRoom(MeetingRoom meetingRoom, String path) {
		
	    int meetRoomFileCnt = meetRoomMapper.selectMeetRoomFileCnt(meetingRoom.getRoomNo());  
		/* log.debug(AN+"파일개수(remove 확인):"+meetRoomFileCnt); */
	    
		    if (meetRoomFileCnt == 1) { // 파일 1(이미지 존재) 하면 삭제
		        MeetRoomFile file = meetRoomMapper.selectMeetRoomFile(meetingRoom.getRoomNo());
				/* log.debug(AN+"삭제 파일 불러오기:"+file); */
	
		        if (file != null) {
		            File f = new File(path + file.getRoomSaveFilename());
		            if (f.exists()) {
		                f.delete();
		            }
					/* log.debug(AN + "프로젝트 내 파일 삭제완료" + RE); */
		        }
	
		        int row = meetRoomMapper.removeMeetRoomFile(meetingRoom.getRoomNo());
				/* log.debug(AN+"파일 삭제 첫번째 로우"+row); */
	
		        if (row == 1) {
		            row = meetRoomMapper.deleteMeetRoom(meetingRoom); // 파일삭제 -> 회의실 삭제
					/* log.debug(AN+"파일 두번째 로우"+row); */
		        }
	
		        return row;
		        
		    } else {
		        // 이미지 파일이 없는 경우 바로 회의실 삭제
		        int row = meetRoomMapper.deleteMeetRoom(meetingRoom);
		        return row;
		    }
	}

	
	// 회의실 이름 검색
	public List<MeetingRoom> searchMeetRoom(Map<String, Object> map) {
		return meetRoomMapper.searchMeetRoom(map);
	}

	// -------------------------------------------------
	
}

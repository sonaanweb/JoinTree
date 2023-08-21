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

import com.goodee.JoinTree.service.CommunityService;
import com.goodee.JoinTree.mapper.BoardFileMapper;
import com.goodee.JoinTree.mapper.CommunityMapper;
import com.goodee.JoinTree.vo.Board;
import com.goodee.JoinTree.vo.BoardFile;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
// @Transactional
public class CommunityService {
	static final String CYAN = "\u001B[46m";
	static final String RESET = "\u001B[0m";
	
	@Autowired
	private CommunityMapper communityMapper;
	
	@Autowired
	private BoardFileMapper boardFileMapper;
	
	// 게시판 목록 
	public Map<String, Object> getCommList(String category, int currentPage, int rowPerPage) {
		int beginRow = (currentPage - 1) * rowPerPage;
		
		Map<String, Object> map = new HashMap<>();
		map.put("beginRow", beginRow);
		map.put("rowPerPage", rowPerPage);
		map.put("currentPage", currentPage);
		map.put("category", category);
		
		log.debug(CYAN + map + " <-- map(CommunityService-getCommList)" + RESET);
		
		List<Board> commList = communityMapper.selectCommListByPage(map);
		
		log.debug(CYAN + commList + " <-- commList(CommunityService-getCommList)" + RESET);
		
		
		
		int commCnt = communityMapper.selectCommCnt(category);
		log.debug(CYAN + commCnt + " <-- commCnt(CommunityService-getCommList)" + RESET);
		
		int lastPage = commCnt / rowPerPage;
		if (commCnt % rowPerPage != 0) {
			lastPage += 1;
		}
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("commList", commList);
		resultMap.put("lastPage", lastPage);
		
		log.debug(CYAN + "category: " + category + RESET);
		log.debug(CYAN + "resultMap: " + resultMap + RESET);
		log.debug(CYAN + "commList: " + resultMap.get("commList") + RESET);
		log.debug( CYAN + "lastPage: " + resultMap.get("lastPage") + RESET);

		return resultMap;
	}
	
	// 게시글 상세보기
	public Map<String, Object> getCommOne(int boardNo) {
		Map<String, Object> map = new HashMap<>();
		map.put("comm", communityMapper.selectCommOne(boardNo));
		map.put("boardFile", boardFileMapper.selectBoardFile(boardNo));
		log.debug(CYAN + map + " <-- map(CommunityService-getCommOne) "+ RESET);
		
		return map;
	}
	
	
	// 게시글 입력 (+ 첨부파일 있을 경우)
	public int addComm(Board board, String path) {
		int row = communityMapper.addComm(board);
		log.debug(CYAN + row + " <--row(CommunityService-addComm)" + RESET);
		
		// 게시글 입력 하나 성공 후 첨부된 파일이 있을 경우
		MultipartFile file = board.getMultipartFile();
		if (row == 1 && file != null && board.getMultipartFile().getSize() > 0) {
			int boardNo = board.getBoardNo(); // row 이후에 호출
			log.debug(CYAN + boardNo + " <--boardNo(CommunityService-addComm)" + RESET);
			
			if (file.getSize() > 0) {
				BoardFile bf = new BoardFile();
				bf.setBoardNo(boardNo);
				bf.setBoardOriginFilename(file.getOriginalFilename()); // 파일 원본 이름
				bf.setBoardFilesize(file.getSize()); // 파일 사이즈
				bf.setBoardFiletype(file.getContentType()); // 파일 타입(MIME)
			
				// 확장자
				String ext = file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf("."));
				
				// 새로운 이름 + 확장자
				String newFilename = UUID.randomUUID().toString().replace("-", "") + ext; // - 를 공백으로 바꿈
				bf.setBoardSaveFilename(newFilename);
				
				// 테이블에 저장
				boardFileMapper.insertBoardFile(bf);
				
				// 파일 저장 (저장 위치: path)
				File f = new File(path + bf.getBoardSaveFilename()); // path 위치에 저장 파일 이름으로 빈 파일을 생성
				
				// 빈 파일에 첨부된 파일의 스트림을 주입
				try {
					file.transferTo(f);
				} catch (IllegalStateException | IOException e) {
					e.printStackTrace();
					// 트랜잭션 작동을 위해 예외(try-catch를 강요하지 않는 예외 -> ex: RuntimeException) 발생 필요
					throw new RuntimeException();
				}
				log.debug(CYAN + file.getOriginalFilename() + " <-- CommunityService-originFilename" + RESET);
				log.debug(CYAN + file.getSize() + " <-- CommunityService-filesize" + RESET);
				log.debug(CYAN + file.getContentType() + " <-- CommunityService-contentType" + RESET);
			}		
		}
	
		return row;
	}
	
	// 게시글 삭제 시 첨부파일 함께 삭제
	public int removeComm(int boardNo, String path) {
		int boardFileCnt = boardFileMapper.selectBoardFileCnt(boardNo);
		log.debug(CYAN + boardFileCnt + " <-- boardFileCnt(CommunityService-removeComm)" + RESET);
		int row = boardFileMapper.removeBoardFile(boardNo);
		log.debug(CYAN + row + " <-- row(CommunityService-removeComm)" + RESET);
		if (boardFileCnt == row) {
			row = communityMapper.removeComm(boardNo);
			
			// 첨부파일 삭제
			BoardFile file = boardFileMapper.selectBoardFile(boardNo);
			log.debug(CYAN + file + " <-- file(CommunityService-removeComm)" + RESET);
			
			if (file != null) { // 파일이 존재할 때만 삭제
				File f = new File(path + file.getBoardSaveFilename());
				if (f.exists()) {
					f.delete();
					log.debug(CYAN + "로컬 파일 삭제(BoardService-removeComm)" + RESET);
				}
			
			}
		}
		
		return row;
	}
	
	// 게시글 수정 (첨부파일 변경 이슈 확인하기)
	public int modifyComm(Board board, String path) {
		int row = communityMapper.modifyComm(board);
		log.debug(CYAN + row + " <-- row(CommunityService-modifyComm)" + RESET);
		if (row == 1) { // 게시글이 수정되었을 경우
			int boardNo = board.getBoardNo();
			log.debug(CYAN + boardNo + " <-- boardNo(CommunityService-modifyComm)" + RESET);
			MultipartFile file = board.getMultipartFile();
			// 첨부파일이 존재할 경우
			if (file != null) {
				
			}
			
		}
		
		return row;
		
	}
}

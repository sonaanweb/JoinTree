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
	
	// 게시판 목록 조회 (검색, 페이징 추가)
	public Map<String, Object> getCommList(String category, int currentPage, int rowPerPage, String searchOption, String searchText) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		int beginRow = (currentPage - 1) * rowPerPage;
		
	
		Map<String, Object> map = new HashMap<>();
		map.put("beginRow", beginRow);
		map.put("rowPerPage", rowPerPage);
		map.put("currentPage", currentPage);
		map.put("category", category);
		
		// 검색 조건이 주어진 경우에만 검색 파라미터를 설정
		if (searchOption != null && searchText != null && !searchText.isEmpty()) {
			map.put("searchOption", searchOption);
			map.put("searchText", searchText);
			
			// 검색 결과 게시글 목록
			List<Board> searchCommList = communityMapper.selectCommListByPageWithSearch(map);
			
			// 검색 조건에 따른 게시글 행 수 출력
			int searchCommCnt = communityMapper.selectCommCntWithSearch(map);
			log.debug(CYAN + searchCommCnt + " <-- searchCommCnt(CommunityService-getCommList)" + RESET);
			
			int lastPage = searchCommCnt / rowPerPage;
			if (searchCommCnt % rowPerPage != 0) {
				lastPage += 1;
			}
			
			// resultMap에 검색 결과를 추가
			resultMap.put("commList", searchCommList);
			
			resultMap.put("lastPage", lastPage);
		} else {
			// 검색 조건이 없는 경우 전체 글 가져오기
		    List<Board> commList = communityMapper.selectCommListByPageWithSearch(map);
		    // log.debug(CYAN + commList + " <-- commList(CommunityService-getCommList)" + RESET);
		    // resultMap에 전체 글 목록을 추가
		    map.put("commList", commList);
		    
		    // 카테고리별 행 수 
			int commCnt = communityMapper.selectCommCnt(category);
			log.debug(CYAN + commCnt + " <-- commCnt(CommunityService-getCommList)" + RESET);
		
			int lastPage = commCnt / rowPerPage;
			if (commCnt % rowPerPage != 0) {
				lastPage += 1;
			}
			
			resultMap.put("commList", commList);
			
			resultMap.put("lastPage", lastPage);
		}
		
		
		log.debug(CYAN + map + " <-- map(CommunityService-getCommList)" + RESET);
		
		// 상단고정 글 가져오기 // 최대 5개?
		List<Board> pinnedCommList = communityMapper.selectPinnedCommList(category);
		log.debug(CYAN + pinnedCommList + " <-- pinnedCmmList(CommunityService-getCommList)" + RESET);
		
		resultMap.put("pinnedCommList", pinnedCommList);
	
		
		log.debug(CYAN + "category: " + category + RESET);
		log.debug(CYAN + "resultMap: " + resultMap + RESET);
		log.debug(CYAN + "pinnedCommList: " + resultMap.get("pinnedCommList") + RESET);
		log.debug(CYAN + "commList: " + resultMap.get("commList") + RESET);
		log.debug( CYAN + "lastPage: " + resultMap.get("lastPage") + RESET);

		return resultMap;
		
		/*
		 * 
		 * 
		 * 
		 */
		
		/*
		 // 게시판 목록 조회 (검색, 페이징 추가)
public Map<String, Object> getCommList(String category, int currentPage, int rowPerPage, String searchOption, String searchText) {
   Map<String, Object> resultMap = new HashMap<>();
   
   int beginRow = (currentPage - 1) * rowPerPage;
   resultMap.put("beginRow", beginRow);
   resultMap.put("rowPerPage", rowPerPage);
   resultMap.put("currentPage", currentPage);
   resultMap.put("category", category);
   
   List<Board> commList;
   int commCnt;
   
   if (searchOption != null && searchText != null && !searchText.isEmpty()) {
       resultMap.put("searchOption", searchOption);
       resultMap.put("searchText", searchText);
       
       // 검색 결과 게시글 목록
       commList = communityMapper.selectCommListByPageWithSearch(resultMap);
       int searchCommCnt = communityMapper.selectCommCntWithSearch(resultMap);
       int lastPage = searchCommCnt / rowPerPage + (searchCommCnt % rowPerPage != 0 ? 1 : 0);
       resultMap.put("commList", commList);
       resultMap.put("lastPage", lastPage);
   } else {
       // 검색 조건이 없는 경우 전체 글 가져오기
       commList = communityMapper.selectCommListByPageWithSearch(resultMap);
       commCnt = communityMapper.selectCommCnt(category);
       int lastPage = commCnt / rowPerPage + (commCnt % rowPerPage != 0 ? 1 : 0);
       resultMap.put("commList", commList);
       resultMap.put("lastPage", lastPage);
   }
   
   // 상단고정 글 가져오기 // 최대 5개?
   List<Board> pinnedCommList = communityMapper.selectPinnedCommList(category);
   resultMap.put("pinnedCommList", pinnedCommList);
   
   log.debug(CYAN + resultMap + " <-- resultMap(CommunityService-getCommList)" + RESET);
   return resultMap;
}
		 
		 
		 
		 */
	}

	// 조회수 증가 처리
	public int increaseCommCount(int boardNo) {
		int row = communityMapper.increaseCommCount(boardNo);
		log.debug(CYAN + row + " <-- row(CommunityService-increaseCommCount)" + RESET);
		
		return row;
	}
	
	// 게시글 상세보기
	public Map<String, Object> getCommOne(int boardNo) {
		Map<String, Object> map = new HashMap<>();
		map.put("comm", communityMapper.selectCommOne(boardNo));
		map.put("boardFile", boardFileMapper.selectBoardFile(boardNo));
		log.debug(CYAN + map + " <-- map(CommunityService-getCommOne) "+ RESET);
		
		return map;
	}
	
	// 이전 글 조회
	public Board getPreBoard(String category, int boardNo) {
		Map<String, Object> params = new HashMap<>();
		params.put("category", category);
		params.put("boardNo", boardNo);
		
		Board preBoard = new Board();
		preBoard = communityMapper.selectPreBoard(params);
		
		return preBoard;
	}
	
	// 다음 글 조회
	public Board getNextBoard(String category, int boardNo) {
		Map<String, Object> params = new HashMap<>();
		params.put("category", category);
		params.put("boardNo", boardNo);
		
		Board nextBoard = new Board();
		nextBoard = communityMapper.selectNextBoard(params);
		
		return nextBoard;
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
				bf.setCreateId(board.getEmpNo());
				bf.setUpdateId(board.getEmpNo());
				
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
	
	// 게시글 삭제 시 첨부파일 함께 삭제 (실제 첨부파일 -> DB 내 파일 정보 -> 게시글 삭제 순)
	public int removeComm(int boardNo, String path) {
		int boardFileCnt = boardFileMapper.selectBoardFileCnt(boardNo);
		log.debug(CYAN + boardFileCnt + " <-- boardFileCnt(CommunityService-removeComm)" + RESET);
		
		if (boardFileCnt == 1) {
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
		
		int row = boardFileMapper.removeBoardFile(boardNo); 
		log.debug(CYAN + row + " <-- 첨부파일 DB 삭제 row(CommunityService-removeComm)" + RESET);
		/*
		if (row == 1) {
			row = communityMapper.removeComm(boardNo);
			log.debug(CYAN + row + " <-- 게시글 삭제 row(CommunityService-removeComm)" + RESET);
		}
		*/
		
		row = communityMapper.removeComm(boardNo);
		log.debug(CYAN + row + " <-- 게시글 삭제 row(CommunityService-removeComm)" + RESET);
		
		return row; // 게시글 삭제 row
	}
	
	// 게시글 삭제 시 카테고리 조회 
	public String getBoardCategory(int boardNo) {
		String category = communityMapper.selectBoardCategory(boardNo); 
				
		return category;
	}
	
	// 게시글 수정 (첨부파일 삭제, 추가는 비동기로 처리)
	public int modifyComm(Board board) {		
		int row = communityMapper.modifyComm(board);
		log.debug(CYAN + row + " <-- row(CommunityService-modifyComm)" + RESET);


		return row;
	}
	
	// 게시글 수정 시 이미지 추가
	public int uploadImg(int empNo, int boardNo, MultipartFile newImg, String path) {
		String originFilename = newImg.getOriginalFilename();
		String ext = originFilename.substring(originFilename.lastIndexOf("."));
		String newFilename = UUID.randomUUID().toString().replace("-", "") + ext;
		String realPath = path + newFilename;
		
		BoardFile boardFile = new BoardFile();
		boardFile.setBoardNo(boardNo);
		boardFile.setBoardOriginFilename(originFilename);
		boardFile.setBoardSaveFilename(newFilename);
		boardFile.setBoardFilesize(newImg.getSize());
		boardFile.setBoardFiletype(newImg.getContentType());
		boardFile.setCreateId(empNo);
		boardFile.setUpdateId(empNo);
		
		// DB에 새 이미지 정보 저장
		int row = boardFileMapper.insertBoardFile(boardFile);
		
		log.debug(CYAN + row + " <-- row(CommunityService-uploadImg)" + RESET);
		
		if (row == 1) {
			// 새 이미지 파일 로컬에 저장
			try {
				newImg.transferTo(new File(realPath));
				row++; // 이미지 등록 성공 시 반환값 증가
			} catch (IllegalStateException | IOException e) {
				e.printStackTrace();
				// 트랜잭션 작동을 위해 예외(try-catch를 강요하지 않는 예외 -> ex: RuntimeException) 발생 필요
				throw new RuntimeException();
			}
		}
		
		return row; // 컨트롤러에서 최종 2 출력 시 DB, 로컬에 이미지 저장 완료
	}
	
	// 게시글 수정 시 이미지 삭제
	public int removeImg(int boardNo, String path) {
		BoardFile boardFile = boardFileMapper.selectBoardFile(boardNo);
		log.debug(CYAN + boardFile + " <-- boardFile(CommunityService-removeImg)" + RESET);
		
		if (boardFile != null) { // boardNo에 해당하는 이미지가 있으면 삭제
			String saveFilename = boardFile.getBoardSaveFilename();
			String realPath = path + saveFilename;
			File f = new File(realPath);
			
			if (f.exists()) {
				f.delete();
				log.debug(CYAN + "이미지 파일 삭제 완료(CommunityService-removeImg)" + RESET);
			}
		}
		
		// DB에서 이미지 정보 삭제
		int row = boardFileMapper.removeBoardFile(boardNo);
		
		log.debug(CYAN + row + " <-- row(CommunityService-removeImg)" + RESET);
		
		return row;
	}
}

package com.goodee.JoinTree.service;

import java.io.File;
import java.io.IOException;
import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.goodee.JoinTree.mapper.BoardFileMapper;
import com.goodee.JoinTree.mapper.BoardMapper;
import com.goodee.JoinTree.vo.Board;
import com.goodee.JoinTree.vo.BoardFile;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class BoardService {
	
	@Autowired
	private BoardMapper boardMapper;
	@Autowired BoardFileMapper boardFileMapper;
	
	// 게시판 글 등록
	public int addBoard(Board board, String path) {
		
		// board_pinned 값의 따른 분기
		String boardPinned = board.getBoardPinned();
		
		if(boardPinned == null) {
			boardPinned = "0";
		}  else {
			boardPinned = "1";
		}
		log.debug(boardPinned+"<-- boardPinned");
		board.setBoardPinned(boardPinned);
		
		int addBoardRow = boardMapper.addBoard(board);
		
		// 게시글 입력 성공 후 첨부파일 있을 경우 파일 저장
		MultipartFile file = board.getMultipartFile();
		
		if(addBoardRow == 1 && file != null && board.getMultipartFile().getSize() > 0) {
			
			int boardNo = board.getBoardNo();
			log.debug(boardNo + "<-- BoardService boardNo");
			
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
			log.debug(file.getOriginalFilename() + " <-- BoardService originFilename");
			log.debug(file.getSize() + " <-- BoardService filesize");
			log.debug(file.getContentType() + " <-- BoardService contentType");
			
		}
		
		return addBoardRow;
	}
	
	// 게시판 목록 조회
	public Map<String, Object> getBoardList(Map<String, Object> boardListMap) {
		
		// 반환값1(검색 조건 별 행의 수)
		int boardListCnt = boardMapper.boardListCnt(boardListMap);
		log.debug(boardListCnt + "<-- BoardService boardListCnt");
		
		// 페이징
		int currentPage = Integer.parseInt((String) boardListMap.get("currentPage")); // 현재 페이지
		int rowPerPage = Integer.parseInt((String) boardListMap.get("rowPerPage")); // 페이지당 행의 수
		
		// 시작 행번호
		int beginRow = (currentPage-1)*rowPerPage;
		
		// 마지막 페이지
		int lastPage = boardListCnt / rowPerPage;
		if(boardListCnt % rowPerPage !=0) {
			lastPage +=1;
		}
		
		// 페이지 블럭
		int currentblock = 0; // 현제 페이지 블럭(currentPage / pageLength)
		int pageLength = 10; // 현제 페이지 블럭의 들어갈 페이지 수
		if(currentPage % pageLength == 0) {
			currentblock = currentPage / pageLength;
		} else {
			currentblock = (currentPage / pageLength) +1;
		}
		
		int startPage = (currentblock -1) * pageLength +1; // 블럭의 시작페이지
		int endPage = startPage + pageLength -1; // 블럭의 마지막 페이지
		if(endPage > lastPage) {
			endPage = lastPage;
		}
		
		// boardListMap에 값 저장
		boardListMap.put("beginRow", beginRow);
		boardListMap.put("rowPerPage", rowPerPage);
		
		// 반환값2(검색 조건 별 게시판 글 목록)
		List<Map<String, Object>> getBoardList = boardMapper.getBoardList(boardListMap);
		log.debug(getBoardList+"BoardService getBoardList");
		
		// 반환값 Map에 저장
		Map<String,Object> getBoardListResult = new HashMap<>();
		getBoardListResult.put("getBoardList", getBoardList);
		getBoardListResult.put("startPage", startPage);
		getBoardListResult.put("endPage", endPage);
		getBoardListResult.put("lastPage", lastPage);
		getBoardListResult.put("pageLength", pageLength);
		getBoardListResult.put("currentPage", currentPage);
		
		return getBoardListResult;
	}
	
	// 게시판 상단고정 목록 조회
	public List<Map<String, Object>> getBoardPinnedList(String boardCategory) {
		
		List<Map<String,Object>> getBoardPinnedList = boardMapper.getBoardPinnedList(boardCategory);
		log.debug(getBoardPinnedList+"BoardService getBoardPinnedList");
		
		return getBoardPinnedList;
	}
	
	// 최신 공지 목록 조회
	public List<Map<String, Object>> getRecentNotice(){
		
		List<Map<String,Object>> getRecentNotice = boardMapper.getRecentNotice();
		log.debug(getRecentNotice+"BoardService getRecentNotice");
		
		return getRecentNotice;
	}
	
	// 게시글 상세 조회
	public Map<String, Object> getBoardOne(int boardNo) {
		
		Map<String, Object> getBoardOne = boardMapper.getBoardOne(boardNo);
		log.debug(getBoardOne+"BoardService getBoardOne");
		
		return getBoardOne;
	}
	
	// 게시글 첨부파일 삭제
	public int removeBoardFile(int boardNo, String path) {
		
		// 게시글 첨부파일 조회
		BoardFile boardFile = boardFileMapper.selectBoardFile(boardNo);
		
		int removeBoardFileRow = 0; // DB 첨부파일 삭제 후 반환 값 변수
		
		// boardNo에 해당하는 파일 삭제
		if (boardFile != null) { 
			String saveFilename = boardFile.getBoardSaveFilename();
			String realPath = path + saveFilename;
			File f = new File(realPath);
			
			if (f.exists()) {
				f.delete();
				log.debug("BoardService removeBoardFile 첨부파일 삭제");
			}
			
			// DB 첨부파일 삭제
			removeBoardFileRow = boardFileMapper.removeBoardFile(boardNo);
			log.debug(removeBoardFileRow+"BoardService removeBoardFileRow");
		}
		
		return removeBoardFileRow;
	}
	
	// 게시글 수정
	public int modifyBoard(Board board, String path) {
		
		// 게시글 번호 저장
		int boardNo = board.getBoardNo();
		
		// board_pinned 값의 따른 분기
		String boardPinned = board.getBoardPinned();
		
		if(boardPinned == null) {
			boardPinned = "0";
		}  else {
			boardPinned = "1";
		}
		log.debug(boardPinned+"<-- boardPinned");
		board.setBoardPinned(boardPinned);
		
		int modifyBoardRow = boardMapper.modifyBoard(board);
		
		// 게시글 수정 성공 후 첨부파일 있을 경우 파일 저장
		MultipartFile file = board.getMultipartFile();
		
		/* 게시글 수정 성공 후 기존 첨부파일 유무에 따른 분기 
		 * 1. 기존 첨부파일이 없는 경우 첨부파일 저장
		 * 2. 기존 첨부파일이 있는 경우 기존 첨부파일 삭제 후 새 첨부파일 저장
		 */	
		
		int removeBoardFileRow = 0; // DB 첨부파일 삭제 후 반환 값 변수
		
		if(modifyBoardRow == 1 && file != null && board.getMultipartFile().getSize() > 0) {
			
			// 게시글 기존 첨부파일 조회
			BoardFile boardFile = boardFileMapper.selectBoardFile(boardNo);
			
			// boardFile의 값이 있으면 boardNo에 해당하는 파일 삭제
			if (boardFile != null) { 
				String saveFilename = boardFile.getBoardSaveFilename();
				String realPath = path + saveFilename;
				File f = new File(realPath);
				
				if (f.exists()) {
					f.delete();
					log.debug("BoardService modifyBoard removeBoardFile 기존 첨부파일 삭제");
				}
				
				// DB 첨부파일 삭제
				removeBoardFileRow = boardFileMapper.removeBoardFile(boardNo);
				log.debug(removeBoardFileRow+"BoardService modifyBoard removeBoardFileRow");
				
			}
			
			// 첨부파일 저장
			BoardFile bf = new BoardFile();
			bf.setBoardNo(boardNo);
			bf.setBoardOriginFilename(file.getOriginalFilename()); // 파일 원본 이름
			bf.setBoardFilesize(file.getSize()); // 파일 사이즈
			bf.setBoardFiletype(file.getContentType()); // 파일 타입(MIME)
			bf.setCreateId(board.getCreateId());
			bf.setUpdateId(board.getUpdateId());
		
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
			log.debug(file.getOriginalFilename() + " <-- BoardService modifyBoard originFilename");
			log.debug(file.getSize() + " <-- BoardService modifyBoard filesize");
			log.debug(file.getContentType() + " <-- BoardService modifyBoard contentType");				
		}	
		
		return modifyBoardRow;
	}
	
	// 이전 글 번호 조회
	public Integer getPreBoard(int boardNo, String categoryCode) {
		
		// boardMapper에 전달할 값 Map에 저장
		Map<String, Object> preBoardMap = new HashMap<>();
		preBoardMap.put("boardNo", boardNo);
		preBoardMap.put("categoryCode", categoryCode);
		
		// 반환 값 Map에 저장
		Integer preBoardNo = boardMapper.getPreBoard(preBoardMap);
		log.debug(preBoardNo+"BoardService getPreBoard preBoardNo");
		return preBoardNo;
	}
	
	// 다음 글 번호 조회
	public Integer getNextBoard(int boardNo, String categoryCode) {
		
		// boardMapper에 전달할 값 Map에 저장
		Map<String, Object> nextBoardMap = new HashMap<>();
		nextBoardMap.put("boardNo", boardNo);
		nextBoardMap.put("categoryCode", categoryCode);
		
		// 반환 값 Map에 저장
		Integer nextBoardNo = boardMapper.getNextBoard(nextBoardMap);
		log.debug(nextBoardNo+"BoardService getNextBoard nextBoardNo");
		
		return nextBoardNo;
	}
	
	// 게시글 삭제(저장된 첨부파일 -> DB내 파일 정보 -> 게시글 삭제)
	public int removeBoard(int boardNo, String path) {
		
		// 게시글 첨부파일 유무 조회
		BoardFile boardFile = boardFileMapper.selectBoardFile(boardNo);
		log.debug(boardFile+"BoardService removeBoard boardFile");
		
		int removeBoardFileRow = 0; // DB 첨부파일 삭제 후 반환 값 변수
		
		// boardFile의 값이 있으면 boardNo에 해당하는 파일 삭제
		if (boardFile != null) { 
			String saveFilename = boardFile.getBoardSaveFilename();
			String realPath = path + saveFilename;
			File f = new File(realPath);
			
			if (f.exists()) {
				f.delete();
				log.debug("BoardService removeBoard removeBoardFile 첨부파일 삭제");
			}
			
			// DB 첨부파일 삭제
			removeBoardFileRow = boardFileMapper.removeBoardFile(boardNo);
			log.debug(removeBoardFileRow+"BoardService modifyBoard removeBoardFileRow");	
		}
		
		// DB 게시글 삭제
		int removeBoardRow = boardMapper.removeBoard(boardNo);
		log.debug(removeBoardRow+"BoardService modifyBoard removeBoardRow");
		
		return removeBoardRow;
	}

}

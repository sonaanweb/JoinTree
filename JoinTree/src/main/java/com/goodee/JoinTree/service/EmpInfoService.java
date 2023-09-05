package com.goodee.JoinTree.service;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.apache.tomcat.util.codec.binary.Base64;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.goodee.JoinTree.mapper.EmpInfoMapper;
import com.goodee.JoinTree.mapper.SignImgMapper;
import com.goodee.JoinTree.vo.AccountList;
import com.goodee.JoinTree.vo.EmpInfoImg;
import com.goodee.JoinTree.vo.SignImg;
import com.goodee.JoinTree.mapper.EmpInfoImgMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
public class EmpInfoService {
	static final String CYAN = "\u001B[46m";
	static final String RESET = "\u001B[0m";
	
	@Autowired
	private EmpInfoMapper empInfoMapper;
	
	@Autowired
	private EmpInfoImgMapper empInfoImgMapper;
	
	@Autowired
	private SignImgMapper signImgMapper;
	
	// 비밀번호 변경
	public int modifyPw(AccountList account) {
		int row = empInfoMapper.modifyPw(account);
		log.debug(CYAN + row + " <-- row(EmpInfoService-modifyPw)" + RESET);
		
		return row;
	}
	
	// 나의 정보 조회
	public Map<String, Object> getEmpOne(int empNo) {
		Map<String, Object> map = new HashMap<>();
		map = empInfoMapper.selectEmpOne(empNo);
		log.debug(CYAN + map + " <-- map(EmpInfoService-getEmpOne)" + RESET);
		
		return map;
	}
	
	// 비밀번호 일치 체크 (나의 정보 변경 전)
	public int selectCheckPw(int empNo, String empPw) {
		int row = empInfoMapper.selectCheckPw(empNo, empPw);
		log.debug(CYAN + row + " <-- row(EmpInfoService-selectCheckPw)" + RESET);
		
		return row;
	}
	
	// 나의 정보 수정
	public int modifyEmp(Map<String, Object> empInfo) {
		// 주소
		String zip = (String) empInfo.get("zip");
		String add1 = (String) empInfo.get("add1");
	    String add2 = (String) empInfo.get("add2");
	    String add3 = (String) empInfo.get("add3");
      
	    // 주소 합쳐서 저장
        String empAddress = String.join("/", zip, add1, add2, add3);
        log.debug(CYAN + empAddress + " <-- empAddress(EmpInfoService-modifyEmp)" + RESET);
      
        // 연락처
        String empPhone1 = (String)empInfo.get("empPhone1");
        String empPhone2 = (String)empInfo.get("empPhone2");
        String empPhone3 = (String)empInfo.get("empPhone3");
        
        // 연락처 합쳐서 저장
        String empPhone = String.join("-", empPhone1, empPhone2, empPhone3);
        log.debug(CYAN + empPhone+ " <-- empPhone(EmpInfoService)" + RESET);
      
        // 주민번호
        String empJuminNo1 = (String)empInfo.get("empJuminNo1");
        String empJuminNo2 = (String)empInfo.get("empJuminNo2");
        
        // 주민번호 합쳐서 저장
        String empJuminNo = String.join("-", empJuminNo1, empJuminNo2);
        log.debug(CYAN + empJuminNo + " <-- empJuminNo(EmpInfoService)" + RESET);
      
        // empInfo 값 저장(사번, 주소, 연락처, 주민번호)
        // empInfo.put("empNo", empNo);
        empInfo.put("empAddress", empAddress);
        empInfo.put("empPhone", empPhone);
	    empInfo.put("empJuminNo", empJuminNo);
	
		int row = empInfoMapper.modifyEmp(empInfo);
		log.debug(CYAN + row + " <-- row(EmpInfoService)" + RESET);

		return row;
	}
	
	// 나의 이미지 추가
	public String uploadEmpImg(int empNo, MultipartFile newImg, String path) {
		String originFilename = newImg.getOriginalFilename();
		String ext = originFilename.substring(originFilename.lastIndexOf("."));
		String newFilename = UUID.randomUUID().toString().replace("-", "") + ext;
		String realPath = path + newFilename;
		
		EmpInfoImg empInfoImg = new EmpInfoImg();
		empInfoImg.setEmpNo(empNo);
		empInfoImg.setEmpOriginImgName(originFilename);
		empInfoImg.setEmpFiletype(newImg.getContentType());
		empInfoImg.setEmpFilesize(newImg.getSize());
		empInfoImg.setEmpSaveImgName(newFilename);
		empInfoImg.setCreateId(empNo);
		empInfoImg.setUpdateId(empNo);
		
		// DB에 새 이미지 정보 저장
		int row = empInfoImgMapper.insertEmpImg(empInfoImg);
		
		log.debug(CYAN + row + " <-- row(EmpInfoService-uploadEmpImg)" + RESET);
		
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
		
		/// return row; // 컨트롤러에서 최종 2 출력 시 DB, 로컬에 이미지 저장 완료 
		return newFilename;
	}
	
	// 나의 서명(이미지) 추가
	public String uploadSignImg(int empNo, String newSignImg, String path) {
		String type = newSignImg.split(";")[0].split(":")[1]; // split: 구분자를 기준으로 문자열 배열 반환
		String data = newSignImg.split(",")[1];
		byte[] image = Base64.decodeBase64(data);
		int size = image.length;
		
		log.debug(CYAN + type + " <-- type(EmpInfoService-uploadSignImg)"  + RESET);
		log.debug(CYAN + size + " <-- size(EmpInfoService-uploadSignImg)"  + RESET);
		
		// 저장 시 사용할 파일명
		String saveFilename = UUID.randomUUID().toString().replace("-", "") + ".png"; // UUID에서 하이픈 제거
		log.debug(CYAN + saveFilename + " <-- saveFilename(EmpInfoService-uploadSignImg)"  + RESET);
		
		
		// DB에 정보 저장
		SignImg signImg = new SignImg();
		signImg.setEmpNo(empNo);
		signImg.setSignSaveImgname(saveFilename);
		signImg.setSignFiletype(type);
		signImg.setSignFilesize(size);
		signImg.setCreateId(empNo);
		signImg.setUpdateId(empNo);
		
		int row = signImgMapper.insertSignImg(signImg);
		log.debug(CYAN + row + " <-- row(EmpInfoService-uploadSignImg)"  + RESET);
		
		// 빈 파일 생성
		File f = new File(path + saveFilename);
		
		try {
			// 빈 파일에 이미지 파일 주입
			FileOutputStream fos = new FileOutputStream(f); // 파일에 바이트를 기록하는 클래스
			fos.write(image); // 디코딩된 데이터 파일에 저장
			fos.close();
			log.debug(CYAN + f.length() + " <-- f.length()(EmpInfoService-uploadSignImg)"  + RESET); 
		} catch (IllegalStateException | IOException e) {
			 e.printStackTrace();
            // 트랜잭션 작동을 위해 예외를 강요하지 않는 예외 발생 필요
            throw new RuntimeException();
		}
		
		// return row; // 1일 때 저장 성공
		return saveFilename;
	}
	
	// 나의 서명(이미지) 삭제
	public int removeSignImg(int empNo) {
		return 0;
	}
	
	
	
	/*
	// 나의 이미지 변경 
	public int modifyEmpImg(int empNo, MultipartFile newImgFile, String path) {
		int row = 0;
		
		// 기존 이미지 삭제
		row = removeEmpImg(empNo, path);
		log.debug(CYAN + row + " <-- 기존 이미지 삭제 row(EmpInfoService-modifyEmpImg)" + RESET);
		
		// 새 이미지 등록 로직
		if (newImgFile != null && !newImgFile.isEmpty()) {
			String originFilename = newImgFile.getOriginalFilename();
			String ext = originFilename.substring(originFilename.lastIndexOf("."));// 확장자 
			String newFilename = UUID.randomUUID().toString().replace("-", "") + ext;
			String realPath = path + newFilename;
			
			EmpInfoImg empInfoImg = new EmpInfoImg();
			empInfoImg.setEmpNo(empNo);
			empInfoImg.setEmpOriginImgName(originFilename);
			empInfoImg.setEmpSaveImgName(newFilename);
			empInfoImg.setEmpFiletype(newImgFile.getContentType());
			empInfoImg.setEmpFilesize(newImgFile.getSize());
			empInfoImg.setCreateId(empNo);
			empInfoImg.setUpdateId(empNo);
		
			// DB에 새 이미지 정보 저장
			int insertRow = empInfoImgMapper.insertEmpImg(empInfoImg);
			log.debug(CYAN + insertRow + " <-- insertRow(EmpInfoService-modifyEmpImg)" + RESET);
			
			if (insertRow == 1) {
				// 새 이미지 파일 로컬에 저장
				try {
					newImgFile.transferTo(new File(realPath));
	                row++; // 이미지 등록 성공 시 반환값 증가
				} catch (IllegalStateException | IOException e) {
	                e.printStackTrace();
	                throw new RuntimeException();
	            }
			}
		}
		
		return row; // 최종 반환값은 이미지 수정 성공 시 2
	}
	
	*/
	
	// 사원 이미지 삭제
	public int removeEmpImg(int empNo, String path) {
		EmpInfoImg empInfoImg = empInfoImgMapper.selectEmpImg(empNo);
		log.debug(CYAN + empInfoImg + " <-- empInfoImg(EmpInfoService-removeEmpImg)" + RESET);
		
		if (empInfoImg != null) { // empNo에 해당하는 이미지가 있으면 삭제 
			String saveFilename = empInfoImg.getEmpSaveImgName();
			String realPath = path + saveFilename;
			File f = new File(realPath);
			
			if (f.exists()) {
				f.delete();
				log.debug(CYAN + "이미지 파일 삭제 완료(EmpInfoService-removeEmpImg)" + RESET);
			}
		}
		
		// DB에서 이미지 정보 삭제
		int row = empInfoImgMapper.removeEmpImg(empNo);
		
		log.debug(CYAN + row + " <-- row(EmpInfoService-removeEmpImg)" + RESET);
		
		return row;
	}
}
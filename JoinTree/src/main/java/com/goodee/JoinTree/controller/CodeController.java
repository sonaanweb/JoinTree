package com.goodee.JoinTree.controller;

import java.util.List;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.goodee.JoinTree.service.CodeService;
import com.goodee.JoinTree.vo.CommonCode;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class CodeController {
	@Autowired // 의존성 주입
	private CodeService codeService;
	
	String yellow = "\u001B[33m";
	String reset = "\u001B[0m";
	
	// 상위 코드 목록을 전달하는 컨트롤러
	@GetMapping("code/codeList")
	public String upCodeInfo(Model model
						) {
		// 서비스 레이어에서 상위 코드 목록을 조회하여 CommonCode타입으로 가져오기
		List<CommonCode> upCodeList = codeService.selectUpCode();
		
		// 조회한 공통코드를 뷰에서 사용할 수 있도록 모델에 추가
		model.addAttribute("upCodeList", upCodeList);
		
		// 상위 코드 목록을 뷰로 전달
		return "code/codeList";
	}
	
	// 하위 코드 목록을 뷰로 전달하는 컨트롤러 
	@GetMapping("code/childCodeList")
	// 아래 내용을 비동기로 호출하면 json 형태로 보내야함 -> @ResponseBody사용
	@ResponseBody // 이 컨트롤러 메서드의 반환값을 HTTP 응답의 본문으로 사용
    public List<CommonCode> childCodeList(@RequestParam(name = "upCode") String upCode) {
	    
		// 서비스 레이어에서 하위 코드 목록을 조회하여 리스트로 받아옴
		List<CommonCode> childCodeList = codeService.selectChildCode(upCode);
		// log.debug(yellow + "childCodeList:" + childCodeList + reset); 
		
	    // @ResponseBody로 인해 호출 시 하위 코드 목록을 JSON 형태로 응답
        return childCodeList;
    }
	
	// 공통코드 상세내용 출력 
	@GetMapping("code/codeOne")
	@ResponseBody
	public List<CommonCode> codeOneList(@RequestParam(name = "code") String code) {
	    
		// 서비스 레이어에서 하위코드에 해당하는 상세 내용을 조회하여 리스트로 받아옴
		List<CommonCode> codeOneList = codeService.selectCodeOne(code);
		
		log.debug(yellow + "codeOneList:" + codeOneList + reset); 
		
	    // @ResponseBody로 인해 호출 시 하위 코드 목록을 JSON 형태로 응답
        return codeOneList;
    }
	
	// 공통코드 추가
	@PostMapping("code/addCommonCode")
	@ResponseBody
	public String addCommonCode(CommonCode commonCode, 
								@RequestParam(name = "upCode") String upCode, 
								@RequestParam(name = "code") String code,
								@RequestParam(name = "codeName") String codeName,
								@RequestParam(name = "createId") String createId,
								@RequestParam(name = "updateId") String updateId) {

		// log.debug(yellow + "upCode:" + upCode + reset); 
		// log.debug(yellow + "code:" + code + reset); 
		// log.debug(yellow + "codeName:" + codeName + reset); 
		int row = codeService.addCommonCode(commonCode);
		
		if(row != 1) {// 실패
			return "fail";
		}
		
		return "success";
	}
	
	// 공통코드 수정
	@PostMapping("code/modifyCommonCode")
	@ResponseBody
	public String modifyCommonCode(@RequestParam(name = "code") String code,
									@RequestParam(name = "status") String status, 
									@RequestParam(name = "updateId") int updateId) {
		
		CommonCode commonCode = new CommonCode();
		commonCode.setCode(code);
		commonCode.setStatus(status);
		commonCode.setUpdateId(updateId);
			// log.debug(yellow + "code:" + code + reset); 
			// log.debug(yellow + "status:" + status + reset); 
			// log.debug(yellow + "updateId:" + updateId + reset); 
		int row = codeService.modifyCommonCode(commonCode);
			// log.debug(yellow + "row:" + row + reset); 
		
		if(row != 1) { // 실패
			return "fail";
		}
		
		return "success";
	}
}

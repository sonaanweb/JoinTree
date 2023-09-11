<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<!-- header -->
<jsp:include page="/WEB-INF/view/inc/header.jsp"/>
<div class="container-fluid page-body-wrapper">
<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->

<h4>경영지원팀 회의실 관리</h4>
	
<div class="row">
	<div class="col-lg-12 grid-margin stretch-card">
		<div class="card">
			<div class="card-body">
				<div class="wrapper">
				    <label class="col-form-label">회의실명</label>
				    <input type="text" class="form-control margin10" style="width: 20%" id="searchRoomName" name="roomName" placeholder="회의실 이름을 입력해주세요">
				    <button id="searchButton" class="btn btn-success btn-sm margin10">검색</button>
				</div>
			</div>
		</div>
	</div>
</div>
	
<div class="row">
	<div class="col-lg-12 grid-margin stretch-card">
		<div class="card">
			<div class="card-body">
			<button type="button" class="btn btn-success btn-sm margin10 floatL" data-bs-toggle="modal" data-bs-target="#addModal" >추가</button>
				<table class="table">
				    <thead>
				        <tr>
				            <td>회의실 번호</td>
				            <td>카테고리</td>
				            <td>회의실이름</td>
				            <td>수용인원</td>
				            <td>사용여부</td>
				            <td rowspan="1">추가일</td>
				            <td></td>
				        </tr>
				    </thead>
				    <tbody id="meetRoomList">
				        <c:forEach var="m" items="${meetRoomList}">
				            <tr>
				                <td class="roomNo">${m.roomNo}</td>
				                <td class="equipCategory">${m.equipCategory}</td>
				                <td class="roomName">${m.roomName}</td>
				                <td class="roomCapacity">${m.roomCapacity}명</td>
				                <td class="roomStatus">
				                    <c:choose>
				                        <c:when test="${m.roomStatus == 1}">사용가능</c:when>
				                        <c:when test="${m.roomStatus == 0}">사용불가</c:when>
				                    </c:choose>
				                </td>
				                <td class="createdate">${m.createdate}</td>
				                <td>
				                    <button class="editButton btn btn-success btn-sm" data-room-no="${m.roomNo}">수정</button>
				                	<button class="deleteButton btn btn-secondary btn-sm" data-room-no="${m.roomNo}">삭제</button>
				                </td>
				            </tr>
				        </c:forEach>
				    </tbody>
				</table>
			</div>
		</div>
	</div>
</div>
	
			<!-- 추가 모달창 -->
			<div class="modal fade" id="addModal" tabindex="-1" aria-labelledby="addModalLabel" aria-hidden="true">
			    <div class="modal-dialog">
			        <div class="modal-content">
			            <div class="modal-header">
			                <h5 class="modal-title" id="addModalLabel">회의실 추가</h5>
			                
					            <button type="button" class="btn btn-close" data-bs-dismiss="modal" aria-label="Close">
								<span>×</span>
								</button>
			            </div>
			            <div class="modal-body">
			                <form id="addForm" method="post" enctype="multipart/form-data">
			                <input type="hidden" id="modalAddCate" name="equipCategory">
			                <input type="hidden" name="empNo">
			                    <div class="mb-3">
			                        <label for="modalAddRoomName" class="col-form-label">이름</label>
			                        <input type="text" class="form-control" name="roomName" id="modalAddRoomName" placeholder="회의실 이름을 입력하세요">
			                        <div class="check" id="rn_add_check"></div><!-- 회의실명 중복, 공백일 시 -->
			                    </div>
			                    <div class="mb-3">
			                        <label for="modalAddRoomCapacity" class="form-label">수용 인원</label>
			                        <input type="number" class="form-control" id="modalAddRoomCapacity" name="roomCapacity" min="1">
			                    </div>
			                    <div class="mb-3">
			                        <label for="modalAddRoomStatus" class="col-form-label">사용여부</label>
			                        <select name="roomStatus" id="modalAddRoomStatus">
			                            <option value="1">사용가능</option>
			                            <option value="0">사용불가</option>
			                        </select>
			                    </div>
		                    	<div class="mb-3">
                        			<label for="modalAddRoomImage" class="form-label">이미지 업로드<span class="check" id="rn_img_check"></span></label>
                        			<input type="file" class="form-control" id="modalAddRoomImage" name="multipartFile" accept="image/jpg, image/jpeg, image/png, image/gif, image/bmp">
                        			<br>
                        			<img id="modalAddImagePreview" src="" alt="미리보기" style=" max-width: 200px; max-height: 200px;">
                   			 	</div>
			                    <button type="button" class="btn btn-success floatR" id="modalBtn">추가</button>
			                </form>
			            </div>
			        </div>
			    </div>
			 </div>
			<!-- 수정 모달창 -->
			<div class="modal fade" id="updateModal" tabindex="-1" aria-labelledby="updateModalLabel" aria-hidden="true">
			    <div class="modal-dialog">
			        <div class="modal-content">
			            <div class="modal-header">
			                <h5 class="modal-title" id="updateModalLabel">회의실 수정</h5>
			                	 
			                	 <button type="button" class="btn btn-close" data-bs-dismiss="modal" aria-label="Close">
								 <span>×</span>
								 </button>
			            </div>
			            <div class="modal-body">
			                <form id="updateForm" enctype="multipart/form-data" method="post" >	                    
			                    <input type="hidden" id="modalRoomNo" name="roomNo">
			                    <input type="hidden" id="modalCate" name="equipCategory">
			                    <div class="mb-3">
			                        <label for="modalRoomName" class="form-label">회의실 이름</label>
			                        <input type="text" class="form-control" id="modalRoomName" name="roomName">
			                        <div class="check" id="rn_check"></div><!-- 회의실명 중복, 공백일 시 -->
			                    </div>
			                    <div class="mb-3">
			                        <label for="modalRoomCapacity" class="form-label">수용 인원</label>
			                        <input type="number" class="form-control" id="modalRoomCapacity" name="roomCapacity" min="1">
			                    </div>
			                    <div class="mb-3">
			                        <label for="modalRoomStatus" class="form-label">사용 여부</label>
			                        <select class="form-control" id="modalRoomStatus" name="roomStatus">
			                            <option value="1">사용가능</option>
			                            <option value="0">사용불가</option>
			                        </select>
			                    </div>		
                    			<!-- 저장된 이미지, 업데이트 프리뷰 출력 -->
		                    	<div class="mb-3">
			                        <label for="modalUpdateRoomImage" class="form-label">이미지 업로드<span class="check" id="img_check"></span></label>
			                        <input type="file" class="form-control" id="modalUpdateRoomImage" name="multipartFile" accept="image/jpg, image/jpeg, image/png, image/gif, image/bmp">
			                        <br>
			                        <img id="modalUpdateImagePreview" src="" alt="미리보기" style="max-width: 200px; max-height: 200px;">
                   		 		</div>
			                    <button type="submit" class="btn btn-success floatR" id="modalBtn">수정</button>               
			                </form>
			            </div>
			        </div>
			    </div>
			</div>
	<!-- 컨텐츠 끝 -->
		</div>
	</div><!-- 컨텐츠전체 끝 -->
<!-- footer -->
<jsp:include page="/WEB-INF/view/inc/footer.jsp"/>
	<div id="empNo" data-empno="${loginAccount.empNo}"></div>
	<script src="/JoinTree/resource/js/equipment/meetRoomList.js"></script>
</html>
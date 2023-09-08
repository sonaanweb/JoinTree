<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<!-- header -->
	<jsp:include page="/WEB-INF/view/inc/header.jsp"/> 
	
	<!-- jQuery 트리뷰 및 쿠키 라이브러리 -->
	<script src="/JoinTree/resource/lib/jquery.cookie.js" type="text/javascript"></script>
	<script src="/JoinTree/resource/lib/jquery.treeview.js" type="text/javascript"></script>
	
	<!-- 트리뷰 스타일 시트 -->
	<link rel="stylesheet" href="/JoinTree/resource/jquery.treeview.css">
	
	<!-- documentDraft js파일 -->
	<script src="/JoinTree/resource/js/document/documentDraft.js"></script>
	
	<div class="container-fluid page-body-wrapper">
		<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
			<div class="content-wrapper doc"> <!-- 컨텐츠부분 wrapper -->
				<div class="row">	
					<!-- 기안서 -->
					<div class="col-md-3 stretch-card">
						<div class="card">
							<div class="card-body doc-line">
								<div>
									<select id="slectDocument" name="document" class="form-control">
										<c:forEach var="d" items="${documentCodeList}">
											<option id="category" value="${d.code}">${d.codeName}</option>
										</c:forEach>
									</select>
								</div>
								<!-- 결재선 -->
								<div class="line margin-top40"></div>
								<div class="margin-top40">
									<div class="wrapper">
										<h4>결재선</h4>
										<button type="button" id="modalSingerBtn" class="btn btn-inverse-dark"><i class="mdi mdi mdi-sitemap"></i></button>	
									</div>
									<div class="doc_selete">
										<div id="docApproval" data-empno="${loginAccount.empNo}">
											기안 | ${empInfo.empName}
										</div>
										
										<div id="selectSigner">
											<!-- 여기에 데이터를 추가하는 부분 -->
										</div>
										
									</div>
									<button type="button" id="deleteSignerBtn" class="btn btn-inverse-dark"><i class="mdi mdi-close"></i></button>
									<button type="button" id="moveUpBtn" class="btn btn-inverse-dark"><i class="mdi mdi-arrow-up"></i></button>
									<button type="button" id="moveDownBtn" class="btn btn-inverse-dark"><i class="mdi mdi-arrow-down"></i></button>
									<button type="button" id="inputSignerBtn" class="btn btn-inverse-dark"><i class="mdi mdi-plus"></i></button>
								</div>
								<div class="line margin-top40"></div>
								<div class="margin-top40">
									<div class="wrapper">
										<h4>참조자</h4>
										<button type="button" id="modalReferBtn" class="btn btn-inverse-dark"><i class="mdi mdi mdi-sitemap"></i></button>	
									</div>
									<div id="selectReference" class="doc_selete">
										<!-- 여기에 데이터를 추가하는 부분 -->
									</div>
									<button type="button" id="inputReferBtn" class="btn btn-inverse-dark"><i class="mdi mdi-plus"></i></button>
								</div>
								<div class="line margin-top40"></div>
								<div class="margin-top40">
									<div class="wrapper">
										<h4>수신팀</h4>
										<button type="button" id="modalReceiverBtn" class="btn btn-inverse-dark"><i class="mdi mdi mdi-sitemap"></i></button>
									</div>
									<div id="selectReceiverTeam" class="doc_selete">
										<!-- 여기에 데이터를 추가하는 부분 -->
									</div>
									<button type="button" id="inputReceiverBtn" class="btn btn-inverse-dark"><i class="mdi mdi-plus"></i></button>
								</div>
							</div><!-- col-md-3 끝 -->
						</div>
					</div>
					
					<div class="col-md-9 stretch-card">
						<div class="card">
							<div class="card-body">
								<button type="button" id="docFormBtn" class="btn btn-dark btn-sm">결재상신</button>
								<div id="documentForm">
									<!-- 폼데이터 추가 -->
								</div>
							</div>
						</div>
					</div><!-- col-md-9 끝 -->
				</div><!-- row 끝 -->
			</div><!-- 컨텐츠 끝 -->
	</div><!-- 컨텐츠전체 끝 -->
	<!-- footer -->
	<jsp:include page="/WEB-INF/view/inc/footer.jsp"/>
	<!-- 결재선 모달 -->
	<div class="modal fade" id="signerModal" tabindex="-1">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">결재선</h5>
					<button type="button" class="btn btn-close" data-bs-dismiss="modal" aria-label="Close">
						<span>×</span>
					</button>	
				</div>
				
				<div class="modal-body">
					<ul id="signerCodeList"> <!-- 고유한 ID 부여 -->
						<c:forEach var="dept" items="${deptList}">
							<li>
								<span class="empTree folder code" data-dept="${dept.code}">${dept.codeName}</span>
								<ul>
									<!-- 여기에 데이터를 추가하는 부분 -->
								</ul>
							</li>
						</c:forEach>
					</ul>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 참조자 모달 -->
	<div class="modal fade" id="referModal" tabindex="-1">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">참조자</h5>
					<button type="button" class="btn btn-close" data-bs-dismiss="modal" aria-label="Close">
						<span>×</span>
					</button>	
				</div>
				
				<div class="modal-body">
					<ul id="referCodeList"> <!-- 고유한 ID 부여 -->
						<c:forEach var="dept" items="${deptList}">
						<li>
							<span class="empTree folder code" data-dept="${dept.code}">${dept.codeName}</span>
							<ul>
								<!-- 여기에 데이터를 추가하는 부분 -->
							</ul>
						</li>
					</c:forEach>
					</ul>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 수신팀 모달 -->
	<div class="modal fade" id="receiverModal" tabindex="-1">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">수신팀</h5>
					<button type="button" class="btn btn-close" data-bs-dismiss="modal" aria-label="Close">
						<span>×</span>
					</button>				
					</div>
					
				<div class="modal-body">
					<ul id="receiverCodeList"> <!-- 고유한 ID 부여 -->
						<c:forEach var="dept" items="${deptList}">
							<li>
								<span class="empTree folder code" data-dept="${dept.code}" data-deptname="${dept.codeName}">${dept.codeName}</span>
							</li>
						</c:forEach>
					</ul>
				</div>
			</div>
		</div>
	</div>
</html>

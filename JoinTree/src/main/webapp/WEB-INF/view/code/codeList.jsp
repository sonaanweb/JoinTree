<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<!-- header -->
	<jsp:include page="/WEB-INF/view/inc/header.jsp"/>
	<!-- codeList js파일 -->
	<script src="/JoinTree/resource/js/code/code.js"></script>
	
	<!-- 필수 요소-->
	<div class="container-fluid page-body-wrapper">
		<jsp:include page="/WEB-INF/view/inc/sideContent.jsp"/> <!-- 사이드바 -->
			<div class="content-wrapper"> <!-- 컨텐츠부분 wrapper -->
				<div class="card">
					<div class="card-body">	
						<!-- 컨텐츠 시작 -->
						<div class="row">
							<div class="col-md-6">
								<div class="code">
								<h1><i class="mdi mdi-checkbox-multiple-blank-circle-outline"></i>상위코드</h1>
									<button type="button" id="addUpCodeLink" class="btn btn-sm btn-success right"><i class="mdi mdi-plus"></i></button>
									<button type="button" id="saveUpCodeBtn" class="btn btn-sm btn-success right" style="display: none"><i class="mdi mdi-content-save"></i></button>
									<button type="button" id="saveUpCodeOneBtn" class="btn btn-sm btn-success right"><i class="mdi mdi-content-save"></i></button>
									<div class="codelist margin-top10">
										<table class="table table-bordered" id="upCodeT">
											<thead>
												<tr>
													<td>코드</td>
													<td>코드명</td>
													<td>사용여부</td>
												</tr>
											</thead>
											<tbody id="upCodeList">
												<!-- 상위 코드들이 여기에 동적으로 추가 됨 -->
											</tbody>
										</table>
									</div>
								</div>
								<div class="code code-one margin-top20">
									<h1><i class="mdi mdi-format-list-bulleted"></i>상위코드 상세</h1>
									<table id="upCodeOne" class="table table-bordered">
										<tbody>
											<tr>
												<th>상위코드</th>
												<td id="upCodeOneList1"></td>
												<th>코드</th>
												<td id="upCodeOneList2"></td>
											</tr>
											<tr>
												<th>코드명</th>
												<td id="upCodeOneList3"></td>
												<th>사용여부</th>
												<td id="upCodeOneList4"></td>
											</tr>
											<tr>
												<th>생성일</th>
												<td id="upCodeOneList5"></td>
												<th>생성자</th>
												<td id="upCodeOneList6"></td>
											</tr>
											<tr>
												<th>수정일</th>
												<td id="upCodeOneList7"></td>
												<th>수정자</th>
												<td id="upCodeOneList8" data-empno="${loginAccount.empNo}"></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
							<div class="col-md-6">
								<div class="code">
								<h1><i class="mdi mdi-checkbox-multiple-blank-circle-outline"></i>하위코드</h1>
									<button type="button" id="addCodeLink" class="btn btn-sm btn-success right"><i class="mdi mdi-plus"></i></button>
									<button type="button" id="saveCodeBtn" class="btn btn-sm btn-success right" style="display: none"><i class="mdi mdi-content-save"></i></button>
									<button type="button" id="saveCodeOneBtn" class="btn btn-sm btn-success right"><i class="mdi mdi-content-save"></i></button>
									<div class="codelist margin-top10">
										<table class="table table-bordered" id="childCodeT">
											<thead>
												<tr>
													<th>코드</th>
													<th>코드명</th>
													<th>사용여부</th>
												</tr>
											</thead>
											
											<tbody id="childCodeList">
												<!-- 하위 코드들이 여기에 동적으로 추가 됨 -->
											</tbody>
										</table>
									</div>
								</div>
								<div class="code code-one margin-top20" >
									<h1><i class="mdi mdi-format-list-bulleted "></i>하위코드 상세</h1>
									<table id="codeOne" class="table table-bordered">
										<tbody>
											<tr>
												<th>상위코드</th>
												<td id="chileCodeOneList1"></td>
												<th>코드</th>
												<td id="chileCodeOneList2"></td>
											</tr>
											<tr>
												<th>코드명</th>
												<td id="chileCodeOneList3"></td>
												<th>사용여부</th>
												<td id="chileCodeOneList4"></td>
											</tr>
											<tr>
												<th>생성일</th>
												<td id="chileCodeOneList5"></td>
												<th>생성자</th>
												<td id="chileCodeOneList7"></td>
											</tr>
											<tr>
												<th>수정일</th>
												<td id="chileCodeOneList6"></td>
												<th>수정자</th>
												<td id="chileCodeOneList8"></td>
											</tr>
										</tbody>
									</table>
								</div>
							</div><!-- col -->
						</div><!-- row -->
					</div>
				</div>
			</div><!-- 컨텐츠 끝 -->
		</div><!-- 컨텐츠전체 끝 -->
	<!-- footer -->
	<jsp:include page="/WEB-INF/view/inc/footer.jsp"/>
</html>
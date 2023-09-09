$(document).ready(function() {
	const urlParams = new URL(location.href).searchParams;
	const msg = urlParams.get("msg");
		if (msg != null) {
			Swal.fire({
				icon: 'success',
				title: msg,
				showConfirmButton: false,
				timer: 1000
			});
		}
	
	// 쿼리 매개변수 "msg"를 제거하고 URL을 업데이트 (새로고침 시 메시지 알림창 출력하지 않음)
    urlParams.delete("msg");
    const newUrl = `${location.pathname}?${urlParams.toString()}`;
    history.replaceState({}, document.title, newUrl);
	
	let currentPage = 1; // 초기 페이지 설정
    let category = "B0105"; // 초기 카테고리 설정
    
    // 페이지 로딩 시 초기 데이터 로드
    loadSecondhandCommList(currentPage, category, "", ""); // 초기 데이터 로드
    
    // 페이지 내비게이션 수정 함수
    function updatePagination(currentPage, startPage, endPage, lastPage) {
    	let pagination = $("#pagination");
    	pagination.empty();
    	
    	// 이전 페이지 버튼
    	if (startPage > 1) {
    		let prevButton = $('<button type="button" class="page-link">').text('이전');
            prevButton.click(function() {
                goToPage(startPage - 1);
            });
            pagination.append(prevButton);
    	}
    	
    	// 페이지 버튼 생성
    	for (let i = startPage; i <= endPage; i++){
			const page = i;
			let pageButton = $('<button type="button" class="page-link">').text(i);
	        
		  // 현재 페이지일 때 'selected-page' 클래스 추가
	        if (page === currentPage) {
	            // pageButton.addClass('selected-page');
	        	pageButton.addClass('selected-page');
				pageButton.prop('disabled', true); // 현재 페이지 버튼 비활성화
	        }
		  
	     	// 추가할 클래스를 여기에 추가
	        pageButton.addClass('page-link');
			
			pageButton.click(function(){
	        	goToPage(page);
	        });
			 
	        pagination.append(pageButton);
		}
    	
		// 다음 페이지 버튼
		if (endPage < lastPage){
			let nextButton = $('<button type="button" class="page-link">').text('다음');
            nextButton.click(function() {
                goToPage(endPage + 1);
            });
            pagination.append(nextButton);
		}
    }

    function loadSecondhandCommList(currentPage, category, searchOption, searchText) {
        $.ajax({
            type: "GET",
            url: "/JoinTree/community/secondhandCommListData",
            data: {
                currentPage: currentPage,
                category: category,
                searchOption: searchOption,
                searchText: searchText
            },
            success: function(data) {
                // 성공 시 데이터를 이용해 페이지 업데이트
                updatePage(data);
                
            },
            error: function() {
                console.log('loadSecondhandCommListError');
                alert("서버 오류 발생. 관리자에게 문의해주세요.");
            }
        });
    }
  
    
	// updatePinnedComm 함수 추가
    function updatePinnedComm(pinnedCommList) {
        let thead = $("#pinnedList");
        thead.empty();
        
     	// 헤더 추가
        let headerRow = $("<tr>");
        headerRow.append("<th class='font-weight-bold text-center'>번호</th>");
        headerRow.append("<th class='font-weight-bold text-center'>제목</th>");
        headerRow.append("<th class='font-weight-bold text-center'>작성자</th>");
        headerRow.append("<th class='font-weight-bold text-center'>작성일</th>");
        headerRow.append("<th class='font-weight-bold text-center'>조회수</th>"); // 헤더를 추가하는 부분
        thead.append(headerRow);

        $.each(pinnedCommList, function(index, pinnedComm) {
            var row = $("<tr>");
            row.append("<td width='7%' class='text-center'>" + pinnedComm.boardNo + "</td>");
            var titleCell = $("<td width='55%'>");
            var titleLink = $("<a>").attr("href", "/JoinTree/community/secondhandCommList/secondhandCommOne?boardNo=" + pinnedComm.boardNo);
            if (pinnedComm.commentCnt > 0) {
                titleLink.append("<span class='text-danger font-weight-bold'>[공지]" + pinnedComm.boardTitle + " [" + pinnedComm.commentCnt + "]</span>");
            } else {
                titleLink.append("<span class='text-danger font-weight-bold'>[공지]" + pinnedComm.boardTitle + "</span>");
            }
            titleCell.append(titleLink);
            row.append(titleCell);
            row.append("<td>" + pinnedComm.empName + "</td>");
            row.append("<td class='text-center'>" + pinnedComm.createdate.substring(0, 10) + "</td>");
            row.append("<td width='7%' class='text-center'>" + pinnedComm.boardCount + "</td>");
            thead.append(row);
        });
    }
    
    function updatePage(data) {
        // 상단고정 게시글 업데이트
        updatePinnedComm(data.pinnedCommList);

        // 게시글 목록 업데이트
        let tbody = $("#commList");
        tbody.empty(); // 새로운 데이터를 가져오기 전 기존 데이터 삭제 
        $.each(data.commList, function(index, comm) {
            var row = $("<tr>");
            row.append("<td width='7%' class='text-center'>" + comm.boardNo + "</td>");
            var titleCell = $("<td width='55%'>");
            var titleLink = $("<a>").attr("href", "/JoinTree/community/secondhandCommList/secondhandCommOne?boardNo=" + comm.boardNo);
            if (comm.commentCnt > 0) {
                titleLink.append("<span>" + comm.boardTitle + " [" + comm.commentCnt + "]</span>");
            } else {
                titleLink.append("<span>" + comm.boardTitle + "</span>");
            }
            titleCell.append(titleLink);
            row.append(titleCell);
            row.append("<td>" + comm.empName + "</td>");
            row.append("<td class='text-center'>" + comm.createdate.substring(0, 10) + "</td>");
            row.append("<td width='7%' class='text-center'>" + comm.boardCount + "</td>");
            tbody.append(row);
        });
        
    	// 페이지 내비게이션 업데이트
     	updatePagination(data.currentPage, data.startPage, data.endPage, data.lastPage);
    }
    

    // 검색 버튼 클릭 이벤트 처리
    $("#searchBtn").on("click", function() {
        let selectedOption = $("#searchOption").val();
        let searchText = $("#searchText").val();
        
        // 검색 시 currentPage 초기화
        currentPage = 1;
        
        loadSecondhandCommList(currentPage, category, selectedOption, searchText);
    });
    
    // 페이지 이동 함수
    function goToPage(page) {
    	// 검색 및 페이지 데이터 수정 함수
    	// searchCommListResults(currentPage);
    	// currentPage = page;
    	// loadFreeCommList(currentPage, category, "", ""); 
    	loadSecondhandCommList(page, category, $("#searchOption").val(), $("#searchText").val()); // 이전 검색 조건을 그대로 유지하며 데이터 로드
    }   
});
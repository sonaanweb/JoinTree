	$(document).ready(function(){
			
		// modifyBoard, removeBoard 실행 후 메세지
		const urlParams = new URL(location.href).searchParams;
		const msg = urlParams.get("msg");
		const removeBoardRow = urlParams.get("removeBoardRow");
		
		if (msg != null) {
			
			Swal.fire({ // 게시글 수정 성공 메세지
				icon: 'success',
				title: msg,
				showConfirmButton: false,
				timer: 1000
			});
			
			if(removeBoardRow == 0){ // 게시글 삭제 실패 메세지
				Swal.fire({
					icon: 'warning',
					title: msg,
					showConfirmButton: false,
					timer: 1000
				});
			}
			
			// 쿼리 매개변수 "msg"를 제거하고 URL을 업데이트
	        urlParams.delete("msg");
	        const newUrl = `${location.pathname}?${urlParams.toString()}`;
	        history.replaceState({}, document.title, newUrl);
		}
		
		// contentDiv의 게시글이 기본 높이 초과 시 div 높이 증가
		let contentDiv = $('#contentDiv'); // contentDiv 선택
        contentDiv.css('height', contentDiv[0].scrollHeight + 'px');
	});
	
	// 삭제 시 confirm 실행
	let removeBtn = $('#removeBtn');
	removeBtn.click(function (event) {
	    event.preventDefault(); // 기본 링크 동작 중단
				
	    Swal.fire({
	        title: '게시글을 삭제하시겠습니까?',
	        text: '삭제한 게시글은 복구할 수 없습니다.',
	        icon: 'warning',
	        showCancelButton: true,
	        confirmButtonColor: '#8BC541',
	        cancelButtonColor: '#888',
	        confirmButtonText: '삭제',
	        cancelButtonText: '취소',
	        preConfirm: () => {
	            
	        	// 확인 버튼을 클릭한 경우 링크로 이동
	            window.location.href = removeBtn.attr('href');
	        }
	    });
	});
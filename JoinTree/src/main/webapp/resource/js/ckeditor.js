ClassicEditor 

    .create( document.querySelector( '#boardContent' ) , {
        // 에디터 구성 옵션 설정
        toolbar: ['heading', 'bold', 'italic', 'link', 'bulletedList', 'numberedList', 'blockQuote', 'undo', 'redo'], // 필요한 툴바 옵션 추가
        placeholder: '내용을 입력해주세요', // 에디터 창에 보이는 미리보기 문구
        // ...
    })
     

    .then( editor => { 
      	// 에디터 창의 스타일 조절
        editor.ui.view.editable.element.style.minHeight = '300px'; // 최소 높이
        editor.ui.view.editable.element.style.height = '300px'; // 높이
        editor.ui.view.editable.element.style.overflow = 'auto'; // 스크롤 추가
		//editor.ui.view.editable.element.style.height = '300px'; // 에디터 창의 높이를 300px로 설정
        console.log( editor ); 

    } ) 

    .catch( error => { 

        console.error( error ); 

    } );
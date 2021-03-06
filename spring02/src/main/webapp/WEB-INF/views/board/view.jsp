<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
	<title>Insert title here</title>
<%@ include file="../include/header.jsp" %>
<script src="${path}/include/js/common.js"></script>
<script src="${path}/ckeditor/ckeditor.js"></script>
<script type="text/javascript">
$(function(){
	// 댓글 목록 출력
	listReply("1");
	// 댓글 쓰기
	$("#btnReply").click(function(){
		reply();
	});
	// 목록으로 이동
	$("#btnList").click(function(){
		location.href = "${path}/board/list.do";
	});
	// 드래그 기본효과 막음
	$(".fileDrop").on("dragenter dragover", function(e) {
		e.preventDefault();
	})
	$(".fileDrop").on("drop", function(e){
		e.preventDefault();
		// 드롭한 파일을 폼데이터에 추가함
		var files = e.originalEvent.dataTransfer.files;
		var file = files[0];
		var formData = new FormData();
		// 폼데이터에 추가
		formData.append("file", file);
		// processData: false - header가 아닌 body로 전송
		$.ajax({
			url: "${path}/upload/uploadAjax",
			data: formData,
			dataType: "text",
			processData: false,
			contentType: false,
			type: "post",
			success: function(data){ // 콜백함수
				var fileInfo = getFileInfo(data); // 첨부파일 정보
				var html = "<a href='" + fileInfo.getLink + "'>" + fileInfo.fileName + "</a><br>"; // 첨부파일 링크
				html += "<input type='hidden' class='file' value='" + fileInfo.fullName + "'>"; // hidden 태그 추가
				$("#uploadedList").append(html); // div에 추가
			}
		});
	});
	$("#btnUpdate").click(function(){
		var str = "";
		$("#uploadedList .file").each(function(i){
			str += "<input type='hidden' name='files[" + i + "]' value='" + $(this).val() + "'>";
		});
		// 폼에 hidden 태그들을 추가
		$("#form1").append(str);
		
		document.form1.action = "${path}/board/update.do";
		document.form1.submit();
	});
	
	listAttach();
	// 첨부파일 삭제
	$("#uploadedList").on("click", ".file_del", function(e){
		var that = $(this);
		$.ajax({
			type: "post",
			url: "${path}/upload/deleteFile",
			data: {fileName:$(this).attr("data-src")},
			dataType: "text",
			success: function(result){
				if(result == "deleted"){
					that.parent("div").remove();
				}
			}
		});
	});
	$("#btnDelete").click(function(){
		if(confirm("삭제하시겠습니까?")){
			document.form1.action = "${path}/board/delete.do";
			document.form1.submit();
		}
	});
});
function listAttach(){
	$.ajax({
		type: "post",
		url: "${path}/board/getAttach/${dto.bno}",
		success: function(list){
			$(list).each(function(){
				var fileInfo = getFileInfo(this);
				var html = "<div><a href = '" + fileInfo.getLink + "'>" + fileInfo.fileName + "<a href='#' class ='file_del' data-src='" + this + "'>[삭제]</a></div>";
				$("#uploadedList").append(html);
			});
		}
	});
}
function reply(){
	var replytext = $("#replytext").val();
	var bno = "${dto.bno}";
	var param = {"replytext" : replytext, "bno" : bno};
	$.ajax({
		type: "post",
		url: "${path}/reply/insert.do",
		data: param,
		success: function(){
			alert("댓글이 등록되었습니다.");
			listReply("1");
		}
	}); 
}
function listReply(num){
	$.ajax({
		type: "post",
		url: "${path}/reply/list.do?bno=${dto.bno}&curPage="+num,
		success: function(result){
			console.log(result);
			$("#listReply").html(result); 
		}
	});
}
</script>
<style type="text/css">
.fileDrop {
	width: 600px;
	height: 100px;
	border: 1px dotted gray;
	background-color: gray;
}
</style>
<%@ include file="../include/menu.jsp" %>
</head>
<body>
<h2>게시물 보기</h2>
<form id="form1" name="form1" method="post">
<div>작성일자 : <fmt:formatDate value="${dto.regdate}" pattern="yyyy-MM-dd a HH:mm:ss"/></div>
<div>조회수 : ${dto.viewcnt}</div>
<div>이름 : ${dto.name}</div>
<div>제목 : <input name="title" value="${dto.title}"></div>
<div style="width: 80%;">내용 : <textarea rows="3" cols="80" name="content" id="content">${dto.content}</textarea></div>
<script type="text/javascript">
CKEDITOR.replace("content", {
	filebrowserUploadUrl: "${path}/imageUpload.do",
	height: "500px"
});
</script>
<div class="fileDrop"></div>
<div id="uploadedList"></div>
<div>
	<input type="hidden" name="bno" value="${dto.bno}">
	<c:if test="${sessionScope.userid == dto.writer}">
		<button type="button" id="btnUpdate">수정</button>
		<button type="button" id="btnDelete">삭제</button>
	</c:if>
	<button type="button" id="btnList">목록</button>
</div>
</form>
<!-- 댓글 작성 -->
<div style="width: 700px; text-align: center;">
<c:if test="${sessionScope.userid != null}">
	<textarea rows="5" cols="80" id="replytext" placeholder="댓글을 작성하세요"></textarea>
	<br>
	<button type="button" id="btnReply">댓글쓰기</button>
</c:if>
</div>
<!-- 댓글 목록을 출력할 영역 -->
<div id="listReply"></div>

</body>
</html>
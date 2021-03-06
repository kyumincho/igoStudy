package com.example.spring02.upload;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

@Controller
public class ImageUploadController {

	private static final Logger logger = LoggerFactory.getLogger(ImageUploadController.class);
	
	@ResponseBody
	@RequestMapping("imageUpload.do")
	public void imageUpload(HttpServletRequest request, HttpServletResponse response, @RequestParam MultipartFile upload) throws Exception {
		// http header 설정
		response.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=utf-8");
		// http body
		// 업로드한 파일 이름
		String fileName = upload.getOriginalFilename();
		// 바이트 배열로 변환
		byte[] bytes = upload.getBytes();
		// 이미지를 업로드할 디렉토리(배포 경로로 설정)
		String uploadPath = request.getSession().getServletContext().getRealPath("/") + "WEB-INF\\views\\images\\";
		OutputStream out = new FileOutputStream(new File(uploadPath + fileName)); // java.io
		// 서버에 저장됨
		out.write(bytes);
		String callback = request.getParameter("CKEditorFuncNum");
		PrintWriter printwriter = response.getWriter();
		String fileUrl = request.getContextPath() + "/images/" + fileName;
		System.out.println("fileUrl:" + fileUrl);
		printwriter.println("<script type='text/javascript'>window.parent.CKEDITOR.tools.callFunction(" + callback + ",'"
                + fileUrl
                + "','이미지를 업로드 하였습니다.'"
                + ")</script>");
		// 스트림 닫기
		printwriter.flush();
        if (out != null) {
            out.close();
        }
        if (printwriter != null) {
            printwriter.close();
        }
	}
	
}

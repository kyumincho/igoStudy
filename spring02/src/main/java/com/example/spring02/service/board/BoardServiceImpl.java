package com.example.spring02.service.board;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.spring02.model.board.dao.BoardDAO;
import com.example.spring02.model.board.dto.BoardDTO;

@Service // service bean
public class BoardServiceImpl implements BoardService {
	
	@Inject // dao 의존관계 주입
	BoardDAO boardDao;

	@Override
	public void deleteFile(String fullName) {
		boardDao.deleteFile(fullName);
	}

	@Override
	public List<String> getAttach(int bno) {
		return boardDao.getAttach(bno);
	}

	@Override
	public void addAttach(String fullName) {
		boardDao.addAttach(fullName);
	}

	@Override
	public void updateAttach(String fullName, int bno) {
		// TODO Auto-generated method stub
	}

	@Transactional
	@Override
	public void create(BoardDTO dto) throws Exception {
		boardDao.create(dto);
		// 첨부파일 정보 저장
		String[] files = dto.getFiles();
		System.out.println(files+"testtest");
		if(files == null) return;
		for(String name : files) {
			boardDao.addAttach(name);
		}
	}

	@Override
	public BoardDTO read(int bno) throws Exception {
		return boardDao.read(bno);
	}
	
	@Transactional
	@Override
	public void update(BoardDTO dto) throws Exception {
		boardDao.update(dto);
		String[] files = dto.getFiles();
		System.out.println("첨부파일:" + files);
		if(files == null) return;
		for(String name : files) {
			boardDao.updateAttach(name, dto.getBno());
		}
	}

	@Override
	public void delete(int bno) throws Exception {
		boardDao.delete(bno);
	}

	@Override
	public List<BoardDTO> listAll(int start, int end, String search_option, String keyword) throws Exception {
		return boardDao.listAll(start, end, search_option, keyword);
	}

	@Override
	public void increateViewcnt(int bno) throws Exception {
		boardDao.increaseViewcnt(bno);
	}

	@Override
	public int countArticle(String search_option, String keyword) throws Exception {
		return boardDao.countArticle(search_option, keyword);
	}

}

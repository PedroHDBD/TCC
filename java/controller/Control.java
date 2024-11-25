package controller;

import com.google.gson.Gson;
import database.DBQuery;
import model.Comentario;
import model.Forum;
import model.Publicacao;
import model.Topico;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/api/control")
public class Control extends HttpServlet {

	private static final long serialVersionUID = 1L;

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		request.setCharacterEncoding("UTF-8");
		String acao = request.getParameter("acao");

		if(request.getSession().getAttribute("idUsuario") == null) {
			response.sendRedirect("../view/login.jsp");
		}
		
		if ("ListarForuns".equals(acao)) {
			ListarForuns(response);
		} else if ("ListarTopicos".equals(acao)) {
			ListarTopicos(request, response);
		} else if ("ListarPublicacoes".equals(acao)) {
			ListarPublicacoes(request, response);
		} else if ("AdicionarTopico".equals(acao)) {
			AdicionarTopico(request, response);
		} else if ("ResgatarTitulo".equals(acao)) {
			ResgatarTitulo(request, response);
		} else if ("AdicionarPublicacao".equals(acao)) {
			AdicionarPublicacao(request, response);
		} else if ("AdicionarComentario".equals(acao)) {
			AdicionarComentario(request, response);
		} else if ("ListarComentarios".equals(acao)) {
			ListarComentarios(request, response);
		} else if ("ExcluirTopico".equals(acao)) {
			ExcluirTopico(request, response);
		} else if ("ExcluirPublicacao".equals(acao)) {
			ExcluirPublicacao(request, response);
		} else if ("EditarTopico".equals(acao)) {
			EditarTopico(request, response);
		} else if ("EditarPublicacao".equals(acao)) {
			EditarPublicacao(request, response);
		} else if ("ExcluirComentario".equals(acao)) {
			ExcluirComentario(request, response);
		}
	}
	
	private void ListarForuns(HttpServletResponse response) throws IOException {
		List<Forum> forums = new ArrayList<>();
		DBQuery dbQuery = new DBQuery("Forum", "idForum, nome", "idForum");
		ResultSet resultSet = dbQuery.select("");

		try {
			while (resultSet.next()) {
				Forum forum = new Forum();
				forum.setIdForum(resultSet.getInt("idForum"));
				forum.setNome(resultSet.getString("nome"));
				forums.add(forum);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		String json = new Gson().toJson(forums);
		response.getWriter().write(json);
	}

	private void ListarTopicos(HttpServletRequest request, HttpServletResponse response) throws IOException {
		List<Topico> topicos = new ArrayList<>();
		String idForum = request.getParameter("idForum");
		DBQuery dbQuery = new DBQuery("Topico", "idTopico, titulo, data, idForum, idUsuario", "idTopico");
		ResultSet resultSet = dbQuery.select("idForum = " + idForum);
		
		
		try {
			while (resultSet.next()) {
				Topico topico = new Topico();
				topico.setIdForum(resultSet.getInt("idForum"));
				topico.setIdTopico(resultSet.getInt("idTopico"));
				topico.setTitulo(resultSet.getString("titulo"));
				topico.setData(resultSet.getTimestamp("data"));
				topico.setIdUsuario(resultSet.getInt("idUsuario"));
				System.out.println("\n\n\n" + topico.getTitulo());

				topicos.add(topico);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		String json = new Gson().toJson(topicos);
		response.getWriter().write(json);
	}

	private void ListarPublicacoes(HttpServletRequest request, HttpServletResponse response) throws IOException {
		List<Publicacao> publicacoes = new ArrayList<>();
		String idTopico = request.getParameter("idTopico");

		DBQuery dbQuery = new DBQuery("Publicacao",
				"data, idPublicacao, idTopico, idUsuario, numComentarios, numReacoes, numSalvamentos, texto",
				"idPublicacao");
		ResultSet resultSet = dbQuery.select("idTopico = " + idTopico);

		try {
			while (resultSet.next()) {
				Publicacao publicacao = new Publicacao();
				publicacao.setData(resultSet.getTimestamp("data"));
				publicacao.setIdPublicacao(resultSet.getInt("idPublicacao"));
				publicacao.setIdTopico(resultSet.getInt("idTopico"));
				publicacao.setIdUsuario(resultSet.getInt("idUsuario"));
				publicacao.setNumComentarios(resultSet.getInt("numComentarios"));
				publicacao.setNumLikes(resultSet.getInt("numReacoes"));
				publicacao.setNumSalvamentos(resultSet.getInt("numSalvamentos"));
				publicacao.setTexto(resultSet.getString("texto"));

				publicacoes.add(publicacao);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		String json = new Gson().toJson(publicacoes);
		response.getWriter().write(json);
	}

	private void ResgatarTitulo(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String idTopico = request.getParameter("idTopico");
		DBQuery dbQuery = new DBQuery("Topico", "titulo, idUsuario, data", "idTopico");
		ResultSet resultSet = dbQuery.select("idTopico = " + idTopico);
		Topico topico = new Topico();

		try {
			while (resultSet.next()) {
				topico.setTitulo(resultSet.getString("titulo"));
				topico.setData(resultSet.getTimestamp("data"));
				topico.setIdUsuario(resultSet.getInt("idUsuario"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		String json = new Gson().toJson(topico);
		response.getWriter().write(json);
	}

	private void AdicionarTopico(HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException {
		String idForum = request.getParameter("idForum");
		int idUsuario = (int) request.getSession().getAttribute("idUsuario");
		String titulo = request.getParameter("titulo");
		String texto = request.getParameter("texto");
		String nome = request.getParameter("nome");

		DBQuery dbQuery = new DBQuery("Topico", "titulo, idForum, idUsuario", "idTopico");
		String[] topico = { titulo, idForum, String.valueOf(idUsuario) };
		int idNovoTopico = dbQuery.insert(topico);

		dbQuery = new DBQuery("Publicacao", "idTopico, texto, idUsuario", "idPublicacao");
		String[] publicacao = { String.valueOf(idNovoTopico), texto, String.valueOf(idUsuario) };
		dbQuery.insert(publicacao);

		String idTopico = Integer.toString(idNovoTopico);
		request.getSession().setAttribute("idTopico", idTopico);
		request.getSession().setAttribute("idForum", idForum);
		request.getSession().setAttribute("nome", nome);

		response.sendRedirect("../view/publicacoes.jsp");
	}

	private void AdicionarPublicacao(HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException {
		String idForum = request.getParameter("idForum");
		String idTopico = request.getParameter("idTopico");
		String nome = request.getParameter("nome");

		int idUsuario = (int) request.getSession().getAttribute("idUsuario");
		String texto = request.getParameter("texto");

		DBQuery dbQuery = new DBQuery("Publicacao", "texto, idTopico, idUsuario", "idPublicacao");
		String[] publicacao = { texto, idTopico, String.valueOf(idUsuario) };
		dbQuery.insert(publicacao);

		request.getSession().setAttribute("idTopico", idTopico);
		request.getSession().setAttribute("idForum", idForum);
		request.getSession().setAttribute("nome", nome);

		response.sendRedirect("../view/publicacoes.jsp");
	}

	private void AdicionarComentario(HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException {
		String idForum = request.getParameter("idForum");
		String idTopico = request.getParameter("idTopico");
		String idPublicacao = request.getParameter("idPublicacao");
		int idUsuario = (int) request.getSession().getAttribute("idUsuario");
		String texto = request.getParameter("texto");

		DBQuery dbQuery = new DBQuery("Comentario", "idPublicacao, texto, idUsuario", "idComentario");
		String[] comentario = { String.valueOf(idPublicacao), texto, String.valueOf(idUsuario) };
		dbQuery.insert(comentario);

		dbQuery.incrementPublicacao(idPublicacao, "numComentarios");
		request.getSession().setAttribute("idTopico", idTopico);
		request.getSession().setAttribute("idForum", idForum);

		response.sendRedirect("../view/publicacoes.jsp");
	}
	
	private void ListarComentarios(HttpServletRequest request, HttpServletResponse response) throws IOException {
	    List<Comentario> comentarios = new ArrayList<>();
	    String idPublicacao = request.getParameter("idPublicacao");
	    DBQuery dbQuery = new DBQuery("Comentario", "idComentario, idPublicacao, idUsuario, texto, data, numCurtidas", "idComentario");
	    ResultSet resultSet = dbQuery.select("idPublicacao = " + idPublicacao);

	    try {
	        while (resultSet.next()) {
	            Comentario comentario = new Comentario();
	            comentario.setIdPublicacao(resultSet.getInt("idPublicacao"));
	            comentario.setIdComentario(resultSet.getInt("idComentario"));
	            comentario.setTexto(resultSet.getString("texto"));	           	           
	            comentario.setData(resultSet.getTimestamp("data"));
	            comentario.setIdUsuario(resultSet.getInt("idUsuario"));
	            comentario.setNumCurtidas(resultSet.getInt("numCurtidas"));
	            
	            comentarios.add(comentario);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    String json = new Gson().toJson(comentarios);
	    response.getWriter().write(json);
	}
	
	private void ExcluirTopico(HttpServletRequest request, HttpServletResponse response)throws IOException, ServletException {
		String idForum = request.getParameter("idForum");
		String idTopico = request.getParameter("idTopico");
		String nome = request.getParameter("nome");

		DBQuery dbQuery = new DBQuery("Topico", "idTopico", "idTopico");
		String[] topico = { idTopico };
		dbQuery.delete(topico);

		request.getSession().setAttribute("idTopico", idTopico);
		request.getSession().setAttribute("idForum", idForum);
		request.getSession().setAttribute("nome", nome);


		response.sendRedirect("../view/topicos.jsp");
	}
	
	private void ExcluirPublicacao(HttpServletRequest request, HttpServletResponse response)throws IOException, ServletException {
		String idForum = request.getParameter("idForum");
		String idTopico = request.getParameter("idTopico");
		String nome = request.getParameter("nome");
		String idPublicacao = request.getParameter("idPublicacao");

		DBQuery dbQuery = new DBQuery("Publicacao", "idPublicacao", "idPublicacao");
		String[] publicacao = { idPublicacao };
		dbQuery.delete(publicacao);

		request.getSession().setAttribute("idTopico", idTopico);
		request.getSession().setAttribute("idForum", idForum);
		request.getSession().setAttribute("nome", nome);

		response.sendRedirect("../view/publicacoes.jsp");
	}
	
	private void ExcluirComentario(HttpServletRequest request, HttpServletResponse response)throws IOException, ServletException {
		String idForum = request.getParameter("idForum");
		String idTopico = request.getParameter("idTopico");
		String nome = request.getParameter("nome");
		String idComentario = request.getParameter("idComentario");

		DBQuery dbQuery = new DBQuery("Comentario", "idComentario", "idComentario");
		String[] comentario = { idComentario };
		dbQuery.delete(comentario);

		request.getSession().setAttribute("idTopico", idTopico);
		request.getSession().setAttribute("idForum", idForum);
		request.getSession().setAttribute("nome", nome);

		response.sendRedirect("../view/publicacoes.jsp");
	}
	
	private void EditarTopico(HttpServletRequest request, HttpServletResponse response)throws IOException, ServletException {
		String idForum = request.getParameter("idForum");
		String idTopico = request.getParameter("idTopico");
		String nome = request.getParameter("nome");
		String titulo = request.getParameter("titulo");
	    
	    DBQuery query = new DBQuery("Topico", "titulo, idTopico", "idTopico");
	    String[] topico = {String.valueOf(titulo), String.valueOf(idTopico)};
	    
	    query.update(topico);

		request.getSession().setAttribute("idTopico", idTopico);
		request.getSession().setAttribute("idForum", idForum);
		request.getSession().setAttribute("nome", nome);

		response.sendRedirect("../view/topicos.jsp");
	}
	
	private void EditarPublicacao(HttpServletRequest request, HttpServletResponse response)throws IOException, ServletException {
		String idForum = request.getParameter("idForum");
		String idTopico = request.getParameter("idTopico");
		String nome = request.getParameter("nome");
		String texto = request.getParameter("texto");
		String idPublicacao = request.getParameter("idPublicacao");
	    
	    DBQuery query = new DBQuery("Publicacao", "texto, idPublicacao", "idPublicacao");
	    String[] publicacao = {texto, idPublicacao};
	    
	    query.update(publicacao);

		request.getSession().setAttribute("idTopico", idTopico);
		request.getSession().setAttribute("idForum", idForum);
		request.getSession().setAttribute("nome", nome);

		response.sendRedirect("../view/publicacoes.jsp");
	}
}
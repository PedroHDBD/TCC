<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Novo tópico</title>
<link rel="stylesheet" href="./css/css.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Lato:ital,wght@0,100;0,300;0,400;0,700;0,900;1,100;1,300;1,400;1,700;1,900&family=Rubik:ital,wght@0,300..900;1,300..900&display=swap" rel="stylesheet">
</head>
<body class='p-3'>

	<%
	request.setCharacterEncoding("UTF-8");
	
	if(request.getSession().getAttribute("idUsuario") == null){
		response.sendRedirect("./login.jsp");
	}

	String idForum = (String) request.getParameter("idForum");
	String nome = (String) request.getParameter("nome");
	String idTopico = (String) request.getParameter("idTopico");
	String tituloAtual = (String) request.getParameter("tituloAtual");

	%>
	
		
	<div class="bg-black bg-gradient text-white p-3 rounded-3 d-flex justify-content-between align-items-center">
    <div class="d-flex align-items-center">
        <form action="./topicos.jsp" method="POST">
        	<input type="hidden" name="idForum" value="<%=idForum%>"> 
			<input type="hidden" name="idTopico" value="<%=idTopico%>"> 
			<input type="hidden" name="nome" value="<%=nome%>"> 
			<button type="submit" class="bg-dark bg-gradient rounded-2 text-white border border-secondary border-opacity-50"><i class="bi bi-arrow-left px-2 fs-4"></i></button>
		</form>
    </div>
    <h5 class="m-0 position-absolute start-50 translate-middle-x text-nowrap"><%=nome%> - <%= tituloAtual %> - Editar tópico </h5>
</h1>

    <div class="ms-auto d-flex flex-column text-end text-black">
        <span>­</span>
        <span>­</span>
    </div>
</div>

<div class='d-flex flex-column justify-content-center align-items-center m-0 p-3 w-100'>

 		<form  action="/ProjetoTCC/api/control?acao=EditarTopico" method="POST" class='w-75 bg-dark-subtle py-3 px-4 rounded-3 shadow'>
			<label for="titulo" class='fs-5 mb-1'>Título: </label> 
			<input type="text" name="titulo" autocomplete="off" maxlength="60" required value='<%=tituloAtual%>' class='w-100 rounded-3 py-1 px-2 border border-dark border-opacity-25' placeholder='Máximo: 60 caracteres'><br>
			<input type="hidden" name="idForum"value="<%=idForum%>">
			<input type="hidden" name="idTopico" value="<%=idTopico%>"> 
			<input type="hidden" name="nome" value="<%=nome%>"> 
			<input type="submit" name="submit" value="Editar" class='rounded-3 py-1 px-3 border border-dark border-opacity-25 mt-2 bg-secondary-subtle fs-5'>
		</form>
				
</div>

</body>
</html>
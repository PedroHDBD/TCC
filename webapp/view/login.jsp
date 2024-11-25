<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<title>Login</title>
<link rel="stylesheet" href="./css/css.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Lato:ital,wght@0,100;0,300;0,400;0,700;0,900;1,100;1,300;1,400;1,700;1,900&family=Rubik:ital,wght@0,300..900;1,300..900&display=swap" rel="stylesheet">
</head>
<body class="p-3">

	<h2>Selecione o Usuário para Logar</h2>

	<form action="login.jsp" method="post">
		<input type="submit" name="usuario1" value="Usuário 1" /> 
		<input type="submit" name="usuario2" value="Usuário 2" />
	</form>

	<%
	if (request.getParameter("usuario1") != null) {
		request.getSession().setAttribute("idUsuario", 1);
		response.sendRedirect("foruns.jsp");
	} else if (request.getParameter("usuario2") != null) {
		request.getSession().setAttribute("idUsuario", 2);
		response.sendRedirect("./foruns.jsp");
	}
	%>

</body>
</html>
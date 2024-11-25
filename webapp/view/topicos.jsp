<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Lista de Tópicos</title>
<link rel="stylesheet" href="./css/css.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Lato:ital,wght@0,100;0,300;0,400;0,700;0,900;1,100;1,300;1,400;1,700;1,900&family=Rubik:ital,wght@0,300..900;1,300..900&display=swap" rel="stylesheet">
</head>
<body class="p-3">

	<%
	request.setCharacterEncoding("UTF-8");
	int idUsuario = -1;

	if(request.getSession().getAttribute("idUsuario") == null){
		response.sendRedirect("./login.jsp");
	}else{
		idUsuario = (int) request.getSession().getAttribute("idUsuario");
	}
	
	String idForum = request.getParameter("idForum");
	String nome = request.getParameter("nome");

	if (idForum == null) {
		idForum = (String) request.getSession().getAttribute("idForum");
	} else {
		request.getSession().removeAttribute("idForum");
		request.getSession().setAttribute("idForum", idForum);
	}

	if (nome == null) {
		nome = (String) request.getSession().getAttribute("nome");
	} else {
		request.getSession().removeAttribute("nome");
		request.getSession().setAttribute("nome", nome);
	}
	%>
	
	<div class="bg-black bg-gradient text-white p-3 rounded-3 d-flex justify-content-between align-items-center">
    <div class="d-flex align-items-center">
        <form action="./foruns.jsp" method="POST">
			<button type="submit" class="bg-dark bg-gradient rounded-2 text-white border border-secondary border-opacity-50"><i class="bi bi-arrow-left px-2 fs-4"></i></button>
		</form>
		<form action="./adicionarTopico.jsp" method="POST">
		<button type="submit"  class="bg-dark bg-gradient rounded-2 text-white ms-2 border border-secondary border-opacity-50"><i class="bi bi-plus-lg fs-4"></i></button>
			<input type="hidden" name="idForum" value="<%=idForum%>"> 
			<input type="hidden" name="nome" value="<%=nome%>">
		</form>
    </div>
    <h5 class="m-0 position-absolute start-50 translate-middle-x"><%=nome%> - Tópicos </h5>
</h1>

    <div class="ms-auto d-flex flex-column text-end text-black">
        <span>­</span>
        <span>­</span>
    </div>
    
</div>
	
<div id="topico-list">Carregando tópicos...</div>

	<script>
    async function carregarTopicos() {
    	
          const idUsuario = "<%= idUsuario %>";
          const idForum = "<%=idForum%>";
          const nome = "<%=nome%>";
    	
    	  const response = await fetch("/ProjetoTCC/api/control?acao=ListarTopicos&idForum=" + idForum, {
              method: "POST"
          });
    	
    	  const topicos = await response.json();
    	  const topicoList = document.getElementById("topico-list");
    	  topicoList.textContent = "";

    	  topicos.forEach(topico => {
              const dataUTC = topico.data;
              const dataLocal = new Date(dataUTC);
              const dia = dataLocal.getUTCDate().toString().padStart(2, '0');
              const mes = (dataLocal.getUTCMonth() + 1).toString().padStart(2, '0');
              const ano = dataLocal.getUTCFullYear().toString().slice(-2);
              const hora = dataLocal.getUTCHours().toString().padStart(2, '0');
              const minutos = dataLocal.getUTCMinutes().toString().padStart(2, '0');
              const dataFormatada = dia + "/" + mes + "/" + ano + " " + hora + ":" + minutos;

    		  const div = document.createElement("div");
    		  div.className = "bg-secondary-subtle my-4 rounded-5 w-75 d-flex align-items-center shadow";
    		  topicoList.appendChild(div);
    		  div.innerHTML = `
    		    <form method='POST' action='publicacoes.jsp' class='flex-grow-1 d-flex'>
    		      <input type='hidden' value='`+idForum+`' name='idForum'>
    		      <input type='hidden' value='`+topico.idTopico+`' name='idTopico'>
    		      <input type='hidden' value='`+nome+`' name='nome'>
    		      <button type='submit' class='w-100 text-start px-3 bg-transparent border border-dark border-opacity-25 forumBtn fs-5 d-flex align-items-stretch botaoSubmit' style='padding: 0;'>
    		        <span class='flex-grow-1 fs-5 py-2 px-3'>`+topico.titulo+`</span>
    		        <div class='d-flex flex-column justify-content-center text-end h-100 m-0 p-0'>
    		          <span class='fs-6'>Por: `+topico.idUsuario+`</span>
    		          <span class='fs-6'>`+dataFormatada+`</span>
    		        </div>
    		      </button>
    		    </form>`;

    		    if (idUsuario == topico.idUsuario) {
    		    const formExcluir = document.createElement("form");
    		    formExcluir.method = "POST";
    		    formExcluir.action = "/ProjetoTCC/api/control?acao=ExcluirTopico&idTopico=" + topico.idTopico;
    		    formExcluir.className = "d-flex align-items-stretch";

    		    div.appendChild(formExcluir);
    		    formExcluir.innerHTML = `
    		        <input type='hidden' value='`+idForum+`' name='idForum'>
    		        <input type='hidden' value='`+topico.idTopico+`' name='idTopico'>
    		        <input type='hidden' value='`+nome+`' name='nome'>
    		        <button type='submit' class='btn bg-dark-subtle border border-dark border-opacity-25 rounded-0 h-100'>
    		            <i class='bi bi-trash fs-4'></i>
    		        </button>`;

    		    const formEditar = document.createElement("form");
    		    formEditar.method = "POST";
    		    formEditar.action = "./editarTopico.jsp";
    		    formEditar.className = "d-flex align-items-stretch";

    		    div.appendChild(formEditar);
    		    formEditar.innerHTML = `
    		        <input type='hidden' value='`+idForum+`' name='idForum'>
    		        <input type='hidden' value='`+topico.idTopico+`' name='idTopico'>
    		        <input type='hidden' value='`+nome+`' name='nome'>
    		        <input type='hidden' value='`+topico.titulo+`' name='tituloAtual'>
    		        <button type='submit' class='btn bg-dark-subtle border border-dark border-opacity-25 rounded-end-pill h-100'>
    		            <i class='bi bi-pencil fs-4'></i>
    		        </button>`;
    		}

              const submitButton = div.querySelector(".botaoSubmit");
              if (idUsuario == topico.idUsuario) {
                  submitButton.classList.add("rounded-start-pill");
              } else {
                  submitButton.classList.add("rounded-5");
              }
    	  });
      }

    	carregarTopicos();
    </script>
</body>
</html>







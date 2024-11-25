<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Lista de Publicações</title>
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
	String idTopico = request.getParameter("idTopico");

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

	if (idTopico == null) {
		idTopico = (String) request.getSession().getAttribute("idTopico");
	} else {
		request.getSession().removeAttribute("idTopico");
		request.getSession().setAttribute("idTopico", idTopico);
	}
	%>
	<div class="bg-black bg-gradient text-white p-3 rounded-3 d-flex justify-content-between align-items-center" id='header'>
    <div class="d-flex align-items-center">
<form action="./topicos.jsp" method="POST">
			<input type="hidden" name="idForum" value="<%=idForum%>"> 
			<input type="hidden" name="nome" value="<%=nome%>"> 
			<button type="submit" class="bg-dark bg-gradient rounded-2 text-white border border-secondary border-opacity-50"><i class="bi bi-arrow-left px-2 fs-4"></i></button>
		</form>
		
		<form action="./adicionarPublicacao.jsp" method="POST" id='adicionarPublicacao'>
		<button type="submit" class="bg-dark bg-gradient rounded-2 text-white ms-2 border border-secondary border-opacity-50"><i class="bi bi-plus-lg fs-4"></i></button>
			<input type="hidden" name="idForum" value="<%=idForum%>"> 
			<input type="hidden" name="idTopico" value="<%=idTopico%>"> 
			<input type="hidden" name="nome" value="<%=nome%>">			
		</form>
    </div>
    
    <div class="ms-auto d-flex flex-column text-end me-3">
        <span id='spanNome'>­</span>
        <span id='spanData'>­</span>
    </div>
    
	</div>
	
	<br>
	<div id="publicacoes-list">Carregando publicações...</div>
	
	<script>
    async function carregarPublicacoes() {
        const idUsuario = "<%=idUsuario%>";
        const idForum = "<%=idForum%>";
        const idTopico = "<%=idTopico%>";
        console.log(idTopico)
        const nome = "<%=nome%>";
		const header = document.getElementById("header");

        const publicacaoList = document.getElementById("publicacoes-list");
        publicacaoList.textContent="";

        const response1 = await fetch("/ProjetoTCC/api/control?acao=ResgatarTitulo&idTopico=" + idTopico, {
            method: "POST"
        });
        
        const topico = await response1.json();
        
        const h5 = document.createElement("h5");
        h5.innerText = nome + " - " + topico.titulo;
        h5.className = "m-0 position-absolute start-50 translate-middle-x w-75 fw-medium";
        header.appendChild(h5)
        
        document.getElementById("spanNome").textContent = "Por: " + topico.idUsuario;
        
        const dataUTCSpan = topico.data;
        const dataLocal = new Date(dataUTCSpan);
        const diaSpan = dataLocal.getUTCDate().toString().padStart(2, '0');
        const mesSpan = (dataLocal.getUTCMonth() + 1).toString().padStart(2, '0');
        const anoSpan = dataLocal.getUTCFullYear().toString().slice(-2);
        const horaSpan = dataLocal.getUTCHours().toString().padStart(2, '0');
        const minutosSpan = dataLocal.getUTCMinutes().toString().padStart(2, '0');
        const dataFormatadaSpan = diaSpan+"/"+mesSpan+"/"+anoSpan+" "+horaSpan+":"+minutosSpan;
        
        document.getElementById("spanData").textContent = dataFormatadaSpan;       
        
        const inputTitulo = document.createElement("input");
        inputTitulo.type = "hidden";
		inputTitulo.name = "titulo";
		inputTitulo.value = topico.titulo;
		document.getElementById("adicionarPublicacao").appendChild(inputTitulo);
				
		if (idUsuario == topico.idUsuario) {
		    const formExcluir = document.createElement("form");
		    formExcluir.method = "POST";
		    formExcluir.action = "/ProjetoTCC/api/control?acao=ExcluirTopico&idTopico=" + idTopico;
		    formExcluir.className = "d-flex align-items-stretch";

		    header.appendChild(formExcluir);
		    formExcluir.innerHTML = `
		        <input type='hidden' value='`+idForum+`' name='idForum'>
		        <input type='hidden' value='`+idTopico+`' name='idTopico'>
		        <input type='hidden' value='`+nome+`' name='nome'>
		        <button type='submit' class='p-1 border border-dark border-opacity-25 forumBtn rounded-start-pill fs-6 bg-dark-subtle'>
                	<i class='bi bi-trash fs-6 px-1'></i>
           		</button>`;

		    const formEditar = document.createElement("form");
		    formEditar.method = "POST";
		    formEditar.action = "./editarTopico.jsp";
		    formEditar.className = "d-flex align-items-stretch";

		    header.appendChild(formEditar);
		    formEditar.innerHTML = `
		        <input type='hidden' value='`+idForum+`' name='idForum'>
		        <input type='hidden' value='`+idTopico+`' name='idTopico'>
		        <input type='hidden' value='`+nome+`' name='nome'>
		        <input type='hidden' value='`+topico.titulo+`' name='tituloAtual'>
		        <button type='submit' class='p-1 border border-dark border-opacity-25 forumBtn rounded-end-pill fs-6 bg-dark-subtle'>
                	<i class='bi bi-pencil fs-6 px-1'></i>
            	</button>`;
		}
		
        const response = await fetch("/ProjetoTCC/api/control?acao=ListarPublicacoes&idTopico=" + idTopico, {
            method: "POST"
        });
        
        const publicacoes = await response.json();
        
        const divConteudo = document.createElement("div");
        divConteudo.className = "d-flex flex-column justify-content-center align-items-center m-0 p-3 w-100";
        divConteudo.id = "divConteudo";
        publicacaoList.appendChild(divConteudo)
        
for (const publicacao of publicacoes) {
    const dataUTC = publicacao.data;
    const dataLocal = new Date(dataUTC);
    const dia = dataLocal.getUTCDate().toString().padStart(2, '0');
    const mes = (dataLocal.getUTCMonth() + 1).toString().padStart(2, '0');
    const ano = dataLocal.getUTCFullYear().toString().slice(-2);
    const hora = dataLocal.getUTCHours().toString().padStart(2, '0');
    const minutos = dataLocal.getUTCMinutes().toString().padStart(2, '0');
    const dataFormatada = dia+"/"+mes+"/"+ano+" "+hora+":"+minutos;

    const mainDiv = document.createElement("div");
    mainDiv.className = "my-5 w-75 shadow rounded-3";

    divConteudo.appendChild(mainDiv);
    mainDiv.innerHTML = `
        <span class='span-header p-3 m-0 bg-secondary text-white rounded-3 rounded-bottom-0 d-flex justify-content-between align-items-center fs-3'>
            Por: `+publicacao.idUsuario+`
            <h6 class='fw-normal m-0 flex-grow-1 ms-5 float-end'>`+dataFormatada+`</h6>
        </span>`;

    const spanHeader = mainDiv.querySelector(".span-header");

    if (idUsuario == publicacao.idUsuario) {
        const formExcluir = document.createElement("form");
        formExcluir.method = "POST";
        formExcluir.action = "/ProjetoTCC/api/control?acao=ExcluirPublicacao";

        formExcluir.innerHTML = `
            <input type='hidden' value='`+idForum+`' name='idForum'>
            <input type='hidden' value='`+idTopico+`' name='idTopico'>
            <input type='hidden' value='`+nome+`' name='nome'>
            <input type='hidden' value='`+publicacao.idPublicacao+`' name='idPublicacao'>
            <button type='submit' class='p-2 border border-dark border-opacity-25 forumBtn rounded-start-pill fs-6 bg-dark-subtle'>
                <i class='bi bi-trash fs-5 px-1'></i>
            </button>`;
        spanHeader.appendChild(formExcluir);

        const formEditar = document.createElement("form");
        formEditar.method = "POST";
        formEditar.action = "./editarPublicacao.jsp";

        formEditar.innerHTML = `
            <input type='hidden' value='`+idForum+`' name='idForum'>
            <input type='hidden' value='`+idTopico+`' name='idTopico'>
            <input type='hidden' value='`+nome+`' name='nome'>
            <input type='hidden' value='`+publicacao.idPublicacao+`' name='idPublicacao'>
            <input type='hidden' value='`+publicacao.texto+`' name='textoAtual'>
            <input type='hidden' value='`+topico.titulo+`' name='titulo'>
            <button type='submit' class='p-2 border border-dark border-opacity-25 forumBtn rounded-end-pill fs-6 bg-dark-subtle'>
                <i class='bi bi-pencil fs-5 px-1'></i>
            </button>`;
        spanHeader.appendChild(formEditar);
    }

    		const h5 = document.createElement("h5");
    		h5.innerText = publicacao.texto;
    		h5.className = "p-3 m-0 bg-dark-subtle fw-normal py-4 text-break";
    		mainDiv.appendChild(h5);

            const comentariosDiv = document.createElement("div");
            mainDiv.appendChild(comentariosDiv)

            if (publicacao.numComentarios > 0) {
                const response2 = await fetch("/ProjetoTCC/api/control?acao=ListarComentarios&idPublicacao=" + publicacao.idPublicacao, {
                    method: "POST"
                });
                const comentarios = await response2.json();

                comentarios.forEach(comentario => {
                	const dataUTC = comentario.data;
                    const dataLocal = new Date(dataUTC);
                    const dia = dataLocal.getUTCDate().toString().padStart(2, '0');
                    const mes = (dataLocal.getUTCMonth() + 1).toString().padStart(2, '0');
                    const ano = dataLocal.getUTCFullYear().toString().slice(-2);
                    const hora = dataLocal.getUTCHours().toString().padStart(2, '0');
                    const minutos = dataLocal.getUTCMinutes().toString().padStart(2, '0');
                    const dataFormatada = dia+"/"+mes+"/"+ano+" "+hora+":"+minutos;
                	const comentarioDiv = document.createElement("div");
                	comentarioDiv.className = "d-flex";
                	comentariosDiv.appendChild(comentarioDiv)
                	
                	comentarioDiv.innerHTML = `
                	<h6 class='text-break fw-normal w-100 p-3 m-0 bg-body-tertiary border-top border-start border-bottom border-black border-opacity-10 d-flex justify-content-between align-items-center'>
                	`+comentario.idUsuario+`: `+comentario.texto+`</h6>
                	<h6 class='fw-normal m-0 p-2 bg-body-tertiary border-top border-end border-bottom border-black border-opacity-10 text-nowrap fs-6'>
                	`+dataFormatada+`</h6>`
                	
                    if(idUsuario == comentario.idUsuario){
                    	const divAcoesComentario = document.createElement("div");
                    	divAcoesComentario.className = "d-flex bg-secondary-subtle border border-black border-opacity-10";
                    	comentarioDiv.appendChild(divAcoesComentario);
                    	
                    	divAcoesComentario.innerHTML = `
                    	<form method='POST' action='/ProjetoTCC/api/control?acao=ExcluirComentario'>
                    		<input type='hidden' value='`+idForum+`' name='idForum'>
                      	  	<input type='hidden' value='`+idTopico+`' name='idTopico'>
                      	  	<input type='hidden' value='`+nome+`' name='nome'>
                      	  	<input type='hidden' value='`+comentario.idComentario+`' name='idComentario'>
                      	  	<button type='submit' class='px-3 forumBtn fs-6 h-100 bg-secondary-subtle'><i class='bi bi-trash fs-5 '></i></button>`
                    }else {
                    	const divAcoesComentario = document.createElement("div");
                    	divAcoesComentario.className = "d-flex bg-secondary-subtle border border-black border-opacity-10";
						comentarioDiv.appendChild(divAcoesComentario);
                    	
                    	divAcoesComentario.innerHTML = `
                    	<form method='POST' action='/ProjetoTCC/api/control?acao=CurtirComentario'>
                    		<input type='hidden' value='`+idForum+`' name='idForum'>
                      	  	<input type='hidden' value='`+idTopico+`' name='idTopico'>
                      	  	<input type='hidden' value='`+nome+`' name='nome'>
                      	  	<input type='hidden' value='`+comentario.idComentario+`' name='idComentario'>
                      	  	<button type='submit' class='px-3 forumBtn fs-6 h-100 bg-secondary-subtle'><i class='bi bi-hand-thumbs-up fs-5 '></i></button>`
                    }      
                });
            }
            const divAdicionarComentario = document.createElement("div");
            divAdicionarComentario.className= "d-flex align-items-stretch w-100";
            mainDiv.appendChild(divAdicionarComentario)
            
            divAdicionarComentario.innerHTML += `
            <form action='/ProjetoTCC/api/control?acao=AdicionarComentario' method='POST' class='d-flex w-100 '>
            <input type='text' name='texto' maxlength='1000' required placeholder='Digite seu comentário...' autocomplete='off'
            class='p-2 border-dark border-opacity-50 flex-grow-1' style='border-radius: 0 0 0 0.375rem'> 
            <input type='hidden' value='`+idForum+`' name='idForum'>
      	  	<input type='hidden' value='`+idTopico+`' name='idTopico'>
      	  	<input type='hidden' value='`+publicacao.idPublicacao+`' name='idPublicacao'>
      	  	<button type='submit' class='btn-submit px-3 bg-info-subtle bg-gradient border border-black border-opacity-10 fs-6 custom-rounded'>
      	  	<i class='bi bi-send fs-5 '></i></button>
            </form>`
        }
    }
    carregarPublicacoes();
</script>
</body>
</html>

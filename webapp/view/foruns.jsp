<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Fóruns</title>
<link rel="stylesheet" href="./css/css.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Lato:ital,wght@0,100;0,300;0,400;0,700;0,900;1,100;1,300;1,400;1,700;1,900&family=Rubik:ital,wght@0,300..900;1,300..900&display=swap" rel="stylesheet">
</head>
<body class="p-3">

	<% 
		if(request.getSession().getAttribute("idUsuario") == null){
			response.sendRedirect("./login.jsp");
		}
	%>

<div class="bg-black bg-gradient text-white p-3 rounded-3 d-flex justify-content-between align-items-center">
    <div class="d-flex align-items-center">
        		<form action="./login.jsp" method="POST">
			<button type="submit" class="bg-dark bg-gradient rounded-2 text-white border border-secondary border-opacity-50"><i class="bi bi-arrow-left px-2 fs-4"></i></button>
		</form>
    </div>
    <h5 class="m-0 position-absolute start-50 translate-middle-x">Fóruns</h5>
    
    <div class="ms-auto d-flex flex-column text-end text-black">
        <span>­</span>
        <span>­</span>
    </div>
    
</div>

	<div id="forum-list">Carregando fóruns...</div>

	<script>    
    async function carregarForuns() {
    	
    	const response = await fetch("/ProjetoTCC/api/control?acao=ListarForuns", {
            method: "POST"
        });
    	
    	  const forums = await response.json();
    	  const forumList = document.getElementById("forum-list");
    	  forumList.textContent="";

    	  forums.forEach(forum => {

    		const div = document.createElement("div");
    		div.className = "bg-secondary-subtle my-4 rounded-5 w-50 d-flex align-items-center shadow";
    		
    		forumList.appendChild(div)
    		div.innerHTML = `
    		<form method='POST' action='./topicos.jsp' class='flex-grow-1'>
    		<input type='hidden' value='`+forum.idForum+`' name='idForum'>
          	<input type='hidden' value='`+forum.nome+`' name='nome'>
          	<button type='submit' class='w-100 text-start px-3 py-2 bg-transparent border border-dark border-opacity-25 forumBtn fs-5 rounded-5'>
          	<span class='px-3'>`+forum.nome+`</span></button>
    		</form>`
    	  
  		});
      }

    	carregarForuns();
    </script>
</body>
</html>
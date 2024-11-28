create database TCC;
use TCC;
SET time_zone = 'SYSTEM';

create table Usuario (
    `idUsuario` int primary key auto_increment,
	`nome` varchar(50) NOT NULL,
    `email` varchar(50) NOT NULL,
    `senha` varchar(50) NOT NULL,
    `regiao` varchar(50),
    `data` timestamp NOT NULL DEFAULT current_timestamp
);

insert into Usuario (nome, email, senha, regiao) values ('Pedro', 'pedro@email.com', '123', 'Sudeste');
insert into Usuario (nome, email, senha, regiao) values ('Maria', 'maria@email.com', '321', 'Norte');

create table Forum (
	`idForum` int auto_increment primary key,
	`nome` varchar(250) NOT NULL,
    `data` timestamp NOT NULL DEFAULT current_timestamp
);
insert into Forum (nome) value ('Acampamentos');
insert into Forum (nome) value ('Ações comunitárias');

create table Topico (
	`idUsuario` int NOT NULL,
	`idTopico` int auto_increment primary key,
    `idForum` int NOT NULL,
	`titulo` varchar(60) NOT NULL,
    `data` timestamp NOT NULL DEFAULT current_timestamp,
    CONSTRAINT foreign key (`idForum`) references Forum (`idForum`),
    CONSTRAINT foreign key (`idUsuario`) references Usuario (`idUsuario`)
);
insert into Topico (idUsuario, idForum, titulo) values (1, 1, 'Acampamento de patrulha');
insert into Topico (idUsuario, idForum, titulo) values (2, 2, 'Revitalização da praça');

create table Publicacao (
	`idUsuario` int NOT NULL,
	`idPublicacao` int primary key auto_increment,
    `idTopico` int NOT NULL,
	`texto` text NOT NULL,
    `numReacoes` int DEFAULT 0,
    `numSalvamentos` int DEFAULT 0,
    `numComentarios` int DEFAULT 0,
    `data` timestamp NOT NULL DEFAULT current_timestamp, 
    CONSTRAINT foreign key (`idTopico`) references Topico (`idTopico`) ON DELETE CASCADE,
    CONSTRAINT foreign key (`idUsuario`) references Usuario (`idUsuario`)
);
insert into Publicacao (titulo, idUsuario, idTopico, texto) values ('Acampamento de patrulha', 1, 1, 'Ontem teve o acampamento da minha patrulha, foram 2 dias de muito aprendizado!');
insert into Publicacao (titulo, idUsuario, idTopico, texto) values ('Revitalização da praça', 2, 2, 'Hoje fizemos a revitalização da praça do bairro. Pintamos os canteiros, tiramos o lixo e plantamos mais árvores!');

create table Comentario (
	`idComentario` int auto_increment primary key,
	`idUsuario` int NOT NULL,
    `idPublicacao` int,
	`texto` text NOT NULL,
    `numCurtidas` int DEFAULT 0,
    `data` timestamp NOT NULL DEFAULT current_timestamp, 
	CONSTRAINT foreign key (`idPublicacao`) references Publicacao (`idPublicacao`)  ON DELETE CASCADE,
    CONSTRAINT foreign key (`idUsuario`) references Usuario (`idUsuario`)
);

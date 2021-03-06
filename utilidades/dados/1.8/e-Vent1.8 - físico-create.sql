-- Gera��o de Modelo f�sico
-- Sql ANSI 2003 - brModelo.

DROP DATABASE IF EXISTS e_vent_br;

CREATE DATABASE e_vent_br;
USE e_vent_br;

CREATE TABLE Configuracao (
data_evento_visivel DATE NOT NULL,
dias_limite_pagamento TINYINT UNSIGNED
);

CREATE TABLE Estado (
cod_estado TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(25) NOT NULL,
sigla CHAR(2) NOT NULL
);

CREATE TABLE Cidade (
cod_cidade SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(60) NOT NULL,
cod_estado TINYINT UNSIGNED NOT NULL,
FOREIGN KEY(cod_estado) REFERENCES Estado (cod_estado)
);

CREATE TABLE Instituicao (
cod_instituicao TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(100) NOT NULL,
sigla VARCHAR(10) NOT NULL
);

CREATE TABLE Curso (
cod_curso TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(60) NOT NULL
);

CREATE TABLE Local (
cod_local TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(140) NOT NULL,
sigla VARCHAR(15),
bloco VARCHAR(60),
quantidade_maxima TINYINT UNSIGNED NOT NULL
);

CREATE TABLE Usuario (
cod_usuario INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
nome_certificado VARCHAR(100) NOT NULL,
nome_cracha VARCHAR(25) NOT NULL,
sexo ENUM ('Feminino', 'Masculino', 'N�o declarar') NOT NULL,
data_nascimento DATE NOT NULL,
cpf CHAR(11) NOT NULL,
rg VARCHAR(10) NOT NULL,
login VARCHAR(30) NOT NULL,
senha VARCHAR(20) NOT NULL,
telefone1 CHAR(11) NOT NULL,
telefone2 CHAR(11),
email VARCHAR(50) NOT NULL,
campus_instituicao VARCHAR(60),
lattes VARCHAR(50),
categoria ENUM('Estudante','Professor','Profissional/Outros') NOT NULL,
nivel_acesso ENUM('Super','Administrador','Comum') NOT NULL,
notifica ENUM('Sim', 'N�o') NOT NULL,
status ENUM('Ativo','Inativo') NOT NULL,
data_hora_cadastro DATETIME NOT NULL,
cod_cidade SMALLINT UNSIGNED NOT NULL,
cod_instituicao TINYINT UNSIGNED,
cod_curso TINYINT UNSIGNED,
FOREIGN KEY(cod_cidade) REFERENCES Cidade (cod_cidade),
FOREIGN KEY(cod_instituicao) REFERENCES Instituicao (cod_instituicao),
FOREIGN KEY(cod_curso) REFERENCES Curso (cod_curso)
);

CREATE TABLE Evento (
cod_evento SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(100) NOT NULL,
sigla VARCHAR(25) NOT NULL,
data_inicio_evento DATE NOT NULL,
data_fim_evento DATE NOT NULL,
data_inicio_inscricao DATE NOT NULL,
data_fim_inscricao DATE NOT NULL,
data_hora_publicado DATETIME,
status ENUM ('Andamento', 'Encerrado', 'Cancelado', 'Publicado') NOT NULL,
pagamento ENUM('Gratuito', 'Pago') NOT NULL,
url_gabarito_atividade VARCHAR(140),
url_gabarito_evento VARCHAR(140),
url_imagem VARCHAR(100),
url_site VARCHAR(100),
dias_limite_pagamento TINYINT UNSIGNED NOT NULL
);

CREATE TABLE Usuario_Evento (
cod_usuario INT UNSIGNED,
cod_evento SMALLINT UNSIGNED,
funcao ENUM('Coordenador','Auxiliar') NOT NULL,
PRIMARY KEY(cod_usuario,cod_evento),
FOREIGN KEY(cod_usuario) REFERENCES Usuario (cod_usuario),
FOREIGN KEY(cod_evento) REFERENCES Evento (cod_evento)
);

CREATE TABLE Inscricao (
cod_inscricao INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
cod_usuario INT UNSIGNED NOT NULL,
cod_evento SMALLINT UNSIGNED NOT NULL,
data_hora_inscricao DATETIME NOT NULL,
status ENUM('Andamento','Confirmada','Cancelada') NOT NULL,
FOREIGN KEY(cod_usuario) REFERENCES Usuario (cod_usuario),
FOREIGN KEY(cod_evento) REFERENCES Evento (cod_evento)
);

CREATE TABLE Pagamento (
cod_pagamento INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
data_hora_pagamento DATETIME,
status ENUM('Aberto', 'Pago', 'Cancelado') NOT NULL,
tipo_pagamento ENUM ('Vista', 'Deposito', 'Boleto'),
cod_inscricao INT UNSIGNED NOT NULL,
FOREIGN KEY(cod_inscricao) REFERENCES Inscricao (cod_inscricao)
);

CREATE TABLE Boleto (
cod_barras VARCHAR(50),
cod_pagamento INT UNSIGNED,
FOREIGN KEY(cod_pagamento) REFERENCES Pagamento (cod_pagamento)
);

CREATE TABLE Deposito (
anexo_pagamento BLOB,
cod_pagamento INT UNSIGNED,
FOREIGN KEY(cod_pagamento) REFERENCES Pagamento (cod_pagamento)
);

CREATE TABLE Certificado (
cod_certificado INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
data_hora_emissao DATETIME NOT NULL,
data_hora_salvo DATETIME,
data_hora_enviado DATETIME,
cod_validacao VARCHAR(50) NOT NULL UNIQUE,
cod_inscricao INT UNSIGNED NOT NULL,
FOREIGN KEY(cod_inscricao) REFERENCES Inscricao (cod_inscricao)
);

CREATE TABLE Atividade_Tipo (
cod_atividade_tipo TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(60) NOT NULL
);

CREATE TABLE Atividade_Valor (
cod_atividade_tipo TINYINT UNSIGNED,
cod_evento SMALLINT UNSIGNED,
valor_estudante DECIMAL (5, 2) UNSIGNED NOT NULL,
valor_professor DECIMAL (5, 2) UNSIGNED NOT NULL,
valor_profissional_outros DECIMAL (5, 2) UNSIGNED NOT NULL,
PRIMARY KEY(cod_atividade_tipo,cod_evento),
FOREIGN KEY(cod_atividade_tipo) REFERENCES Atividade_Tipo (cod_atividade_tipo),
FOREIGN KEY(cod_evento) REFERENCES Evento (cod_evento)
);

CREATE TABLE Atividade (
cod_atividade MEDIUMINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(200) NOT NULL,
resumo BLOB NOT NULL,
conhecimento_aprendido BLOB,
conteudo_programatico BLOB NOT NULL,
prerequisito VARCHAR(140) NOT NULL,
publico_alvo VARCHAR(140) NOT NULL,
ferramenta VARCHAR(140) NOT NULL,
carga_horaria TINYINT UNSIGNED NOT NULL,
vagas TINYINT UNSIGNED NOT NULL,
observacao BLOB,
tipo_frequencia ENUM('Evento', 'Atividade') NOT NULL,
status ENUM('Confirmada', 'Cancelada') NOT NULL,
cod_atividade_tipo TINYINT UNSIGNED NOT NULL,
cod_evento SMALLINT UNSIGNED NOT NULL,
FOREIGN KEY(cod_atividade_tipo, cod_evento) REFERENCES Atividade_Valor (cod_atividade_tipo, cod_evento)
);

CREATE TABLE Usuario_Atividade (
cod_usuario INT UNSIGNED,
cod_atividade MEDIUMINT UNSIGNED,
funcao ENUM('Ministrante', 'Monitor') NOT NULL,
PRIMARY KEY(cod_usuario,cod_atividade),
FOREIGN KEY(cod_usuario) REFERENCES Usuario (cod_usuario),
FOREIGN KEY(cod_atividade) REFERENCES Atividade (cod_atividade)
);

CREATE TABLE Atividade_Agenda (
cod_atividade_agenda MEDIUMINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
data DATE NOT NULL,
horario_inicio TIME NOT NULL,
horario_fim TIME NOT NULL,
cod_local TINYINT UNSIGNED NOT NULL,
cod_atividade MEDIUMINT UNSIGNED NOT NULL,
FOREIGN KEY(cod_atividade) REFERENCES Atividade (cod_atividade),
FOREIGN KEY(cod_local) REFERENCES Local (cod_local)
);

CREATE TABLE Inscricao_Historico (
cod_inscricao INT UNSIGNED,
cod_atividade_agenda MEDIUMINT UNSIGNED,
valor_pago DECIMAL (5, 2) UNSIGNED NOT NULL,
frequente ENUM('N�o lan�ado','Presente', 'Ausente') NOT NULL,
observacao BLOB,
PRIMARY KEY(cod_inscricao,cod_atividade_agenda),
FOREIGN KEY(cod_inscricao) REFERENCES Inscricao (cod_inscricao),
FOREIGN KEY(cod_atividade_agenda) REFERENCES Atividade_Agenda (cod_atividade_agenda)
);

CREATE TABLE Usuario_Temporario (
cpf CHAR(11) PRIMARY KEY,
nome VARCHAR(100) NOT NULL,
email VARCHAR(50) NOT NULL,
login VARCHAR(30) NOT NULL,
senha VARCHAR(20) NOT NULL
);
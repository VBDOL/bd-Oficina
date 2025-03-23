-- Criação do Banco de Dados
CREATE DATABASE oficina;
USE oficina;

-- Tabela de Clientes
CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    endereco VARCHAR(255),
    telefone VARCHAR(20)
);

-- Tabela de Veículos
CREATE TABLE veiculos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    placa VARCHAR(10) UNIQUE NOT NULL,
    modelo VARCHAR(255) NOT NULL,
    marca VARCHAR(255) NOT NULL,
    ano INT NOT NULL,
    id_cliente INT,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id)
);

-- Tabela de Mecânicos
CREATE TABLE mecanicos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    endereco VARCHAR(255),
    especialidade VARCHAR(255)
);

-- Tabela de Equipes
CREATE TABLE equipes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL
);

-- Tabela de Associação entre Equipes e Mecânicos
CREATE TABLE equipe_mecanicos (
    id_equipe INT,
    id_mecanico INT,
    PRIMARY KEY (id_equipe, id_mecanico),
    FOREIGN KEY (id_equipe) REFERENCES equipes(id),
    FOREIGN KEY (id_mecanico) REFERENCES mecanicos(id)
);

-- Tabela de Ordens de Serviço (OS)
CREATE TABLE ordens_servico (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_veiculo INT,
    id_equipe INT,
    data_emissao DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Aberta', 'Em Andamento', 'Concluída', 'Cancelada') DEFAULT 'Aberta',
    valor_total DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (id_veiculo) REFERENCES veiculos(id),
    FOREIGN KEY (id_equipe) REFERENCES equipes(id)
);

-- Tabela de Serviços Executados
CREATE TABLE servicos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(255) NOT NULL,
    preco DECIMAL(10,2) NOT NULL
);

-- Tabela de Associação entre OS e Serviços
CREATE TABLE ordem_servico_servicos (
    id_os INT,
    id_servico INT,
    quantidade INT NOT NULL,
    PRIMARY KEY (id_os, id_servico),
    FOREIGN KEY (id_os) REFERENCES ordens_servico(id),
    FOREIGN KEY (id_servico) REFERENCES servicos(id)
);

-- Tabela de Peças
CREATE TABLE pecas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    estoque INT NOT NULL
);

-- Tabela de Associação entre OS e Peças
CREATE TABLE ordem_servico_pecas (
    id_os INT,
    id_peca INT,
    quantidade INT NOT NULL,
    PRIMARY KEY (id_os, id_peca),
    FOREIGN KEY (id_os) REFERENCES ordens_servico(id),
    FOREIGN KEY (id_peca) REFERENCES pecas(id)
);

-- Inserção de Dados
INSERT INTO clientes (nome, endereco, telefone) VALUES 
('Carlos Silva', 'Rua A, 123', '11999999999'),
('Maria Souza', 'Rua B, 456', '11988888888');

INSERT INTO veiculos (placa, modelo, marca, ano, id_cliente) VALUES 
('ABC-1234', 'Civic', 'Honda', 2020, 1),
('XYZ-5678', 'Corolla', 'Toyota', 2019, 2);

INSERT INTO mecanicos (nome, endereco, especialidade) VALUES 
('João Mecânico', 'Rua C, 789', 'Motor'),
('Pedro Técnico', 'Rua D, 321', 'Suspensão');

INSERT INTO equipes (nome) VALUES 
('Equipe Alpha'),
('Equipe Beta');

INSERT INTO equipe_mecanicos (id_equipe, id_mecanico) VALUES 
(1, 1),
(2, 2);

INSERT INTO ordens_servico (id_veiculo, id_equipe, status, valor_total) VALUES 
(1, 1, 'Aberta', 0.00);

INSERT INTO servicos (descricao, preco) VALUES 
('Troca de óleo', 150.00),
('Alinhamento', 100.00);

INSERT INTO ordem_servico_servicos (id_os, id_servico, quantidade) VALUES 
(1, 1, 1);

INSERT INTO pecas (nome, preco, estoque) VALUES 
('Filtro de óleo', 50.00, 20),
('Pneu 175/65R14', 300.00, 10);

INSERT INTO ordem_servico_pecas (id_os, id_peca, quantidade) VALUES 
(1, 1, 1);

-- Consultas SQL Complexas
-- Quantas ordens de serviço cada cliente possui?
SELECT c.nome AS cliente, COUNT(os.id) AS total_os 
FROM clientes c 
JOIN veiculos v ON c.id = v.id_cliente 
JOIN ordens_servico os ON v.id = os.id_veiculo 
GROUP BY c.nome;

-- Lista de serviços realizados em cada OS
SELECT os.id AS ordem_servico, s.descricao AS servico, oss.quantidade 
FROM ordens_servico os 
JOIN ordem_servico_servicos oss ON os.id = oss.id_os 
JOIN servicos s ON oss.id_servico = s.id;

-- Mecânicos por equipe
SELECT e.nome AS equipe, m.nome AS mecanico 
FROM equipes e 
JOIN equipe_mecanicos em ON e.id = em.id_equipe 
JOIN mecanicos m ON em.id_mecanico = m.id;

-- Peças utilizadas por OS
SELECT os.id AS ordem_servico, p.nome AS peca, osp.quantidade 
FROM ordens_servico os 
JOIN ordem_servico_pecas osp ON os.id = osp.id_os 
JOIN pecas p ON osp.id_peca = p.id;

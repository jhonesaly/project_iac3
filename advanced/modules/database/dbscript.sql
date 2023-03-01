CREATE TABLE estoque (
    id_codigo_barras VARCHAR(13) NOT NULL,
    nome VARCHAR(50) NOT NULL,
    marca VARCHAR(50) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    data_compra DATE NOT NULL,
    data_validade DATE NOT NULL,
    PRIMARY KEY (id_codigo_barras)
);
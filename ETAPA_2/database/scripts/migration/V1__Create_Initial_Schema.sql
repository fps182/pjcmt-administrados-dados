CREATE SEQUENCE grupo_codigo_seq;

CREATE TABLE grupo (
                codigo BIGINT NOT NULL DEFAULT nextval('grupo_codigo_seq'),
                nome VARCHAR(50) NOT NULL,
                CONSTRAINT grupo_pk PRIMARY KEY (codigo)
);


ALTER SEQUENCE grupo_codigo_seq OWNED BY grupo.codigo;

CREATE SEQUENCE permissao_codigo_seq;

CREATE TABLE permissao (
                codigo BIGINT NOT NULL DEFAULT nextval('permissao_codigo_seq'),
                nome VARCHAR(50) NOT NULL,
                CONSTRAINT permissao_pk PRIMARY KEY (codigo)
);


ALTER SEQUENCE permissao_codigo_seq OWNED BY permissao.codigo;

CREATE TABLE grupo_permissao (
                codigo_grupo BIGINT NOT NULL,
                codigo_permissao BIGINT NOT NULL,
                CONSTRAINT grupo_permissao_pk PRIMARY KEY (codigo_grupo, codigo_permissao)
);


CREATE SEQUENCE estado_codigo_seq;

CREATE TABLE estado (
                codigo BIGINT NOT NULL DEFAULT nextval('estado_codigo_seq'),
                nome VARCHAR(50) NOT NULL,
                sigla VARCHAR(2) NOT NULL,
                CONSTRAINT estado_pk PRIMARY KEY (codigo)
);


ALTER SEQUENCE estado_codigo_seq OWNED BY estado.codigo;

CREATE SEQUENCE cidade_codigo_seq;

CREATE TABLE cidade (
                codigo BIGINT NOT NULL DEFAULT nextval('cidade_codigo_seq'),
                nome VARCHAR(50) NOT NULL,
                codigo_estado BIGINT NOT NULL,
                CONSTRAINT cidade_pk PRIMARY KEY (codigo)
);


ALTER SEQUENCE cidade_codigo_seq OWNED BY cidade.codigo;

CREATE SEQUENCE cliente_codigo_seq;

CREATE TABLE cliente (
                codigo BIGINT NOT NULL DEFAULT nextval('cliente_codigo_seq'),
                nome VARCHAR(80) NOT NULL,
                tipo_pessoa VARCHAR(15) NOT NULL CHECK (tipo_pessoa = 'FISICA' OR tipo_pessoa = 'JURIDICA' OR tipo_pessoa = 'AMBOS'),
                cpf_cnpj VARCHAR(30) NOT NULL,
                telefone VARCHAR(20),
                email VARCHAR(50),
                logradouro VARCHAR(50),
                numero VARCHAR(15),
                complemento VARCHAR(20),
                cep VARCHAR(15),
                codigo_cidade BIGINT NOT NULL,
                CONSTRAINT cliente_pk PRIMARY KEY (codigo)
);


ALTER SEQUENCE cliente_codigo_seq OWNED BY cliente.codigo;

CREATE SEQUENCE usuario_codigo_seq;

CREATE TABLE usuario (
                codigo BIGINT NOT NULL DEFAULT nextval('usuario_codigo_seq'),
                nome VARCHAR(50) NOT NULL,
                email VARCHAR(50) NOT NULL,
                senha VARCHAR(120) NOT NULL,
                ativo SMALLINT DEFAULT 1 NOT NULL,
                data_nascimento DATE NOT NULL,
                CONSTRAINT usuario_pk PRIMARY KEY (codigo)
);


ALTER SEQUENCE usuario_codigo_seq OWNED BY usuario.codigo;

CREATE TABLE usuario_grupo (
                codigo_usuario BIGINT NOT NULL,
                codigo_grupo BIGINT NOT NULL,
                CONSTRAINT usuario_grupo_pk PRIMARY KEY (codigo_usuario, codigo_grupo)
);


CREATE SEQUENCE venda_codigo_seq;

CREATE TABLE venda (
                codigo BIGINT NOT NULL DEFAULT nextval('venda_codigo_seq'),
                data_criacao TIMESTAMP DEFAULT now() NOT NULL,
                valor_frete DECIMAL(10,2),
                valor_desconto DECIMAL(10,2),
                valor_total DECIMAL(10,2) NOT NULL,
                status VARCHAR(30) DEFAULT 'EMABERTO' NOT NULL CHECK (status = 'EMABERTO' OR status = 'NOTAEMITIDA' OR status = 'EMSEPARACAO' OR status = 'CANCELADA' OR status = 'DEVOLVIDA' OR status = 'FECHADA'),
                observacao VARCHAR(200),
                data_hora_entrega TIMESTAMP,
                codigo_cliente BIGINT NOT NULL,
                codigo_usuario BIGINT NOT NULL,
                CONSTRAINT venda_pk PRIMARY KEY (codigo)
);


ALTER SEQUENCE venda_codigo_seq OWNED BY venda.codigo;

CREATE SEQUENCE estilo_codigo_seq;

CREATE TABLE estilo (
                codigo BIGINT NOT NULL DEFAULT nextval('estilo_codigo_seq'),
                nome VARCHAR(50) NOT NULL,
                CONSTRAINT estilo_pk PRIMARY KEY (codigo)
);


ALTER SEQUENCE estilo_codigo_seq OWNED BY estilo.codigo;

CREATE SEQUENCE cerveja_codigo_seq;

CREATE TABLE cerveja (
                codigo BIGINT NOT NULL DEFAULT nextval('cerveja_codigo_seq'),
                sku VARCHAR(50) NOT NULL,
                nome VARCHAR(80) NOT NULL,
                descricao TEXT,
                valor DECIMAL(10,2) DEFAULT 0 NOT NULL,
                teor_alcoolico DECIMAL(10,2) NOT NULL,
                comissao DECIMAL(10,2) NOT NULL,
                sabor VARCHAR(50),
                origem VARCHAR(50),
                codigo_estilo BIGINT NOT NULL,
                quantidade_estoque INT NOT NULL,
                foto VARCHAR(100) NOT NULL,
                content_type VARCHAR(100) NOT NULL,
                CONSTRAINT cerveja_pk PRIMARY KEY (codigo)
);


ALTER SEQUENCE cerveja_codigo_seq OWNED BY cerveja.codigo;

CREATE SEQUENCE item_venda_codigo_seq;

CREATE TABLE item_venda (
                codigo BIGINT NOT NULL DEFAULT nextval('item_venda_codigo_seq'),
                quantidade INT DEFAULT 1 NOT NULL,
                valor_unitario DECIMAL(10,2) NOT NULL,
                codigo_cerveja BIGINT NOT NULL,
                codigo_venda BIGINT NOT NULL,
                CONSTRAINT item_venda_pk PRIMARY KEY (codigo)
);


ALTER SEQUENCE item_venda_codigo_seq OWNED BY item_venda.codigo;

ALTER TABLE grupo_permissao ADD CONSTRAINT grupo_grupo_permissao_fk
FOREIGN KEY (codigo_grupo)
REFERENCES grupo (codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE usuario_grupo ADD CONSTRAINT grupo_usuario_grupo_fk
FOREIGN KEY (codigo_grupo)
REFERENCES grupo (codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE grupo_permissao ADD CONSTRAINT permissao_grupo_permissao_fk
FOREIGN KEY (codigo_permissao)
REFERENCES permissao (codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE cidade ADD CONSTRAINT estado_cidade_fk
FOREIGN KEY (codigo_estado)
REFERENCES estado (codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE cliente ADD CONSTRAINT cidade_cliente_fk
FOREIGN KEY (codigo_cidade)
REFERENCES cidade (codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE venda ADD CONSTRAINT cliente_venda_fk
FOREIGN KEY (codigo_cliente)
REFERENCES cliente (codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE venda ADD CONSTRAINT usuario_venda_fk
FOREIGN KEY (codigo_usuario)
REFERENCES usuario (codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE usuario_grupo ADD CONSTRAINT usuario_usuario_grupo_fk
FOREIGN KEY (codigo_usuario)
REFERENCES usuario (codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE item_venda ADD CONSTRAINT venda_item_venda_fk
FOREIGN KEY (codigo_venda)
REFERENCES venda (codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE cerveja ADD CONSTRAINT estilo_cerveja_fk
FOREIGN KEY (codigo_estilo)
REFERENCES estilo (codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE item_venda ADD CONSTRAINT cerveja_item_venda_fk
FOREIGN KEY (codigo_cerveja)
REFERENCES cerveja (codigo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
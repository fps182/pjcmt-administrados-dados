/*********************************************************
 * GRUPO DE INFORMAÇÕES 1: Usuários, Permissões e Grupos *
 *********************************************************/
CREATE EXTENSION IF NOT EXISTS pgcrypto;

INSERT INTO grupo (nome) VALUES ('Administradores'), ('Gerentes'), ('Vendedores');
INSERT INTO permissao (nome) VALUES ('Desconto maior que 20%'), ('Realizar Orçamentos'), ('Fechar Vendas'); 
	
-- Salt MD5 da App: $1$DoS8JVPc 
INSERT INTO usuario (nome, email, senha, data_nascimento)
VALUES	('Julia Araujo Almeida', 'juliaaraujoalmeida@teleworm.us', crypt('Shio4puo2', '$1$DoS8JVPc'), '1964-01-25')
		, ('Luana Carvalho Pereira', 'luanacarvalhopereira@dayrep.com', crypt('paePho7Oh', '$1$DoS8JVPc'), '1965-06-16')
		, ('Diogo Pereira Ribeiro', 'diogopereiraribeiro@jourrapide.com', crypt('eeYeimijoa0', '$1$DoS8JVPc'), '1995-09-30');

-- Ligação entre grupo e permissões
INSERT INTO grupo_permissao (codigo_grupo, codigo_permissao)
SELECT	g.codigo AS codigo_grupo
		, p.codigo AS codigo_permissao
FROM	permissao p
		INNER JOIN	grupo g
		ON			g.nome IN ('Administradores', 'Gerentes')
WHERE	NOT EXISTS (
			SELECT	1
			FROM	grupo_permissao gp
			WHERE	gp.codigo_grupo = g.codigo
			AND		gp.codigo_permissao = p.codigo
			LIMIT	1
		)
		
UNION ALL

SELECT	g.codigo AS codigo_grupo
		, p.codigo AS codigo_permissao
FROM	permissao p
		INNER JOIN	grupo g
		ON			g.nome = 'Vendedores'
		AND			p.nome IN ('Realizar Orçamentos', 'Fechar Vendas')
WHERE	NOT EXISTS (
			SELECT	1
			FROM	grupo_permissao gp
			WHERE	gp.codigo_grupo = g.codigo
			AND		gp.codigo_permissao = p.codigo
			LIMIT	1
		);

-- Ligação entre grupo e usuários	
INSERT INTO usuario_grupo (codigo_usuario, codigo_grupo)
SELECT	u.codigo AS codigo_usuario
		, g.codigo AS codigo_grupo
FROM	usuario u
		INNER JOIN	grupo g
		ON			g.nome = CASE WHEN (u.nome LIKE 'Julia%') THEN 'Vendedores' 
								WHEN (u.nome LIKE 'Luana%') THEN 'Gerentes' 
								ELSE 'Administradores' END
WHERE	NOT EXISTS (
			SELECT	1
			FROM	usuario_grupo ug
			WHERE	ug.codigo_grupo = g.codigo
			AND		ug.codigo_usuario = u.codigo
			LIMIT	1
		);

	
/*********************************************************
 * GRUPO DE INFORMAÇÕES 2: Cliente, Cidade, Estado       *
 *********************************************************/
INSERT INTO estado (nome, sigla) VALUES ('Mato Grosso', 'MT'), ('Sao Paulo', 'SP'), ('Rio de Janeiro', 'RJ'), ('Parana', 'PR'), ('Minas Gerais', 'MG');

INSERT INTO cidade (nome, codigo_estado) 
SELECT	CASE sigla
			WHEN 'MT' THEN 'Cuiaba'
			WHEN 'MG' THEN 'Belo Horizonte'
			WHEN 'PR' THEN 'Curitiba'
			ELSE nome
		END AS nome
		, codigo
FROM	estado;

INSERT INTO cliente (nome, tipo_pessoa, cpf_cnpj, telefone, email, logradouro, numero, complemento, cep, codigo_cidade)
VALUES ('Andre Rocha Lima', 'FISICA', '400.941.029-96', '(63) 2863-7280', 'andrerochalima@armyspy.com', 'Rua dos Corretores', '105', 'Frente ao Correio', '77809-350', (SELECT codigo FROM cidade ORDER	BY random() LIMIT 1))
	, ('Giovanna Cardoso Fernandes', 'FISICA', '575.415.297-37', '(27) 6939-2155', 'giovannacardosofernandes@armyspy.com', 'Travessa Sao Paulo', '90', 'Lado Esquerdo', '29101-305', (SELECT codigo FROM cidade ORDER	BY random() LIMIT 1))
	, ('Leonor Ferreira Carvalho', 'FISICA', '897.574.394-28', '(41) 5999-8143', 'leonorferreiracarvalho@rhyta.com', 'Rua E', '379', 'Apt 290', '83601-275', (SELECT codigo FROM cidade ORDER	BY random() LIMIT 1))
;

	
/*********************************************************
 * GRUPO DE INFORMAÇÕES 3: Cervejas e Estilos            *
 *********************************************************/
INSERT INTO estilo (nome) VALUES ('Pilsen'), ('Red Ale'), ('Strong Golden Ale'), ('Marzen'), ('Bock'), ('Altbier'), ('Porter'), ('Stout'), ('Weizenbier'), ('Witbier');

INSERT into cerveja (sku, nome, descricao, valor, teor_alcoolico, comissao, sabor, origem, codigo_estilo, quantidade_estoque, foto, content_type)
VALUES ('CAC-LT-350-PIL' /*sku*/
			, 'Ampolis Cacildis do Mussum' /*nome*/
			, 'A Cacildis é uma cerveja artesanal criada para homenagear o eterno humorista Mussum. Uma puro malte de coloração dourada e com líquido cristalino. Apresenta em sua receita, aromas com um frescor floral e remetem ao miolo de pão, proveniente do malte. É uma cerveja leve e refrescante que te fará pedir mais um gole. Saúdis!' /*descricao*/
			, 9.98 /*valor*/
			, 5.00 /*teor*/
			, 5.00 /*comissao*/
			, 'AMARGOR: Moderado' /*sabor*/
			, 'Rio de Janeiro - RJ'/*origem*/
			, (SELECT codigo FROM estilo WHERE nome = 'Pilsen' LIMIT 1) /*codigo_estilo*/
			, (random() * 1000) /*quantidade_estoque*/
			, 'https://clubedomalte.fbitsstatic.net/img/p/ampolis-cacildis-do-mussum-lata-350ml-88426/255483.jpg' /*foto*/
			, 'image/jpeg' /*content_type*/
		),
		('DAR-LN-600-RAL' /*sku*/
			, 'Dado Bier Red Ale' /*nome*/
			, 'A DaDo Bier Red Ale é uma Irish Red Ale encorpada, de sabor marcante, amargor pronunciado, cor vermelha aveludada e aroma de mel e caramelo. É elaborada com lúpulos importados cuidadosamente selecionados e um blend de cinco maltes de cevada, extraindo assim o máximo do seu estilo. Intensa como uma noite em um pub irlandês, a nossa Red Ale foi premiada com as medalhas de prata e bronze no South BeerCup.' /*descricao*/
			, 13.90 /*valor*/
			, 5.30 /*teor*/
			, 5.00 /*comissao*/
			, 'AMARGOR: Moderado' /*sabor*/
			, 'Porto Alegre - RS'/*origem*/
			, (SELECT codigo FROM estilo WHERE nome = 'Red Ale' LIMIT 1) /*codigo_estilo*/
			, (random() * 1000) /*quantidade_estoque*/
			, 'https://clubedomalte.fbitsstatic.net/img/p/dado-bier-red-ale-garrafa-600ml-63348/230201.jpg' /*foto*/
			, 'image/jpeg' /*content_type*/
		),
		('DUV-LN-300-SGA' /*sku*/
			, 'Duvel' /*nome*/
			, 'Originalmente batizada de Victory Ale, para homenagear e comemorar o fim da primeira guerra mundial, esta cerveja teve seu nome alterado, devido a sua graduação alcoólica. A Duvel é uma cerveja do estilo Belgian Strong Golden Ale, única, com alta carbonatação, ácida e com um dulçor exclusivo. Possui ainda aromas intenso de frutas cristalizadas e a sensação alcoólica desta cerveja é facilmente detectada no paladar.' /*descricao*/
			, 26.90 /*valor*/
			, 8.50 /*teor*/
			, 10.00 /*comissao*/
			, 'AMARGOR: Alto' /*sabor*/
			, 'Breendonkdorp - Bélgica'/*origem*/
			, (SELECT codigo FROM estilo WHERE nome = 'Strong Golden Ale' LIMIT 1) /*codigo_estilo*/
			, (random() * 1000) /*quantidade_estoque*/
			, 'https://clubedomalte.fbitsstatic.net/img/p/duvel-garrafa-330ml-63731/230584.jpg' /*foto*/
			, 'image/jpeg' /*content_type*/
		)
;		
	
/*********************************************************
 * GRUPO DE INFORMAÇÕES 4: Vendas e Itens                *
 *********************************************************/
INSERT INTO venda (valor_frete, valor_total, observacao, codigo_cliente, codigo_usuario)
SELECT	CASE es.sigla 
			WHEN 'MT' THEN 0
			WHEN 'MG' THEN 15.00
			ELSE 30.00 
		END AS valor_frete
		, 0 AS valor_total 
		, CASE WHEN (es.sigla = 'MT') THEN 'Entregar gelado' END AS observacao
		, cl.codigo AS codigo_cliente
		, u.codigo AS codigo_usuario
FROM	cliente cl
		INNER JOIN	cidade cd
		ON			cd.codigo = cl.codigo_cidade 
		
		INNER JOIN	estado es
		ON			es.codigo = cd.codigo_estado 
		
		INNER JOIN	usuario u 
		ON			u.codigo IS NOT NULL
		
		INNER JOIN	usuario_grupo ug
		ON			ug.codigo_usuario = u.codigo 
		
		INNER JOIN	grupo g
		ON			g.codigo = ug.codigo_grupo

WHERE	g.nome IN ('Vendedores', 'Gerentes')
ORDER	BY u.codigo
		, random()
LIMIT	5;

--Itens de venda
INSERT INTO item_venda (quantidade, valor_unitario, codigo_cerveja, codigo_venda)
SELECT	random() * 100 AS quantidade
		, c.valor AS valor_unitario
		, c.codigo AS codigo_cerveja
		, v.codigo AS codigo_venda
FROM	cerveja c 
		INNER JOIN	venda v
		ON			v.codigo IS NOT NULL
WHERE	(random() * 100) > 30
ORDER	BY v.codigo;

--Valores das vendas baseado nos itens
UPDATE	venda
SET		valor_desconto = calc.valor_desconto
		, valor_total = calc.valor_total
		, status = calc.status
FROM	(
			SELECT	SUM(COALESCE(iv.quantidade) * COALESCE(iv.valor_unitario)) * (
							CASE WHEN EXISTS (
									SELECT	1
									FROM	usuario_grupo ug
											INNER JOIN	grupo_permissao gp 
											ON			gp.codigo_grupo = ug.codigo_grupo
											
											INNER JOIN	permissao p 
											ON			p.codigo = gp.codigo_permissao
									WHERE	ug.codigo_usuario = v.codigo_usuario
									AND		p.nome = 'Desconto maior que 20%'
									LIMIT	1
								) 
								THEN 0.25 
								ELSE 
									CASE	
										WHEN ((random() * 100) > 70) THEN 0.25
										WHEN ((random() * 100) > 50) THEN 0.15
										WHEN ((random() * 100) > 30) THEN 0.05
										ELSE 0
									END
								END 
						) AS valor_desconto
					, SUM(COALESCE(iv.quantidade) * COALESCE(iv.valor_unitario)) AS valor_total
					, CASE WHEN (SUM(COALESCE(iv.quantidade) * COALESCE(iv.valor_unitario)) <= 0) THEN 'CANCELADA' ELSE 'EMSEPARACAO' END AS status
					, iv.codigo_venda
			FROM	item_venda iv
					INNER JOIN	venda v
					ON			v.codigo = iv.codigo_venda 
					
			GROUP	BY iv.codigo_venda 
						, v.codigo_usuario
		) AS calc
WHERE	venda.codigo = calc.codigo_venda
AND		venda.status = 'EMABERTO';
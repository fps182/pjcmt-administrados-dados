/*9) Escreva uma sentença SQL que exiba uma lista das cervejas vendidas ordenadas primeiramente pela quantidade de vendas. 
 * É imprescindível que nesta lista apareça as cervejas que não tiveram vendas realizadas com o numeral zero;*/
CREATE VIEW uvw_cervejas_vendidas AS
SELECT	c.codigo 
		, c.nome
		, SUM(COALESCE(iv.quantidade, 0)) AS quantidade_unidades_vendidas
		, COUNT(v.codigo) AS quantidade_vendas_presente
FROM	cerveja c 
		LEFT JOIN	item_venda iv
		ON			iv.codigo_cerveja = c.codigo 
		
		LEFT JOIN	venda v
		ON			v.codigo =  iv.codigo_venda
		AND			v.status IN ('NOTAEMITIDA', 'EMSEPARACAO', 'FECHADA', 'EMABERTO')	
		
GROUP	BY c.codigo
		, c.nome
		
ORDER	BY 	SUM(COALESCE(iv.quantidade, 0))	DESC;

/*10) Escreva uma sentença SQL que exiba uma lista da quantidade de vendas realizadas pelos usuários por mês no corrente ano 
 * (Retornar nome do usuário, ano da venda, mês  da venda, quantidade vendida);*/
CREATE VIEW uvw_usuario_quantidade_vendas AS
SELECT	u.nome AS nome_usuario
		, EXTRACT(YEAR FROM v.data_criacao) AS ano_venda
		, EXTRACT(MONTH FROM v.data_criacao) AS mes_venda
		, COUNT(*) AS qtd_venda
FROM	venda v 
		INNER JOIN	usuario u
		ON			u.codigo =  v.codigo_usuario 
		
WHERE	EXTRACT(YEAR FROM v.data_criacao) = EXTRACT(YEAR FROM NOW())	
GROUP	BY u.nome
		, EXTRACT(YEAR FROM v.data_criacao)
		, EXTRACT(MONTH FROM v.data_criacao);

/*Escreva uma sentença SQL que exiba quanto de comissão em valores recebeu o primeiro usuário cadastrado em sua base de dados (normalmente com id 1) em razão das  vendas que realizou.*/
CREATE VIEW uvw_usuario_comissao_vendas AS
WITH dados_venda AS (
	SELECT	v.valor_total 
			, (iv.quantidade * iv.valor_unitario) AS valor_total_item_na_venda
			, COALESCE(v.valor_desconto, 0) AS valor_desconto
			, (c.comissao / 100) AS percentual_comissao
			, ((iv.quantidade * iv.valor_unitario) / v.valor_total) AS percentual_do_item_na_venda
			, v.codigo_usuario
	FROM	venda v 
			INNER JOIN	item_venda iv
			ON			iv.codigo_venda = v.codigo
			
			INNER JOIN	cerveja c
			ON			c.codigo =  iv.codigo_cerveja
			
	WHERE	v.codigo_usuario = 1
	AND		v.status IN ('NOTAEMITIDA', 'EMSEPARACAO', 'FECHADA', 'EMABERTO')
)
SELECT	dv.codigo_usuario
		, u.nome AS vendedor
		, ROUND(SUM((valor_total_item_na_venda - (valor_desconto * percentual_do_item_na_venda)) * percentual_comissao), 2) AS valor_comissao
FROM	dados_venda dv
		INNER JOIN	usuario u
		ON			u.codigo = dv.codigo_usuario
GROUP	BY dv.codigo_usuario
		, u.nome;
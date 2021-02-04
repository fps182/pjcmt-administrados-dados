CREATE MATERIALIZED VIEW uvw_estilo_cervejas_por_cliente AS 
WITH estilos AS (
	SELECT	v.codigo_cliente
			, es.nome
			, SUM(COALESCE(iv.quantidade, 0)) AS quantidade
	FROM	venda v 
			INNER JOIN	item_venda iv 
			ON			iv.codigo_venda = v.codigo
			
			INNER JOIN	cerveja cv 
			ON			cv.codigo = iv.codigo_cerveja
			
			INNER JOIN	estilo es
			ON			es.codigo = cv.codigo_estilo
			
	WHERE	v.status IN ('NOTAEMITIDA', 'EMSEPARACAO', 'FECHADA', 'EMABERTO')
	GROUP	BY v.codigo_cliente
			, es.nome
)

SELECT	cl.nome AS nome_cliente
		, string_agg(es.nome, ', ' ORDER BY es.quantidade DESC) AS nome_estilos
FROM	cliente cl 
		LEFT JOIN	estilos es 
		ON			es.codigo_cliente = cl.codigo 
GROUP	BY cl.nome;
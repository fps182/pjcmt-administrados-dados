/* Os indexes de PK e FK já foram criados anteriormente.
	Criando possíveis indexes de busca mais populares:
		* Clientes por nome, tipo de pessoa, cpf/cnpj;
		* Vendas por data, status para um cliente/vendedor específico;
		* Cerveja por valor, comissão e teor alcoolico;
		* Itens Venda por quantidade e cerveja;
*/

CREATE INDEX cliente_hotsearch_idx ON cliente (nome, tipo_pessoa, cpf_cnpj );
CREATE INDEX venda_hotsearch_idx ON venda (data_criacao, status, data_hora_entrega, codigo_cliente, codigo_usuario);
CREATE INDEX cerveja_hotsearch_idx ON cerveja (valor, teor_alcoolico, comissao);
CREATE INDEX itensvenda_hotsearch_idx ON item_venda (quantidade, codigo_cerveja, codigo_venda);
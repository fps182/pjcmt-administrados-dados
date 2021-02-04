/*Etapa 2, Passo 6 */
CREATE USER usr_relatorio WITH ENCRYPTED PASSWORD 'secreta';

/*Etapa 2 Passo 7 */
REVOKE ALL PRIVILEGES ON DATABASE conveniencia FROM usr_relatorio;

/*Etapa 2 Passo 8*/
GRANT CONNECT ON DATABASE conveniencia TO usr_relatorio;

GRANT SELECT ON uvw_estilo_cervejas_por_cliente TO usr_relatorio;
GRANT SELECT ON venda_auditoria TO usr_relatorio;
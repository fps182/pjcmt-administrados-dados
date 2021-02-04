CREATE TABLE venda_auditoria (
                codigo BIGINT NOT NULL,
                data_criacao TIMESTAMP NOT NULL,
                valor_frete NUMERIC(10,2),
                valor_desconto NUMERIC(10,2),
                valor_total NUMERIC(10,2) NOT NULL,
                status VARCHAR(30) NOT NULL,
                observacao VARCHAR(200),
                data_hora_entrega TIMESTAMP,
                codigo_cliente BIGINT NOT NULL,
                codigo_usuario BIGINT NOT NULL,
                aud_data_operacao TIMESTAMP DEFAULT now() NOT NULL,
                aud_tipo_operacao VARCHAR(1) NOT NULL CHECK (aud_tipo_operacao = 'C' OR aud_tipo_operacao = 'U' OR aud_tipo_operacao = 'D'),
                aud_usuario_banco VARCHAR(65) NOT NULL,
                aud_ip VARCHAR(30),
                aud_host VARCHAR(100),
                aud_aplicacao_nome VARCHAR(250)

);
COMMENT ON COLUMN venda_auditoria.aud_tipo_operacao IS 'C:CREATE | U:UPDATE | D:DELETE';

/*******************
* TRIGGER FUNCTION *
********************/
CREATE OR REPLACE FUNCTION audit_venda() RETURNS TRIGGER AS $$
    BEGIN
        IF (TG_OP = 'DELETE') THEN
            INSERT  INTO venda_auditoria 
            SELECT  OLD.*
                    , NOW() AS aud_data_operacao
                    , 'D' AS aud_tipo_operacao
                    , usename
                    , client_addr
                    , client_hostname
                    , application_name
            FROM	pg_stat_activity 
            WHERE	pid = pg_backend_pid();

            RETURN OLD;

        ELSIF (TG_OP = 'UPDATE') THEN
            INSERT  INTO venda_auditoria 
            SELECT  NEW.*
                    , NOW() AS aud_data_operacao
                    , 'U' AS aud_tipo_operacao
                    , usename
                    , client_addr
                    , client_hostname
                    , application_name
            FROM	pg_stat_activity 
            WHERE	pid = pg_backend_pid();

            RETURN NEW;

        ELSIF (TG_OP = 'INSERT') THEN
            INSERT  INTO venda_auditoria 
            SELECT  NEW.*
                    , NOW() AS aud_data_operacao
                    , 'C' AS aud_tipo_operacao
                    , usename
                    , client_addr
                    , client_hostname
                    , application_name
            FROM	pg_stat_activity 
            WHERE	pid = pg_backend_pid();

            RETURN NEW;
        END IF;
        RETURN NULL;
    END;
$$ LANGUAGE plpgsql;



/*******************
*      TRIGGER     *
********************/
CREATE TRIGGER CRUD_VENDAS_AUDIT
AFTER INSERT OR UPDATE OR DELETE ON venda
    FOR EACH ROW EXECUTE PROCEDURE audit_venda();
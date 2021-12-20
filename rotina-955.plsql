--Início da Separação
--(Inserir número do pedido)
SELECT DISTINCT PCPEDC.NUMPED, -- Número do pedido                                                                                                              
                PCPEDC.POSICAO, -- Posição do pedido                                                                                                             
                DECODE(TRUNC(PCPEDC.DTINICIALSEP), TO_DATE('30-12-1899','DD-MM-YYYY'), NULL, TRUNC(PCPEDC.DTINICIALSEP)) DTINICIALSEP, -- Data Inicial da separação
                DECODE(TRUNC(PCPEDC.DTFINALSEP), TO_DATE('30-12-1899','DD-MM-YYYY'), NULL, TRUNC(PCPEDC.DTFINALSEP)) DTFINALSEP, -- Data final da separação 
                PCPEDI.CODFUNCSEP, -- Código funcinário                                                                                                    
                PCPEDC.ORIGEMPED,  -- Origem do pedido                                                                                                        
                NVL(PCPEDC.NUMVIASMAPASEP, 0) NUMVIASMAPASEP  -- Número de vias de mapa de SEP impressas                                                                             
  FROM PCPEDC, PCPEDI                                                                                                                      
 WHERE PCPEDI.NUMPED = PCPEDC.NUMPED                                                                                                       
   AND PCPEDC.NUMPED = :NUMPED -- Número pedido a ser inserido

-- (Cancelar inicio\finalização de expedição) 
-- SELECT 1         
--   FROM PCPEDC             
--  WHERE NUMPED = :NUMPED   
--    AND POSICAO = :POSICAO 
   
--(Inserir código de separador)
	--(Nome do Separador)
 SELECT MATRICULA CODFUNCSEP -- Código de matricula do separador
     , NOME SEPARADOR -- Nome do separador
  FROM PCEMPR
 WHERE TIPOVENDA = 'S' -- Saida NORMAL
      AND NVL(SITUACAO, 'A') = 'A' -- Situação funcionario - ATIVO
 AND NOME LIKE :PARAM1 || '%' ORDER BY NOME --
 
	--(Código do Separador)
SELECT MATRICULA CODFUNCSEP -- Código de matricula do separador
     , NOME SEPARADOR -- Nome do separador
  FROM PCEMPR
 WHERE TIPOVENDA = 'S' -- Saida NORMAL
      AND NVL(SITUACAO, 'A') = 'A' -- Situação funcionario - ATIVO
 AND TO_CHAR(MATRICULA) = :PARAM1 ORDER BY NOME
 
--(Adicionar DataInicialSeparação)
	--(PCPEDC)
UPDATE PCPEDC 
 SET DTINICIALSEP = SYSDATE -- Inseri data inicial da separação
      ,CODFUNCSEP = :CODFUNCSEP -- Inseri codigo do funcionario
WHERE NUMPED=:NUMPED 
	--(PCPEDI)
UPDATE PCPEDI 
   SET CODFUNCSEP = :CODFUNCSEP 
    ,DTINICIALSEP = SYSDATE
WHERE NUMPED=:NUMPED


------------------------------------------------------------------

--Final da Separação
--(Inserir número do pedido)
 SELECT DISTINCT PCPEDC.NUMPED, -- Número do pedido                                                                                                               
                PCPEDC.POSICAO, -- Posição do pedido                                                                                                       
                DECODE(TRUNC(PCPEDC.DTINICIALSEP), TO_DATE('30-12-1899','DD-MM-YYYY'), NULL, TRUNC(PCPEDC.DTINICIALSEP)) DTINICIALSEP, -- Data inicial do pedido
                DECODE(TRUNC(PCPEDC.DTFINALSEP), TO_DATE('30-12-1899','DD-MM-YYYY'), NULL, TRUNC(PCPEDC.DTFINALSEP)) DTFINALSEP, -- Data final do pedido
                PCPEDI.CODFUNCSEP, -- Codigo do funcionario                                                                                                     
                PCPEDC.ORIGEMPED,  -- Origem do pedido                                                                                                       
                NVL(PCPEDC.NUMVIASMAPASEP, 0) NUMVIASMAPASEP  -- Número de vias de mapa de SEP impressas                                                                              
  FROM PCPEDC, PCPEDI                                                                                                                      
 WHERE PCPEDI.NUMPED = PCPEDC.NUMPED                                                                                                       
   AND PCPEDC.NUMPED = :NUMPED  -- Número do pedido a ser inserido

-- (Cancelar inicio\finalização de expedição) 
--    SELECT 1                  
--   FROM PCPEDC             
--  WHERE NUMPED = :NUMPED   
--    AND POSICAO = :POSICAO
   
-- (Retornando resultado da pesquisa - separador vinculado ao pedido)  
  SELECT MATRICULA CODFUNCSEP -- Codigo de matricula do separador
     , NOME SEPARADOR -- Nome do separador
  FROM PCEMPR
 WHERE TIPOVENDA = 'S' -- Saida NORMAL
      AND NVL(SITUACAO, 'A') = 'A' -- Situação funcionario - ATIVO
 AND TO_CHAR(MATRICULA) = :PARAM1 ORDER BY NOME
   
   --(Adicionar DataFinalSeparação)
	--(PCPEDC)
UPDATE PCPEDC 
 SET DTFINALSEP = SYSDATE -- Inseri data final da separação
      ,CODFUNCSEP = :CODFUNCSEP -- Inseri codigo do funcionario
WHERE NUMPED=:NUMPED

	--(PCPEDI)
UPDATE PCPEDI 
   SET CODFUNCSEP = :CODFUNCSEP 
    ,DTFINALSEP = SYSDATE 
WHERE NUMPED=:NUMPED -- Inseri número do pedido
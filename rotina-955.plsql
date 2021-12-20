--Início da Separação
--(Inserir número do pedido)
SELECT DISTINCT PCPEDC.NUMPED, -- Número do pedido                                                                                                              
                PCPEDC.POSICAO, -- Posição do pedido                                                                                                             
                DECODE(TRUNC(PCPEDC.DTINICIALSEP), TO_DATE('30-12-1899','DD-MM-YYYY'), NULL, TRUNC(PCPEDC.DTINICIALSEP)) DTINICIALSEP, 
                DECODE(TRUNC(PCPEDC.DTFINALSEP), TO_DATE('30-12-1899','DD-MM-YYYY'), NULL, TRUNC(PCPEDC.DTFINALSEP)) DTFINALSEP,       
                PCPEDI.CODFUNCSEP,                                                                                                         
                PCPEDC.ORIGEMPED,                                                                                                          
                NVL(PCPEDC.NUMVIASMAPASEP, 0) NUMVIASMAPASEP                                                                               
  FROM PCPEDC, PCPEDI                                                                                                                      
 WHERE PCPEDI.NUMPED = PCPEDC.NUMPED                                                                                                       
   AND PCPEDC.NUMPED = :NUMPED

SELECT 1                  
  FROM PCPEDC             
 WHERE NUMPED = :NUMPED   
   AND POSICAO = :POSICAO
   
--(Inserir código de separador)
	--(Nome do Separador)
 SELECT MATRICULA CODFUNCSEP
     , NOME SEPARADOR
  FROM PCEMPR
 WHERE TIPOVENDA = 'S'
      AND NVL(SITUACAO, 'A') = 'A'
 AND NOME LIKE :PARAM1 || '%' ORDER BY NOME
 
	--(Código do Separador)
SELECT MATRICULA CODFUNCSEP
     , NOME SEPARADOR
  FROM PCEMPR
 WHERE TIPOVENDA = 'S'
      AND NVL(SITUACAO, 'A') = 'A'
 AND TO_CHAR(MATRICULA) = :PARAM1 ORDER BY NOME
 
--(Adicionar DataInicialSeparação)
	--(PCPEDC)
UPDATE PCPEDC 
 SET DTINICIALSEP = SYSDATE 
      ,CODFUNCSEP = :CODFUNCSEP 
WHERE NUMPED=:NUMPED
	--(PCPEDI)
UPDATE PCPEDI 
   SET CODFUNCSEP = :CODFUNCSEP 
    ,DTINICIALSEP = SYSDATE 
WHERE NUMPED=:NUMPED


------------------------------------------------------------------

--Final da Separação
--(Inserir número do pedido)
 SELECT DISTINCT PCPEDC.NUMPED,                                                                                                               
                PCPEDC.POSICAO,                                                                                                            
                DECODE(TRUNC(PCPEDC.DTINICIALSEP), TO_DATE('30-12-1899','DD-MM-YYYY'), NULL, TRUNC(PCPEDC.DTINICIALSEP)) DTINICIALSEP, 
                DECODE(TRUNC(PCPEDC.DTFINALSEP), TO_DATE('30-12-1899','DD-MM-YYYY'), NULL, TRUNC(PCPEDC.DTFINALSEP)) DTFINALSEP,       
                PCPEDI.CODFUNCSEP,                                                                                                         
                PCPEDC.ORIGEMPED,                                                                                                          
                NVL(PCPEDC.NUMVIASMAPASEP, 0) NUMVIASMAPASEP                                                                               
  FROM PCPEDC, PCPEDI                                                                                                                      
 WHERE PCPEDI.NUMPED = PCPEDC.NUMPED                                                                                                       
   AND PCPEDC.NUMPED = :NUMPED
   
   SELECT 1                  
  FROM PCPEDC             
 WHERE NUMPED = :NUMPED   
   AND POSICAO = :POSICAO
   
-- (Retornando resultado da pesquisa - separador vinculado ao pedido)  
  SELECT MATRICULA CODFUNCSEP
     , NOME SEPARADOR
  FROM PCEMPR
 WHERE TIPOVENDA = 'S'
      AND NVL(SITUACAO, 'A') = 'A'
 AND TO_CHAR(MATRICULA) = :PARAM1 ORDER BY NOME
   
   --(Adicionar DataFinalSeparação)
	--(PCPEDC)
UPDATE PCPEDC 
 SET DTFINALSEP = SYSDATE 
      ,CODFUNCSEP = :CODFUNCSEP 
WHERE NUMPED=:NUMPED

	--(PCPEDI)
UPDATE PCPEDI 
   SET CODFUNCSEP = :CODFUNCSEP 
    ,DTFINALSEP = SYSDATE 
WHERE NUMPED=:NUMPED
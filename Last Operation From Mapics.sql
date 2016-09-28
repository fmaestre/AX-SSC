SELECT [Order], CAST(LastOP AS NVARCHAR) LastOP
FROM
(
	SELECT [Order],	MAX(CAST(Oper AS NUMERIC)) LastOP,
		   (SELECT MAX(CAST(Oper AS NUMERIC)) 
			 FROM [dbo].MAPICS AS i
			 WHERE i.[Order] = A.[Order]
		   ) [Max]
	FROM [dbo].MAPICS A
	WHERE Status = '40'	
	GROUP BY [Order]
) LAST_OP
WHERE  LAST_OP.LastOP <> [Max]
UNION
SELECT [Order], '' LastOP
FROM [dbo].MAPICS A
WHERE Status = ALL (SELECT status 
					FROM [dbo].MAPICS B
					WHERE B.[Order] = A.[Order]
				   )
      AND Status <> '40'
GROUP BY [Order]



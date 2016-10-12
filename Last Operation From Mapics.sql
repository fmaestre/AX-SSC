SELECT [Order], RIGHT(REPLICATE('0',4) + CAST(LastOP AS NVARCHAR),4) LastOP
FROM	(
			SELECT	[Order],	
					MAX(CAST(Oper AS NUMERIC))			LastOP,
					(	
						SELECT MAX(CAST(Oper AS NUMERIC)) 
						FROM [dbo].MAPICS AS i
						WHERE i.[Order] = A.[Order]
					)									[Max]
			FROM [dbo].MAPICS A
			WHERE status = '40'	
			GROUP BY [Order]
		) LAST_OP
WHERE  LAST_OP.LastOP <> [Max]
UNION
SELECT [Order], '' LastOP
FROM [dbo].MAPICS A
WHERE status = ALL (
						SELECT status 
						FROM [dbo].MAPICS B
						WHERE B.[Order] = A.[Order]
				   )
      AND status <> '40'
GROUP BY [Order]
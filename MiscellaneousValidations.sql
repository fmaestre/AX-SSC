------------------------------------------------------------------------------------
-- MTO COVERAGE GROUP ITEMS having Demand Forecast.
------------------------------------------------------------------------------------
SELECT ITEMID 
FROM InventTable it
WHERE REQGROUPID = 'MTO' --and itemid = '02-0238'
	  and exists (
				SELECT 1
				FROM     dbo.FORECASTSALES AS T1 
				WHERE (T1.ITEMID = it.ITEMID) and DATAAREAID = '220'
			)
ORDER BY 1
------------------------------------------------------------------------------------
-- COVERAGE GROUP TYPES WITH NO Demand Forecast.
------------------------------------------------------------------------------------
SELECT * FROM (
				SELECT  IT.ITEMID, 
						REQGROUPID COVERAGE_GROUP, 
						CASE iexp.ProductSubtype	WHEN 1 THEN 'PRODUCT' 
													WHEN 2 THEN 'PRODUCT MASTER'
													WHEN 3 THEN 'PRODUCT VARIANT'
													ELSE '' 
						 END SUBTYPE,
						COUNT(T1.ITEMID) DEMAND_FORECAST_LINES,
						(
							SELECT count(*)
							FROM     dbo.BOM		AS T1 INNER JOIN
									 dbo.bomversion AS T3 ON t1.BOMID = t3.BOMID 
							WHERE  (T1.ITEMID=IT.ITEMID)		
						) UsedOn
				FROM InventTable it LEFT JOIN dbo.FORECASTSALES AS T1 ON (T1.ITEMID = it.ITEMID) and T1.DATAAREAID = '220'
	 
					 LEFT JOIN 	INVENTTABLEEXPANDED			iexp  ON iexp.ItemId			= it.ITEMID
				WHERE ISNULL(REQGROUPID,'') <> '' 
					  AND IT.ITEMID NOT LIKE  '%OBSOLETE%'
					  AND REQGROUPID <> 'MTO'
				GROUP BY IT.ITEMID, REQGROUPID,IEXP.PRODUCTSUBTYPE	  
				HAVING COUNT(T1.ITEMID)  =0 AND PRODUCTSUBTYPE = 2
			   ) A
WHERE UsedOn = 0
ORDER BY 4 DESC
------------------------------------------------------------------------------------
-- WHERE USED
------------------------------------------------------------------------------------
SELECT distinct t3.ITEMID
FROM     dbo.BOM		AS T1 INNER JOIN
		 dbo.bomversion AS T3 ON t1.BOMID = t3.BOMID 
WHERE  (T1.ITEMID='01-0002')  
ORDER BY 1



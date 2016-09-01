
    SELECT       itemid,Route_id, 
				 LastAxOPeration,
				 CASE isnull(Nest_To_LastAxOPeration,-1)
					 WHEN -1 then LastAxOPeration
					 ELSE Nest_To_LastAxOPeration
				 END Nest_To_LastAxOPeration
	FROM(
			SELECT itemid,Route_id, LastAxOPeration, (SELECT MAX(OPRNUM) FROM ROUTE WHERE ROUTEID = A.Route_id and OPRNUM < LastAxOPeration ) Nest_To_LastAxOPeration
			FROM (
				   select rv.itemid,rv.ROUTEID Route_id, 
						  (SELECT MAX(OPRNUM) FROM ROUTE WHERE ROUTEID = ro.ROUTEID  ) LastAxOPeration
				   FROM RouteTable ro CROSS JOIN routeversion rv
				   WHERE  rv.APPROVED = 1 AND rv.ROUTEID = ro.ROUTEID
										  AND ACTIVE = 1
				 ) A
     ) B
      --where itemid = '20-0268'
	  --order by 1
	  except

    SELECT       itemid,Route_id, 
				 LastAxOPeration,
				 COALESCE (Next_To_LastAxOPeration,LastAxOPeration) Next_To_LastAxOPeration
	FROM(
			SELECT itemid,Route_id, LastAxOPeration, (SELECT MAX(OPRNUM) FROM ROUTE WHERE ROUTEID = A.Route_id and OPRNUM < LastAxOPeration ) Next_To_LastAxOPeration
			FROM (
				   SELECT rv.itemid,rv.ROUTEID Route_id, 
						  (SELECT MAX(OPRNUM) FROM ROUTE WHERE ROUTEID = ro.ROUTEID  ) LastAxOPeration
				   FROM RouteTable ro CROSS JOIN routeversion rv
				   WHERE  rv.APPROVED = 1 AND rv.ROUTEID = ro.ROUTEID
										  AND ACTIVE = 1
				 ) A
     ) B
	-- order by 1
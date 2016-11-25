select A.prodid,A.OPRNUM, A.OPRID, A.OPRFINISHED, 
          CASE PRODSTATUS
			 WHEN 0 THEN  'Created'
			 WHEN 1 THEN  'CostEstimated'
			 WHEN 2 THEN  'Scheduled'
			 WHEN 3 THEN  'Released'
			 WHEN 4 THEN  'StartedUp'
			 WHEN 5 THEN  'ReportedFinished'
			 WHEN 7 THEN  'Ended'
		END PRODSTATUS, MAX(DATEWIP) TransDate
from PRODROUTE  A 
INNER JOIN PRODTABLE P ON A.prodid = P.prodid	
LEFT JOIN ProdRouteTrans B ON A.prodid = TRANSREFID AND TRANSTYPE = 1 and A.OPRNUM = B.OPRNUM
group by A.OPRNUM, A.OPRNUM ,A.OPRID, A.prodid, ROUTEGROUPID, A.OPRFINISHED, QTYSTUP,PRODSTATUS
having   A.OPRFINISHED = 1
         AND A.OPRID  like '%sh%wrap%' 
		 --AND PRODSTATUS <> 7
order by 6 desc
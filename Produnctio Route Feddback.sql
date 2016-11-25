select A.prodid,A.OPRNUM, A.OPRNUM ,A.OPRID, ROUTEGROUPID, QTYSTUP, SUM(B.QTYGOOD) good, SUM(b.QTYERROR) Scrap , A.OPRFINISHED, 
    case PRODSTATUS when 7 then 'Ended' else 'Wip' end PRODSTATUS
from PRODROUTE  A 
INNER JOIN PRODTABLE P ON A.prodid = P.prodid	
LEFT JOIN ProdRouteTrans B ON A.prodid = TRANSREFID AND TRANSTYPE = 1 and A.OPRNUM = B.OPRNUM
--where A.prodid = 'MBSP460'
group by A.OPRNUM, A.OPRNUM ,A.OPRID, A.prodid, ROUTEGROUPID, A.OPRFINISHED, QTYSTUP,PRODSTATUS
having   (
			SUM(B.QTYGOOD + b.QTYERROR) <= 0 
			--			OR
			--QTYSTUP*1.1  <  SUM(B.QTYGOOD + b.QTYERROR) 
		 )
		 AND A.OPRFINISHED = 1
         AND A.OPRID not like '%RWK%' 
		 AND PRODSTATUS <> 7
order by 1
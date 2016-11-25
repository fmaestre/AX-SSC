Select POSTEDUSERID	, Name, count(*) QtyOrderWithMoreThan1ReportedAsFinished
  from 
	(
	SELECT PRODID, COUNT(PRODID) REPORTASFINISHED , POSTEDUSERID, NAME, MAX(PRODID) + ', ' + MIN(PRODID)   SAMPLES
	FROM PRODJOURNALTABLE T1 LEFT JOIN UserInfo ON id =  POSTEDUSERID
	WHERE JOURNALTYPE = 1 --and T1.NUMOFLINES > 1
	group by prodid,POSTEDUSERID, Name 
) A
Where reportAsFinished > 1
group by POSTEDUSERID	, Name
order by 3 desc
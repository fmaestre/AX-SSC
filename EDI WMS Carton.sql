--SELECT	asnid,
--		boxid,-- RIGHT(asnid,8) + CAST([lineno] AS VARCHAR) boxid,
--		sscc,
--		packweight,
--		mixed,
--		trackingno,
--		rfid,
--		orderno,
--		[lineno],
--		'' itemid, 
--		'' packqty, 
--		datareadid
--FROM (
		SELECT	hdr.packingslipid			AS asnid, 
				MAX(shp.leadtrackingnumber) AS boxid,  
				''							AS sscc, 
				ISNULL(MAX(shp.weight), 0)	AS packweight, 
				'N'							AS mixed, 
				shp.trackingnumber			AS trackingno, 
				''							AS rfid, 
				'' /*MAX(hdr.salesid)*/			AS orderno, 
				ROW_NUMBER() OVER (PARTITION BY hdr.packingslipid   ORDER BY shp.trackingnumber) AS [lineno], 
				''							AS itemid, 
				''							AS packqty, 
				MAX(hdr.dataareaid)			AS datareadid
		FROM	SHIPCARRIERSHIPPINGREQUEST AS hdr	WITH (NOLOCK)	LEFT OUTER JOIN 
				shipcarrierstaging	AS shp	WITH (NOLOCK)	ON hdr.packingslipid	= shp.packingslipid AND hdr.salesid = shp.salesid LEFT OUTER JOIN 
				salestable			AS so	WITH (NOLOCK)	ON hdr.salesid			= so.salesid
		WHERE so.edi856enable = 1 AND 
				EXISTS (	SELECT 1 
							FROM shipcarrierstaging shp2 WITH (NOLOCK) 
							WHERE shp.packingslipid = shp2.packingslipid AND shp.salesid = salesid and shipcarriervoidindicator <> 'Deleted'  
								  AND NOT EXISTS (	SELECT recid 
													FROM shipcarrierstaging WITH (NOLOCK) 
													WHERE	shp.packingslipid  = packingslipid	AND shp.salesid = salesid 
														AND shp.trackingnumber = trackingnumber	AND shipcarriervoidindicator = 'Y'
												  )
									  
					    )		       
			and hdr.PACKINGSLIPID = 'PS00033158'
		GROUP BY hdr.packingslipid, shp.trackingnumber
	/*) T1 LEFT JOIN
	(
		SELECT packingslipid,linenum,itemid, qty  
		FROM custpackingsliptrans 	WITH (NOLOCK) 
	) T2 ON packingslipid = asnid AND linenum = [lineno] */
--WHERE  T1.asnid = 'PS00032707'
ORDER BY 1 

--select * from EDIWMSCarton where asnid = 'PS00032707'

declare @packslip nvarchar(20) = 'PS00033158'
SELECT * from custpackingsliptrans where PACKINGSLIPID = @packslip
SELECT * from custpackingslipjour where PACKINGSLIPID = @packslip
SELECT * from shipcarrierstaging  where PACKINGSLIPID = @packslip
SELECT * FROM shipcarriershippingrequest WHERE  PACKINGSLIPID=@packslip


select * from shipcarriertracking where PACKINGSLIPID = @packslip
select * from shipcarrierpackage where PACKINGSLIPID = @packslip

select * from salestable where SALESID = 'S00026775'

select PACKINGSLIPID,DELIVERYDATE,count(*) 
from custpackingsliptrans a
where exists (select 1 from shipcarrierstaging  where PACKINGSLIPID = a.PACKINGSLIPID)
group by PACKINGSLIPID,DELIVERYDATE
order by DELIVERYDATE desc



SELECT hdr.PACKINGSLIPID AS asnid, MAX(shp.LEADTRACKINGNUMBER) AS boxid,  '' AS sscc, ISNULL(MAX(shp.WEIGHT), 0) AS packweight, 'N' AS mixed, shp.TRACKINGNUMBER AS trackingno, '' AS rfid, MAX(hdr.SALESID) AS 
orderno, ROW_NUMBER() OVER (PARTITION BY hdr.PACKINGSLIPID   ORDER BY shp.TRACKINGNUMBER) AS [lineno], '' AS ITEMID, '' AS packqty, MAX(hdr.DATAAREAID) AS DATAREADID
FROM CUSTPACKINGSLIPJOUR AS hdr WITH (NOLOCK) LEFT OUTER JOIN SHIPCARRIERSTAGING AS shp WITH (NOLOCK) ON 
hdr.PACKINGSLIPID = shp.PACKINGSLIPID AND hdr.SALESID = shp.SALESID LEFT OUTER JOIN SALESTABLE AS so WITH (NOLOCK)ON hdr.SALESID = so.SALESID
WHERE so.EDI856ENABLE = 1 and (EXISTS (SELECT RECID FROM SHIPCARRIERSTAGING WITH (NOLOCK) 
       WHERE (shp.PACKINGSLIPID = PACKINGSLIPID) AND (shp.SALESID = SALESID) AND (SHIPCARRIERVOIDINDICATOR <> 'Deleted')  AND 
      (NOT EXISTS (SELECT RECID FROM SHIPCARRIERSTAGING WITH (NOLOCK) 
       WHERE (shp.PACKINGSLIPID = PACKINGSLIPID) AND (shp.SALESID = SALESID) AND (shp.TRACKINGNUMBER =  TRACKINGNUMBER) AND (SHIPCARRIERVOIDINDICATOR = 'Y')))))
	   AND  hdr.PACKINGSLIPID = 'PS00033158'
GROUP BY hdr.PACKINGSLIPID, shp.TRACKINGNUMBER
ORDER BY hdr.PACKINGSLIPID

--ShipCarrierTracking where PACKINGSLIPID = 'PS00027777'
--ShipCarrierPackage where PACKINGSLIPID = 'PS00027777'







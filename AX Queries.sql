--******************************************************************************************
-- PRODUCTION ORDERS
--******************************************************************************************
--[PRODTABLE]
--[PRODBOM]
--[PRODROUTE]
--[PRODROUTEJOB]
--******************************************************************************************
-- RELEASED PRODUCTS
--******************************************************************************************
	SELECT	it.ITEMID, SEARCHNAME, NAME, 
			CASE eprd.ProductType	WHEN 1 THEN 'ITEM' 
									ELSE 'Service' 
			END Type,
			CASE iexp.ProductSubtype	WHEN 1 THEN 'PRODUCT' 
										WHEN 2 THEN 'PRODUCT MASTER'
										WHEN 3 THEN 'PRODUCT VARIANT'
										ELSE '' 
			END SubType,
			it.ItemClassId 
	FROM	ECORESPRODUCT				eprd, 
			INVENTTABLE					it, 
			ECORESPRODUCTTRANSLATION	trans, 
			INVENTTABLEEXPANDED			iexp
	WHERE eprd.DISPLAYPRODUCTNUMBER = it.ITEMID 
		 -- AND it.ITEMID				= 'RA-1033Q'
		  AND trans.PRODUCT			= it.PRODUCT 
		  AND iexp.ItemId			= it.ITEMID
--******************************************************************************************
-- RELEASED PRODUCTS WHOLE
--******************************************************************************************
SELECT 
		*
FROM	INVENTTABLE							T1																										LEFT OUTER JOIN 
		INVENTMODELGROUPITEM				T3	ON ((T3.PARTITION=T1.PARTITION) AND ((T1.ITEMID=T3.ITEMID) AND (T1.DATAAREAID=T3.ITEMDATAAREAID)))	LEFT OUTER JOIN 
		INVENTITEMGROUPITEM					T4	ON ((T4.PARTITION=T1.PARTITION) AND ((T1.ITEMID=T4.ITEMID) AND (T1.DATAAREAID=T4.ITEMDATAAREAID)))	LEFT OUTER JOIN 
		ECORESTRACKINGDIMENSIONGROUPITEM	T5	ON ((T5.PARTITION=T1.PARTITION) AND ((T1.ITEMID=T5.ITEMID) AND (T1.DATAAREAID=T5.ITEMDATAAREAID)))	LEFT OUTER JOIN 
		ECORESSTORAGEDIMENSIONGROUPITEM		T6	ON ((T6.PARTITION=T1.PARTITION) AND ((T1.ITEMID=T6.ITEMID) AND (T1.DATAAREAID=T6.ITEMDATAAREAID)))	CROSS JOIN 
		ECORESPRODUCT						T7																										LEFT OUTER JOIN 
		ECORESPRODUCTDIMENSIONGROUPPRODUCT	T8	ON ((T8.PARTITION=T1.PARTITION) AND (T7.RECID=T8.PRODUCT))											LEFT OUTER JOIN 
		ECORESPRODUCTTRANSLATION			T9	ON ((T9.PARTITION=T1.PARTITION) AND ((T9.LANGUAGEID='en-us') AND (T7.RECID=T9.PRODUCT)))			LEFT OUTER JOIN 
		ECORESPRODUCTDIMENSIONGROUP			T10 ON ((T10.PARTITION=T1.PARTITION) AND (T8.PRODUCTDIMENSIONGROUP=T10.RECID)) 
WHERE ((T1.PARTITION=5637144576) AND (T1.DATAAREAID=220)) AND ((T7.PARTITION=T1.PARTITION) AND (T1.PRODUCT=T7.RECID)) 
ORDER BY T1.ITEMID OPTION(FAST 7)
--******************************************************************************************
-- ONHAND NOT CLOSED
--******************************************************************************************
SELECT  
		T1.ITEMID					AS [ITEM NUMBER], 
		T2.INVENTLOCATIONID			AS WH, 
        T2.INVENTBATCHID			AS BATCH, 
		T2.WMSLOCATIONID			AS LOC, 
		T3.NAMEALIAS				AS [SEARCH NAME],
		SUM(T1.POSTEDQTY)			AS [POSTED QUANTITY],    
		SUM(T1.POSTEDVALUE)			AS [FINANCIAL COST AMOUNT],  
		SUM(T1.PHYSICALVALUE)		AS [PHYSICAL COST AMOUNT], 
		SUM(T1.DEDUCTED)			AS DEDUCTED, 
		SUM(T1.REGISTERED)			AS REGISTERED, 
		SUM(T1.RECEIVED)			AS RECEIVED, 
		SUM(T1.PICKED)				AS PICKED, 
		SUM(T1.RESERVPHYSICAL)		AS [PHYSICAL RESERVED], 
		SUM(T1.RESERVORDERED)		AS [ORDERED RESERVED], 
        SUM(T1.ONORDER)				AS [ON ORDER], 
		SUM(T1.ORDERED)				AS ORDERED, 
		SUM(T1.ARRIVED)				AS ARRIVED, 
		SUM(T1.QUOTATIONRECEIPT)	AS [QUOTATION RECEIPT], 
		SUM(T1.QUOTATIONISSUE)		AS [QUOTATION ISSUE], 
		SUM(T1.PHYSICALINVENT)		AS [PHYSICAL INVENTORY], 
		SUM(T1.AVAILPHYSICAL)		AS [AVAILABLE PHYSICAL], 
		SUM(T1.AVAILORDERED)		AS [AVAILABLE ORDERED]
FROM    dbo.INVENTSUM	AS T1									 INNER JOIN
        dbo.INVENTDIM	AS T2 ON T1.INVENTDIMID = T2.INVENTDIMID INNER JOIN
        dbo.INVENTTABLE AS T3 ON T1.ITEMID		= T3.ITEMID
WHERE       (T1.PARTITION	= 5637144576) 
		AND (T1.DATAAREAID	= 220) 
		AND (T1.CLOSED		= 0) 
		AND (T2.PARTITION = T1.PARTITION) AND (T2.DATAAREAID =T1.DATAAREAID)
		AND (T3.PARTITION = T1.PARTITION) AND (T3.DATAAREAID =T1.DATAAREAID)
GROUP BY T1.ITEMID, T2.INVENTLOCATIONID, T2.INVENTBATCHID, T2.WMSLOCATIONID, T3.NAMEALIAS
ORDER BY T1.ITEMID OPTION (FAST 9)
--******************************************************************************************
-- WAREHOUSE
--****************************************************************************************** 
 SELECT * FROM InventLocation --WH TABLE --INVENTLOCATIONTYPE 0 STD 1 QRT 2 TRANSIT
 WHERE INVENTLOCATIONTYPE = 1
--******************************************************************************************
-- LOCATIONS
--****************************************************************************************** 
  SELECT * FROM WMSLocation
--******************************************************************************************
-- ALL PRODUCTONS ORDERS

  --PRODSTATUS: 0 Created, 1 CostEstimated, 2 Scheduled, 3 Released, 4 StartedUp, 5 ReportedFinished, 7 Completed. 
  --PRODPOOLID: Pool
  --ROUTEID
  --Ramain Status = BackorderStatus
--****************************************************************************************** 
---------------------------------------------------------------------------------------------------------------
-- CREATED DATE + QTY OF ORDERS
---------------------------------------------------------------------------------------------------------------
  SELECT   cast(CREATEDDATETIME as date) Created_Date, count(*) Qty_Of_Orders
    FROM PRODTABLE T1 WHERE (((PARTITION=5637144576) AND (DATAAREAID=220))) --AND (PRODID='MBMW540')
                     AND CREATEDDATETIME > getdate() -8
  GROUP BY cast(CREATEDDATETIME as date) 
  ORDER BY 1 desc OPTION(FAST 20)
  ---------------------------------------------------------------------------------------------------------------
  --------- PROD ORDERS PER STATUS ------------------------------------------------------------------------------
  ---------------------------------------------------------------------------------------------------------------
  SELECT  
		 CASE PRODSTATUS
			 WHEN 0 THEN  'Created'
			 WHEN 1 THEN  'CostEstimated'
			 WHEN 2 THEN  'Scheduled'
			 WHEN 3 THEN  'Released'
			 WHEN 4 THEN  'StartedUp'
			 WHEN 5 THEN  'ReportedFinished'
			 WHEN 7 THEN  'Ended'
		 END status		
		 , CAST(DATEADD(hh, DATEDIFF(hh, getdate(), GETUTCDATE())*-1, t1.MODIFIEDDATETIME) as date) MODIFIEDDATE	-- POR DIA
		 ,count(*) Qty_Of_Orders		 
  FROM PRODTABLE T1 with(nolock)
  WHERE PARTITION=5637144576 AND DATAAREAID=220 AND CREATEDDATETIME > getdate() -8
  GROUP BY PRODSTATUS 
  ,CAST(DATEADD(hh, DATEDIFF(hh, getdate(), GETUTCDATE())*-1, t1.MODIFIEDDATETIME) as date)						-- POR DIA
  ORDER BY 1 desc OPTION(FAST 20)
---------------------------------------------------------------------------------------------------------------
  --define start and end limits
Declare @todate datetime, @fromdate datetime
Select @fromdate='2016-10-01', @todate='2016-10-10'
 
;With DateSequence( Date ) as
(
    Select @fromdate as Date
        union all
    Select dateadd(day, 1, Date)
        from DateSequence
        where Date < @todate
)
 
Select	cast([date] as date) [Date], 
        (select count(*) from PRODTABLE t1 with(nolock) where CAST(DATEADD(hh, DATEDIFF(hh, getdate(), GETUTCDATE())*-1, t1.CREATEDDATETIME) as date)= [date] )  Created,
		(select count(*) from PRODTABLE t1 with(nolock) where t1.CalcDate= [date] )  Estimated,
		(select count(*) from PRODTABLE t1 with(nolock) where t1.SchedDate = [date] )  Scheduled,
		(select count(*) from PRODTABLE t1 with(nolock) where t1.StUpDate = [date] )  [Started],
		(select count(*) from PRODTABLE t1 with(nolock) where t1.FinishedDate = [date] )  [Reported as finished],
		(select count(*) from PRODTABLE t1 with(nolock) where t1.RealDate = [date] )  Ended
from DateSequence
option (MaxRecursion 1000) 

---------------------------------------------------------------------------------------------------------------
--******************************************************************************************
-- Production BOM - Detail of ProdTable
   --PRODFLUSHINGPRINCIP => Blank 0 Start 2 Finish 3 Manual 1
--******************************************************************************************
  SELECT 
	  CASE PRODFLUSHINGPRINCIP  WHEN  0 THEN 'Blank'
								WHEN  1 THEN 'Manual'
								WHEN  2 THEN 'Start'
								WHEN  3 THEN 'Finish'
	  END ['BOM Consumption']
      , count(*)  ['Number of Items'  -----> ProdBOM Table]
  FROM ProdBOM
  GROUP BY  PRODFLUSHINGPRINCIP
  -------------------------------------------------------------------------------------------
  SELECT * FROM ProdBOM
  WHERE PRODFLUSHINGPRINCIP = 1


  SELECT CREATEDBY Created_By, cast (CREATEDDATETIME as date)  Created_Date, count(*) ['Qty of orders'], max(PRODSTATUS)
  FROM PRODTABLE
  GROUP BY  CREATEDBY,cast (CREATEDDATETIME as date)
  order by 2 desc
  --------------------------------------------------------------------------------------------
  SELECT * FROM PRODTABLE
  WHERE PRODID IN(
					SELECT prodid FROM PRODBOM
					WHERE prodflushingprincip = 1
				 )
--******************************************************************************************
-- Planned Orders   
--******************************************************************************************
SELECT *
FROM	REQPO			T1 CROSS JOIN 
		REQPLANVERSION	T2 CROSS JOIN 
		REQTRANS		T3 CROSS JOIN 
		INVENTDIM		T4 
WHERE	(((T1.PARTITION=5637144576)				AND (T1.DATAAREAID='220'))	)	AND (((T1.REFTYPE=34)			 OR (T1.REFTYPE=31)))	--AND */			 (T2.RECID=16))) 
		AND ((T2.PARTITION=T1.PARTITION)		AND ( --(T2.ACTIVE=19)	AND	
			(T1.PLANVERSION=T2.RECID)))			AND (((T3.PARTITION=T1.PARTITION)	AND (T3.DATAAREAID='220')) 
		AND (((T1.PLANVERSION=T3.PLANVERSION)	AND (T1.REFTYPE=T3.REFTYPE))	AND (T1.REFID=T3.REFID)))		AND	(((T4.PARTITION=T1.PARTITION)	AND (T4.DATAAREAID='220')) 
		AND (T3.COVINVENTDIMID=T4.INVENTDIMID)) 
ORDER BY T1.REFID OPTION(FAST 19)
--******************************************************************************************
-- ROUTERS
--******************************************************************************************
	SELECT * FROM prodTable
	WHERE ROUTEID in(
					 SELECT ROUTEID 
					 FROM RouteTable 
					 WHERE ROUTEID in(
									  SELECT ROUTERELATION 
									  FROM RouteOpr
									  WHERE CONFIGID = '')
						   AND Approved = 1)
--******************************************************************************************
-- VIEWS
--******************************************************************************************
	SELECT * FROM [AX_TEST_SSC].[dbo].[vProductionOrderItem]
	WHERE ROUTEID = 'ROU00014932'
--******************************************************************************************
--	ROUTERS SHOWING LAST AX AND LASTNON-QA
--******************************************************************************************
	select	ROUTEID, 
			(SELECT max(OPRNUM) FROM route WHERE ROUTEID = ro.ROUTEID AND OPRID <> 'QA RELEASE' ) LastNonQaAxOPeration,
			(SELECT max(OPRNUM) FROM route WHERE ROUTEID = ro.ROUTEID  ) LastAxOPeration
	FROM RouteTable ro
	WHERE APPROVED = 1 AND ROUTEID = 'ROU00014932'
--******************************************************************************************
-- ROUTERS WITH ONE OPERATION
--******************************************************************************************
	SELECT * FROM (
	SELECT	rv.itemid,ro.ROUTEID, 
			(	SELECT COUNT(OPRNUM) FROM ROUTE WHERE ROUTEID = ro.ROUTEID  ) Qty
				FROM RouteTable ro cross join routeversion rv
				WHERE rv.APPROVED = 1 
					 AND rv.ROUTEID = ro.ROUTEID
					 AND ACTIVE = 1
			 ) A
	WHERE qty =1
	ORDER BY 1
--******************************************************************************************
-- ROUTERS SHOWING LAST AND NEXT-TO-LAST
--******************************************************************************************
	SELECT itemid,Route_id, LastAxOPeration, (SELECT MAX(OPRNUM) FROM ROUTE WHERE ROUTEID = A.Route_id AND OPRNUM < LastAxOPeration ) Nest_To_LastAxOPeration
	FROM			(
					SELECT	rv.itemid,rv.ROUTEID Route_id, 
							(SELECT MAX(OPRNUM) FROM ROUTE WHERE ROUTEID = ro.ROUTEID  ) LastAxOPeration
					FROM RouteTable ro cross join routeversion rv
					WHERE	rv.APPROVED = 1  
							AND rv.ROUTEID = ro.ROUTEID
							AND ACTIVE = 1
					) A
--******************************************************************************************
-- ROUTERS SHOWING BOMTABLE , BOMVERSION
--******************************************************************************************








--******************************************************************************************
-- QTY OF PURCHASING ORDERS CREATED PER DAY
--******************************************************************************************
  SELECT   cast(CREATEDDATETIME as date) Created_Date, count(*) Qty_Of_POs
  FROM PURCHTABLE T1 
  WHERE (((PARTITION=5637144576) AND (DATAAREAID=220))) AND CREATEDDATETIME > getdate() -9
  GROUP BY cast(CREATEDDATETIME as date) 
  ORDER BY 1 desc OPTION(FAST 20)
--******************************************************************************************
-- QTY OF PURCHASING ORDERS grouped by Status in the last X days
--******************************************************************************************
  SELECT  
	CASE PurchStatus
		WHEN 0 THEN  'None'
		WHEN 1 THEN  'Backorder'
		WHEN 2 THEN  'Received'
		WHEN 3 THEN  'Invoiced'
		WHEN 4 THEN  'Canceled'
	END Status		
	,count(*) Qty_Of_POs
  FROM PURCHTABLE T1 WHERE (((PARTITION=5637144576) AND (DATAAREAID=220))) AND CREATEDDATETIME > getdate() -9
  GROUP BY PurchStatus
  ORDER BY 1 DESC OPTION(FAST 20)
------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------*WAREHOUSE TRANSACTIONS*----------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

 SELECT REFERENCECATEGORY, STATUSRECEIPT, COUNT(distinct REFERENCEID) QTY, MODIFIEDDATE,CREATED_BY
 FROM
 (
	SELECT 
	T1.INVENTTRANSID,
	CASE T1.REFERENCECATEGORY
		WHEN 0 THEN (SELECT CREATEDBY FROM SalesTable WHERE SalesID = REFERENCEID)
		WHEN 2 THEN (SELECT CREATEDBY FROM ProdTable WHERE PRODID = REFERENCEID)
		WHEN 3 THEN (SELECT CREATEDBY FROM PurchTable WHERE PURCHID = REFERENCEID)
 		WHEN 8 THEN (SELECT CREATEDBY FROM ProdTable WHERE PRODID = REFERENCEID)
		ELSE ''
		end CREATED_by
	,
	CASE T1.REFERENCECATEGORY
						WHEN 0 THEN 'Sales Order'
						WHEN 2 THEN 'Production'						
						WHEN 3 THEN 'Purchase order'						
						WHEN 4 THEN 'InventTransaction'						
						WHEN 5 THEN 'InventLossProfit'						
						WHEN 6 THEN 'InventTransfer'						
						WHEN 7 THEN 'SummedUp'						
						WHEN 8 THEN 'Production Line'	
						WHEN 9 THEN 'BOMLine'	
						WHEN 10 THEN 'BOMMain'	
						WHEN 11 THEN 'WMSOrder'	
						WHEN 12 THEN 'Project'	
						WHEN 13 THEN 'InventCounting'	
						WHEN 14 THEN 'WMSTransport'	
						WHEN 15 THEN 'QuarantineOrder'
						WHEN 20 THEN 'Asset'
						WHEN 21 THEN 'TransferOrderShip'
						WHEN 22 THEN 'TransferOrderReceive'
						WHEN 23 THEN 'TransferOrderScrap'
						WHEN 24 THEN 'SalesQuotation'
						WHEN 25 THEN 'QualityOrder'
						WHEN 26 THEN 'Blocking'
						WHEN 27 THEN 'KanbanJobProcess'
						WHEN 28 THEN 'KanbanJobTransferReceipt'
						WHEN 29 THEN 'KanbanJobTransferIssue'
						WHEN 30 THEN 'KanbanJobPickingList'
						WHEN 31 THEN 'KanbanJobWIP'
						WHEN 32 THEN 'KanbanEmptied'
						WHEN 100 THEN 'PmfProdCoBy'
						WHEN 101 THEN 'ProdRelease_RU'
						WHEN 102 THEN 'FixedAssets_RU'
						WHEN 150 THEN 'Statement'
						WHEN 103 THEN 'Assembling_JP'
						WHEN 201 THEN 'WHSWork'
						WHEN 202 THEN 'WHSQuarantine'
						WHEN 203 THEN 'WHSContainer'
	end REFERENCECATEGORY,
	T1.REFERENCEID,T3.INVENTLOCATIONID, T3.INVENTBATCHID, T2.ITEMID, T2.QTY, 
	CASE STATUSRECEIPT WHEN 0 THEN 'none'
						WHEN 1 THEN 'Sold'						
						WHEN 2 THEN 'Deducted'						
						WHEN 3 THEN 'Picked'						
						WHEN 4 THEN 'ReservPhysical'						
						WHEN 5 THEN 'ReservOrdered'						
						WHEN 6 THEN 'OnOrder'						
						WHEN 7 THEN 'QuotationIssue'						
	end STATUSRECEIPT, 
	CASE STATUSISSUE   WHEN 0 THEN 'none'
						WHEN 1 THEN 'Purchased'						
						WHEN 2 THEN 'Received'						
						WHEN 3 THEN 'Registered'						
						WHEN 4 THEN 'Arrived'						
						WHEN 5 THEN 'Ordered'						
						WHEN 6 THEN 'QuotationReceipt'										   				
	end STATUSISSUE,
	DATEADD(hh, DATEDIFF(hh, getdate(), GETUTCDATE())*-1, t2.MODIFIEDDATETIME) MODIFIEDDATETIME,
	CAST(DATEADD(hh, DATEDIFF(hh, getdate(), GETUTCDATE())*-1, t2.MODIFIEDDATETIME) as date) MODIFIEDDATE,
	MODIFIEDBY
	FROM INVENTTRANSORIGIN T1 CROSS JOIN INVENTTRANS T2 CROSS JOIN INVENTDIM T3 
	WHERE T1.PARTITION=5637144576 AND T1.DATAAREAID='220' AND 
			T2.PARTITION=5637144576 AND T2.DATAAREAID='220' AND T1.RECID=T2.INVENTTRANSORIGIN AND 
			T3.PARTITION=5637144576 AND T3.DATAAREAID='220' AND T2.INVENTDIMID=T3.INVENTDIMID 
			AND t2.MODIFIEDDATETIME > getdate()-2
	--ORDER BY T1.INVENTTRANSID desc OPTION(FAST 18) 
 ) A
 GROUP BY REFERENCECATEGORY,STATUSRECEIPT,  MODIFIEDDATE,CREATED_by
 order by 4 DESC


------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------*ITEM COST*----------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT 
ITEMID,VERSIONID, PRICEUNIT, PRICE, UNITID, PRICEQTY, INVENTSITEID, ACTIVATIONDATE
FROM INVENTITEMPRICE T1 CROSS JOIN INVENTDIM T2 
WHERE	T1.PARTITION=5637144576 AND T1.DATAAREAID='220'  AND --T1.ITEMID='WIP-Labor' AND 
		T2.PARTITION=T1.PARTITION AND T2.DATAAREAID=T1.DATAAREAID AND T1.INVENTDIMID=T2.INVENTDIMID 
		AND INVENTSITEID = 'TJ'
ORDER BY T1.ACTIVATIONDATE DESC,T1.CREATEDDATETIME DESC,T1.ITEMID,T1.INVENTDIMID,T1.PRICETYPE OPTION( FAST 19)
------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------*CICLE COUNTS - JEAN PAUL*----------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT	T1.JOURNALID,
        T4.DESCRIPTION,
		CASE T4.POSTED WHEN 0 THEN 'OPEN'
					   WHEN 1 THEN 'POSTED'
		END POSTED,			 
		DATEADD(hh, DATEDIFF(hh, getdate(), GETUTCDATE())*-1, T4.POSTEDDATETIME) POSTEDDATETIME,  	
		T1.ITEMID,
		cast(T1.LINENUM as int) LINENUM,
		T2.INVENTBATCHID,
		T2.WMSLOCATIONID,		
		T2.INVENTLOCATIONID,
		T2.INVENTSITEID,
		T1.TRANSDATE,
		CAST(T1.INVENTONHAND as int) INVENTONHAND,
		cast(T1.COUNTED as int) COUNTED,
		cast(T1.QTY as int) QTY,		
		cast(T1.COSTPRICE as numeric(10,2)) COSTPRICE,
		cast(T1.COSTAMOUNT as numeric(10,2)) COSTAMOUNT,
		CAST(T1.INVENTONHAND * T1.COSTPRICE as numeric(10,2)) INVENTONHAND_COSTAMOUNT,		
		T5.PDSDISPOSITIONCODE DISPOSITIONCODE,
		CASE T6.STATUS WHEN 0 THEN 'Unavailable'
					   WHEN 1 THEN 'Available'
					   WHEN 2 THEN 'NotApplicable'
					   ELSE		   '' 	
		end DISPOSITIONCODE_STATUS
FROM	INVENTJOURNALTRANS	T1															CROSS JOIN 
		INVENTDIM			T2															LEFT OUTER JOIN 
		HCMWORKER			T3 ON T3.PARTITION	=T1.PARTITION	AND T1.WORKER=T3.RECID	INNER JOIN 
		INVENTJOURNALTABLE	T4 ON T1.JOURNALID	= T4.JOURNALID							LEFT JOIN	
		INVENTBATCH			T5 ON T1.ITEMID		= T5.ITEMID		AND T2.INVENTBATCHID = T5.INVENTBATCHID LEFT JOIN
		PDSDISPOSITIONMASTER T6 ON T6.DISPOSITIONCODE = T5.PDSDISPOSITIONCODE
WHERE	T1.PARTITION=5637144576 AND T1.DATAAREAID='220' AND T2.PARTITION=T1.PARTITION AND T2.DATAAREAID=T1.DATAAREAID 
		AND T1.JOURNALTYPE = 4
		AND T1.INVENTDIMID=T2.INVENTDIMID 
		AND T4.PARTITION=T1.PARTITION
		AND DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE())*-1, T4.POSTEDDATETIME) >=  DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE() - 1), 0) --first date of current month
		ORDER BY T1.JOURNALID,T1.LINENUM OPTION(FAST 19) 

------------ EDGARD V
---------------- ITEM/SUSTITUDOS DUPLICADOS EN BOM
SELECT NAMEALIAS, bv.itemid, COUNT(*) Qty
FROM BOMVersion bv							INNER JOIN 
	 BOM b			ON bv.bomid = b.bomid	INNER JOIN
	 INVENTTABLE i	ON i.ITEMID = b.itemid 
WHERE ACTIVE = 1 and APPROVED = 1  and  BOMQTY > 0
GROUP BY namealias,  bv.itemid
HAVING COUNT(*) > 1

------------ ALEJANDRO - SEMIFINISHS BOM
SELECT DISTINCT b.Itemid, INVENTLOCATIONID
FROM BOMVersion bv		WITH(NOLOCK) INNER JOIN 
	 BOM  b				WITH(NOLOCK) ON bv.bomid = b.bomid	INNER JOIN
	 INVENTTABLE  i		WITH(NOLOCK) ON i.ITEMID = b.itemid LEFT JOIN
	 inventdim   id		WITH(NOLOCK) ON b.INVENTDIMID = id.INVENTDIMID 
WHERE ACTIVE = 1 and APPROVED = 1  
      --and  bv.itemid = '72-1501'
	  and exists (SELECT 1 FROM BOMVersion xx WITH(NOLOCK)  WHERE xx.itemid = b.itemid)
ORDER BY 1
-----------  Alejandro Last Complete Operation
select PT.PRODPOOLID [POOL],
       A.*, 
	   PT.QtySched [SCHEDULED],
	   PT.QtyStUp [STARTED],
	   B.OPRID,
	   DATEADD(hh, DATEDIFF(hh, GETDATE(), GETUTCDATE())*-1, PT.MODIFIEDDATETIME) LAST_DATE,	   
	   (select OPRNUMNEXT from PRODROUTE t1 where t1.prodid = A.prodid and A.LAST_RPT_FINISH = t1.OPRNUM  ) NextOP
FROM  (
		select PRODID, max(OPRNUM) LAST_RPT_FINISH, 'WIP'  [STATUS] 
		from PRODROUTE t0
		where OPRFINISHED =  1
		group by prodid
		UNION
		select PRODID, min(OPRNUM) LAST_RPT_FINISH, 'Waiting'
		from PRODROUTE
		group by PRODID
		having max(OPRFINISHED) = 0
	  ) A, PRODROUTE B, PRODTABLE PT
WHERE A.prodid = B.prodid and LAST_RPT_FINISH = OPRNUM AND PT.PRODID = A.PRODID
Order by PT.MODIFIEDDATETIME desc
---- Alejandro Opened Operatinos
select PRODID, OPRNUM, OPRID
from PRODROUTE		
where OPRFINISHED = 0

--------------------------------------------LAST TRANSACTION (Citlali)---------------------------------------------
SELECT	ITEMNUM, MAX(RECID) RECID,
		(select INVENTREFCATEGORY 
		 from ANGBPMINVENTORYTRANSEXTRACT X  
		 where X.RECID = MAX(A.RECID)) INVENTREFCATEGORY,
		(select INVENTDATEPHYSICAL 
		 from ANGBPMINVENTORYTRANSEXTRACT X  
		 where X.RECID = MAX(A.RECID)) INVENTDATEPHYSICAL
FROM	ANGBPMINVENTORYTRANSEXTRACT A
WHERE INVENTISSUESTATUS = 'Sold' OR INVENTRECEIPTSTATUS = 'Purchased'
GROUP BY ITEMNUM


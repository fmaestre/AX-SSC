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
	SELECT	  it.ITEMID, SEARCHNAME, NAME, 
			  CASE eprd.ProductType		WHEN 1 THEN 'ITEM' 
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
		  AND it.ITEMID				= 'RA-1033Q'
		  AND trans.PRODUCT			= it.PRODUCT 
		  AND iexp.ItemId			= it.ITEMID
--******************************************************************************************
-- RELEASED PRODUCTS WHOLE
--******************************************************************************************
SELECT 
		T1.ITEMID,
		T1.ITEMTYPE,
		T1.PURCHMODEL,
		T1.HEIGHT,
		T1.WIDTH,
		T1.SALESMODEL,
		T1.COSTGROUPID,
		T1.REQGROUPID,
		T1.PRIMARYVENDORID,
		T1.NETWEIGHT,
		T1.DEPTH,
		T1.UNITVOLUME,
		T1.BOMUNITID,
		T1.ITEMPRICETOLERANCEGROUPID,
		T1.DENSITY,
		T1.COSTMODEL,
		T1.USEALTITEMID,
		T1.ALTITEMID,
		T1.MATCHINGPOLICY,
		T1.INTRACODE,
		T1.PRODFLUSHINGPRINCIP,
		T1.MINIMUMPALLETQUANTITY,
		T1.PBAITEMAUTOGENERATED,
		T1.WMSARRIVALHANDLINGTIME,
		T1.BOMMANUALRECEIPT,
		T1.PHANTOM,
		T1.INTRAUNIT,
		T1.BOMLEVEL,
		T1.BATCHNUMGROUPID,
		T1.AUTOREPORTFINISHED,
		T1.ORIGCOUNTRYREGIONID,
		T1.STATISTICSFACTOR,
		T1.ALTCONFIGID,
		T1.STANDARDCONFIGID,
		T1.PRODPOOLID,
		T1.PROPERTYID,
		T1.ABCTIEUP,
		T1.ABCREVENUE,
		T1.ABCVALUE,
		T1.ABCCONTRIBUTIONMARGIN,
		T1.COMMISSIONGROUPID,
		T1.SALESPERCENTMARKUP,
		T1.SALESCONTRIBUTIONRATIO,
		T1.SALESPRICEMODELBASIC,
		T1.NAMEALIAS,
		T1.PRODGROUPID,
		T1.PROJCATEGORYID,
		T1.GROSSDEPTH,
		T1.GROSSWIDTH,
		T1.GROSSHEIGHT,
		T1.STANDARDPALLETQUANTITY,
		T1.QTYPERLAYER,
		T1.SORTCODE,
		T1.SERIALNUMGROUPID,
		T1.ITEMBUYERGROUPID,
		T1.TAXPACKAGINGQTY,
		T1.WMSPALLETTYPEID,
		T1.ORIGSTATEID,
		T1.WMSPICKINGQTYTIME,
		T1.TARAWEIGHT,
		T1.PACKAGINGGROUPID,
		T1.SCRAPVAR,
		T1.SCRAPCONST,
		T1.ITEMDIMCOSTPRICE,
		T1.FORECASTDMPINCLUDE,
		T1.PRODUCT,
		T1.DEFAULTDIMENSION,
		T1.BOMCALCGROUPID,
		T1.PDSBESTBEFORE,
		T1.PDSFREIGHTALLOCATIONGROUPID,
		T1.PDSITEMREBATEGROUPID,
		T1.PDSSHELFADVICE,
		T1.PDSSHELFLIFE,
		T1.PDSVENDORCHECKITEM,
		T1.PMFPLANNINGITEMID,
		T1.PMFPRODUCTTYPE,
		T1.PMFYIELDPCT,
		T1.BATCHMERGEDATECALCULATIONMETHOD,
		T1.ENGINEERINGDRAWINGNUMBER,
		T1.ITEMCLASSID,
		T1.MODIFIEDDATETIME,
		T1.DEL_MODIFIEDTIME,
		T1.MODIFIEDBY,
		T1.CREATEDDATETIME,
		T1.DEL_CREATEDTIME,
		T1.CREATEDBY,
		T1.RECVERSION,		
		T1.RECID,

		T3.ITEMDATAAREAID,
		T3.MODELGROUPID,
		T3.ITEMID,
		T3.MODELGROUPDATAAREAID,
		T3.RECVERSION,		
		T3.RECID,

		T4.ITEMID,
		T4.ITEMDATAAREAID,
		T4.ITEMGROUPID,
		T4.ITEMGROUPDATAAREAID,
		T4.RECVERSION,		
		T4.RECID,

		T5.TRACKINGDIMENSIONGROUP,
		T5.ITEMID,
		T5.ITEMDATAAREAID,
		T5.RECVERSION,		
		T5.RECID,

		T6.STORAGEDIMENSIONGROUP,
		T6.ITEMID,
		T6.ITEMDATAAREAID,
		T6.RECVERSION,
		T6.RECID,

		T7.PRODUCTMASTER,
		T7.RETAITOTALWEIGHT,
		T7.VARIANTCONFIGURATIONTECHNOLOGY,
		T7.INSTANCERELATIONTYPE,
		T7.DISPLAYPRODUCTNUMBER,
		T7.SEARCHNAME,
		T7.PRODUCTTYPE,
		T7.MODIFIEDBY,
		T7.RECVERSION,
		T7.RELATIONTYPE,		
		T7.RECID,

		T8.PRODUCTDIMENSIONGROUP,
		T8.RECVERSION,
		T8.RECID,

		T9.NAME,
		T9.RECVERSION,
		T9.RECID,

		T10.NAME,
		T10.RECVERSION,
		T10.RECID 
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
                     and CREATEDDATETIME > getdate() -8
  group by cast(CREATEDDATETIME as date) 
  ORDER BY 1 desc OPTION(FAST 20)
    ---------------------------------------------------------------------------------------------------------------
  --------- PROD ORDERS PER STATUS ------------------------------------------------------------------------------
  ---------------------------------------------------------------------------------------------------------------
  SELECT  
		 case PRODSTATUS
		 when 0 then  'Created'
		 when 1 then  'CostEstimated'
		 when 2 then  'Scheduled'
		 when 3 then  'Released'
		 when 4 then  'StartedUp'
		 when 5 then  'ReportedFinished'
		 when 7 then  'Completed'
		 END Status		
		 ,count(*) Qty_Of_Orders
		 --,min(PRODID),max(PRODID)
  FROM PRODTABLE T1 WHERE (((PARTITION=5637144576) AND (DATAAREAID=220))) --AND (PRODID='MBMW540')
                     and CREATEDDATETIME > getdate() -8
  group by PRODSTATUS
  ORDER BY 1 desc OPTION(FAST 20)
---------------------------------------------------------------------------------------------------------------
--******************************************************************************************
-- Production BOM - Detail of ProdTable
   --PRODFLUSHINGPRINCIP => Blank 0 Start 2 Finish 3 Manual 1
--******************************************************************************************
  select 
  case PRODFLUSHINGPRINCIP  when  0 then 'Blank'
                            when  1 then 'Manual'
							when  2 then 'Start'
							when  3 then 'Finish'
  END ['BOM Consumption']
							, count(*)  ['Number of Items'  -----> ProdBOM Table]
  from ProdBOM
  group by  PRODFLUSHINGPRINCIP
  -------------------------------------------------------------------------------------------
  select * from ProdBOM
  where PRODFLUSHINGPRINCIP = 1


  select CREATEDBY Created_By, cast (CREATEDDATETIME as date)  Created_Date, count(*) ['Qty of orders'], max(PRODSTATUS)
  FROM PRODTABLE
  group by CREATEDBY,cast (CREATEDDATETIME as date)
  order by 2 desc
  --------------------------------------------------------------------------------------------
  select * from prodtable
  where PRODID in(
					SELECT PRODID from ProdBOM
					where PRODFLUSHINGPRINCIP = 1
				  )
--******************************************************************************************
-- Planned Orders   
--******************************************************************************************
SELECT 
T1.ITEMID,T1.ROUTEJOBSUPDATED,T1.REQDATE,T1.QTY,T1.REQDATEORDER,T1.VENDID,T1.ITEMGROUPID,T1.REQPOSTATUS,T1.PURCHUNIT,
T1.PLANVERSION,T1.SCHEDMETHOD,T1.PURCHID,T1.REQDATEDLV,T1.REFID,T1.REFTYPE,T1.ITEMROUTEID,T1.ITEMBOMID,T1.ITEMBUYERGROUPID,
T1.COVINVENTDIMID,T1.REQTIMEORDER,T1.VENDGROUPID,T1.LEADTIME,T1.CALENDARDAYS,T1.SCHEDTODATE,T1.SCHEDFROMDATE,T1.PURCHQTY,
T1.REQTIME,T1.BOMROUTECREATED,T1.ISDERIVEDDIRECTLY,T1.ISFORECASTPURCH,T1.INTVQR,T1.INTVMTH,T1.INTVWK,T1.COSTAMOUNT,
T1.TRANSFERID,T1.PRODUCT,T1.PMFBULKORD,T1.PMFPLANNINGITEMID,T1.PMFSEQUENCED,T1.PMFYIELDPCT,T1.MODIFIEDDATETIME,
T1.DEL_MODIFIEDTIME,T1.MODIFIEDBY,T1.RECVERSION,T1.PARTITION,T1.RECID,T2.ACTIVE,T2.REQPLANDATAAREAID,
T2.REQPLANID,T2.RECVERSION,T2.RECID,T3.ITEMID,T3.COVINVENTDIMID,T3.REQDATE,T3.DIRECTION,
T3.REFTYPE,T3.OPENSTATUS,T3.QTY,T3.COVQTY,T3.REFID,T3.KEEP,T3.REQDATEDLVORIG,T3.FUTURESDAYS,T3.FUTURESMARKED,
T3.OPRNUM,T3.ACTIONQTYADD,T3.ACTIONDAYS,T3.ACTIONMARKED,T3.ACTIONTYPE,T3.PLANVERSION,T3.ORIGINALQUANTITY,
T3.ISDERIVEDDIRECTLY,T3.PRIORITY,T3.ACTIONDATE,T3.FUTURESDATE,T3.INVENTTRANSORIGIN,T3.BOMREFRECID,
T3.MARKINGREFINVENTTRANSORIGIN,T3.LEVEL_,T3.BOMTYPE,T3.ITEMROUTEID,T3.ITEMBOMID,T3.ISFORECASTPURCH,
T3.LASTPLANRECID,T3.REQTIME,T3.FUTURESTIME,T3.SUPPLYDEMANDSUBCLASSIFICATION,T3.REQPROCESSID,
T3.INTERCOMPANYPLANNEDORDER,T3.PMFPLANGROUPPRIMARYISSUE,T3.ISDELAYED,T3.PDSEXPIRYDATE,
T3.PDSSELLABLEDAYS,T3.PMFACTIONQTYADD,T3.PMFCOBYREFRECID,T3.PMFPLANGROUPID,T3.PMFPLANGROUPPRIORITY,
T3.PMFPLANNINGITEMID,T3.PMFPLANPRIORITYCURRENT,T3.REQUISITIONLINE,T3.CUSTACCOUNTID,T3.CUSTGROUPID,
T3.MCRPRICETIMEFENCE,T3.RECVERSION,T3.RECID,T4.INVENTDIMID,T4.INVENTBATCHID,T4.WMSLOCATIONID,
T4.WMSPALLETID,T4.INVENTSERIALID,T4.INVENTLOCATIONID,T4.CONFIGID,T4.INVENTSITEID,T4.MODIFIEDDATETIME,
T4.MODIFIEDBY,T4.CREATEDDATETIME,T4.RECVERSION,T4.RECID 
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
	select * from prodTable
	where ROUTEID in(
					 select ROUTEID 
					 from RouteTable 
					 where ROUTEID in(
									  select ROUTERELATION 
									  from RouteOpr
									  where CONFIGID = '')
						   and Approved = 1)
--******************************************************************************************
-- VIEWS
--******************************************************************************************
	select * from [AX_TEST_SSC].[dbo].[vProductionOrderItem]
	where ROUTEID = 'ROU00014932'
--******************************************************************************************
--	ROUTERS SHOWING LAST AX AND LASTNON-QA
--******************************************************************************************
	select	ROUTEID, 
			(select max(OPRNUM) from route where ROUTEID = ro.ROUTEID and OPRID <> 'QA RELEASE' ) LastNonQaAxOPeration,
			(select max(OPRNUM) from route where ROUTEID = ro.ROUTEID  ) LastAxOPeration
	from RouteTable ro
	where APPROVED = 1 and ROUTEID = 'ROU00014932'
--******************************************************************************************
-- ROUTERS WITH ONE OPERATION
--******************************************************************************************
	SELECT * FROM (
	SELECT	rv.itemid,ro.ROUTEID, 
			(	SELECT COUNT(OPRNUM) FROM ROUTE WHERE ROUTEID = ro.ROUTEID  ) Qty
				FROM RouteTable ro cross join routeversion rv
				WHERE rv.APPROVED = 1 --and ROUTEID = 'ROU00014932'
					 and rv.ROUTEID = ro.ROUTEID
					 and ACTIVE = 1
			 ) A
	WHERE qty =1
	ORDER BY 1
--******************************************************************************************
-- ROUTERS SHOWING LAST AND NEXT-TO-LAST
--******************************************************************************************
	SELECT itemid,Route_id, LastAxOPeration, (SELECT MAX(OPRNUM) FROM ROUTE WHERE ROUTEID = A.Route_id and OPRNUM < LastAxOPeration ) Nest_To_LastAxOPeration
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
  WHERE (((PARTITION=5637144576) AND (DATAAREAID=220))) and CREATEDDATETIME > getdate() -9
  group by cast(CREATEDDATETIME as date) 
  ORDER BY 1 desc OPTION(FAST 20)
--******************************************************************************************
-- QTY OF PURCHASING ORDERS grouped by Status in the last X days
--******************************************************************************************
  SELECT  
	case PurchStatus
		when 0 then  'None'
		when 1 then  'Backorder'
		when 2 then  'Received'
		when 3 then  'Invoiced'
		when 4 then  'Canceled'
	END Status		
	,count(*) Qty_Of_POs
  FROM PURCHTABLE T1 WHERE (((PARTITION=5637144576) AND (DATAAREAID=220))) and CREATEDDATETIME > getdate() -9
  group by PurchStatus
  ORDER BY 1 desc OPTION(FAST 20)
------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------*WAREHOUSE TRANSACTIONS*----------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT 
T1.INVENTTRANSID,
case T1.REFERENCECATEGORY
				   when 0 then 'Sales Order'
				   when 2 then 'Production'						
				   when 3 then 'Purchase order'						
				   when 4 then 'InventTransaction'						
				   when 5 then 'InventLossProfit'						
				   when 6 then 'InventTransfer'						
				   when 7 then 'SummedUp'						
				   when 8 then 'Production Line'	
				   when 9 then 'BOMLine'	
				   when 10 then 'BOMMain'	
				   when 11 then 'WMSOrder'	
				   when 12 then 'Project'	
				   when 13 then 'InventCounting'	
				   when 14 then 'WMSTransport'	
				   when 15 then 'QuarantineOrder'
				   when 20 then 'Asset'
				   when 21 then 'TransferOrderShip'
				   when 22 then 'TransferOrderReceive'
				   when 23 then 'TransferOrderScrap'
				   when 24 then 'SalesQuotation'
				   when 25 then 'QualityOrder'
				   when 26 then 'Blocking'
				   when 27 then 'KanbanJobProcess'
				   when 28 then 'KanbanJobTransferReceipt'
				   when 29 then 'KanbanJobTransferIssue'
				   when 30 then 'KanbanJobPickingList'
				   when 31 then 'KanbanJobWIP'
				   when 32 then 'KanbanEmptied'
				   when 100 then 'PmfProdCoBy'
				   when 101 then 'ProdRelease_RU'
				   when 102 then 'FixedAssets_RU'
				   when 150 then 'Statement'
				   when 103 then 'Assembling_JP'
				   when 201 then 'WHSWork'
				   when 202 then 'WHSQuarantine'
				   when 203 then 'WHSContainer'
end REFERENCECATEGORY,
T1.REFERENCEID,T3.INVENTLOCATIONID, T3.INVENTBATCHID, T2.ITEMID, T2.QTY, 
case STATUSRECEIPT when 0 then 'none'
				   when 1 then 'Sold'						
				   when 2 then 'Deducted'						
				   when 3 then 'Picked'						
				   when 4 then 'ReservPhysical'						
				   when 5 then 'ReservOrdered'						
				   when 6 then 'OnOrder'						
				   when 7 then 'QuotationIssue'						
end STATUSRECEIPT, 
case STATUSISSUE   when 0 then 'none'
				   when 1 then 'Purchased'						
				   when 2 then 'Received'						
				   when 3 then 'Registered'						
				   when 4 then 'Arrived'						
				   when 5 then 'Ordered'						
				   when 6 then 'QuotationReceipt'										   				
end STATUSISSUE,
DATEADD(hh, DATEDIFF(hh, getdate(), GETUTCDATE())*-1, t2.MODIFIEDDATETIME) MODIFIEDDATETIME,
CAST(DATEADD(hh, DATEDIFF(hh, getdate(), GETUTCDATE())*-1, t2.MODIFIEDDATETIME) as date) MODIFIEDDATE,
MODIFIEDBY
FROM INVENTTRANSORIGIN T1 CROSS JOIN INVENTTRANS T2 CROSS JOIN INVENTDIM T3 
WHERE T1.PARTITION=5637144576 AND T1.DATAAREAID='220' AND 
	--T3.INVENTLOCATIONID='TJ-OEM' 
	--T2.ITEMID='11903-775' AND 
      T2.PARTITION=5637144576 AND T2.DATAAREAID='220' AND T1.RECID=T2.INVENTTRANSORIGIN AND 
	  T3.PARTITION=5637144576 AND T3.DATAAREAID='220' AND T2.INVENTDIMID=T3.INVENTDIMID 
	  and t2.MODIFIEDDATETIME > getdate()-8
ORDER BY T1.INVENTTRANSID desc OPTION(FAST 18) 
------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------*ITEM COST*----------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT --ITEMID, count* 
ITEMID,VERSIONID, PRICEUNIT, PRICE, UNITID, PRICEQTY, INVENTSITEID, ACTIVATIONDATE
FROM INVENTITEMPRICE T1 CROSS JOIN INVENTDIM T2 
WHERE	T1.PARTITION=5637144576 AND T1.DATAAREAID='220'  AND --T1.ITEMID='WIP-Labor' AND 
		T2.PARTITION=T1.PARTITION AND T2.DATAAREAID=T1.DATAAREAID AND T1.INVENTDIMID=T2.INVENTDIMID 
		AND INVENTSITEID = 'TJ'
--GROUP BY ITEMID
--HAVING COUNT* > 1
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
		
		--cast(T1.COSTMARKUP as numeric(10,2)) COSTMARKUP,
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
		--AND T1.JOURNALID='JN00004841' 
		AND T1.JOURNALTYPE = 4
		AND T1.INVENTDIMID=T2.INVENTDIMID 
		AND T4.PARTITION=T1.PARTITION
		AND DATEADD(hh, DATEDIFF(hh, getdate(), GETUTCDATE())*-1, T4.POSTEDDATETIME) >=  DATEADD(month, DATEDIFF(month, 0, getdate() - 1), 0) --first date of current month
		ORDER BY T1.JOURNALID,T1.LINENUM OPTION(FAST 19) 
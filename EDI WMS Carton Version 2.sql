SELECT
         hdr.PackingSlipID                                                               AS asnid,
         RIGHT(hdr.PackingSlipID,8) + right('0000' +  CONVERT(Integer, lin.LineNum),4)   AS boxid,
         ''                                                                              AS sscc,
         ISNULL(shp.WEIGHT, 0)                                                           AS packweight,
         'N'                                                                             AS mixed,
         shp.LEADTRACKINGNUMBER                                                          AS trackingno,
         ''                                                                              AS rfid,
         hdr.SalesID                                                                     AS orderno,            
         CONVERT(Integer, lin.LineNum)                                                   AS [lineno],
         lin.itemid                                                                      AS itemid,         
         SUM(wmsot.QTY)                                                                  AS packqty,
         hdr.DataAreaID                                                                  AS dataareaid
FROM	SHIPCARRIERSHIPPINGREQUEST		hdr WITH (NOLOCK)	INNER JOIN 
		CustPackingSlipTrans	lin WITH (NOLOCK)   ON	hdr.packingslipid   =  lin.packingslipid	AND 
														hdr.dataareaid      =  lin.dataareaid		AND 
														hdr.PARTITION       =  lin.PARTITION              
													LEFT OUTER JOIN 
		WMSORDERTRANS			wmsot WITH (NOLOCK) ON	wmsot.INVENTTRANSID	=  lin.INVENTTRANSID	AND 
														lin.DATAAREAID		=  wmsot.DATAAREAID		AND 
														wmsot.EXPEDITIONSTATUS  =  10				AND 
														wmsot.PARTITION			=  lin.PARTITION 
													LEFT OUTER JOIN 
		SHIPCARRIERSTAGING		shp WITH (NOLOCK)	ON	hdr.PACKINGSLIPID	= shp.PACKINGSLIPID		AND 
														hdr.SALESID         = shp.SALESID
WHERE	EXISTS (    SELECT 1 
                    FROM shipcarrierstaging shp2 WITH (NOLOCK) 
                    WHERE shp.packingslipid = shp2.packingslipid AND shp.salesid = salesid and shipcarriervoidindicator <> 'Deleted'  
                            AND NOT EXISTS (    SELECT recid 
                                            FROM shipcarrierstaging WITH (NOLOCK) 
                                            WHERE    shp.packingslipid  = packingslipid    AND shp.salesid = salesid 
                                                AND shp.trackingnumber = trackingnumber    AND shipcarriervoidindicator = 'Y'
                                            )
                                      
                )
		AND wmsot.QTY > 0
		and hdr.PACKINGSLIPID = 'PS00032707'
GROUP BY	hdr.PACKINGSLIPID, 
			RIGHT(hdr.PackingSlipID,8) + right('0000' +  CONVERT(Integer, lin.LineNum),4),
            ISNULL(shp.WEIGHT, 0),
			shp.LEADTRACKINGNUMBER, 
			hdr.SALESID, 
			lin.LINENUM, 
			lin.ITEMID, 
			lin.QTY, 
			hdr.DATAAREAID 

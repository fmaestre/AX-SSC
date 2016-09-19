select * from EDIWMSCarton where asnid IN ('PS00030648')
--except
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
FROM	SHIPCARRIERSHIPPINGREQUEST	hdr WITH (NOLOCK)	INNER JOIN 
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
		and hdr.PACKINGSLIPID IN ('PS00030648')
GROUP BY	hdr.PACKINGSLIPID, 
			RIGHT(hdr.PackingSlipID,8) + right('0000' +  CONVERT(Integer, lin.LineNum),4),
            ISNULL(shp.WEIGHT, 0),
			shp.LEADTRACKINGNUMBER, 
			hdr.SALESID, 
			lin.LINENUM, 
			lin.ITEMID, 
			lin.QTY, 
			hdr.DATAAREAID 
--except
--select * from EDIWMSCarton where asnid IN ('PS00016432','PS00017785','PS00018277','PS00020825','PS00024212','PS00024194','PS00024197','PS00024365','PS00027032','PS00027213','PS00027211','PS00027244','PS00027328','PS00027314','PS00027264','PS00027331','PS00027334','PS00027291','PS00027324','PS00027912','PS00027919','PS00027984','PS00027973','PS00027932','PS00028206','PS00028547','PS00028785','PS00028810','PS00028827','PS00029066','PS00029335','PS00029312','PS00029517','PS00029573','PS00029578','PS00029730','PS00029918','PS00029875','PS00030024','PS00030258','PS00030175','PS00030183','PS00030200','PS00030181','PS00031319','PS00031706','PS00031706','PS00031568','PS00031802','PS00031863','PS00031854','PS00032292','PS00032477','PS00033399','PS00033399','PS00032790','PS00032998','PS00033373','PS00033373','PS00033390','PS00033367','PS00033355','PS00033389','PS00033397','PS00033392','PS00033395','PS00033401','PS00033396','PS00033393','PS00033377','PS00033382','PS00033391','PS00033378','PS00033381','PS00033379','PS00033376','PS00033400','PS00033375','PS00033386','PS00033394','PS00033383','PS00033387','PS00033380','PS00033388','PS00033384','PS00033374','PS00033372','PS00033385','PS00033398')

--PS00024194
--PS00024197
--PS00024212
--PS00032292
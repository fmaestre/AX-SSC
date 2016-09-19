--CAVAN01DBW001P.AngioDW

SELECT 
 vAXOrdersReleased.PICKINGROUTEID as Pick#
, CONVERT(VARCHAR(10),[PICKLISTCREATEDDATETIMELOCAL],120) as PickDate
, vAXOrdersReleased.CUSTOMERNUM as Cust#
, vAXOrdersReleased.DELIVERYNAME as DeliverTo
, vAXOrdersReleased.PICKLISTCREATEDBY as PickCreatedBy
, case when saleslinestatus='Invoice' then 
cast(coalesce(sum([invoicePRICE]*[PICKLISTPICKEDQTY]),0) as decimal(16,2)) 
else
cast(coalesce(sum([SALESPRICE]*[PICKLISTPICKEDQTY]),0) as decimal(16,2)) 
end
as Total
, vAXOrdersReleased.PICKSTATUS as "Pick Status"
, coalesce(vAXOrdersReleased.[PACKINGSLIPID],'') as "Packing Slip"
, case when coalesce(vAXOrdersReleased.[PACKINGSLIPID],'') <> '' then CONVERT(VARCHAR(10),vAXOrdersReleased.[PACKEDDATE],120)
    else ''
    end
as "PackDate"
,vAXOrdersReleased.[INVOICENUM]
FROM vAXOrdersReleasedHistory vAXOrdersReleased
where (WMSORDERSTATUS<>'Cancelled') and (customernum is not null) and (orderreleasedstatus <> 'Adjusted')
      --and coalesce(vAXOrdersReleased.[PACKINGSLIPID],'') <> ''
	  --and vAXOrdersReleased.[INVOICENUM] <> ''
group by 
 vAXOrdersReleased.PICKINGROUTEID
, vAXOrdersReleased.PICKLISTCREATEDDATETIMELOCAL
, vAXOrdersReleased.CUSTOMERNUM
, vAXOrdersReleased.DELIVERYNAME
, vAXOrdersReleased.PICKLISTCREATEDBY
, vAXOrdersReleased.PICKSTATUS
, coalesce(vAXOrdersReleased.[PACKINGSLIPID],'')
, vAXOrdersReleased.[PACKEDDATE]
,vAXOrdersReleased.[INVOICENUM]
,saleslinestatus
order by vAXOrdersReleased.PICKINGROUTEID
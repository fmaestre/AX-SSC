Declare @todate datetime, @fromdate datetime
Select @fromdate='2016-10-01', @todate= getdate()-1

;With DateSequence( Date ) as
(
    Select @fromdate as Date
        union all
    Select dateadd(day, 1, Date)
        from DateSequence
        where Date < @todate
)

Select cast([date] as date) [Date], 
        (select count(*) from PRODTABLE t1 with(nolock) where CAST(DATEADD(hh, DATEDIFF(hh, getdate(), GETUTCDATE())*-1, t1.CREATEDDATETIME) as date)= [date] )  Created,
             (select count(*) from PRODTABLE t1 with(nolock) where t1.CalcDate= [date] )  Estimated,
             (select count(*) from PRODTABLE t1 with(nolock) where t1.SchedDate = [date] )  Scheduled,
             (select count(*) from PRODTABLE t1 with(nolock) where t1.StUpDate = [date] )  [Started],
             (select count(*) from PRODTABLE t1 with(nolock) where t1.FinishedDate = [date] )  [Reported as finished],
			 (select count(*) from PRODTABLE t1 with(nolock) where t1.FinishedDate = [date] and t1.RealDate = '1900-01-01' )  [Waiting To Be Ended],			 			 
		     isnull(stuff(( 
						select DISTINCT TOP 100 PERCENT  ',' + PRODID + '(' + PRODPOOLID + ')'
						from dbo.PRODTABLE AS tx WITH (nolock)  							 
						where tx.FinishedDate = [date] and tx.RealDate = '1900-01-01' 
						ORDER BY ',' + PRODID + '(' + PRODPOOLID + ')'
						FOR XML PATH('')
						), 1, 1, '') + '','') AS [Waiting To Be Ended],
			 (select cast(DATEDIFF ( day , max(t1.FinishedDate)  , getdate()) as nvarchar) + ' days'   from PRODTABLE t1 with(nolock) where t1.FinishedDate = [date] and t1.RealDate = '1900-01-01' )  [Delay],
             (select count(*) from PRODTABLE t1 with(nolock) where t1.RealDate = [date] )  Ended
from DateSequence
option (MaxRecursion 1000) 

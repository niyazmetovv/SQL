use lessons;
go

declare @result varchar(max) = 
(
    select
        tbs.name as td, '',
        ids.name as td, '',
        ids.type_desc as td, '',
        ty.name as td
    from sys.indexes ids
    left join sys.tables tbs
        on ids.object_id = tbs.object_id
    left join sys.columns co
        on co.object_id = ids.object_id
    left join sys.types ty
        on ty.system_type_id = co.system_type_id
    for xml path('tr')
)

declare @html_body varchar(max) = '<table>' + @result + '</table>';

EXEC msdb.dbo.sp_send_dbmail
    @profile_name = 'SQL profile',
    @recipients = 'niyazmetovjaxongir@gmail.com',
    @subject = 'Metadata about indeces',
    @body = @html_body,
    @body_format = 'HTML';

--List Tables Columns in SQL Server
USE [DBName]
select schema_name(tab.schema_id) as schema_name,
    tab.name as table_name, 
    col.column_id,
    col.name as column_name, 
    t.name as data_type,    
    col.max_length,
    col.precision
from sys.tables as tab
    inner join sys.columns as col
        on tab.object_id = col.object_id
    left join sys.types as t
    on col.user_type_id = t.user_type_id
order by schema_name,
    table_name, 
    column_id;


--List Views Columns in SQL Server
USE [DBName]
select schema_name(v.schema_id) as schema_name,
       object_name(c.object_id) as view_name,
       c.column_id,
       c.name as column_name,
       type_name(user_type_id) as data_type,
       c.max_length,
       c.precision
from sys.columns c
join sys.views v 
     on v.object_id = c.object_id
order by schema_name,
         view_name,
         column_id;
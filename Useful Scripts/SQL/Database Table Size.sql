--Database Table Size

USE DBNAME

SELECT
a2.name AS [Table Name],
a3.Name AS [Schema Name],
a1.rows as [Row Count],



--s.name as SchemaName,
(a1.reserved + ISNULL(a4.reserved,0))* 8 AS [Reserved(KB)],
a1.data * 8 AS [Data Space Used(KB)],
(CASE WHEN (a1.used + ISNULL(a4.used,0)) > a1.data THEN (a1.used + ISNULL(a4.used,0)) - a1.data ELSE 0 END) * 8 AS [Index Space Used(KB)],
(CASE WHEN (a1.reserved + ISNULL(a4.reserved,0)) > a1.used THEN (a1.reserved + ISNULL(a4.reserved,0)) - a1.used ELSE 0 END) * 8 AS [Unused(KB)]
FROM
(SELECT
ps.object_id,
SUM (
CASE
WHEN (ps.index_id < 2) THEN row_count
ELSE 0
END
) AS [rows],
SUM (ps.reserved_page_count) AS reserved,
SUM (
CASE
WHEN (ps.index_id < 2) THEN (ps.in_row_data_page_count + ps.lob_used_page_count + ps.row_overflow_used_page_count)
ELSE (ps.lob_used_page_count + ps.row_overflow_used_page_count)
END
) AS data,
SUM (ps.used_page_count) AS used
FROM sys.dm_db_partition_stats ps
WHERE ps.object_id NOT IN (SELECT object_id FROM sys.tables WHERE is_memory_optimized = 1)
GROUP BY ps.object_id) AS a1
LEFT OUTER JOIN
(SELECT
it.parent_id,
SUM(ps.reserved_page_count) AS reserved,
SUM(ps.used_page_count) AS used
FROM sys.dm_db_partition_stats ps
INNER JOIN sys.internal_tables it ON (it.object_id = ps.object_id)
WHERE it.internal_type IN (202,204)
GROUP BY it.parent_id) AS a4 ON (a4.parent_id = a1.object_id)
INNER JOIN sys.all_objects a2 ON ( a1.object_id = a2.object_id )
INNER JOIN sys.schemas a3 ON (a2.schema_id = a3.schema_id)



WHERE a2.type <> N'S' and a2.type <> N'IT'
ORDER BY a3.name, a2.name
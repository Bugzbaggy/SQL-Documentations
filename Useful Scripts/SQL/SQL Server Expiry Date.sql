SELECT
	create_date AS 'SQL Server Install Date',
	DATEADD(DD, 180, create_date) AS 'SQL Server Expiry Date'
FROM sys.server_principals
	WHERE name = 'NT AUTHORITY\SYSTEM'
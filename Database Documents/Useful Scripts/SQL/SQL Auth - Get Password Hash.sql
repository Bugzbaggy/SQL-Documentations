/*SUSER_SID() - Returns the SID of the current security context*/
USE [master]
SELECT SUSER_SID('testlogin')
GO
/*LOGINPROPERTY('testlogin','PASSWORDHASH') - Returns the hash of the password*/
USE [master]
SELECT LOGINPROPERTY('testlogin','PASSWORDHASH')
GO

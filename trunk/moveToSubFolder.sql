/****** Script for SelectTopNRows command from SSMS  ******/
UPDATE [dbo].[Images]
SET [Directory] = 'QQ997224\Converted\' + 
		REPLACE(REPLACE(REPLACE(Right([FileName], 3),' ', '_'),'.', '_'),'\', '_') + '\' +
		REPLACE(REPLACE(REPLACE(Right([FileName], 6),' ', '_'),'.', '_'),'\', '_')		  
WHERE [Directory] = 'QQ997224\Converted'


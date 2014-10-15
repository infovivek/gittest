GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_VendorRequest_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
	DROP PROCEDURE [dbo].[Sp_VendorRequest_Help]
GO
/* 
Author Name : Anbu
Created On 	: <Created Date (12/03/2014)  >
Section  	: VendorRequest HELP
Purpose  	: VendorRequest HELP
Remarks  	: <Remarks if any>                        
Reviewed By	: <Reviewed By (Leave it blank)>
*/            
/*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
'Name			Date			Signature			Description of Changes
********************************************************************************************************	
*******************************************************************************************************
*/

CREATE PROCEDURE [dbo].[Sp_VendorRequest_Help]
(
	@Action NVARCHAR(100),
	@Id		BIGINT,
	@UserId BIGINT,
	@Str    NVARCHAR(100)
)
 AS
 BEGIN
 IF @Action='PAGELOAD'
 BEGIN
   	SELECT DISTINCT P.PropertyName AS Property,P.Id Id	
	FROM WRBHBPropertyUsers  PU 
    JOIN WRBHBProperty P ON PU.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0
	WHERE  P.Category IN('Internal Property','Managed G H') AND
	PU.IsActive=1 AND PU.IsDeleted=0 AND PU.UserId=@UserId
	ORDER BY P.Id ASC
	
	----Date
	--SELECT CONVERT(varchar(103),GETDATE(),103) as Date
	
END
 IF @Action='Property'
 BEGIN	
	SELECT DISTINCT CategoryId AS data,VendorCategory AS label 
    FROM WRBHBVendor 
    WHERE IsActive=1 AND IsDeleted=0 
 END 
 IF @Action='Category'
 BEGIN
    SELECT Id,VendorName FROM WRBHBVendor
  	WHERE CategoryId=@Id AND IsActive=1 AND IsDeleted=0
 END
 IF @Action='Vendor'
 BEGIN
    SELECT NatureofService FROM WRBHBVendor
  	WHERE Id=@Id AND IsActive=1 AND IsDeleted=0
  END
 IF @Action='Service'
 BEGIN
    SELECT Type FROM WRBHBVendorRequestType
 END
 IF @Action='Apartment'
 BEGIN
    SELECT (B.BlockName+'-'+A.ApartmentNo) AS ApartmentNo,A.Id AS ApartmentId FROM WRBHBPropertyApartment A
    JOIN WRBHBPropertyBlocks B ON A.PropertyId=B.PropertyId AND  B.IsActive=1 AND B.IsDeleted=0
    WHERE A.IsActive=1 AND A.IsDeleted=0 AND A.PropertyId=@Id
 END
 IF @Action ='Room'
 BEGIN
    SELECT (C.BlockName+'-'+B.ApartmentNo+'-'+A.RoomNo+'-'+A.RoomType) AS RoomNo,A.Id As RoomId
    FROM WRBHBPropertyRooms A
    JOIN WRBHBPropertyApartment B ON A.ApartmentId=B.Id AND  B.IsActive=1 AND B.IsDeleted=0
    JOIN WRBHBPropertyBlocks C ON B.BlockId=C.Id AND  C.IsActive=1 AND C.IsDeleted=0
    WHERE A.IsActive=1 AND A.IsDeleted=0 AND A.PropertyId=@Id AND A.ApartmentId=@UserId
 END
END
 
 

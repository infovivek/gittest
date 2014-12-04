-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_OutsourceKOTHdr_Help]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_OutsourceKOTHdr_Help]
GO 
-- ===============================================================================
-- Author: Anbu
-- Create date:01-08-2014
-- ModifiedBy :          , ModifiedDate: 
-- Description:	New KOT Entry
-- =================================================================================
CREATE PROCEDURE [dbo].[Sp_OutsourceKOTHdr_Help]
(@Action NVARCHAR(100)=NULL,
@Str1 NVARCHAR(100)=NULL,
@Id BIGINT=NULL)

AS
BEGIN
If @Action ='PageLoad'
	BEGIN
		SELECT DISTINCT (P.PropertyName+'-'+S.StateName) as Property, H.PropertyId AS PropertyId
		FROM WRBHBPropertyUsers H
		JOIN WRBHBProperty P ON H.PropertyId=P.Id AND P.IsActive=1 AND P.IsDeleted=0 
		JOIN  WRBHBState S on P.StateId = S.Id
		WHERE H.IsActive = 1 and H.IsDeleted = 0 AND H.UserId=@Id AND  P.Category IN('Internal Property','Managed G H')
	END
If @Action ='Property'
	BEGIN
	    SELECT DISTINCT ServiceItem,Id 
	    FROM WRBHBOutsourceServiceItems 
		WHERE IsActive=1 AND IsDeleted=0 
	END
	
IF @Action='Service'
    BEGIN
	    SELECT DISTINCT  ServiceItem ,V.Cost AS Price,V.ItemId,1 as Quantity, (1*Cost) as Amount,
	    0 AS Id
	    FROM WRBHBOutsourceServiceItems O
		JOIN WRBHBVendorCost V ON O.ItemId= V.ItemId AND V.IsActive=1 AND V.IsDeleted=0
		WHERE  O.IsActive=1 AND O.IsDeleted=0 AND O.ServiceItem=@Str1 AND V.Flag=1
	END
END



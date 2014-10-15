SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[SP_PaxInOut_Select]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[SP_PaxInOut_Select]
GO 
-- ===============================================================================
-- Author     :	Anbu
-- Create date: 30-06-2014
-- ModifiedBy :              
-- ModifiedDate  : 
-- Description:	Pax In/Out Select
-- =================================================================================
CREATE PROCEDURE [dbo].[SP_PaxInOut_Select](@Id INT=NULL)
AS
BEGIN
IF @Id<>0 BEGIN
SELECT InOut,CONVERT(VARCHAR(100),Date,103) AS Dt,PropertyId,Property,TaxId,ChkInHdrId,
RoomId,RoomNo,RoomType,CAST(Tariff AS VARCHAR) AS NewTariff,ExtraBed,
CAST(Tax AS VARCHAR) AS NewTax,Cess,HECess,VAT,Luxury,ServiceTax,
Male AS NewMale,Female AS NewFemale,Child AS NewChild,OldMale,OldFemale,
CAST(OldTariff AS VARCHAR) AS OldTariff,CAST(OldTax AS VARCHAR) AS OldTax,
0 AS OldChild,Time,Id FROM WRBHBPaxInOut WHERE Id=@Id;
END
ELSE
BEGIN
     SELECT Property,RoomNo,CONVERT(VARCHAR(100),Date,103) AS Dt FROM WRBHBPaxInOut
END
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[dbo].[Sp_ClientColumn_update]') AND OBJECTPROPERTY(ID, N'ISPROCEDURE') = 1)
DROP PROCEDURE [dbo].[Sp_ClientColumn_update]
GO   
/* 
Author Name : <Naharjun.U>
Created On 	: <Created Date (22/04/2014)  >
*/            
/*******************************************************************************************************
*				AMENDMENT BLOCK
********************************************************************************************************
'Name			Date			Signature			Description of Changes
********************************************************************************************************	
Sakthi - Fields Added & Procedure Alteration
*******************************************************************************************************
*/
CREATE PROCEDURE [dbo].[Sp_ClientColumn_update](@ClientId BIGINT,
@Column1 NVARCHAR(100),@Column2 NVARCHAR(100),@Column3 NVARCHAR(100),
@Column4 NVARCHAR(100),@Column5 NVARCHAR(100),@Column6 NVARCHAR(100),
@Column7 NVARCHAR(100),@Column8 NVARCHAR(100),@Column9 NVARCHAR(100),
@Column10 NVARCHAR(100),@Column1Mandatory BIT,@Column2Mandatory BIT,
@Column3Mandatory BIT,@Column4Mandatory BIT,@Column5Mandatory BIT,
@Column6Mandatory BIT,@Column7Mandatory BIT,@Column8Mandatory BIT,
@Column9Mandatory BIT,@Column10Mandatory BIT,@UsrId BIGINT,@Id BIGINT,
@UpdateChkColumn1 BIT,@UpdateChkColumn2 BIT,@UpdateChkColumn3 BIT,
@UpdateChkColumn4 BIT,@UpdateChkColumn5 BIT,@UpdateChkColumn6 BIT,
@UpdateChkColumn7 BIT,@UpdateChkColumn8 BIT,@UpdateChkColumn9 BIT,
@UpdateChkColumn10 BIT)
AS
BEGIN
 UPDATE WRBHBClientColumns SET Column1 = @Column1,Column2 = @Column2,
 Column3 = @Column3,Column4 = @Column4,Column5 = @Column5,Column6 = @Column6,
 Column7 = @Column7,Column8 = @Column8,Column9 = @Column9,Column10 = @Column10,
 Column1Mandatory = @Column1Mandatory,Column2Mandatory = @Column2Mandatory,
 Column3Mandatory = @Column3Mandatory,Column4Mandatory = @Column4Mandatory,
 Column5Mandatory = @Column5Mandatory,Column6Mandatory = @Column6Mandatory,
 Column7Mandatory = @Column7Mandatory,Column8Mandatory = @Column8Mandatory,
 Column9Mandatory = @Column9Mandatory,Column10Mandatory = @Column10Mandatory,
 ModifiedBy = @UsrId,ModifiedDate = GETDATE(),
 UpdateChkColumn1 = @UpdateChkColumn1,UpdateChkColumn2 = @UpdateChkColumn2,
 UpdateChkColumn3 = @UpdateChkColumn3,UpdateChkColumn4 = @UpdateChkColumn4,
 UpdateChkColumn5 = @UpdateChkColumn5,UpdateChkColumn6 = @UpdateChkColumn6,
 UpdateChkColumn7 = @UpdateChkColumn7,UpdateChkColumn8 = @UpdateChkColumn8,
 UpdateChkColumn9 = @UpdateChkColumn9,UpdateChkColumn10 = @UpdateChkColumn10
 WHERE Id = @Id;
 SELECT Id,RowId FROM WRBHBClientColumns WHERE Id = @Id;
END		
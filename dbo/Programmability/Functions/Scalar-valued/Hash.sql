create function dbo.[Hash](
    @input varbinary (max)
  , @algorithm nvarchar (8) = N'SHA2_256'
)
returns varbinary (max)
as
external name [ByteGarden.SqlServer.Database].[HashFunctions].[Hash];
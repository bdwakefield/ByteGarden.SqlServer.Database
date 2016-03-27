create function dbo.LogicalOr(
    @x varbinary (max)
  , @y varbinary (max)
)
returns varbinary (max)
as
external name [ByteGarden.SqlServer.Database].[LogicalFunctions].[LogicalOr];
create function dbo.LogicalSet(
    @x varbinary (max)
  , @index int
  , @value bit
)
returns varbinary (max)
as
external name [ByteGarden.SqlServer.Database].[LogicalFunctions].[LogicalSet];
create function dbo.LogicalNot(
    @x varbinary (max)
)
returns varbinary (max)
as
external name [ByteGarden.SqlServer.Database].[LogicalFunctions].[LogicalNot];
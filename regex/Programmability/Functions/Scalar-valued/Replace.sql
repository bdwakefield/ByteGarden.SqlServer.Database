create function regex.[Replace](
    @input nvarchar (max)
  , @pattern nvarchar (max)
  , @replacement nvarchar(max)
  , @options int = 0
)
returns nvarchar (max)
as
external name [ByteGarden.SqlServer.Database].[RegexFunctions].[Replace];
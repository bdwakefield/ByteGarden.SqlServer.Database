create function regex.Matches(
    @input nvarchar(max)
  , @pattern nvarchar(max)
  , @options int
)
returns table (
    [Index] int null
  , [Length] int null
  , [Value] nvarchar(max) null
)
as
external name [ByteGarden.SqlServer.Database].[RegexFunctions].[Matches];
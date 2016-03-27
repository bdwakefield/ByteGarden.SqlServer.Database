create function regex.Match(
    @input nvarchar (max)
  , @pattern nvarchar (max)
  , @options int = 0
)
returns nvarchar (max)
as
external name [ByteGarden.SqlServer.Database].[RegexFunctions].[Match];
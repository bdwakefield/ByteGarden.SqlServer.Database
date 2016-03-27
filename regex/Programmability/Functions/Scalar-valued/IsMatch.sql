create function regex.IsMatch(
    @input nvarchar (max)
  , @pattern nvarchar (max)
  , @options int = 0
)
returns bit
as
external name [ByteGarden.SqlServer.Database].[RegexFunctions].[IsMatch];
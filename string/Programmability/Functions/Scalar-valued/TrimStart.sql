create function string.TrimStart(
    @input nvarchar(max)
  , @trimChars nvarchar(max)
)
returns nvarchar (max)
as
external name [ByteGarden.SqlServer.Database].[StringFunctions].[TrimStart];
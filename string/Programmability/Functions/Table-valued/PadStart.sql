create function string.PadStart(
    @input nvarchar(max) = null
  , @padChars nvarchar(max) = null
  , @padLength bigint = null
  , @maxLength bigint = null
)
returns table
with schemabinding
as return (
    select Right(Replicate(@padChars, Coalesce(@padLength, 1)) + @input, Coalesce(@maxLength, Len(@input) + Len(@padChars))) as s
);
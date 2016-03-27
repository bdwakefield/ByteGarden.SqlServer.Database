create function string.PadEnd(
    @input nvarchar(max) = null
  , @padChars nvarchar(max) = null
  , @padLength bigint = null
  , @maxLength bigint = null
)
returns table
with schemabinding
as return (
    select Left(@input + Replicate(@padChars, Coalesce(@padLength, 1)), Coalesce(@maxLength, Len(@input) + Len(@padChars))) as s
);
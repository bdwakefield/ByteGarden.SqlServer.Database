create function math.[Normalize](
    @f float = 1.
  , @x float = 0.
  , @y float = 1.
  , @a float = 0.
  , @b float = 1.
)
returns table
with schemabinding as
return (
    select ((@f - @x) * (@b - @a)) / NullIf(@y - @x, 0) + @a as f
);
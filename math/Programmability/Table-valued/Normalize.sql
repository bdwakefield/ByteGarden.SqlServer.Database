create function math.[Normalize](
    @f float = 1.
  , @inputMin float = 0.
  , @inputMax float = 1.
  , @outputMin float = 0.
  , @outputMax float = 1.
)
returns table
with schemabinding as
return (
    select ((@f - @inputMin) * (@outputMax - @outputMin)) / NullIf(@inputMax - @inputMin, 0) + @outputMin as f
);
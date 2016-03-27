create function math.RandomDate(
    @x date = N'0001-01-01'
  , @y date = N'9999-12-31'
)
returns table
with schemabinding as
return (
    select DateAdd(day, RandomIntBetween.n, case when @x < @y then @x else @y end) as d
    from math.RandomIntBetween(0, Abs(DateDiff(day, @x, @y)))
);
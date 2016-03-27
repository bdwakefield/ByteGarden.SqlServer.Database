create function math.RandomTime(
    @x time(3) = N'00:00:00.000'
  , @y time(3) = N'23:59:59.999'
)
returns table
with schemabinding as
return (
    select DateAdd(millisecond, RandomIntBetween.n, case when @x < @y then @x else @y end) as t
    from math.RandomIntBetween(0, Abs(DateDiff(millisecond, @x, @y)))
);
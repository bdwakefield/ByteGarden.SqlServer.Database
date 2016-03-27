create function math.RangeDate(
    @x date = N'0001-01-01'
  , @y date = N'9999-12-31'
)
returns table
with schemabinding as
return (
    select DateAdd(Day, [Iterator].n, case when @x < @y then @x else @y end) as d
    from math.RangeInt (0, Abs(DateDiff(Day, @x, @y))) as [Iterator]
);
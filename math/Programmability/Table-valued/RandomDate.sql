create function math.RandomDate()
returns table
with schemabinding as
return (
    select DateAdd(day, RandomOffset.n, Cast(N'0001-01-01' as date)) as d
    from math.RandomIntBetween(0, 3652058) as RandomOffset
);
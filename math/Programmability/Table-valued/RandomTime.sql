create function math.RandomTime()
returns table
with schemabinding as
return (
    select DateAdd(millisecond, RandomOffset.n, Cast(N'00:00:00.000' as time(3))) as t
    from math.RandomIntBetween(0, 86399999) as RandomOffset
);
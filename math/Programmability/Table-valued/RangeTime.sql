﻿create function math.RangeTime(
    @x time(3) = N'00:00:00.000'
  , @y time(3) = N'23:59:59.999'
  , @timePart nvarchar(20) = N'minute'
)
returns table
with schemabinding as
return (
    select case @timePart
               when N'millisecond' then DateAdd(Millisecond, [Iterator].n, Anchor.t)
               when N'second' then DateAdd(Second, [Iterator].n, Anchor.t)
               when N'minute' then DateAdd(Minute, [Iterator].n, Anchor.t)
               when N'hour' then DateAdd(Hour, [Iterator].n, Anchor.t)
           end as t
    from math.RangeInt (0, Abs(
        case @timePart
            when N'millisecond' then DateDiff(Millisecond, @x, @y)
            when N'second' then DateDiff(Second, @x, @y)
            when N'minute' then DateDiff(Minute, @x, @y)
            when N'hour' then DateDiff(Hour, @x, @y)
        end
    )) as [Iterator]
    cross apply (values(case when @x < @y then @x else @y end)) as Anchor (t)
);
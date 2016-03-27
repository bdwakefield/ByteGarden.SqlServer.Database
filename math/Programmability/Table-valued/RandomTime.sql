create function math.RandomTime(
    @x time(3) = N'00:00:00.000'
  , @y time(3) = N'23:59:59.999'
  , @timePart nvarchar(20) = N'minute'
)
returns table
with schemabinding as
return (
    select case @timePart
               when N'millisecond' then DateAdd(millisecond, RandomOffset.n, Anchor.t)
               when N'second' then DateAdd(second, RandomOffset.n, Anchor.t)
               when N'minute' then DateAdd(minute, RandomOffset.n, Anchor.t)
               when N'hour' then DateAdd(hour, RandomOffset.n, Anchor.t)
           end as t
    from math.RandomIntBetween(
        0
      , Abs(
            case @timePart
                when N'millisecond' then DateDiff(millisecond, @x, @y)
                when N'second' then DateDiff(second, @x, @y)
                when N'minute' then DateDiff(minute, @x, @y)
                when N'hour' then DateDiff(hour, @x, @y)
            end
        )
    ) as RandomOffset
    cross apply (values(case when @x < @y then @x else @y end)) as Anchor (t)
);
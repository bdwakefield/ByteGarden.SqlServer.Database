create function math.RangeTime(
    @x time(3) = N'00:00:00.000'
  , @y time(3) = N'23:59:59.999'
  , @timePart nvarchar(20) = N'minute'
)
/*
    What? Generates a range of up to 4,294,967,296 contiguous time values.

    How? 1) cache range of integers based on the absolute difference of @x and @y into [Iterator] (n)
         2) cache the min of @x and @y into Achor (t)
         3) calculate the value of the row by using DateAdd to offset Anchor(t) by [Iterator] (n)
 */
returns table
with schemabinding as
return (
    select case @timePart
               when N'millisecond' then DateAdd(millisecond, [Iterator].n, Anchor.t)
               when N'second' then DateAdd(second, [Iterator].n, Anchor.t)
               when N'minute' then DateAdd(minute, [Iterator].n, Anchor.t)
               when N'hour' then DateAdd(hour, [Iterator].n, Anchor.t)
           end as t
    from math.RangeInt (
        0
      , Abs(
            case @timePart
                when N'millisecond' then DateDiff(millisecond, @x, @y)
                when N'second' then DateDiff(second, @x, @y)
                when N'minute' then DateDiff(minute, @x, @y)
                when N'hour' then DateDiff(hour, @x, @y)
            end
        )
    ) as [Iterator]
    cross apply (values(case when @x < @y then @x else @y end)) as Anchor (t)
);
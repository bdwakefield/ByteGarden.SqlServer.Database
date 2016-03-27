create function math.RandomBigInt(
    @x bigint = -9223372036854775808
  , @y bigint = 9223372036854775807
)
returns table
with schemabinding as
return (
    select Cast(Round(c.f, 0, 0) as bigint) as n
    from (values(
        case when @x < @y then @x else @y end
      , case when @y > @x then @y else @x end
    )) a ([Min], [Max])
    cross join crypto.vw_RandomBytes8 as b
    cross apply math.[Normalize](
        Cast(b.Bytes as bigint)
      , -9223372036854775808
      , 9223372036854775807
      , a.[Min] - 0.5
      , a.[Max] + 0.5
    ) as c
);
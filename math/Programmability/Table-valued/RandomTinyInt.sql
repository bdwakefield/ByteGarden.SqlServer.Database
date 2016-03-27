create function math.RandomTinyInt(
    @x tinyint = 0
  , @y tinyint = 255
)
returns table
with schemabinding as
return (
    select Sign(c.f) * Ceiling(Abs(c.f) - 0.5) as n
    from (values(
        case when @x < @y then @x else @y end
      , case when @y > @x then @y else @x end
    )) a ([Min], [Max])
    cross join crypto.vw_RandomBytes1 as b
    cross apply math.[Normalize](
        Cast(b.Bytes as tinyint)
      , 0
      , 255
      , a.[Min] - 0.5
      , a.[Max] + 0.5
    ) as c
);
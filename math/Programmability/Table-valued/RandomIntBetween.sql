create function math.RandomIntBetween(
    @x int = -2147483648
  , @y int = 2147483647
)
returns table
with schemabinding as
return (
    select Cast(Round(c.f, 0, 0) as int) as n
    from (values(
        case when @x < @y then @x else @y end
      , case when @y > @x then @y else @x end
    )) a ([Min], [Max])
    cross join math.RandomInt()
    cross apply math.[Normalize](
        RandomInt.n
      , -2147483648
      , 2147483647
      , a.[Min] - 0.5
      , a.[Max] + 0.5
    ) as c
);
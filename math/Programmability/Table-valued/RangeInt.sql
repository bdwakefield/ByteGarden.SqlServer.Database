create function math.RangeInt(
    @x bigint = null
  , @y bigint = null
)
returns table
with schemabinding as
return (
    -- Generate a range of up to 4,294,967,296 contiguous bigints
    with Ints (n) as (select Ints.n from math.RangeSmallInt(0, 65535) as Ints)
    select top (Coalesce(Abs(@x - @y) + 1, 0))
           Row_Number() over(order by (select null)) + case when @x <= @y then @x else @y end - 1 as n
    from Ints x
    cross join Ints y
    where Abs(@x - @y) + 1 < 4294967297
);
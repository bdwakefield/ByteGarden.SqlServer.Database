create function math.RangeSmallInt(
    @x bigint = null
  , @y bigint = null
)
/*
    What? Generates a range of up to 65,536 contiguous bigint values.

    When? Enumeration, Looping

    How? 1) cache an array of 256 values into Ints (n) by cloning @x 256 times
         2) cross join Ints with itself to create an array of 65,536 values
         3) bail early if requested range exceeds 65,536 values
         4) calculate the number of rows to return based on the absolute difference of @x and @y
         5) calculate the value of the row by generating a row number and offsetting it by the max of @x and @y
 */
returns table
with schemabinding as
return (
    with Ints (n) as ( /* 1 */
        select Ints.n
        from (values
            (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x) -- 16
          , (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x) -- 32
          , (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x) -- 48
          , (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x) -- 64
          , (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x) -- 80
          , (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x) -- 96
          , (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x) -- 112
          , (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x) -- 128
          , (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x) -- 144
          , (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x) -- 160
          , (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x) -- 176
          , (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x) -- 192
          , (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x) -- 208
          , (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x) -- 224
          , (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x) -- 240
          , (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x), (@x) -- 256
        ) Ints (n)
    )
    select top (Coalesce(Abs(@x - @y) + 1, 0)) /* 4 */
           Row_Number() over(order by (select null)) + case when @x < @y then @x else @y end - 1 as n /* 5 */
    from Ints x
    cross join Ints y /* 2 */
    where Abs(@x - @y) + 1 < 65537 /* 3 */
);
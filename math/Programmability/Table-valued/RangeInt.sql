create function math.RangeInt(
    @x bigint = null
  , @y bigint = null
)
/*
    What? Generates a range of up to 4,294,967,296 contiguous bigint values.

    When? Enumeration, Looping

    How? 1) cache an array of 65,536 values into Ints (n) using the full width of math.RangeSmallInt
         2) cross join Ints with itself to create an array of 4,294,967,296 values
         3) bail early if requested range exceeds 4,294,967,297 values
         4) calculate the number of rows to return based on the absolute difference of @x and @y
         5) calculate the value of the row by generating a row number and offsetting it by the max of @x and @y
 */
returns table
with schemabinding as
return (
    with Ints (n) as (select Ints.n from math.RangeSmallInt(0, 65535) as Ints) /* 1 */
    select top (Coalesce(Abs(@x - @y) + 1, 0)) /* 4 */
           Row_Number() over(order by (select null)) + case when @x < @y then @x else @y end - 1 as n /* 5 */
    from Ints x
    cross join Ints y /* 2 */
    where Abs(@x - @y) + 1 < 4294967297 /* 3 */
);
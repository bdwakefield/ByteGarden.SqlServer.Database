create function math.RangeDate(
    @x date = N'0001-01-01'
  , @y date = N'9999-12-31'
)
/*
    What? Generates a range of up to 4,294,967,296 contiguous date values.

    How? 1) cache range of integers based on the absolute difference of @x and @y into [Iterator] (n)
         2) calculate the value of the row by using DateAdd to offset the min of @x and @y by [Iterator] (n)
 */
returns table
with schemabinding as
return (
    select DateAdd(Day, [Iterator].n, case when @x < @y then @x else @y end) as d /* 2 */
    from math.RangeInt (0, Abs(DateDiff(Day, @x, @y))) as [Iterator] /* 1 */
);
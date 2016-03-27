create function math.RandomAscii(
    @x tinyint = 0
  , @y tinyint = 255
)
returns table
with schemabinding as
return (
    select Char(a.n) as c
    from math.RandomInt(@x, @y) as a
);
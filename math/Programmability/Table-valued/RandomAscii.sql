create function math.RandomAscii(
    @x tinyint = 0
  , @y tinyint = 255
)
returns table
with schemabinding as
return (
    select Char(a.n) as c
    from math.RandomTinyInt(@x, @y) as a
);
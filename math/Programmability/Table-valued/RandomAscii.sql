create function math.RandomAscii(
    @x char = 'A'
  , @y char = 'Z'
)
returns table
with schemabinding as
return (
    select Char(a.n) as c
    from math.RandomInt(Ascii(@x), Ascii(@y)) as a
);
create function math.RandomAscii()
returns table
with schemabinding as
return (
    select Char(RandomIntBetween.n) as c
    from math.RandomIntBetween(0, 255)
);
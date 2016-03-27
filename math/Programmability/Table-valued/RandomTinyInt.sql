create function math.RandomTinyInt()
returns table
with schemabinding as
return (
    select Cast(a.Bytes as tinyint) as n
    from crypto.vw_RandomBytes1 as a
);
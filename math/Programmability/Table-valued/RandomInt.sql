create function math.RandomInt()
returns table
with schemabinding as
return (
    select Cast(a.Bytes as int) as n
    from crypto.vw_RandomBytes4 as a
);
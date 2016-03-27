create function math.RandomBigInt()
returns table
with schemabinding as
return (
    select Cast(a.Bytes as bigint) as n
    from crypto.vw_RandomBytes8 as a
);
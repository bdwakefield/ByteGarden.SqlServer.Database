create function math.RandomFloat()
returns table
with schemabinding as
return (
    select Coefficient.f
         * (Cast(Substring(a.Bytes, 1, 1) as tinyint) + Coefficient.f
         * (Cast(Substring(a.Bytes, 2, 1) as tinyint) + Coefficient.f
         * (Cast(Substring(a.Bytes, 3, 1) as tinyint) + Coefficient.f
         * Cast(Substring(a.Bytes, 4, 1) as tinyint)))) as f
    from (values(1. / 256)) as Coefficient (f)
    cross join crypto.vw_RandomBytes8 as a
);
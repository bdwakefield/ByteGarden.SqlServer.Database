create view crypto.vw_RandomBytes4
with schemabinding
as (
    select Crypt_Gen_Random(4) as Bytes
);
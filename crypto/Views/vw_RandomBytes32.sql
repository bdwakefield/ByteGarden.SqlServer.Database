create view crypto.vw_RandomBytes32
with schemabinding
as (
    select Crypt_Gen_Random(32) as Bytes
);
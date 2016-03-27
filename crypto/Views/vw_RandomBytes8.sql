create view crypto.vw_RandomBytes8
with schemabinding
as (
    select Crypt_Gen_Random(8) as Bytes
);
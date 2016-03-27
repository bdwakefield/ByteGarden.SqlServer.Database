create view crypto.vw_RandomBytes2
with schemabinding
as (
    select Crypt_Gen_Random(2) as Bytes
);
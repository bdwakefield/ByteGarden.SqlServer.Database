create view crypto.vw_RandomBytes16
with schemabinding
as (
    select Crypt_Gen_Random(16) as Bytes
);
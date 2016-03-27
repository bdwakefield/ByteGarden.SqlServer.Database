create view crypto.vw_RandomBytes1
with schemabinding
as (
    select Crypt_Gen_Random(1) as Bytes
);
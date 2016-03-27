create function crypto.Totp (
    @key varbinary(max) = 0x3132333435363738393031323334353637383930313233343536373839303132 
  , @timeStep int = 30
  , @unixEpoch bigint = 59
)
returns table
with schemabinding as
return (
    select [Pin].s as Pin
    from crypto.Hmac(@key, Cast(Cast(Floor(1. * @unixEpoch / @timeStep) as bigint) as binary(8))) [Hash]
    cross apply (values(Cast(Substring([Hash].Bytes, DataLength([Hash].Bytes), 1) as tinyint) & 0xF)) Offset (n)
    cross apply (values(
        ((Substring([Hash].Bytes, Offset.n + 1, 1) & 127) * 16777216)
      + ((Substring([Hash].Bytes, Offset.n + 2, 1) & 255) * 65536)
      + ((Substring([Hash].Bytes, Offset.n + 3, 1) & 255) * 256)
      + (Substring([Hash].Bytes, Offset.n + 4, 1) & 255)
    )) [Binary] (n)
    cross apply (values([Binary].n % 100000000)) [Password] (n)
    cross apply string.PadStart(Cast([Password].n as nvarchar(max)), N'0', 8, 8) [Pin]
);
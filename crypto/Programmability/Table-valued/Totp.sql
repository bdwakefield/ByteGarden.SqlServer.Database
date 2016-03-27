create function crypto.Totp (
    @key varbinary(max) = 0x3132333435363738393031323334353637383930313233343536373839303132 
  , @timeStep int = 30
  , @unixTime bigint = 59
)
/*
    What? Generates an 8 digit pin based off of a given key, time step, and unix time.

    When? Crytography

    Why? https://tools.ietf.org/html/rfc6238
 */
returns table
with schemabinding as
return (
    select [Pin].s as Pin
    from crypto.Hmac(@key, Cast(Cast(Floor(1. * @unixTime / @timeStep) as bigint) as binary(8)))
    cross apply (values(Cast(Substring(Hmac.Code, DataLength(Hmac.Code), 1) as tinyint) & 0xF)) Offset (n)
    cross apply (values(
        ((Substring(Hmac.Code, Offset.n + 1, 1) & 127) * 16777216)
      + ((Substring(Hmac.Code, Offset.n + 2, 1) & 255) * 65536)
      + ((Substring(Hmac.Code, Offset.n + 3, 1) & 255) * 256)
      + (Substring(Hmac.Code, Offset.n + 4, 1) & 255)
    )) [Binary] (n)
    cross apply (values([Binary].n % 100000000)) [Password] (n)
    cross apply string.PadStart(Cast([Password].n as nvarchar(max)), N'0', 8, 8) [Pin]
);
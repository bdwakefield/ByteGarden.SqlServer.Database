create function crypto.Hmac (
    @key varbinary(max) = 0x0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
  , @message varbinary(max) = 0x4869205468657265
)   
returns table
with schemabinding as
return (
    select dbo.[Hash](Pads.o + dbo.[Hash](Pads.i + @message, N'SHA2_256'), N'SHA2_256') as Bytes
    from (values(
        Cast( -- keys longer than blocksize are shortened and keys shorter than blocksize are zero-padded
            case
                when DataLength(@key) > 64 then dbo.[Hash](@key, N'SHA2_256')
                else @key
            end
        as binary(64))
      , Cast(0x3636363636363636 as bigint) -- Rfc2104 inner padding constant
      , Cast(0x5C5C5C5C5C5C5C5C as bigint) -- Rfc2104 outer padding constant
    )) as Vars ([key], innerPadding, outerPadding)
    cross apply (values(
      -- unrolled loop to XOR key and iPad
        Cast((Substring(Vars.[key], 1, 8) ^ Vars.innerPadding) as binary(8))
      + Cast((Substring(Vars.[key], 9, 8) ^ Vars.innerPadding) as binary(8))
      + Cast((Substring(Vars.[key], 17, 8) ^ Vars.innerPadding) as binary(8))
      + Cast((Substring(Vars.[key], 25, 8) ^ Vars.innerPadding) as binary(8))
      + Cast((Substring(Vars.[key], 33, 8) ^ Vars.innerPadding) as binary(8))
      + Cast((Substring(Vars.[key], 41, 8) ^ Vars.innerPadding) as binary(8))
      + Cast((Substring(Vars.[key], 49, 8) ^ Vars.innerPadding) as binary(8))
      + Cast((Substring(Vars.[key], 57, 8) ^ Vars.innerPadding) as binary(8))
      -- unrolled loop to XOR key and oPad
      , Cast((Substring(Vars.[key], 1, 8) ^ Vars.outerPadding) as binary(8))
      + Cast((Substring(Vars.[key], 9, 8) ^ Vars.outerPadding) as binary(8))
      + Cast((Substring(Vars.[key], 17, 8) ^ Vars.outerPadding) as binary(8))
      + Cast((Substring(Vars.[key], 25, 8) ^ Vars.outerPadding) as binary(8))
      + Cast((Substring(Vars.[key], 33, 8) ^ Vars.outerPadding) as binary(8))
      + Cast((Substring(Vars.[key], 41, 8) ^ Vars.outerPadding) as binary(8))
      + Cast((Substring(Vars.[key], 49, 8) ^ Vars.outerPadding) as binary(8))
      + Cast((Substring(Vars.[key], 57, 8) ^ Vars.outerPadding) as binary(8))
    )) as Pads (i, o)
);
create function crypto.Hmac (
    @key varbinary(max) = 0x0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B
  , @message varbinary(max) = 0x4869205468657265
)
/*
    What? Generates a code that simultaneously verifies the data integrity and authentication of a message.

    When? Crytography

    Why? https://tools.ietf.org/html/rfc2104

    How? 1a) cache Rfc2104's inner padding constant
         1b) cache Rfc2104's outer padding constant
         1c) keys shorter than or equal to the block size (64) are zero padded
             keys longer than the block size (64) are hashed and then zero padded
         2a) XOR each byte of the key with the inner padding constant and sum the results in an unrolled loop
         2b) XOR each byte of the key with the outer padding constant and sum the results in an unrolled loop
         3) concatenate iPad with @message
         4) hash the result
         5) concatenate oPad with the hash
         6) hash the result
 */
returns table
with schemabinding as
return (
    select dbo.[Hash](Pads.o + /* 5 */ dbo.[Hash](Pads.i + /* 3 */ @message, N'SHA2_256')/* 4 */, N'SHA2_256')/* 6 */ as Code
    from (values(
        Cast(0x3636363636363636 as bigint) /* 1a */
      , Cast(0x5C5C5C5C5C5C5C5C as bigint) /* 1b */
      , Cast(case when DataLength(@key) < 65 then @key else dbo.[Hash](@key, N'SHA2_256') end as binary(64)) /* 1c */
    )) as Vars (innerPadding, outerPadding, [key])
    cross apply (values(
      /* 2a */
        Cast((Substring(Vars.[key], 1, 8) ^ Vars.innerPadding) as binary(8)) -- loop iteration 0 (byte offset 0)
      + Cast((Substring(Vars.[key], 9, 8) ^ Vars.innerPadding) as binary(8)) -- loop iteration 1 (byte offset 8)
      + Cast((Substring(Vars.[key], 17, 8) ^ Vars.innerPadding) as binary(8)) -- loop iteration 2 (byte offset 16)
      + Cast((Substring(Vars.[key], 25, 8) ^ Vars.innerPadding) as binary(8)) -- loop iteration 3 (byte offset 24)
      + Cast((Substring(Vars.[key], 33, 8) ^ Vars.innerPadding) as binary(8)) -- loop iteration 4 (byte offset 32)
      + Cast((Substring(Vars.[key], 41, 8) ^ Vars.innerPadding) as binary(8)) -- loop iteration 5 (byte offset 40)
      + Cast((Substring(Vars.[key], 49, 8) ^ Vars.innerPadding) as binary(8)) -- loop iteration 6 (byte offset 48)
      + Cast((Substring(Vars.[key], 57, 8) ^ Vars.innerPadding) as binary(8)) -- loop iteration 7 (byte offset 56)
      /* 2b */
      , Cast((Substring(Vars.[key], 1, 8) ^ Vars.outerPadding) as binary(8)) -- loop iteration 0 (byte offset 0)
      + Cast((Substring(Vars.[key], 9, 8) ^ Vars.outerPadding) as binary(8)) -- loop iteration 1 (byte offset 8)
      + Cast((Substring(Vars.[key], 17, 8) ^ Vars.outerPadding) as binary(8)) -- loop iteration 2 (byte offset 16)
      + Cast((Substring(Vars.[key], 25, 8) ^ Vars.outerPadding) as binary(8)) -- loop iteration 3 (byte offset 24)
      + Cast((Substring(Vars.[key], 33, 8) ^ Vars.outerPadding) as binary(8)) -- loop iteration 4 (byte offset 32)
      + Cast((Substring(Vars.[key], 41, 8) ^ Vars.outerPadding) as binary(8)) -- loop iteration 5 (byte offset 40)
      + Cast((Substring(Vars.[key], 49, 8) ^ Vars.outerPadding) as binary(8)) -- loop iteration 6 (byte offset 48)
      + Cast((Substring(Vars.[key], 57, 8) ^ Vars.outerPadding) as binary(8)) -- loop iteration 7 (byte offset 56)
    )) as Pads (i, o)
);
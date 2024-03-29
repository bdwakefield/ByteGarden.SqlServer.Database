﻿create function crypto.Pbkdf2 (
    @password varbinary(max) = 0x70617373776F7264
  , @salt varbinary(max) = 0x73616C74
  , @derivedKeyLength int = 32
  , @iterations int = 1000
)
/*
    What? Generates a cryptographic key of a particular length by deriving a value from a given password and salt.

    When? Crytography

    Why? https://tools.ietf.org/html/rfc2898
 */
returns varbinary(max)
with schemabinding
as
begin;
    declare @hmacLength int = 32;
    declare @i int = 1;
    declare @l int = (@derivedKeyLength + @hmacLength - 1) / @hmacLength;
    declare @r int = @derivedKeyLength - (@l - 1) * @hmacLength;
    declare @derivedKey varbinary(max) = Cast('' as varbinary(max));
    declare @uA binary(32);
    declare @uB binary(32);

    while(@i <= @l)
    begin;
        declare @j int = 1;

        select @uA = uA.Code
             , @uB = uA.Code
        from crypto.Hmac(@password, @salt + Cast(@i as binary(4))) as uA;

        while @j < @iterations
        begin;
            select @uA = tA.Code from crypto.Hmac(@password, @uA) as tA;
            select @uB = tB.Code
            from (values(-- unrolled loop to XOR uA and uB
                Cast(Substring(@uA, 1, 8) ^ Cast(Substring(@uB, 1, 8) as bigint) as binary(8))
              + Cast(Substring(@uA, 9, 8) ^ Cast(Substring(@uB, 9, 8) as bigint) as binary(8))
              + Cast(Substring(@uA, 17, 8) ^ Cast(Substring(@uB, 17, 8) as bigint) as binary(8))
              + Cast(Substring(@uA, 25, 8) ^ Cast(Substring(@uB, 25, 8) as bigint) as binary(8))
            )) tB (Code);

            select @j = @j + 1;
        end;

        select @derivedKey = @derivedKey + Cast(case when @i = @l then Left(@uB, @r) else @uB end as varbinary(32));

        select @i = @i + 1;
    end;

    return @derivedKey;
end;
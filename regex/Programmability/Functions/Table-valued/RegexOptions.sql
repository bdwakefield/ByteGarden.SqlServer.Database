create function regex.RegexOptions ()
returns table
with schemabinding as
return (
    select [None] = 0
         , IgnoreCase = 1
         , Multiline = 2
         , ExplicitCapture = 4
         , Compiled = 8
         , Singleline = 16
         , IgnorePatternWhitespace = 32
         , RightToLeft = 64
         , ECMAScript = 256
         , CultureInvariant = 512
);
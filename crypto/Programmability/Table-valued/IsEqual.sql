create function crypto.IsEqual (
    @x varbinary(max) = 0x00
  , @y varbinary(max) = 0x00
)
/*
    What? Compares two variable length binary strings byte by byte in constant time.

    When? Cryptography, Gaming

    Why? Given the strings 0x1234 and 0x1213: a simple equality comparison will stop processing after
         it hits the first difference at byte position 3. An opponent who only knows @x can exploit this
         feature to guess @y by trying thousands of comparisons and gathering statistics on how long
         each one took.

         In other words, assuming that it takes 100 milliseconds to compare a 16 byte string, an
         opponent can rely on the fact that strings that take more than 50 milliseconds to process are
         better guesses than ones that take less than 50 milliseconds. Thus, if a comparison takes 50
         milliseconds then @x is a 50% match of @y (from byte positions 1 through 8).

    How? 1) cache the length of @x into [@xLength] (n)
         2) cache a range of integers from 1 to XLength.n into [Iterator] (n)
         3) bail early if the lengths of @x and @y are not equal
         4) XOR nth byte of @x with nth byte of @y
         5) SUM all XOR results then cast to bit (0 will stay 0, any other number will become 1)
         6) invert the result to match "IsEqual" naming convention
 */
returns table
with schemabinding as
return (
    select ~/* 6 */Cast(Sum(/* 5 */Substring(@x, [Iterator].n, 1) ^ /* 4 */Cast(Substring(@y, [Iterator].n, 1) as tinyint)) as bit) as b
    from (values(DataLength(@x))) as [@xLength] (n) /* 1 */
    cross apply math.RangeInt(1, [@xLength].n) as [Iterator] /* 2 */
    where Abs([@xLength].n - DataLength(@y)) = 0 /* 3 */
);
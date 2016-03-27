create function math.Clamp(
    @f float = 0.
  , @x float = -1.
  , @y float = 1.
)
returns table
with schemabinding as
return (
    select case
               when @f < @x then @x
               when @f > @y then @y
               else @f
           end as f
);
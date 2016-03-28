create function math.Clamp(
    @f float = 0.
  , @min float = -1.
  , @max float = 1.
)
returns table
with schemabinding as
return (
    select case
               when @f < @min then @min
               when @f > @max then @max
               else @f
           end as f
);
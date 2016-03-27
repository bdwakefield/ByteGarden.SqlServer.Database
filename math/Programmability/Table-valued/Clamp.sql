create function math.Clamp(
    @f float = 0.
  , @x float = 0.
  , @y float = 1.
)
returns table
with schemabinding as
return (
    select case
               when [Difference].f = 0 then @f
               when [Difference].f < @x then @x
               when [Difference].f > @y then @y
           end as f
    from (values(@x - @y)) [Difference] (f)
);
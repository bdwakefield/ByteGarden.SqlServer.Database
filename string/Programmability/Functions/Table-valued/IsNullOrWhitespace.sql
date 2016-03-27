create function string.IsNullOrWhitespace(
    @input nvarchar(max) = null
)
returns table
with schemabinding
as return (
    select case when NullIf(@input, N'') is null then 1 else 0 end as b
);
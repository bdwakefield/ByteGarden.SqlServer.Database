create function web.HttpRequestCacheLevel()
returns table
with schemabinding as
return (
    select 0 as [Default]
         , 1 as BypassCache
         , 2 as CacheOnly
         , 3 as CacheIfAvailable
         , 4 as Revalidate
         , 5 as Reload
         , 6 as NoCacheNoStore
         , 7 as CacheOrNextCacheOnly
         , 8 as Refresh
);
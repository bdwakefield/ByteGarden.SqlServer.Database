create function web.[GET](
    @url nvarchar (max)
  , @httpRequestCacheLevel int = 0
  , @chunkSize int = 1024
  , @basicAuthUserName nvarchar (4000) = null
  , @basicAuthPassword nvarchar (4000) = null
)
returns varbinary (max)
as
external name [ByteGarden.SqlServer.Database].[WebFunctions].[GET];
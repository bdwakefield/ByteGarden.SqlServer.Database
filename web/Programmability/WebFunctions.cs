using Microsoft.SqlServer.Server;
using System.Data.SqlTypes;
using System.IO;
using System.Net;
using System.Net.Cache;

public sealed class WebFunctions
{
    [SqlFunction(DataAccess = DataAccessKind.None, IsDeterministic = true, IsPrecise = false)]
    public static SqlBytes GET(SqlString url, SqlInt32 httpRequestCacheLevel, SqlInt32 chunkSize, SqlString basicAuthUserName, SqlString basicAuthPassword) {
        if (url.IsNull || url.Value.Trim() == "") { return SqlBytes.Null; }
        else {
            if (httpRequestCacheLevel.IsNull) { httpRequestCacheLevel = (int)HttpRequestCacheLevel.Default; }
            if (chunkSize.IsNull) { chunkSize = 1024; }
        }

        var stream = new MemoryStream();
        var request = WebRequest.Create(url.Value);
        request.CachePolicy = new HttpRequestCachePolicy((HttpRequestCacheLevel)httpRequestCacheLevel.Value);

        if (!basicAuthUserName.IsNull && basicAuthUserName.Value.Trim() != "" && !basicAuthPassword.IsNull && basicAuthPassword.Value.Trim() != "") {
            request.Credentials = new NetworkCredential { UserName = basicAuthUserName.Value, Password = basicAuthPassword.Value };
        }

        using (var response = request.GetResponse()) {
            var resultStream = response.GetResponseStream();
            var buffer = new byte[chunkSize.Value];
            var bytesRead = 0;

            while ((bytesRead = resultStream.Read(buffer, 0, chunkSize.Value)) > 0) {
                stream.Write(buffer, 0, bytesRead);
            }
        }

        return new SqlBytes(stream);
    }
}
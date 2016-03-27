using Microsoft.SqlServer.Server;
using System.Data.SqlTypes;

public sealed class StringFunctions
{
    [SqlFunction]
    public static SqlString Trim(SqlString input, SqlChars trimChars) {
        if (input.IsNull) { return SqlString.Null; }
        else if (trimChars.IsNull) { return input; }
        else {
            return input.Value.Trim(trimChars.Value);
        }
    }
    [SqlFunction]
    public static SqlString TrimEnd(SqlString input, SqlChars trimChars) {
        if (input.IsNull) { return SqlString.Null; }
        else if (trimChars.IsNull) { return input; }
        else {
            return input.Value.TrimEnd(trimChars.Value);
        }
    }
    [SqlFunction]
    public static SqlString TrimStart(SqlString input, SqlChars trimChars) {
        if (input.IsNull) { return SqlString.Null; }
        else if (trimChars.IsNull) { return input; }
        else {
            return input.Value.TrimStart(trimChars.Value);
        }
    }
}
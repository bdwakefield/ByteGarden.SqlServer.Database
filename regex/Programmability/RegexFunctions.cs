using Microsoft.SqlServer.Server;
using System.Collections;
using System.Data.SqlTypes;
using System.Linq;
using System.Text.RegularExpressions;

public sealed class RegexFunctions
{
    [SqlFunction]
    public static SqlBoolean IsMatch(SqlString input, SqlString pattern, SqlInt32 options) {
        if (input.IsNull || pattern.IsNull) { return SqlBoolean.Null; }
        else if (options.IsNull) { options = (int)RegexOptions.None; }

        return Regex.IsMatch(input.Value, pattern.Value, (RegexOptions)options.Value);
    }
    [SqlFunction]
    public static SqlString Match(SqlString input, SqlString pattern, SqlInt32 options) {
        if (input.IsNull || pattern.IsNull) { return SqlString.Null; }
        else if (options.IsNull) { options = (int)RegexOptions.None; }

        return Regex.Match(input.Value, pattern.Value, (RegexOptions)options.Value).Value;
    }
    [SqlFunction]
    public static SqlString Replace(SqlString input, SqlString pattern, SqlString replacement, SqlInt32 options) {
        if (input.IsNull || pattern.IsNull || replacement.IsNull) { return SqlString.Null; }
        else if (options.IsNull) { options = (int)RegexOptions.None; }

        return Regex.Replace(input.Value, pattern.Value, replacement.Value, (RegexOptions)options.Value);
    }
    [SqlFunction(
        DataAccess = DataAccessKind.None,
        FillRowMethodName = "Matches_FillRow",
        IsDeterministic = true,
        IsPrecise = false,
        SystemDataAccess = SystemDataAccessKind.None,
        TableDefinition =
            @"[Index] int
            , Length int
            , Value nvarchar(max)"
    )]
    public static IEnumerable Matches(SqlString input, SqlString pattern, SqlInt32 options) {
        if (input.IsNull || pattern.IsNull) { return Enumerable.Empty<SqlString>(); }
        else if (options.IsNull) { options = (int)RegexOptions.None; }

        return Regex.Matches(input.Value, pattern.Value, (RegexOptions)options.Value);
    }

    // Private Methods
    private static void Matches_FillRow(object obj, out SqlInt32 index, out SqlInt32 length, out SqlString value) {
        var o = (Match)obj;

        index = o.Index;
        length = o.Length;
        value = o.Value;
    }
}
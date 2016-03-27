using Microsoft.SqlServer.Server;
using System.Collections;
using System.Data.SqlTypes;

public sealed class LogicalFunctions
{
    [SqlFunction]
    public static SqlBytes LogicalAnd(SqlBytes x, SqlBytes y) {
        if (x.IsNull || y.IsNull) { return SqlBytes.Null; }
        else {
            byte[] buffer;

            if (x.Length > y.Length) {
                buffer = new byte[x.Length];

                y.Value.CopyTo(buffer, x.Length - y.Length);

                new BitArray(x.Value).And(new BitArray(buffer)).CopyTo(buffer, 0);
            }
            else {
                buffer = new byte[y.Length];

                x.Value.CopyTo(buffer, y.Length - x.Length);

                new BitArray(buffer).And(new BitArray(y.Value)).CopyTo(buffer, 0);
            }

            return new SqlBytes(buffer);
        }
    }
    [SqlFunction]
    public static SqlBytes LogicalNot(SqlBytes x) {
        if (x.IsNull) { return SqlBytes.Null; }
        else {
            var buffer = new byte[x.Length];

            new BitArray(x.Value).Not().CopyTo(buffer, 0);

            return new SqlBytes(buffer);
        }
    }
    [SqlFunction]
    public static SqlBytes LogicalOr(SqlBytes x, SqlBytes y) {
        if (x.IsNull || y.IsNull) { return SqlBytes.Null; }
        else {
            byte[] buffer;

            if (x.Length > y.Length) {
                buffer = new byte[x.Length];

                y.Value.CopyTo(buffer, x.Length - y.Length);

                new BitArray(x.Value).Or(new BitArray(buffer)).CopyTo(buffer, 0);
            }
            else {
                buffer = new byte[y.Length];

                x.Value.CopyTo(buffer, y.Length - x.Length);

                new BitArray(buffer).Or(new BitArray(y.Value)).CopyTo(buffer, 0);
            }

            return new SqlBytes(buffer);
        }
    }
    [SqlFunction]
    public static SqlBytes LogicalSet(SqlBytes x, SqlInt32 index, SqlBoolean value) {
        if (x.IsNull || index.IsNull || value.IsNull) { return SqlBytes.Null; }
        else {
            var bits = new BitArray(x.Value);
            var buffer = new byte[x.Length];

            bits.Set(index.Value, value.Value);
            bits.CopyTo(buffer, 0);

            return new SqlBytes(buffer);
        }
    }
    [SqlFunction]
    public static SqlBytes LogicalXor(SqlBytes x, SqlBytes y) {
        if (x.IsNull || y.IsNull) { return SqlBytes.Null; }
        else {
            byte[] buffer;

            if (x.Length > y.Length) {
                buffer = new byte[x.Length];

                y.Value.CopyTo(buffer, x.Length - y.Length);

                new BitArray(x.Value).Xor(new BitArray(buffer)).CopyTo(buffer, 0);
            }
            else {
                buffer = new byte[y.Length];

                x.Value.CopyTo(buffer, y.Length - x.Length);

                new BitArray(buffer).Xor(new BitArray(y.Value)).CopyTo(buffer, 0);
            }

            return new SqlBytes(buffer);
        }
    }
}
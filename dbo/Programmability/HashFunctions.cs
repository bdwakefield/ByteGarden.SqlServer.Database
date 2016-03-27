using Microsoft.SqlServer.Server;
using System.Data.SqlTypes;
using System.Security.Cryptography;

public sealed class HashFunctions
{
    private static readonly MD5 m_md5 = MD5.Create();
    private static readonly SHA256 m_sha256 = SHA256.Create();
    private static readonly SHA512 m_sha512 = SHA512.Create();

    [SqlFunction]
    public static SqlBinary Hash(SqlBytes input, SqlString algorithm) {
        if (input.IsNull) { return SqlBinary.Null; }
        else if (algorithm.IsNull) { algorithm = "SHA2_256"; }

        switch (algorithm.Value) {
            case "SHA2_256":
                return new SqlBinary(m_sha256.ComputeHash(input.Stream));
            case "SHA2_512":
                return new SqlBinary(m_sha512.ComputeHash(input.Stream));
            case "MD5":
                return new SqlBinary(m_md5.ComputeHash(input.Stream));
            default:
                return new SqlBinary(m_sha256.ComputeHash(input.Stream));
        }
    }
}
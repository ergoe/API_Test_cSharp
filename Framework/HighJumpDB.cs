
using Dapper;
using System;
using System.Configuration;

using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.IO;
using System.Text;

namespace Api_TestFramework.Framework
{
    class HighJumpDB
    {
        public static void TestConnection()
        {
            string connectionString = null;
            connectionString = "Data Source=HJTESTDB;Initial Catalog=AAD;persist security info=True;user id=tmWMS-prod;password=nH4dhSd4bDsbz@b3dbSd6b;MultipleActiveResultSets=True;App=EntityFramework";
            
            var sql = Resources.Resource.HJ_COMPOUND_LABEL_XML.ToString();
            
            StringBuilder strb = new StringBuilder();
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();
                SqlCommand command = new SqlCommand(sql, connection);
                SqlDataReader reader = command.ExecuteReader();
                while(reader.Read())
                {                                
                    strb.Append(String.Format("{0}", reader[0]));
                }

                File.WriteAllText(@"D:\gitRepos\Api_TestFramework\TempXml\foo.xml", strb.ToString(), Encoding.UTF8);
            }
        }
    }
}

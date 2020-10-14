using System;
using RestSharp;
using Xunit;

namespace Api_TestFramework
{

    public class UnitTest1
    {

        private const string BASE_URL = "https://www.metaweather.com/api/";

        [Fact]
        public void Test1()
        {
            RestClient client = new RestClient();
            Assert.Equal(4, Add(2, 2));
        }

        [Fact]
        public void Test2()
        {

        }

        int Add(int x, int y)
        {
            return x + y;
        }
    }
}
using RestSharp;
using TechTalk.SpecFlow;

namespace Api_TestFramework.Steps
{
       
    [Binding]
    [Scope]
    public class BaseTestSteps
    {
        private RestClient _restclient = null;
        
        [When(@"user gets '(.*)'")]
        public void WhenUserGets(string endpoint)
        {
            _restclient = new RestClient(endpoint);
            
            var request = new RestRequest(Method.GET);

            IRestResponse response = _restclient.Execute(request);

            var responseCode = response.StatusCode;
        }
        
        
        
    }
}
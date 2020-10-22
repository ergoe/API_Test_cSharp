using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using AventStack.ExtentReports;
using AventStack.ExtentReports.Gherkin.Model;
using AventStack.ExtentReports.Reporter;
//
using RestSharp;
using TechTalk.SpecFlow;
using Xunit;

namespace Api_TestFramework.Steps
{
       
    [Binding]
    [Scope]
    public class BaseTestSteps
    {
        private readonly ScenarioContext _context;
        private RestClient _restclient = null;

        public BaseTestSteps(ScenarioContext context)
        {
            if (context == null) throw new ArgumentNullException("scenarioContext");
            this._context = context;
        }
        
        
        [When(@"user gets '(.*)'")]
        public void WhenUserGets(string endpoint)
        {
            _restclient = new RestClient(endpoint);
            
            var request = new RestRequest(Method.GET);

            IRestResponse response = _restclient.Execute(request);


            var responseCode = response.StatusCode;
            var responseBody = response.Content;
            var responseHeaders = response.Headers;
            
            _context.Set(responseCode, "ResponseStatusCode");
            _context.Set(responseBody, "ResponseContent");
            _context.Set(responseHeaders, "ResponseHeaders");
        }

        [Then("should get '(.*)' response")]
        public void ShouldGetSpecifiedResponse(int expectedResponse)
        {
            int statusCode = (int)_context.Get<HttpStatusCode>("ResponseStatusCode");
            Console.WriteLine(statusCode);
            Assert.Equal(expectedResponse, statusCode);
        }

        [Then(@"should get Content-type '(.*)'")]
        public void ThenShouldGetContent_Type(string contenType)
        {
            List<Parameter> headers = _context.Get<List<Parameter>>("ResponseHeaders");
            var actualContentType = headers.FirstOrDefault(x => x.Name == "Content-Type");
            
            Assert.Equal(contenType, actualContentType.Value);
        }






    }
}
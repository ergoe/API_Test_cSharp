using AventStack.ExtentReports;
using AventStack.ExtentReports.Gherkin.Model;
using AventStack.ExtentReports.Reporter;
using BoDi;
using Io.Cucumber.Messages;
using Microsoft.VisualStudio.TestPlatform.ObjectModel;
using System;
using System.Collections.Generic;
using System.Reflection;
using System.Text;
using TechTalk.SpecFlow;
using TechTalk.SpecFlow.Bindings;

namespace Api_TestFramework
{
    [Binding]
    class Hooks
    {

        //private static ExtentTest test;
        private static ExtentTest scenario;
        private static ExtentReports extentReports;

        static ScenarioContext _scenarioContext;

        public Hooks(ScenarioContext scenarioContext)
        {
            if (scenarioContext != null)
            {
                _scenarioContext = scenarioContext;
            }
        }

        [BeforeScenario]
        public void initialize()
        {

        }

        [BeforeTestRun]
        public static void InitializeReport()
        {
            var htmlReporter = new ExtentHtmlReporter(@"D:\gitRepos\Api_TestFramework\ExtentReport.html");
            //htmlReporter.Config.Theme = AventStack.ExtentReports.Reporter.Configuration.Theme.Dark;
            extentReports = new ExtentReports();
            extentReports.AttachReporter(htmlReporter);
        }

        [AfterTestRun]
        public static void TearDownReport()
        {
            extentReports.Flush();
        }

        [BeforeFeature]
        public static void BeforeFeature(FeatureContext featureContext)
        {
            scenario = extentReports.CreateTest<Feature>(featureContext.FeatureInfo.Title);
            
        }

        [BeforeScenario]
        public static void BeforeScenario()
        {
            scenario = extentReports.CreateTest<Scenario>(_scenarioContext.ScenarioInfo.Title);
        }

        [AfterStep]
        public static void InsertReportSteps(ScenarioContext scenarioContext)
        {
            //var stepType = ScenarioStepContext.Current.StepInfo.StepDefinitionType.ToString();
            var stepType = scenarioContext.StepContext.StepInfo.StepDefinitionType.ToString();
            Console.WriteLine();

            //PropertyInfo propertyInfo = typeof(ScenarioContext).GetProperty("TestStatus", BindingFlags.Instance | BindingFlags.NonPublic);
            //MethodInfo getter = propertyInfo.GetGetMethod(nonPublic: true);
            //object TestResult = getter.Invoke(scenarioContext, null);


            if (scenarioContext.TestError == null)
            {
                if (stepType == "Given")
                    scenario.CreateNode<Given>(scenarioContext.StepContext.StepInfo.Text);
                else if (stepType == "When")
                    scenario.CreateNode<When>(scenarioContext.StepContext.StepInfo.Text);
                else if (stepType == "Then")
                    scenario.CreateNode<Then>(scenarioContext.StepContext.StepInfo.Text);
                else if (stepType == "And")
                    scenario.CreateNode<And>(scenarioContext.StepContext.StepInfo.Text);

            }
            else if (scenarioContext.TestError != null)
            {
                if (stepType == "Given")
                    scenario.CreateNode<Given>(scenarioContext.StepContext.StepInfo.Text).Fail(scenarioContext.TestError.Message);
                if (stepType == "When")
                    scenario.CreateNode<When>(scenarioContext.StepContext.StepInfo.Text).Fail(scenarioContext.TestError.Message);
                if (stepType == "Then")
                {
                    scenario.CreateNode<Then>(scenarioContext.StepContext.StepInfo.Text).Fail("put this in the step");
                    //scenario.CreateNode(new GherkinKeyword("Then"), scenarioContext.StepContext.StepInfo.Text).Fatal("put this in the step");


                }
                
                Console.WriteLine();
            }



            //if (TestResult.ToString() == "StepDefinitionPending")
            //{
            //    if (stepType == "Given")
            //        scenario.CreateNode<Given>(scenarioContext.StepContext.StepInfo.Text).Skip("Step Definition Pending");
            //    if (stepType == "When")
            //        scenario.CreateNode<When>(scenarioContext.StepContext.StepInfo.Text).Skip("Step Definition Pending");
            //    if (stepType == "Then")
            //        scenario.CreateNode<Then>(scenarioContext.StepContext.StepInfo.Text).Skip("Step Definition Pending");
            //}



        }




    }
}

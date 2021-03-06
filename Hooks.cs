﻿using AventStack.ExtentReports;
using AventStack.ExtentReports.Gherkin.Model;
using AventStack.ExtentReports.Reporter;
using System;
using System.IO;
using TechTalk.SpecFlow;
using TechTalk.SpecFlow.CommonModels;
using static System.Net.Mime.MediaTypeNames;

namespace Api_TestFramework
{
    [Binding]
    class Hooks
    {
        // Mongodb connection string for Mongodb 
        //mongodb+srv://egoeckeritz:<password>@cluster0.yompo.mongodb.net/<dbname>?retryWrites=true&w=majority

        private readonly FeatureContext _featureContext;
        private readonly ScenarioContext _scenarioContext;
        private ExtentTest _currentScenarioName;

        public Hooks(FeatureContext featureContext, ScenarioContext scenarioContext)
        {
            _featureContext = featureContext;
            _scenarioContext = scenarioContext;
        }

        //private static ExtentTest test;
        private static ExtentTest featureName;
        private static ExtentReports extent;
        private static ExtentKlovReporter klov;

        [AfterStep]
        public void InsertReportSteps(ScenarioContext scenarioContext)
        {
            var stepType = _scenarioContext.StepContext.StepInfo.StepDefinitionType.ToString();

            if (_scenarioContext.TestError == null)
            {
                if (stepType == "Given")
                    _currentScenarioName.CreateNode<Given>(_scenarioContext.StepContext.StepInfo.Text);
                else if (stepType == "When")
                    _currentScenarioName.CreateNode<When>(_scenarioContext.StepContext.StepInfo.Text);
                else if (stepType == "Then")
                    _currentScenarioName.CreateNode<Then>(_scenarioContext.StepContext.StepInfo.Text);
                else if (stepType == "And")
                    _currentScenarioName.CreateNode<And>(_scenarioContext.StepContext.StepInfo.Text);
            }
            else if (_scenarioContext.TestError != null)
            {
                ////screenshot in the Base64 format
                //var mediaEntity = _parallelConfig.CaptureScreenshotAndReturnModel(_scenarioContext.ScenarioInfo.Title.Trim());

                if (stepType == "Given")
                    _currentScenarioName.CreateNode<Given>(_scenarioContext.StepContext.StepInfo.Text).Fail(_scenarioContext.TestError.Message);
                else if (stepType == "When")
                    _currentScenarioName.CreateNode<When>(_scenarioContext.StepContext.StepInfo.Text).Fail(_scenarioContext.TestError.Message);
                else if (stepType == "Then")
                {
                    var message = _scenarioContext.TestError.Message;
                    _currentScenarioName.CreateNode<Then>(_scenarioContext.StepContext.StepInfo.Text).Fail(message, null).CreateNode(message).Fail("");
                    //_currentScenarioName.CreateNode<Then>(message);
                    //_currentScenarioName.CreateNode(message,"");
                }
            }
            else if (_scenarioContext.ScenarioExecutionStatus.ToString() == "StepDefinitionPending")
            {
                if (stepType == "Given")
                    _currentScenarioName.CreateNode<Given>(ScenarioStepContext.Current.StepInfo.Text).Skip("Step Definition Pending");
                else if (stepType == "When")
                    _currentScenarioName.CreateNode<When>(ScenarioStepContext.Current.StepInfo.Text).Skip("Step Definition Pending");
                else if (stepType == "Then")
                {
                    _currentScenarioName.CreateNode<Then>(ScenarioStepContext.Current.StepInfo.Text).Skip("Step Definition Pending");
                    
                    
                }
            }
        }

        [BeforeTestRun]
        public static void InitializeReport()
        {
            //Initialize Extent report before test starts
            //var htmlReporter = new ExtentHtmlReporter(@"D:\gitRepos\Api_TestFramework\ExtentReport.html");
            DirectoryInfo dirInfo = new DirectoryInfo(Directory.GetCurrentDirectory());
            DirectoryInfo solutionPath = dirInfo.Parent.Parent.Parent;
            var htmlReporter = new ExtentHtmlReporter(solutionPath + @"\ExtentReport.html");
           
            htmlReporter.Config.Theme = AventStack.ExtentReports.Reporter.Configuration.Theme.Dark;
            //Attach report to reporter
            extent = new AventStack.ExtentReports.ExtentReports();
            klov = new ExtentKlovReporter();
            //mongodb+srv://egoeckeritz:<password>@cluster0.yompo.mongodb.net/<dbname>?retryWrites=true&w=majority
            //klov.InitMongoDbConnection("localhost", 27017);
            
            // MongoDB atlas
            klov.InitKlovServerConnection("mongodb+srv://egoeckeritz:L @goe5910mb@cluster0.yompo.mongodb.net/<dbname>?retryWrites=true&w=majority");
            //klov.InitMongoDbConnection("10.100.100.187", 27017);

            klov.ProjectName = "APIAutomation Test";
            klov.InitKlovServerConnection("http://localhost:80");

            klov.ReportName = "Karthik KK" + System.DateTime.Now.ToString();

            extent.AttachReporter(htmlReporter);
            //extent.AttachReporter(klov);
            
        }

        [BeforeScenario]
        public void Initialize()
        {
            
            //featureName = extent.CreateTest<Feature>(_featureContext.FeatureInfo.Title);
            featureName = extent.CreateTest<Scenario>(_scenarioContext.ScenarioInfo.Title);

            //Create dynamic scenario name
            _currentScenarioName = featureName.CreateNode<Scenario>(_scenarioContext.ScenarioInfo.Title);
        }

        [BeforeFeature]
        public static void InitializeFeature()
        {
            ////Get feature Name
            //featureName = extent.CreateTest<Feature>(_featureContext.FeatureInfo.Title);
        }



        [AfterScenario]
        public void TestStop()
        {
            
        }

        [AfterTestRun]
        public static void CleanUpAndReport()
        {
            //Flush report once all tests complete
            extent.Flush();

        }



    }
}

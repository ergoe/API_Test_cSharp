  Feature: BaseApi
      Verify response codes from server
  
    
    @smokeTest
    Scenario: Check receive 200 response 
      When  user gets 'https://www.metaweather.com/api/location/44418'
#      Then  should get '200' response
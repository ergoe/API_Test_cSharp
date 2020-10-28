  Feature: BaseApi Feature
      Verify response codes from server
  
    
    @regression
    Scenario: Check receive 200 response 
      When  user gets 'https://www.metaweather.com/api/location/44418'
      Then  should get '2001' response

    @smoke
    Scenario: Validate Content-type is application/json
      When  user gets 'https://www.metaweather.com/api/location/44418'
      Then  should get Content-type 'application/jso'


    #Validate json or xml response against schema
    @smoke
    Scenario: Validate response content
      When  user gets 'https://www.metaweather.com/api/location/44418'

    @smoke
    Scenario: Validate sql response
        When Attempt to get xml from query
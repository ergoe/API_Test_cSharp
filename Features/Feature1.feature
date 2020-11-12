@Book-16
Feature: Feature1

A short summary of the feature

@TEST_BOOK-15
Scenario: Check receive 200 response
	When  user gets 'https://www.metaweather.com/api/location/44418'
	Then  should get '200' response

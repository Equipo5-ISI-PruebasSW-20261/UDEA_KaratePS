@test
Feature: test

Background:
  * url 'https://parabank.parasoft.com/parabank/services/bank'
  * header Accept = 'application/json'

Scenario: test loan
  Given path 'login', 'john', 'demo'
  When method GET
  Then status 200
  * def custId = response.id

  Given path 'customers', custId, 'accounts'
  When method GET
  Then status 200
  * def accId = response[0].id
  * def bal = response[0].balance
  * print 'balance: ', bal

  Given path 'requestLoan'
  And param customerId = custId
  And param amount = 1000
  And param downPayment = 500
  And param fromAccountId = accId
  When method POST
  Then status 200
  * print response


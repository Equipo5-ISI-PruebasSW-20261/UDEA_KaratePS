@account_data_integrity
Feature: Integridad de Datos en Consulta de Cuentas

  Background:
    * url baseUrl
    * header Accept = 'application/json'
    * def customerId = 12212

  @account_data_integrity_response_headers
  Scenario: Validar estructura base y headers de respuesta
    Given path 'customers'
    And path customerId
    And path 'accounts'
    When method GET
    Then status 200
    # Validar que la respuesta es un array
    And match response == '#[]'
    # Validar que el Content-Type sea JSON
    And match header Content-Type contains 'application/json'
    # Validar que la respuesta no está vacía
    * def accountCount = response.length
    And assert accountCount > 0

  @account_data_integrity_schema_validation
  Scenario: Validar esquema estricto de cada objeto de cuenta
    Given path 'customers'
    And path customerId
    And path 'accounts'
    When method GET
    Then status 200
    # Definir el esquema esperado
    * def expectedSchema = 
      """
      {
        id: '#number',
        customerId: '#number',
        type: '#string',
        balance: '#number'
      }
      """
    # Validar que cada objeto cumple con el esquema
    And match each response == expectedSchema
    # Validar que el type sea uno de los valores permitidos
    And match each response[*].type == '#regex CHECKING|SAVINGS'
    # Validar que id y customerId sean enteros positivos
    And match each response[*].id == '#? _ > 0'
    And match each response[*].customerId == '#? _ > 0'

  @account_data_integrity_null_validation
  Scenario: Validar que no existan valores nulos o undefined
    Given path 'customers'
    And path customerId
    And path 'accounts'
    When method GET
    Then status 200
    * def validateNoNulls = 
      """
      function(accounts) {
        for (let i = 0; i < accounts.length; i++) {
          let account = accounts[i];
          if (account.id === null || account.id === undefined) {
            return false;
          }
          if (account.customerId === null || account.customerId === undefined) {
            return false;
          }
          if (account.type === null || account.type === undefined || account.type === '') {
            return false;
          }
          if (account.balance === null || account.balance === undefined) {
            return false;
          }
        }
        return true;
      }
      """
    * def noNullsPresent = validateNoNulls(response)
    And match noNullsPresent == true

  @account_data_integrity_negative_balance
  Scenario: Validar que ningún balance sea negativo (Integridad Financiera)
    Given path 'customers'
    And path customerId
    And path 'accounts'
    When method GET
    Then status 200
    * def validateBalances =
      """
      function(accounts) {
        let results = {
          hasNegativeBalances: false,
          negativeAccounts: [],
          isValidNumbers: true
        };
        
        for (let i = 0; i < accounts.length; i++) {
          let balance = accounts[i].balance;
          
          // Validar que sea un número válido (no NaN, no Infinity)
          if (isNaN(balance) || !isFinite(balance)) {
            results.isValidNumbers = false;
          }
          
          // Validar que no sea negativo
          if (balance < 0) {
            results.hasNegativeBalances = true;
            results.negativeAccounts.push({
              id: accounts[i].id,
              balance: balance,
              type: accounts[i].type
            });
          }
        }
        
        return results;
      }
      """
    * def balanceValidation = validateBalances(response)
    # En producción, los balances no deben ser negativos
    And match balanceValidation.hasNegativeBalances == false
    # Validar que todos los números sean válidos
    And match balanceValidation.isValidNumbers == true

  @account_data_integrity_customer_id_match
  Scenario: Validar que el customerId en la respuesta coincida con el de la URI
    Given path 'customers'
    And path customerId
    And path 'accounts'
    When method GET
    Then status 200
    * def validateCustomerIdMatch =
      """
      function(accounts, expectedCustomerId) {
        let allMatch = true;
        let mismatches = [];
        
        for (let i = 0; i < accounts.length; i++) {
          if (accounts[i].customerId !== expectedCustomerId) {
            allMatch = false;
            mismatches.push({
              accountId: accounts[i].id,
              responseCustomerId: accounts[i].customerId,
              expectedCustomerId: expectedCustomerId
            });
          }
        }
        
        return {
          allMatch: allMatch,
          mismatches: mismatches,
          totalMismatches: mismatches.length
        };
      }
      """
    * def customerIdValidation = validateCustomerIdMatch(response, customerId)
    And match customerIdValidation.allMatch == true

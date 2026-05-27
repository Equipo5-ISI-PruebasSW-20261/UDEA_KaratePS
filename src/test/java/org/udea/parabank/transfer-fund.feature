@transfer_fund_hu03
Feature: HU03 - Transferencia Atómica y Validación de Histórico

  Background:
    * url baseUrl
    * header Accept = 'application/json'

    # Iniciamos sesión para obtener contexto de usuario
    * def credentials = { username: 'john', password: 'demo' }
    Given path 'login', credentials.username, credentials.password
    When method GET
    Then status 200
    * def customerId = response.id

    # Obtenemos cuentas del usuario
    Given path 'customers', customerId, 'accounts'
    And header Accept = 'application/json'
    When method GET
    Then status 200
    * def accounts = response
    * def fromAccountId = accounts[0].id
    
    # Cuenta destino: usamos la segunda cuenta si existe
    * def toAccountId = accounts.length > 1 ? accounts[1].id : 17451

  @transfer_hu03_successful
  Scenario: Transferencia exitosa y captura de datos
    Given path 'transfer'
    And param fromAccountId = fromAccountId
    And param toAccountId = toAccountId
    And param amount = 100.00
    When method POST
    Then status 200
    # La respuesta es un texto como: "Successfully transferred $100.00 from account #12345 to account #12456"
    And match response == '#string'
    And match response contains 'Successfully transferred'
    And match response contains 'from account'
    And match response contains 'to account'

  @transfer_hu03_verify_ledger
  Scenario: Validación de la transacción en el histórico de cuenta destino
    Given path 'transfer'
    And param fromAccountId = fromAccountId
    And param toAccountId = toAccountId
    And param amount = 125.50
    When method POST
    Then status 200

    # Realizamos GET al historial de transacciones de la cuenta destino
    Given path 'accounts', toAccountId, 'transactions'
    And header Accept = 'application/json'
    When method GET
    Then status 200
    And match response == '#[]'
    
    # Buscamos la transacción de crédito con el monto exacto
    * def transactionFound = response.find(t => t.type === 'Credit' && t.amount === 125.50)
    
    # Validamos que la transacción fue registrada en el histórico
    And match transactionFound.type == 'Credit'
    And match transactionFound.amount == 125.50
    And match transactionFound.description == 'Funds Transfer Received'

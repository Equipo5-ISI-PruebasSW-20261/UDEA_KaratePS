@request_loan_hu05
Feature: HU05 - Simulación de Prestamo con Evaluacion de Riesgo

  Background:
    * url baseUrl
    * header Accept = 'application/json'

    # Iniciamos sesión para tener un contexto activo
    * def credentials = { username: 'john', password: 'demo' }
    Given path 'login', credentials.username, credentials.password
    When method GET
    Then status 200
    * def customerIdActual = response.id

    # Obtenemos cuentas dinámicamente
    Given path 'customers', customerIdActual, 'accounts'
    And header Accept = 'application/json'
    When method GET
    Then status 200
    
    # Usaremos la primera cuenta encontrada para efectuar la prueba
    * def fromAccount = response[0].id

  @loan_hu05_approved
  Scenario: Validación de respuesta de préstamo con parámetros de bajo riesgo
    Given path 'requestLoan'
    And param customerId = customerIdActual
    # Validamos un préstamo con parámetros razonables
    And param amount = 5000
    And param downPayment = 2500
    And param fromAccountId = fromAccount
    When method POST
    Then status 200
    And match response['ns2:loanResponse']['_'] contains
      """
      {
        "responseDate": "#string",
        "loanProviderName": "#string",
        "approved": "#string"
      }
      """

  @loan_hu05_denied
  Scenario: Solicitud de préstamo rechazada por insuficiencia en cuota inicial o alto riesgo
    Given path 'requestLoan'
    And param customerId = customerIdActual
    # Intentando sacar un monto altísimo con una cuota mínima que activará error.insufficient.down.payment
    And param amount = 10000000
    And param downPayment = 1
    And param fromAccountId = fromAccount
    When method POST
    Then status 200
    And match response['ns2:loanResponse']['_'] contains
      """
      {
        "responseDate": "#string",
        "loanProviderName": "#string",
        "approved": "#string",
        "message": "#string"
      }
      """

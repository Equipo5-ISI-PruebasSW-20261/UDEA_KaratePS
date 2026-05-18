@parabank_billpay_hu04
Feature: HU04 - Robustez y Manejo de Excepciones en Pagos (Bill Pay)

  Background:
    * url baseUrl
    * header Accept = 'application/json'
    * header Content-Type = 'application/json'

    * def billpayCredentials = { username: 'coco92', password: '12345' }

    Given path 'login', billpayCredentials.username, billpayCredentials.password
    When method GET
    Then status 200
    * def billpayCustomerId = response.id

    Given path 'customers', billpayCustomerId, 'accounts'
    And header Accept = 'application/json'
    When method GET
    Then status 200
    * def billpayCuentas = response
    * def billpayFromAccountId = billpayCuentas[0].id
    * def billpaySaldoDisponible = billpayCuentas[0].balance

    * def billpayPayee =
      """
      {
        "name": "Beneficiario Prueba HU04",
        "address": {
          "street":  "Calle 123",
          "city":    "Springfield",
          "state":   "Springfield",
          "zipCode": "62701"
        },
        "phoneNumber":   "5551234567",
        "accountNumber": #(billpayFromAccountId)
      }
      """


  @billpay_hu04_saldo_insuficiente
  Scenario: Bill Pay con monto superior al saldo devuelve respuesta del servidor

    * def billpayMontoExcedente = billpaySaldoDisponible + 9999

    Given path 'billpay'
    And param accountId = billpayFromAccountId
    And param amount = billpayMontoExcedente
    And header Accept = 'application/json'
    And request billpayPayee
    When method POST
    Then status 200
    And match response ==
    """
    {
      "payeeName": '#(billpayPayee.name)',
      "amount": #(billpayMontoExcedente),
      "accountId": #(billpayFromAccountId)
    }
    """


  @billpay_hu04_casos_borde
  Scenario Outline: Bill Pay - caso de borde: <descripcionCasoBorde>

    * def billpayPayeeCasoBorde =
      """
      {
        "name":  "Beneficiario Caso Borde HU04",
        "address": {
          "street":  "Av Borde 456",
          "city":    "Testville",
          "state":   "CA",
          "zipCode": "90210"
        },
        "phoneNumber":   "5559876543",
        "accountNumber": <cuentaDestinoId>
      }
      """

    * def montoCasoBordeNum = Number(montoCasoBorde)

    Given path 'billpay'
    And param accountId = billpayFromAccountId
    And param amount = montoCasoBordeNum
    And header Accept = 'application/json'
    And request billpayPayeeCasoBorde
    When method POST
    Then status 200
    And match response ==
    """
    {
      "payeeName":  '#(billpayPayeeCasoBorde.name)',
      "amount":     #(montoCasoBordeNum),
      "accountId":  #(billpayFromAccountId)
    }
    """

    Examples:
      | descripcionCasoBorde          | montoCasoBorde | cuentaDestinoId |
      | Monto cero                    | 0              | 13677           |
      | Monto negativo                | -100           | 13677           |
      | Cuenta de destino inexistente | 50             | 99999999        |


  @billpay_hu04_pago_exitoso
  Scenario: Bill Pay con monto valido retorna confirmacion exitosa

    * def billpayMontoValido = 1

    Given path 'billpay'
    And param accountId = billpayFromAccountId
    And param amount = billpayMontoValido
    And header Accept = 'application/json'
    And request billpayPayee
    When method POST
    Then status 200
    And match response ==
      """
      {
        "payeeName":  '#(billpayPayee.name)',
        "amount":     #(billpayMontoValido),
        "accountId":  #(billpayFromAccountId)
      }
      """
    And match response.amount == billpayMontoValido
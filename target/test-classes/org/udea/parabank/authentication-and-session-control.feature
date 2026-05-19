@authentication_session
Feature: Autenticación y Persistencia de Sesión

  Background:
    * url baseUrl
    * header Accept = 'application/json'

  Scenario: Autenticación exitosa y validación de Set-Cookie / JSESSIONID
    Given path 'login'
    And path 'john'
    And path 'demo'
    When method GET
    Then status 200
    # Valida que el Content-Type sea compatible con JSON
    And match header Content-Type contains 'application/json'
    # Karate extrae automáticamente las cookies del header Set-Cookie a la variable responseCookies
    * def sessionCookie = responseCookies.JSESSIONID
    And match sessionCookie != null
    # Puedes usar esto para validaciones subsecuentes y saber el valor real:
    * print 'Sesión iniciada correctamente. JSESSIONID:', sessionCookie.value

  Scenario: Intento de inicio de sesión con credenciales incorrectas (400)
    Given path 'login'
    And path 'usuarioInvalido'
    And path 'claveIncorrecta'
    When method GET
    Then status 400
    # Validación del mensaje de error devuelto
    And match response == 'Invalid username and/or password'

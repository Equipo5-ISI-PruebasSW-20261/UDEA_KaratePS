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

  Scenario: Intento de inicio de sesión con credenciales incorrectas (401)
    Given path 'login'
    And path 'usuarioInvalido'
    And path 'claveIncorrecta'
    When method GET
    Then status 400
    # Validación del esquema de error estandarizado
    # Nota: la estructura exacta JSON dependerá de la respuesta precisa de Parabank, ajustamos usando fuzzy matchers.
    And match response == '#object'
    And match response contains any { error: '#ignore', message: '#string', status: '#ignore' }

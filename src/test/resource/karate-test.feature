Feature: Pruebas de la API de personajes de Marvel - HU-PruebaAutomatizacion

  Background:
    * url baseUrl
    * header Content-Type = 'application/json'

  @id:1 @obtenerPersonajes @listaVacia
  Scenario: Obtener todos los personajes (lista vacía)
    Given path ''
    When method GET
    Then status 200
    And match response == []

  @id:2 @obtenerPersonajePorId @exitoso
  Scenario: Obtener personaje por ID (exitoso)
    Given path '1'
    When method GET
    Then status 200
    And match response.name == 'Iron Man'

  @id:3 @obtenerPersonajePorId @noExiste
  Scenario: Obtener personaje por ID (no existe)
    Given path '999'
    When method GET
    Then status 404
    And match response.error == 'Character not found'

  @id:4 @crearPersonaje @exitoso
  Scenario: Crear personaje (exitoso)
    Given request
      """
      {
        "name": "Iron Man",
        "alterego": "Tony Stark",
        "description": "Genius billionaire",
        "powers": ["Armor", "Flight"]
      }
      """
    When method POST
    Then status 201
    And match response.name == 'Iron Man'

  @id:5 @crearPersonaje @nombreDuplicado
  Scenario: Crear personaje (nombre duplicado)
    Given request
      """
      {
        "name": "Iron Man",
        "alterego": "Otro",
        "description": "Otro",
        "powers": ["Armor"]
      }
      """
    When method POST
    Then status 400
    And match response.error == 'Character name already exists'

  @id:6 @crearPersonaje @faltanCampos
  Scenario: Crear personaje (faltan campos requeridos)
    Given request
      """
      {
        "name": "",
        "alterego": "",
        "description": "",
        "powers": []
      }
      """
    When method POST
    Then status 400
    And match response.name == 'Name is required'

  @id:7 @actualizarPersonaje @exitoso
  Scenario: Actualizar personaje (exitoso)
    Given path '1'
    And request
      """
      {
        "name": "Iron Man",
        "alterego": "Tony Stark",
        "description": "Updated description",
        "powers": ["Armor", "Flight"]
      }
      """
    When method PUT
    Then status 200
    And match response.description == 'Updated description'

  @id:8 @actualizarPersonaje @noExiste
  Scenario: Actualizar personaje (no existe)
    Given path '999'
    And request
      """
      {
        "name": "Iron Man",
        "alterego": "Tony Stark",
        "description": "Updated description",
        "powers": ["Armor", "Flight"]
      }
      """
    When method PUT
    Then status 404
    And match response.error == 'Character not found'

  @id:9 @eliminarPersonaje @exitoso
  Scenario: Eliminar personaje (exitoso)
    Given path '1'
    When method DELETE
    Then status 204

  @id:10 @eliminarPersonaje @noExiste
  Scenario: Eliminar personaje (no existe)
    Given path '999'
    When method DELETE
    Then status 404
    And match response.error == 'Character not found'

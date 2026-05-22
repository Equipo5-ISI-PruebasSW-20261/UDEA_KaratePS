package org.udea.parabank;

import com.intuit.karate.junit5.Karate;
import org.junit.jupiter.api.DisplayName;

@DisplayName("HU02 - Integridad de Datos en Consulta de Cuentas")
class TestRunnerAccountDataIntegrityHU02 {

    @Karate.Test
    @DisplayName("HU02.1 - Validar estructura base y headers de respuesta")
    Karate testResponseHeaders() {
        return Karate.run("account-data-integrity")
                .tags("@account_data_integrity_response_headers")
                .relativeTo(getClass())
                .outputCucumberJson(true);
    }

    @Karate.Test
    @DisplayName("HU02.2 - Validar esquema estricto de cada objeto de cuenta")
    Karate testSchemaValidation() {
        return Karate.run("account-data-integrity")
                .tags("@account_data_integrity_schema_validation")
                .relativeTo(getClass())
                .outputCucumberJson(true);
    }

    @Karate.Test
    @DisplayName("HU02.3 - Validar que no existan valores nulos o undefined")
    Karate testNullValidation() {
        return Karate.run("account-data-integrity")
                .tags("@account_data_integrity_null_validation")
                .relativeTo(getClass())
                .outputCucumberJson(true);
    }

    @Karate.Test
    @DisplayName("HU02.4 - Validar que ningún balance sea negativo (Integridad Financiera)")
    Karate testNegativeBalanceValidation() {
        return Karate.run("account-data-integrity")
                .tags("@account_data_integrity_negative_balance")
                .relativeTo(getClass())
                .outputCucumberJson(true);
    }

    @Karate.Test
    @DisplayName("HU02.5 - Validar que el customerId coincida con el de la URI")
    Karate testCustomerIdMatchValidation() {
        return Karate.run("account-data-integrity")
                .tags("@account_data_integrity_customer_id_match")
                .relativeTo(getClass())
                .outputCucumberJson(true);
    }
}

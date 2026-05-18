package org.udea.parabank;

import com.intuit.karate.junit5.Karate;

class TestRunnerBillpayHU04 {

    @Karate.Test
    Karate test04_BillPayRobustezExcepciones() {
        return Karate.run("billpay")
                .relativeTo(getClass())
                .outputCucumberJson(true);
    }

    @Karate.Test
    Karate test04_BillPaySaldoInsuficiente() {
        return Karate.run("billpay")
                .tags("@billpay_hu04_saldo_insuficiente")
                .relativeTo(getClass())
                .outputCucumberJson(true);
    }

    @Karate.Test
    Karate test04_BillPayCasosBorde() {
        return Karate.run("billpay")
                .tags("@billpay_hu04_casos_borde")
                .relativeTo(getClass())
                .outputCucumberJson(true);
    }

    @Karate.Test
    Karate test04_BillPayExitoso() {
        return Karate.run("billpay")
                .tags("@billpay_hu04_pago_exitoso")
                .relativeTo(getClass())
                .outputCucumberJson(true);
    }
}
package org.udea.parabank;

import com.intuit.karate.junit5.Karate;

public class TestRunnerTransferHU03 {
    @Karate.Test
    Karate testTransferFund() {
        return Karate.run("transfer-fund").relativeTo(getClass());
    }
}

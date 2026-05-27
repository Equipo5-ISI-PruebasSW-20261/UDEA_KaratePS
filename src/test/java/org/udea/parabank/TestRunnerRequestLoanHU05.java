package org.udea.parabank;

import com.intuit.karate.junit5.Karate;

public class TestRunnerRequestLoanHU05 {

    @Karate.Test
    Karate testRequestLoan() {
        return Karate.run("request-loan").relativeTo(getClass());
    }
}

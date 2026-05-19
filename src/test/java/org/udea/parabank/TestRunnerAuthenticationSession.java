package org.udea.parabank;

import com.intuit.karate.junit5.Karate;

class TestRunnerAuthenticationSession {

    @Karate.Test
    Karate testAuthenticationSession() {
        return Karate.run("authentication-and-session-control")
                .relativeTo(getClass())
                .outputCucumberJson(true);
    }

}
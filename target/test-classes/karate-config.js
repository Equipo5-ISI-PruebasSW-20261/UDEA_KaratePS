function fn() {
    karate.configure('connectTimeout', 5000);
    karate.configure('readTimeout', 5000);
    // karate.configure('abortSuiteOnFailure', true);

    var protocol = 'https';
    var server = 'parabank.parasoft.com';
    if (karate.env == 'local') {
        protocol = 'http';
        server = '192.168.0.182:8080';
    }

    var config = {
        baseUrl: protocol + '://' + server + '/parabank/services/bank'
    };
    config.faker = Java.type('com.github.javafaker.Faker');

    return config;
}
//
//  currencyConverterMVCTests.swift
//  currencyConverterMVCTests
//
//  Created by Sebastian Fernandez on 16/05/2021.
//

import XCTest
@testable import currencyConverterMVC

class currencyConverterMVCTests: XCTestCase {
    var sut: CurrencyConverterRepository!
    
    override func setUp() {
        sut = CurrencyConverterRepository()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetCurrencies() {
        XCTAssertNotNil(sut.getCurrencies())
    }

    func testGetLatestRateWithExpectedUrlHostAndPath() throws {
        let mockURLSession = MockURLSession(data: nil, urlResponse: nil, error: nil)
        sut.session = mockURLSession
        sut.getLatestRate(from: "USD") { rates, error in }

        XCTAssertEqual(mockURLSession.cachedUrl?.host, "api.exchangerate-api.com")
        XCTAssertEqual(mockURLSession.cachedUrl?.path, "/v4/latest/USD")
    }

    func testGetLatestRateSuccess() {
        let jsonData = """
        {
            "provider":"https://www.exchangerate-api.com","WARNING_UPGRADE_TO_V6":"https://www.exchangerate-api.com/docs/free","terms":"https://www.exchangerate-api.com/terms","base":"USD","date":"2021-05-18","time_last_updated":1621296001,"rates":{"USD":1,"AED":3.67,"AFN":77.7,"ALL":101.75,"AMD":521.91,"ANG":1.79,"AOA":649.37,"ARS":94.04,"AUD":1.29,"AWG":1.79,"AZN":1.7,"BAM":1.61,"BBD":2,"BDT":84.81,"BGN":1.61,"BHD":0.376,"BIF":1961.6,"BMD":1,"BND":1.33,"BOB":6.88,"BRL":5.28,"BSD":1,"BTN":73.32,"BWP":10.82,"BYN":2.52,"BZD":2,"CAD":1.21,"CDF":1988.03,"CHF":0.903,"CLP":701.11,"CNY":6.44,"COP":3693.35,"CRC":614.06,"CUC":1,"CUP":25.75,"CVE":90.63,"CZK":21,"DJF":177.72,"DKK":6.13,"DOP":56.91,"DZD":133.53,"EGP":15.68,"ERN":15,"ETB":42.71,"EUR":0.822,"FJD":2.03,"FKP":0.708,"FOK":6.13,"GBP":0.708,"GEL":3.4,"GGP":0.708,"GHS":5.76,"GIP":0.708,"GMD":51.95,"GNF":9856.45,"GTQ":7.7,"GYD":213.6,"HKD":7.77,"HNL":23.97,"HRK":6.19,"HTG":87.65,"HUF":291.21,"IDR":14301.05,"ILS":3.29,"IMP":0.708,"INR":73.32,"IQD":1458.51,"IRR":41952.68,"ISK":124.32,"JMD":150.46,"JOD":0.709,"JPY":109.28,"KES":107.24,"KGS":84.59,"KHR":4066.72,"KID":1.29,"KMF":404.37,"KRW":1136.22,"KWD":0.3,"KYD":0.833,"KZT":428.33,"LAK":9407.34,"LBP":1507.5,"LKR":196.88,"LRD":172.06,"LSL":14.12,"LYD":4.46,"MAD":8.84,"MDL":17.76,"MGA":3755.64,"MKD":50.76,"MMK":1557.91,"MNT":2846.09,"MOP":8.01,"MRU":35.84,"MUR":40.49,"MVR":15.42,"MWK":796.82,"MXN":19.85,"MYR":4.13,"MZN":58.89,"NAD":14.12,"NGN":414.18,"NIO":34.9,"NOK":8.27,"NPR":117.31,"NZD":1.39,"OMR":0.384,"PAB":1,"PEN":3.69,"PGK":3.53,"PHP":47.92,"PKR":152.08,"PLN":3.74,"PYG":6601.66,"QAR":3.64,"RON":4.06,"RSD":96.81,"RUB":73.98,"RWF":999.95,"SAR":3.75,"SBD":7.89,"SCR":15.73,"SDG":398.45,"SEK":8.35,"SGD":1.33,"SHP":0.708,"SLL":10261.51,"SOS":578.45,"SRD":14.15,"SSP":177.59,"STN":20.14,"SYP":1265.24,"SZL":14.12,"THB":31.49,"TJS":11.31,"TMT":3.5,"TND":2.73,"TOP":2.23,"TRY":8.35,"TTD":6.79,"TVD":1.29,"TWD":28.06,"TZS":2315.76,"UAH":27.56,"UGX":3531.82,"UYU":44.06,"UZS":10438.2,"VES":2931949.4,"VND":23050.46,"VUV":107.86,"WST":2.5,"XAF":539.16,"XCD":2.7,"XDR":0.694,"XOF":539.16,"XPF":98.08,"YER":250.25,"ZAR":14.12,"ZMW":22.43}}
        """.data(using: .utf8)

        let mockURLSession = MockURLSession(data: jsonData, urlResponse: nil, error: nil)
        sut.session = mockURLSession
        let ratesExpectation = expectation(description: "rates")
        var ratesResponse: RateResponse?

        sut.getLatestRate(from: "USD") {rates, error in
            ratesResponse = rates
            ratesExpectation.fulfill()
        }

        waitForExpectations(timeout: 1) { error in
            XCTAssertNotNil(ratesResponse, "\(String(describing: error?.localizedDescription))")
        }
    }

    func testGetRatesError() {
        let error = NSError(domain: "error", code: 1234, userInfo: nil)
        let mockURLSession = MockURLSession(data: nil, urlResponse: nil, error: error)
        sut.session = mockURLSession

        let errorExpectation = expectation(description: "error")
        var errorResponse: Error?

        sut.getLatestRate(from: "USD") { currencies, error in
            errorResponse = error
            errorExpectation.fulfill()
        }

        waitForExpectations(timeout: 1) { error in
            XCTAssertNotNil(errorResponse)
        }
    }

    func testGetRatesEmptyDataError() {
        let mockUrlSession = MockURLSession(data: nil, urlResponse: nil, error: nil)
        sut.session = mockUrlSession
        var errorResponse: Error?
        let emptyDataExpectation = expectation(description: "emptyData")

        sut.getLatestRate(from: "USD") { currencies, error in
            errorResponse = error
            emptyDataExpectation.fulfill()
        }

        waitForExpectations(timeout: 1) { error in
            XCTAssertNotNil(errorResponse)
        }
    }

    func testGetCurrenciesInvalidJSONReturnsError() {
        let jsonData = "{\"t\"}".data(using: .utf8)
        let mockURLSession  = MockURLSession(data: jsonData, urlResponse: nil, error: nil)
        sut.session = mockURLSession
        let errorExpectation = expectation(description: "error")
        var errorResponse: Error?

        sut.getLatestRate(from: "USD") { (movies, error) in
          errorResponse = error
          errorExpectation.fulfill()
        }

        waitForExpectations(timeout: 1) { error in
          XCTAssertNotNil(errorResponse)
        }
    }
}

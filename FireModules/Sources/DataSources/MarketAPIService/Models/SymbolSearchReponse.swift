import DomainEntities

struct SymbolSearchResultResponse: Decodable {
    let searchedResult: [SymbolSearchResponse]

    init(from decoder: Decoder) throws {
        self.searchedResult = try decoder.decode("searchedResult")
    }
}

extension SymbolSearchResultResponse {
    func asSymbolEntityList() -> [SymbolDisplayEntity] {
        return searchedResult.map { $0.asSymbolEntity() }
    }
}

struct SymbolSearchResponse: Decodable {
    let symbol: String
    let instrumentName: String
    let exchange: String
    let micCode: String
    let exchangeTimezone: String
    let instrumentType: String
    let country: String
    let currency: String

    init(from decoder: Decoder) throws {
        self.symbol = try decoder.decode("symbol")
        self.instrumentName = try decoder.decode("instrument_name")
        self.exchange = try decoder.decode("exchange")
        self.micCode = try decoder.decode("mic_code")
        self.exchangeTimezone = try decoder.decode("exchange_timezone")
        self.instrumentType = try decoder.decode("instrument_type")
        self.country = try decoder.decode("country")
        self.currency = try decoder.decode("currency")
    }
}

extension SymbolSearchResponse {
    func asSymbolEntity() -> SymbolDisplayEntity {
        return SymbolDisplayEntity(
            symbol: Symbol(symbol),
            instrumentName: instrumentName
        )
    }
}

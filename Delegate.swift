import StoreKit

final class SatellaDelegate: NSObject, SKProductsRequestDelegate {
    static let shared: SatellaDelegate = .init()
    var delegates: [SKProductsRequestDelegate] = []
    var products: [SKProduct] = []
    
    func productsRequest(
        _ request: SKProductsRequest,
        didReceive response: SKProductsResponse
    ) {
        
        guard response.products.isEmpty else {
            _ = delegates.map { $0.productsRequest(request, didReceive: response) }
            return
        }
        
        if products.isEmpty {
            let _request: AnyObject? = request.value(forKey: "_productsRequestInternal") as? AnyObject
            let _identifiers: Set<String>? = _request?.value(forKey: "_productIdentifiers") as? Set<String>
            let identifiers: [String] = .init(_identifiers ?? [])
            
            products = identifiers.map {
                let product: SKProduct = .init()
                
                product.setValuesForKeys([
                    "price": 0.01 as NSDecimalNumber,
                    "priceLocale": Locale(identifier: "da_DK"),
                    "productIdentifier": $0,
                    "localizedDescription": $0,
                    "localizedTitle": $0
                ])
                
                return product
            }
        }
        
        let fakeResponse: SKProductsResponse = .init()
        fakeResponse.setValue(products, forKey: "products")
        
        _ = delegates.map { $0.productsRequest(request, didReceive: fakeResponse) }
    }
}

import UIKit

struct ReceiptGenerator {
    
    static func old(
        for productID: String?
    ) -> OldReceipt {
        let bundleID: String = Bundle.main.bundleIdentifier ?? "emt.paisseon.satella"
        let now: Int64 = .init(Date().timeIntervalSince1970) * 1000
        let nowDate: String = "\(Date()) Europe/Copenhagen"
        let receiptID: Int = .random(in: 1 ... 0x07151129)
        let vendorID: String = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
        
        let info: OldReceiptInfo = .init(
            appItemID: receiptID.description,
            bundleID: bundleID,
            bundleVersion: version,
            externalVersion: version,
            itemID: receiptID.description,
            originalPurchaseDate: nowDate,
            originalPurchaseDateMs: now.description,
            originalPurchaseDatePst: nowDate,
            originalTransactionID: receiptID.description,
            productID: productID ?? "emt.paisseon.satella.product",
            purchaseDate: nowDate,
            purchaseDateMs: now.description,
            purchaseDatePst: nowDate,
            quantity: "1",
            transactionID: receiptID.description,
            uniqueID: receiptID.description,
            uniqueVendorID: vendorID
        )
        
        return .init(signature: Data(signature).base64EncodedString(), purchaseInfo: info, pod: "44", signingStatus: "0")
    }
    
    static func new(
        for productID: String?
    ) -> Receipt {
        let bundleID: String = Bundle.main.bundleIdentifier ?? "emt.paisseon.satella"
        let now: Int64 = .init(Date().timeIntervalSince1970) * 1000
        let nowDate: String = "\(Date()) Europe/Copenhagen"
        let receiptID: Int64 = .random(in: 1 ... 0x07151129)
        let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
        let expDate: String = "\(Date(timeIntervalSince1970: 0xf2a52380)) Europe/Copenhagen"
        let expNow: Int64 = 0xf2a52380 * 1000
        
        let info: ReceiptInfo = .init(
            quantity: "1",
            productID: productID ?? bundleID,
            transactionID: receiptID.description,
            originalTransactionID: receiptID.description,
            purchaseDate: nowDate,
            purchaseDateMs: now.description,
            purchaseDatePst: nowDate,
            originalPurchaseDate: nowDate,
            originalPurchaseDateMs: nowDate,
            originalPurchaseDatePst: nowDate,
            expiresDate: expDate,
            expiresDateMs: expNow.description,
            expiresDatePst: expDate,
            isTrialPeriod: "false",
            isInIntroOfferPeriod: "false"
        )
        
        let receipt: Receipt = .init(
            receiptType: "Production",
            adamID: receiptID,
            appItemID: receiptID,
            bundleID: bundleID,
            applicationVersion: version,
            downloadID: Int(receiptID),
            versionExternalIDentifier: 0,
            receiptCreationDate: nowDate,
            receiptCreationDateMs: now.description,
            receiptCreationDatePst: nowDate,
            requestDate: nowDate,
            requestDateMs: now.description,
            requestDatePst: nowDate,
            originalPurchaseDate: nowDate,
            originalPurchaseDateMs: now.description,
            originalPurchaseDatePst: nowDate,
            originalApplicationVersion: version,
            inApp: [info]
        )
        
        return receipt
    }
    
    static func response(
        for productID: String
    ) -> Data? {
        let receipt: Receipt = new(for: productID)
        let encoder: JSONEncoder = .init()
        var base64: String = ""
        
        do {
            let receiptData: Data = try encoder.encode(receipt)
            base64 = receiptData.base64EncodedString()
        } catch {
            return nil
        }
        
        let renewal: RenewalInfo = .init(
            autoRenewProductID: productID,
            originalTransactionID: UUID().uuidString,
            productID: productID,
            autoRenewStatus: "1"
        )
        
        let response: ReceiptResponse = .init(
            status: 0,
            environment: "Production",
            receipt: receipt,
            latestReceiptInfo: receipt.inApp,
            lastReceipt: base64,
            pendingRenewalInfo: [renewal]
        )
        
        do {
            let responseData: Data = try encoder.encode(response)
            return responseData
        } catch {
            return nil
        }
    }

    private static let signature: [UInt8] = [
        0x03, 0x42, 0xFB, 0x17, 0x13, 0xCE, 0x78, 0xFD, 0x08, 0x3D, 0xA8, 0x30, 0x13, 0xE0, 0xAE, 0xC6, 0x6D, 0x4C,
        0xA5, 0x57, 0xFC, 0x32, 0x34, 0xED, 0xA3, 0xEE, 0xC5, 0x0D, 0xB4, 0xCD, 0x03, 0xD1, 0xF1, 0x39, 0x25, 0x54,
        0xF9, 0x7C, 0xD0, 0x42, 0x4A, 0x6E, 0xAB, 0x04, 0xC8, 0x0B, 0xDB, 0x1D, 0x24, 0xB0, 0x9A, 0xBC, 0xAC, 0x33,
        0x3E, 0x37, 0xD8, 0x23, 0xFF, 0x1F, 0x58, 0x46, 0xD1, 0x7D, 0x66, 0xD3, 0x3C, 0x63, 0xF3, 0x1D, 0xD5, 0x4C,
        0xB6, 0xEE, 0x6B, 0x5D, 0x9F, 0x0E, 0x20, 0x9B, 0x10, 0xFB, 0xFA, 0xC7, 0x90, 0xB1, 0x98, 0x38, 0xEC, 0x37,
        0xBE, 0x37, 0x2F, 0x8F, 0xB5, 0x4C, 0x9C, 0x55, 0x4D, 0x09, 0xE6, 0x85, 0x8D, 0xCF, 0xBF, 0x53, 0x27, 0x4F,
        0x5B, 0x6A, 0xA6, 0x22, 0xAF, 0x2B, 0x81, 0x1A, 0x3E, 0xE7, 0xF1, 0xDD, 0x7D, 0x82, 0xD7, 0x49, 0x9F, 0xF6,
        0xC1, 0x27, 0xAA, 0xC5, 0xE1, 0x53, 0xC5, 0x84, 0x63, 0x0F, 0xCB, 0x6B, 0x1A, 0x4D, 0xBD, 0x8E, 0x3F, 0x43,
        0xA6, 0x38, 0xBB, 0xD1, 0xCE, 0x90, 0xA8, 0x14, 0x06, 0x84, 0xE8, 0x04, 0xA7, 0x01, 0xBD, 0x68, 0x96, 0xC8,
        0xB9, 0xA1, 0xAF, 0xA7, 0xDF, 0x6A, 0xE4, 0x3F, 0x55, 0x07, 0xD4, 0xC8, 0x65, 0x4D, 0xDA, 0x1D, 0x2A, 0x4C,
        0x92, 0x2D, 0x39, 0x1A, 0x3E, 0x85, 0x03, 0x36, 0x0D, 0xD2, 0x8D, 0x41, 0x75, 0xD5, 0xAE, 0x3C, 0x6C, 0xB0,
        0xC1, 0x6F, 0xAD, 0xAC, 0x08, 0xE1, 0xAD, 0x95, 0xDE, 0x01, 0x12, 0x6C, 0x4A, 0x9E, 0xCB, 0x48, 0xED, 0x4A,
        0x11, 0xE7, 0x28, 0xDC, 0x06, 0xCD, 0x37, 0x03, 0x2F, 0xB4, 0xD2, 0x7F, 0x8C, 0xAC, 0x29, 0xFF, 0x64, 0xAE,
        0x45, 0x81, 0xFF, 0x9A, 0x6B, 0x4E, 0xC9, 0xDD, 0x6E, 0xA3, 0x8A, 0x90, 0x04, 0xF5, 0x17, 0x84, 0x8C, 0x14,
        0x46, 0x99, 0xA0, 0x18, 0x24, 0x00, 0x00, 0x05, 0x80, 0x30, 0x82, 0x05, 0x7C, 0x30, 0x82, 0x04, 0x64, 0xA0,
        0x03, 0x02, 0x01, 0x02, 0x02, 0x08, 0x0E, 0xEB, 0x57, 0x87, 0xE7, 0x9E, 0x09, 0x8D, 0x30, 0x0D, 0x06, 0x09,
        0x2A, 0x86, 0x48, 0x86, 0xF7, 0x0D, 0x01, 0x01, 0x05, 0x05, 0x00, 0x30, 0x81, 0x96, 0x31, 0x0B, 0x30, 0x09,
        0x06, 0x03, 0x55, 0x04, 0x06, 0x13, 0x02, 0x55, 0x53, 0x31, 0x13, 0x30, 0x11, 0x06, 0x03, 0x55, 0x04, 0x0A,
        0x0C, 0x0A, 0x41, 0x70, 0x70, 0x6C, 0x65, 0x20, 0x49, 0x6E, 0x63, 0x2E, 0x31, 0x2C, 0x30, 0x2A, 0x06, 0x03,
        0x55, 0x04, 0x0B, 0x0C, 0x23, 0x41, 0x70, 0x70, 0x6C, 0x65, 0x20, 0x57, 0x6F, 0x72, 0x6C, 0x64, 0x77, 0x69,
        0x64, 0x65, 0x20, 0x44, 0x65, 0x76, 0x65, 0x6C, 0x6F, 0x70, 0x65, 0x72, 0x20, 0x52, 0x65, 0x6C, 0x61, 0x74,
        0x69, 0x6F, 0x6E, 0x73, 0x31, 0x44, 0x30, 0x42, 0x06, 0x03, 0x55, 0x04, 0x03, 0x0C, 0x3B, 0x41, 0x70, 0x70,
        0x6C, 0x65, 0x20, 0x57, 0x6F, 0x72, 0x6C, 0x64, 0x77, 0x69, 0x64, 0x65, 0x20, 0x44, 0x65, 0x76, 0x65, 0x6C,
        0x6F, 0x70, 0x65, 0x72, 0x20, 0x52, 0x65, 0x6C, 0x61, 0x74, 0x69, 0x6F, 0x6E, 0x73, 0x20, 0x43, 0x65, 0x72,
        0x74, 0x69, 0x66, 0x69, 0x63, 0x61, 0x74, 0x69, 0x6F, 0x6E, 0x20, 0x41, 0x75, 0x74, 0x68, 0x6F, 0x72, 0x69,
        0x74, 0x79, 0x30, 0x1E, 0x17, 0x0D, 0x31, 0x35, 0x31, 0x31, 0x31, 0x33, 0x30, 0x32, 0x31, 0x35, 0x30, 0x39,
        0x5A, 0x17, 0x0D, 0x32, 0x33, 0x30, 0x32, 0x30, 0x37, 0x32, 0x31, 0x34, 0x38, 0x34, 0x37, 0x5A, 0x30, 0x81,
        0x89, 0x31, 0x37, 0x30, 0x35, 0x06, 0x03, 0x55, 0x04, 0x03, 0x0C, 0x2E, 0x4D, 0x61, 0x63, 0x20, 0x41, 0x70,
        0x70, 0x20, 0x53, 0x74, 0x6F, 0x72, 0x65, 0x20, 0x61, 0x6E, 0x64, 0x20, 0x69, 0x54, 0x75, 0x6E, 0x65, 0x73,
        0x20, 0x53, 0x74, 0x6F, 0x72, 0x65, 0x20, 0x52, 0x65, 0x63, 0x65, 0x69, 0x70, 0x74, 0x20, 0x53, 0x69, 0x67,
        0x6E, 0x69, 0x6E, 0x67, 0x31, 0x2C, 0x30, 0x2A, 0x06, 0x03, 0x55, 0x04, 0x0B, 0x0C, 0x23, 0x41, 0x70, 0x70,
        0x6C, 0x65, 0x20, 0x57, 0x6F, 0x72, 0x6C, 0x64, 0x77, 0x69, 0x64, 0x65, 0x20, 0x44, 0x65, 0x76, 0x65, 0x6C,
        0x6F, 0x70, 0x65, 0x72, 0x20, 0x52, 0x65, 0x6C, 0x61, 0x74, 0x69, 0x6F, 0x6E, 0x73, 0x31, 0x13, 0x30, 0x11,
        0x06, 0x03, 0x55, 0x04, 0x0A, 0x0C, 0x0A, 0x41, 0x70, 0x70, 0x6C, 0x65, 0x20, 0x49, 0x6E, 0x63, 0x2E, 0x31,
        0x0B, 0x30, 0x09, 0x06, 0x03, 0x55, 0x04, 0x06, 0x13, 0x02, 0x55, 0x53, 0x30, 0x82, 0x01, 0x22, 0x30, 0x0D,
        0x06, 0x09, 0x2A, 0x86, 0x48, 0x86, 0xF7, 0x0D, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x0F, 0x00,
        0x30, 0x82, 0x01, 0x0A, 0x02, 0x82, 0x01, 0x01, 0x00, 0xA5, 0xCF, 0x81, 0xFD, 0x25, 0xA2, 0x81, 0x5B, 0xD6,
        0x87, 0xED, 0x23, 0xDA, 0x33, 0x1C, 0x8E, 0xE2, 0x23, 0xC0, 0xA5, 0xC4, 0x26, 0xCB, 0x3D, 0xC6, 0x9F, 0xEC,
        0x4A, 0x0D, 0x55, 0x86, 0xFF, 0xA4, 0x02, 0xD7, 0x97, 0xCA, 0x39, 0x54, 0x6D, 0x7D, 0x7F, 0xB2, 0x54, 0x18,
        0x9D, 0xC4, 0x2C, 0x52, 0x71, 0x8E, 0x64, 0x7B, 0x82, 0xCE, 0x89, 0xBA, 0x49, 0xD6, 0x08, 0xE5, 0xB4, 0x88,
        0x71, 0xCF, 0x3F, 0x5B, 0x46, 0x2E, 0xC6, 0xC4, 0x1D, 0xB8, 0x03, 0xA9, 0x58, 0xA2, 0x04, 0x3E, 0x21, 0x78,
        0xD5, 0xDB, 0xB7, 0xD0, 0x8E, 0x12, 0x8D, 0x83, 0x4C, 0x5B, 0x2A, 0x68, 0x37, 0x93, 0xC2, 0xF2, 0xBD, 0x1E,
        0xC4, 0xD2, 0xA1, 0x0C, 0x4A, 0x58, 0x52, 0xAB, 0x12, 0xE3, 0xED, 0xDD, 0x1F, 0x98, 0x15, 0x90, 0x35, 0x2D,
        0xC2, 0xCC, 0x12, 0xCA, 0x8D, 0x48, 0x81, 0xF7, 0x58, 0x78, 0x54, 0x6B, 0xE8, 0x8C, 0x31, 0x36, 0x1F, 0x4A,
        0x06, 0x0C, 0x47, 0x54, 0xF3, 0x37, 0x90, 0xB8, 0xB2, 0x92, 0x89, 0x7D, 0x5F, 0xA4, 0x85, 0x4A, 0xE1, 0xC0,
        0x9C, 0xE0, 0xBA, 0xA4, 0xBB, 0x82, 0x97, 0x63, 0xF4, 0x2B, 0x93, 0xC1, 0xFD, 0x3E, 0x6F, 0xCA, 0xC1, 0xF5,
        0x3C, 0xA9, 0x8F, 0x52, 0x1A, 0xC0, 0x25, 0x0A, 0x76, 0x0E, 0xDE, 0xFE, 0x99, 0xFE, 0xFF, 0xC2, 0x6B, 0xF5,
        0x5B, 0x5E, 0xAC, 0x73, 0x51, 0x49, 0x08, 0x56, 0x89, 0xCC, 0x43, 0x90, 0xCC, 0x8E, 0x81, 0x02, 0xD0, 0xA0,
        0x97, 0xB6, 0x5C, 0xB1, 0xA1, 0x69, 0x69, 0x87, 0x90, 0x10, 0x68, 0x26, 0x26, 0x39, 0xB8, 0x1D, 0x10, 0x73,
        0xB0, 0x0A, 0x5D, 0xC5, 0x73, 0xD0, 0xDF, 0x76, 0x3B, 0xD8, 0x2D, 0xD9, 0x88, 0x1E, 0xE3, 0xEC, 0x07, 0xCF,
        0xE2, 0x8E, 0xD0, 0xD3, 0xFA, 0x26, 0x55, 0x81, 0xEF, 0xE2, 0x03, 0x49, 0x23, 0x02, 0x03, 0x01, 0x00, 0x01,
        0xA3, 0x82, 0x01, 0xD7, 0x30, 0x82, 0x01, 0xD3, 0x30, 0x3F, 0x06, 0x08, 0x2B, 0x06, 0x01, 0x05, 0x05, 0x07,
        0x01, 0x01, 0x04, 0x33, 0x30, 0x31, 0x30, 0x2F, 0x06, 0x08, 0x2B, 0x06, 0x01, 0x05, 0x05, 0x07, 0x30, 0x01,
        0x86, 0x23, 0x68, 0x74, 0x74, 0x70, 0x3A, 0x2F, 0x2F, 0x6F, 0x63, 0x73, 0x70, 0x2E, 0x61, 0x70, 0x70, 0x6C,
        0x65, 0x2E, 0x63, 0x6F, 0x6D, 0x2F, 0x6F, 0x63, 0x73, 0x70, 0x30, 0x33, 0x2D, 0x77, 0x77, 0x64, 0x72, 0x30,
        0x34, 0x30, 0x1D, 0x06, 0x03, 0x55, 0x1D, 0x0E, 0x04, 0x16, 0x04, 0x14, 0x91, 0xA4, 0x9C, 0xFC, 0xC4, 0x76,
        0xB7, 0x9F, 0xA0, 0x8A, 0xF4, 0x4D, 0xF5, 0x8F, 0x36, 0x5D, 0xED, 0x2B, 0x04, 0x85, 0x30, 0x0C, 0x06, 0x03,
        0x55, 0x1D, 0x13, 0x01, 0x01, 0xFF, 0x04, 0x02, 0x30, 0x00, 0x30, 0x1F, 0x06, 0x03, 0x55, 0x1D, 0x23, 0x04,
        0x18, 0x30, 0x16, 0x80, 0x14, 0x88, 0x27, 0x17, 0x09, 0xA9, 0xB6, 0x18, 0x60, 0x8B, 0xEC, 0xEB, 0xBA, 0xF6,
        0x47, 0x59, 0xC5, 0x52, 0x54, 0xA3, 0xB7, 0x30, 0x82, 0x01, 0x1E, 0x06, 0x03, 0x55, 0x1D, 0x20, 0x04, 0x82,
        0x01, 0x15, 0x30, 0x82, 0x01, 0x11, 0x30, 0x82, 0x01, 0x0D, 0x06, 0x0A, 0x2A, 0x86, 0x48, 0x86, 0xF7, 0x63,
        0x64, 0x05, 0x06, 0x01, 0x30, 0x81, 0xFE, 0x30, 0x81, 0xC3, 0x06, 0x08, 0x2B, 0x06, 0x01, 0x05, 0x05, 0x07,
        0x02, 0x02, 0x30, 0x81, 0xB6, 0x0C, 0x81, 0xB3, 0x52, 0x65, 0x6C, 0x69, 0x61, 0x6E, 0x63, 0x65, 0x20, 0x6F,
        0x6E, 0x20, 0x74, 0x68, 0x69, 0x73, 0x20, 0x63, 0x65, 0x72, 0x74, 0x69, 0x66, 0x69, 0x63, 0x61, 0x74, 0x65,
        0x20, 0x62, 0x79, 0x20, 0x61, 0x6E, 0x79, 0x20, 0x70, 0x61, 0x72, 0x74, 0x79, 0x20, 0x61, 0x73, 0x73, 0x75,
        0x6D, 0x65, 0x73, 0x20, 0x61, 0x63, 0x63, 0x65, 0x70, 0x74, 0x61, 0x6E, 0x63, 0x65, 0x20, 0x6F, 0x66, 0x20,
        0x74, 0x68, 0x65, 0x20, 0x74, 0x68, 0x65, 0x6E, 0x20, 0x61, 0x70, 0x70, 0x6C, 0x69, 0x63, 0x61, 0x62, 0x6C,
        0x65, 0x20, 0x73, 0x74, 0x61, 0x6E, 0x64, 0x61, 0x72, 0x64, 0x20, 0x74, 0x65, 0x72, 0x6D, 0x73, 0x20, 0x61,
        0x6E, 0x64, 0x20, 0x63, 0x6F, 0x6E, 0x64, 0x69, 0x74, 0x69, 0x6F, 0x6E, 0x73, 0x20, 0x6F, 0x66, 0x20, 0x75,
        0x73, 0x65, 0x2C, 0x20, 0x63, 0x65, 0x72, 0x74, 0x69, 0x66, 0x69, 0x63, 0x61, 0x74, 0x65, 0x20, 0x70, 0x6F,
        0x6C, 0x69, 0x63, 0x79, 0x20, 0x61, 0x6E, 0x64, 0x20, 0x63, 0x65, 0x72, 0x74, 0x69, 0x66, 0x69, 0x63, 0x61,
        0x74, 0x69, 0x6F, 0x6E, 0x20, 0x70, 0x72, 0x61, 0x63, 0x74, 0x69, 0x63, 0x65, 0x20, 0x73, 0x74, 0x61, 0x74,
        0x65, 0x6D, 0x65, 0x6E, 0x74, 0x73, 0x2E, 0x30, 0x36, 0x06, 0x08, 0x2B, 0x06, 0x01, 0x05, 0x05, 0x07, 0x02,
        0x01, 0x16, 0x2A, 0x68, 0x74, 0x74, 0x70, 0x3A, 0x2F, 0x2F, 0x77, 0x77, 0x77, 0x2E, 0x61, 0x70, 0x70, 0x6C,
        0x65, 0x2E, 0x63, 0x6F, 0x6D, 0x2F, 0x63, 0x65, 0x72, 0x74, 0x69, 0x66, 0x69, 0x63, 0x61, 0x74, 0x65, 0x61,
        0x75, 0x74, 0x68, 0x6F, 0x72, 0x69, 0x74, 0x79, 0x2F, 0x30, 0x0E, 0x06, 0x03, 0x55, 0x1D, 0x0F, 0x01, 0x01,
        0xFF, 0x04, 0x04, 0x03, 0x02, 0x07, 0x80, 0x30, 0x10, 0x06, 0x0A, 0x2A, 0x86, 0x48, 0x86, 0xF7, 0x63, 0x64,
        0x06, 0x0B, 0x01, 0x04, 0x02, 0x05, 0x00, 0x30, 0x0D, 0x06, 0x09, 0x2A, 0x86, 0x48, 0x86, 0xF7, 0x0D, 0x01,
        0x01, 0x05, 0x05, 0x00, 0x03, 0x82, 0x01, 0x01, 0x00, 0x0D, 0xA6, 0x1B, 0xD3, 0x2E, 0x3D, 0xE3, 0x5B, 0x2B,
        0x07, 0x6E, 0x42, 0x96, 0x6C, 0xD3, 0xE8, 0x8C, 0x43, 0x30, 0x82, 0x5F, 0xE0, 0x5C, 0xD1, 0x8D, 0xBE, 0xBD,
        0x0F, 0xBD, 0x1A, 0xFC, 0x25, 0x92, 0xDB, 0x8C, 0x85, 0xC3, 0x80, 0x59, 0xDF, 0xE3, 0xE2, 0xD7, 0x2E, 0x05,
        0x14, 0xAC, 0x0D, 0xDB, 0xB6, 0xB8, 0xFE, 0xFC, 0x35, 0x2E, 0x7C, 0xCB, 0xAD, 0x17, 0x6B, 0x8E, 0x7F, 0x1F,
        0xE4, 0x77, 0xB9, 0xB1, 0x67, 0x95, 0xB4, 0x13, 0x5E, 0xA6, 0x19, 0x86, 0x76, 0xF8, 0x5A, 0x20, 0x95, 0xE7,
        0x63, 0x8C, 0x0F, 0x73, 0xFC, 0xE8, 0xED, 0xC6, 0x1F, 0xAE, 0x99, 0xF8, 0x65, 0x48, 0x5C, 0xA0, 0xE0, 0x28,
        0x3A, 0xC0, 0x10, 0x37, 0x2D, 0xB9, 0xA0, 0x04, 0x39, 0x1F, 0x73, 0xB9, 0xC8, 0x05, 0xFD, 0xF2, 0xDE, 0x7F,
        0x1A, 0x2A, 0x2A, 0x6E, 0x2B, 0x01, 0xFC, 0xA0, 0x20, 0x5C, 0xD9, 0xEB, 0x7D, 0x27, 0xA6, 0x33, 0xF8, 0xF5,
        0x98, 0xE0, 0xBE, 0x44, 0xDB, 0xB1, 0x4C, 0x67, 0xFC, 0x6E, 0x0A, 0x4F, 0xC9, 0xE2, 0x06, 0xA8, 0xD2, 0x97,
        0xF3, 0xA7, 0x8E, 0x6B, 0x51, 0xA2, 0x5A, 0x84, 0x75, 0x65, 0xD1, 0x16, 0x04, 0x62, 0xE3, 0xC1, 0x5F, 0xF5,
        0x08, 0xA9, 0xCF, 0x68, 0xD9, 0x92, 0x00, 0xC9, 0xC1, 0x8C, 0xB3, 0xF8, 0x8D, 0x00, 0x64, 0xBA, 0x58, 0x60,
        0xC0, 0x7C, 0xAF, 0x8F, 0x75, 0xCA, 0x69, 0xB9, 0x5B, 0x2A, 0xD6, 0x1D, 0x68, 0x6E, 0x98, 0x42, 0xF5, 0x4C,
        0xA7, 0x37, 0x19, 0x9B, 0xCC, 0x3B, 0x1C, 0x7A, 0x19, 0x43, 0xF3, 0xA3, 0x6D, 0xBF, 0x48, 0x60, 0x06, 0x0C,
        0x36, 0x92, 0x2B, 0xEC, 0xDE, 0x18, 0xB5, 0x11, 0xDA, 0x2D, 0x23, 0xD0, 0x8E, 0xFC, 0xA0, 0x69, 0x9C, 0x17,
        0x1B, 0x9E, 0x80, 0x7B, 0x39, 0x47, 0x45, 0x30, 0x61, 0x2F, 0xC7
    ]
}

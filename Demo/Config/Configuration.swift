//
//  Configuration.swift
//
//
//  Created by
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import Foundation

protocol ConfigurationDelegate: class {
    var baseUrl: String { get }

    func isMock() -> Bool
}

class Configuration: ConfigurationDelegate {

    var baseUrl: String = ""

    private enum TypeConfiguration: String {
        case mock, dev, qa, uat, prod
    }

    private var infoDict: [String: Any] {
        if let dict = Bundle.main.infoDictionary {
            return dict
        }
        return [:]
    }

    private var type: TypeConfiguration = .prod

    init() {
        guard let configFileName = infoDict["EnvConfigFile"] as? String else { return }
        guard let path = Bundle.main.path(forResource: configFileName, ofType: "json") else { return }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            guard let json = jsonResult as? [String: Any],
                  let typeString = json.keys.first,
                  let type = TypeConfiguration(rawValue: typeString),
                  let dict = json.values.first as? [String: Any] else {
                    return
            }
            self.type = type
//            print(typeString)
            setConfig(dict)
        } catch {
            // handle error
        }
    }

    private func setConfig(_ json: [String: Any]) {
        self.baseUrl = (json["baseUrl"] as? String) ?? ""
    }

    func isMock() -> Bool {
        return type == .mock
    }
}

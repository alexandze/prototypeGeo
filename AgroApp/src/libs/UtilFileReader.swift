//
//  UtilFileReader.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-27.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

public class UtilReaderFile {
    public static func readJsonFile<T: Decodable>(
        resource: String,
        typeRessource: String,
        _ type: T.Type
    ) -> T? {
        if let data = readFile(resource: resource, typeRessource: typeRessource) {
            let jsonDecode = JSONDecoder()
            return try? jsonDecode.decode(T.self, from: data)
        }

        return nil
    }

    public static func readFile(resource: String, typeRessource: String) -> Data? {
        if let path = Bundle.main.path(forResource: resource, ofType: typeRessource) {
            do {
                return try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            } catch {

            }
        }

        return nil
    }
}

//
//  FundFeatureContainer+AutoRegister.swift
//
//
//  Created by Hien Tran on 28/02/2024.
//

// swiftlint:disable force_unwrapping

// extension FundFeatureContainer: AutoRegistering {
//    public func autoRegister() {
//        fundDetailsUseCase.register { resolve(\.fundDetailsUseCase) }
//        fundCreationUseCase.register { resolve(\.fundCreationUseCase) }
//        fundDetailsReducer.register {
//            FundDetailsReducer(fundDetailsUseCase: self.fundDetailsUseCase.resolve()!)
//        }
//        fundCreationReducer.register {
//            FundCreationReducer(fundCreationUseCase: self.fundCreationUseCase.resolve()!)
//        }
//    }
// }

// swiftlint:enable force_unwrapping

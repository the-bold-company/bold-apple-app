//
//  HomeFeatureContainer+AutoRegister.swift
//
//
//  Created by Hien Tran on 28/02/2024.
//

// swiftlint:disable force_unwrapping

// extension HomeFeatureContainer: AutoRegistering {
//    public func autoRegister() {
//        transactionListUseCase.register { resolve(\.transactionListUseCase) }
//        fundListUseCase.register { resolve(\.fundListUseCase) }
//        fundDetailsUseCase.register { resolve(\.fundDetailsUseCase) }
//        portfolioUseCase.register { resolve(\.portfolioUseCase) }
//        homeReducer.register {
//            HomeReducer(
//                transactionListUseCase: self.transactionListUseCase.resolve()!,
//                fundListUseCase: self.fundListUseCase.resolve()!,
//                fundDetailsUseCase: self.fundDetailsUseCase.resolve()!,
//                portfolioUseCase: self.portfolioUseCase.resolve()!
//            )
//        }
//    }
// }

// swiftlint:enable force_unwrapping

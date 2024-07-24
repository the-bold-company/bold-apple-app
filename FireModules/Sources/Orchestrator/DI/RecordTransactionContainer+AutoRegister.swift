//
//  RecordTransactionContainer+AutoRegister.swift
//
//
//  Created by Hien Tran on 27/02/2024.
//

// swiftlint:disable force_unwrapping

// extension RecordTransactionFeatureContainer: AutoRegistering {
//    public func autoRegister() {
//        transactionRecordUseCase.register { resolve(\.transactionRecordUseCase) }
//        fundListUseCase.register { resolve(\.fundListUseCase) }
//        sendMoneyReducer.register {
//            SendMoneyReducer(
//                transactionRecordUseCase: self.transactionRecordUseCase.resolve()!,
//                fundListUseCase: self.fundListUseCase.resolve()!
//            )
//        }
//    }
// }

// swiftlint:enable force_unwrapping

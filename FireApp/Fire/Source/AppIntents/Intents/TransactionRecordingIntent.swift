////
////  Intents.swift
////  Fire
////
////  Created by Hien Tran on 08/02/2024.
////

import AppIntents
import Intents
import SwiftUI

struct TransactionRecordingIntent: AppIntent {
    init() {}

    @Parameter(title: "Source funds")
    var sourceFund: SourceFundIntentEntity?

    @Parameter(title: "Destination funds")
    var destinationFund: DestinationFundIntentEntity?

    @Parameter(title: "Amount", requestValueDialog: IntentDialog("What's the amount"))
    var amount: Double?

    static var title: LocalizedStringResource = "Make transactions"

    static var description = IntentDescription("Record a transaction from your fund")

    static var parameterSummary: some ParameterSummary {
        Summary("Spend \(\.$amount) from \(\.$sourceFund) to \(\.$destinationFund)")
    }

    func perform() async throws -> some ProvidesDialog & ShowsSnippetView {
        let source: SourceFundIntentEntity?
        let destination: DestinationFundIntentEntity?
        let _amount: Double?
        let appIntentService = AppIntentService()

        do {
            let funds = try await appIntentService.fetchFunds()

            if let amount {
                _amount = amount
            } else {
                _amount = try await $amount.requestValue(IntentDialog("What's the amount?"))
            }

            if let sourceFund {
                source = sourceFund
            } else {
                let _source = try await $sourceFund.requestDisambiguation(
                    among: funds.map {
                        SourceFundIntentEntity(id: $0.id, name: $0.name, balance: $0.balance)
                    },
                    dialog: IntentDialog("Select source fund")
                )

                source = _source
            }

            if let destinationFund {
                destination = destinationFund
            } else {
                var destinationFundOptions = [DestinationFundIntentEntity.none]
                destinationFundOptions.append(contentsOf: funds
                    .filter { $0.id != source!.id }
                    .map {
                        DestinationFundIntentEntity(id: $0.id, name: $0.name, balance: $0.balance)
                    }
                )
                let _destination = try await $destinationFund.requestDisambiguation(
                    among: destinationFundOptions,
                    dialog: IntentDialog("Select destination fund")
                )

                destination = _destination
            }

            let res = await appIntentService.makeTransaction(
                sourceFundId: source!.id,
                destinationFundId: destination!.representsNull
                    ? nil
                    : destination!.id,
                amount: Decimal(_amount!)
            )

            switch res {
            case let .success(transaction):
                var message = "Transaction recorded sucessfully"
                message += destination!.representsNull
                    ? "."
                    : " to \(destination!.name)."

                return .result(
                    dialog: IntentDialog(stringLiteral: message),
                    view: TransactionOverview(
                        source: source!,
                        destination: destination!,
                        amount: transaction.amount
                    )
                )
            case let .failure(error):
                return .result(
                    dialog: IntentDialog(stringLiteral: "\(error.failureReason ?? ""). Operation could not be completed.")
                )
            }
        } catch {
            print("❌ \(error)")
            return .result(
                dialog: "Operation could not be completed, please try again later."
            )
        }
    }
}

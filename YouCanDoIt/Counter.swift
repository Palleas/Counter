import Foundation
import ReactiveSwift
import Tentacle
import Result


final class Counter {
    private let c = Client(.dotCom, token: ProcessInfo.processInfo.environment["GITHUB_API_TOKEN"]!)

    enum CounterError: Error {
        case githubError(wrapped: Client.Error)
        case invalidDirectory
        case fetchingError
        case downloadError
    }

    func count() -> SignalProducer<Int, CounterError> {
        return fetch().map { content in
            let options: NSLinguisticTagger.Options = [.omitWhitespace, .omitPunctuation, .joinNames]
            let schemes = NSLinguisticTagger.availableTagSchemes(forLanguage: "en")
            let tagger = NSLinguisticTagger(tagSchemes: schemes, options: Int(options.rawValue))
            tagger.string = content

            let tags = tagger.tags(in: NSMakeRange(0, (content as NSString).length), scheme: NSLinguisticTagSchemeTokenType, options: options, tokenRanges: nil)

            return tags.count
        }
        .reduce(0, +)
    }

    func fetch() -> SignalProducer<String, CounterError> {
        return c
            .content(atPath: "_drafts", in: Repository(owner: "palleas", name: "romain-pouclet.com"))
            .mapError { CounterError.githubError(wrapped: $0) }
            .flatMap(.latest) { response, content -> SignalProducer<String, CounterError> in
                guard case let .directory(files) = content else {
                    return SignalProducer(error: .invalidDirectory)
                }

                return SignalProducer(files)
                    .flatMap(.concat) { file -> SignalProducer<String, CounterError> in
                        guard case let .file(_, url) = file.content, let downloadUrl = url else { return .empty }

                        let download = URLSession.shared.reactive.data(with: URLRequest(url: downloadUrl))
                            .mapError { _ in CounterError.downloadError }
                            .map { data, _ in data }
                            .map { String(data: $0, encoding: .utf8)! }

                        return download
                    }
            }
    }

}

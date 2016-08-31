import Argo
import KsApi

public enum RefTag {
  case activity
  case activitySample
  case category
  case categoryFeatured
  case categoryWithSort(DiscoveryParams.Sort)
  case city
  case dashboard
  case discovery
  case discoveryPotd
  case messageThread
  case push
  case recommended
  case recommendedWithSort(DiscoveryParams.Sort)
  case search
  case social
  case thanks
  case unrecognized(String)
  case users

  /**
   Create a RefTag value from a code string. If a ref tag cannot be matched, an `.unrecognized` tag is
   returned.

   - parameter code: A code string.

   - returns: A ref tag.
   */
  // swiftlint:disable cyclomatic_complexity
  public init(code: String) {
    switch code {
    case "activity":                  self = .activity
    case "category":                  self = .category
    case "category_featured":         self = .categoryFeatured
    case "discovery_activity_sample": self = .activitySample
    case "category_ending_soon":      self = .categoryWithSort(.endingSoon)
    case "category":                  self = .categoryWithSort(.magic)
    case "category_most_funded":      self = .categoryWithSort(.mostFunded)
    case "category_newest":           self = .categoryWithSort(.newest)
    case "category_popular":          self = .categoryWithSort(.popular)
    case "city":                      self = .city
    case "dashboard":                 self = .dashboard
    case "discovery":                 self = .discovery
    case "discovery_potd":            self = .discoveryPotd
    case "message_thread":            self = .messageThread
    case "push":                      self = .push
    case "recommended":               self = .recommended
    case "recommended_ending_soon":   self = .recommendedWithSort(.endingSoon)
    case "recommended":               self = .recommendedWithSort(.magic)
    case "recommended_most_funded":   self = .recommendedWithSort(.mostFunded)
    case "recommended_newest":        self = .recommendedWithSort(.newest)
    case "recommended_popular":       self = .recommendedWithSort(.popular)
    case "search":                    self = .search
    case "social":                    self = .social
    case "thanks":                    self = .thanks
    case "users":                     self = .users
    default:                          self = .unrecognized(code)
    }
  }
  // swiftlint:enable cyclomatic_complexity

  /// A string representation of the ref tag that can be used in analytics tracking, cookies, etc...
  public var stringTag: String {
    switch self {
    case .activity:
      return "activity"
    case .category:
      return "category"
    case .categoryFeatured:
      return "category_featured"
    case .activitySample:
      return "discovery_activity_sample"
    case let .categoryWithSort(sort):
      return "category" + sortRefTagSuffix(sort)
    case .city:
      return "city"
    case .dashboard:
      return "dashboard"
    case .discovery:
      return "discovery"
    case .discoveryPotd:
      return "discovery_potd"
    case .messageThread:
      return "message_thread"
    case .push:
      return "push"
    case .recommended:
      return "recommended"
    case let .recommendedWithSort(sort):
      return "recommended" + sortRefTagSuffix(sort)
    case .search:
      return "search"
    case .social:
      return "social"
    case .thanks:
      return "thanks"
    case .users:
      return "users"
    case let .unrecognized(code):
      return code
    }
  }
}

extension RefTag: Equatable {
}
public func == (lhs: RefTag, rhs: RefTag) -> Bool {
  switch (lhs, rhs) {
  case (.activity, .activity), (.category, .category), (.categoryFeatured, .categoryFeatured),
    (.activitySample, .activitySample), (.city, .city), (.dashboard, .dashboard), (.discovery, .discovery),
    (.discoveryPotd, .discoveryPotd), (.messageThread, .messageThread), (.recommended, .recommended),
    (.search, .search), (.social, .social), (.thanks, .thanks), (.users, .users):
    return true
  case let (.categoryWithSort(lhs), .categoryWithSort(rhs)):
    return lhs == rhs
  case let (.recommendedWithSort(lhs), .recommendedWithSort(rhs)):
    return lhs == rhs
  case let (.unrecognized(lhs), .unrecognized(rhs)):
    return lhs == rhs
  default:
    return false
  }
}

extension RefTag: CustomStringConvertible {
  public var description: String {
    return self.stringTag
  }
}

extension RefTag: Hashable {
  public var hashValue: Int {
    return self.stringTag.hashValue
  }
}

private func sortRefTagSuffix(sort: DiscoveryParams.Sort) -> String {
  switch sort {
  case .endingSoon:
    return "_ending_soon"
  case .magic:
    return ""
  case .mostFunded:
    return "_most_funded"
  case .newest:
    return "_newest"
  case .popular:
    return "_popular"
  }
}

extension RefTag: Decodable {
  public static func decode(json: JSON) -> Decoded<RefTag> {
    switch json {
    case let .String(code):
      return .Success(RefTag(code: code))
    default:
      return .Failure(.Custom("RefTag code must be a string."))
    }
  }
}

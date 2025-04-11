# ExPass

ExPass is an Elixir library for generating and manipulating Apple Wallet passes.

## Installation

The package can be installed by adding `ex_pass` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_pass, "~> 0.1.0"}
  ]
end
```

## Progress

| Index | Status | Object | Field | Issue No. |
|-------|--------|--------|-------|-----------|
| 1 | ✅ | `Pass.PassFieldContent` | `Pass.PassFieldContent.attributedValue` | [#145](https://github.com/njausteve/ex_pass/issues/145) |
| 2 | ✅ |  | `Pass.PassFieldContent.changeMessage` | [#146](https://github.com/njausteve/ex_pass/issues/146) |
| 3 | ✅ |  | `Pass.PassFieldContent.currencyCode` | [#147](https://github.com/njausteve/ex_pass/issues/147) |
| 4 | ✅ |  | `Pass.PassFieldContent.dataDetectorTypes` | [#148](https://github.com/njausteve/ex_pass/issues/148) |
| 5 | ✅ |  | `Pass.PassFieldContent.dateStyle` | [#149](https://github.com/njausteve/ex_pass/issues/149) |
| 6 | ✅ |  | `Pass.PassFieldContent.ignoresTimeZone` | [#150](https://github.com/njausteve/ex_pass/issues/150) |
| 7 | ✅ |  | `Pass.PassFieldContent.isRelative` | [#151](https://github.com/njausteve/ex_pass/issues/151) |
| 8 | ✅ |  | `Pass.PassFieldContent.key` | [#152](https://github.com/njausteve/ex_pass/issues/152) |
| 9 | ✅ |  | `Pass.PassFieldContent.label` | [#159](https://github.com/njausteve/ex_pass/issues/159) |
| 10 | ✅ |  | `Pass.PassFieldContent.numberStyle` | [#154](https://github.com/njausteve/ex_pass/issues/154) |
| 11 | ✅ |  | `Pass.PassFieldContent.textAlignment` | [#155](https://github.com/njausteve/ex_pass/issues/155) |
| 12 | ✅ |  | `Pass.PassFieldContent.timeStyle` | [#156](https://github.com/njausteve/ex_pass/issues/156) |
| 13 | ✅ |  | `Pass.PassFieldContent.value` | [#157](https://github.com/njausteve/ex_pass/issues/157) |
| 14 | ✅ | `Pass.Barcodes` | `Pass.barcodes.altText` | [#56](https://github.com/njausteve/ex_pass/issues/56) |
| 15 | ✅ |  | `Pass.barcodes.format` | [#57](https://github.com/njausteve/ex_pass/issues/57) |
| 16 | ✅ |  | `Pass.barcodes.message` | [#58](https://github.com/njausteve/ex_pass/issues/58) |
| 17 | ✅ |  | `Pass.barcodes.messageEncoding` | [#59](https://github.com/njausteve/ex_pass/issues/59) |
| 18 | ✅ | `Pass.Beacons` | `Pass.beacons.major` | [#60](https://github.com/njausteve/ex_pass/issues/60) |
| 19 | ✅ |  | `Pass.beacons.minor` | [#61](https://github.com/njausteve/ex_pass/issues/61) |
| 20 | ✅ |  | `Pass.beacons.proximityUUID` | [#62](https://github.com/njausteve/ex_pass/issues/62) |
| 21 | ✅ |  | `Pass.beacons.relevantText` | [#63](https://github.com/njausteve/ex_pass/issues/63) |
| 22 | ✅ | `Pass.Locations` | `Pass.locations.altitude` | [#89](https://github.com/njausteve/ex_pass/issues/89) |
| 23 | ✅ |  | `Pass.locations.latitude` | [#90](https://github.com/njausteve/ex_pass/issues/90) |
| 24 | ✅ |  | `Pass.locations.longitude` | [#91](https://github.com/njausteve/ex_pass/issues/91) |
| 25 | ✅ |  | `Pass.locations.relevantText` | [#92](https://github.com/njausteve/ex_pass/issues/92) |
| 26 | ✅ | `Pass.SemanticTags.Seat` | `Pass.semanticTags.seat.seatType` | [#114](https://github.com/njausteve/ex_pass/issues/114) |
| 27 | ✅ | `Pass.NFC` | `Pass.nfc.encryptionPublicKey` | [#93](https://github.com/njausteve/ex_pass/issues/93) |
| 28 | ✅ |  | `Pass.nfc.message` | [#94](https://github.com/njausteve/ex_pass/issues/94) |
| 29 | ✅ |  | `Pass.nfc.requiresAuthentication` | [#95](https://github.com/njausteve/ex_pass/issues/95) |
| 30 | `todo` | `Pass.PassFields.AuxiliaryFields` | Inherits From `Pass.PassFieldContent` |  |
| 31 | `todo` |  | `Pass.PassFields.AuxiliaryFields.row` | [#64](https://github.com/njausteve/ex_pass/issues/64) |
| 32 | `todo` | `Pass.PassFields.SecondaryFields` | Inherits From `Pass.PassFieldContent` | [#69](https://github.com/njausteve/ex_pass/issues/69) |
| 33 | `todo` | `Pass.PassFields.PrimaryFields` | Inherits From `Pass.PassFieldContent` | [#68](https://github.com/njausteve/ex_pass/issues/68) |
| 34 | `todo` | `Pass.PassFields.HeaderFields` | Inherits From `Pass.PassFieldContent` | [#67](https://github.com/njausteve/ex_pass/issues/67) |
| 35 | `todo` | `Pass.PassFields.BackFields` | Inherits From `Pass.PassFieldContent` | [#66](https://github.com/njausteve/ex_pass/issues/66) |
| 36 | `todo` | `Pass.PassFields` | `Pass.PassFields.auxiliaryFields` | [#139](https://github.com/njausteve/ex_pass/issues/139) |
| 37 | `todo` |  | `Pass.PassFields.backFields` | [#140](https://github.com/njausteve/ex_pass/issues/140) |
| 38 | `todo` |  | `Pass.PassFields.headerFields` | [#141](https://github.com/njausteve/ex_pass/issues/141) |
| 39 | `todo` |  | `Pass.PassFields.primaryFields` | [#142](https://github.com/njausteve/ex_pass/issues/142) |
| 40 | `todo` |  | `Pass.PassFields.secondaryFields` | [#143](https://github.com/njausteve/ex_pass/issues/143) |
| 41 | `todo` | `Pass.BoardingPass` | Inherits From `Pass.PassFields` | [#75](https://github.com/njausteve/ex_pass/issues/75) |
| 42 | `todo` |  | `Pass.boardingPass.transitType` | [#144](https://github.com/njausteve/ex_pass/issues/144) |
| 43 | `todo` | `Pass.Coupon` | Inherits From `Pass.PassFields` | [#77](https://github.com/njausteve/ex_pass/issues/77) |
| 44 | `todo` |  | `Pass.coupon.couponCode` | [#78](https://github.com/njausteve/ex_pass/issues/78) |
| 45 | `todo` |  | `Pass.coupon.discountAmount` | [#79](https://github.com/njausteve/ex_pass/issues/79) |
| 46 | `todo` |  | `Pass.coupon.expirationDate` | [#80](https://github.com/njausteve/ex_pass/issues/80) |
| 47 | `todo` | `Pass.EventTicket` | Inherits From `Pass.PassFields` | [#81](https://github.com/njausteve/ex_pass/issues/81) |
| 48 | `todo` |  | `Pass.eventTicket.preferred_style_schemes` | [#84](https://github.com/njausteve/ex_pass/issues/84) |
| 49 | `todo` | `Pass.Generic` | Inherits From `Pass.PassFields` | [#88](https://github.com/njausteve/ex_pass/issues/88) |
| 50 | `todo` | `Pass.StoreCard` | Inherits From `Pass.PassFields` | [#96](https://github.com/njausteve/ex_pass/issues/96) |
| 51 | `todo` | `Pass.SemanticTags.CurrencyAmount` | `Pass.semanticTags.currencyAmount.amount` | [#115](https://github.com/njausteve/ex_pass/issues/115) |
| 52 | `todo` |  | `Pass.semanticTags.currencyAmount.currencyCode` | [#98](https://github.com/njausteve/ex_pass/issues/98) |
| 53 | `todo` | `Pass.SemanticTags.Location` | `Pass.semanticTags.location.latitude` | [#99](https://github.com/njausteve/ex_pass/issues/99) |
| 54 | `todo` |  | `Pass.semanticTags.location.longitude` | [#100](https://github.com/njausteve/ex_pass/issues/100) |
| 55 | `todo` | `Pass.SemanticTags.PersonNameComponents` | `Pass.semanticTags.personNameComponents.familyName` | [#101](https://github.com/njausteve/ex_pass/issues/101) |
| 56 | `todo` |  | `Pass.semanticTags.personNameComponents.givenName` | [#102](https://github.com/njausteve/ex_pass/issues/102) |
| 57 | `todo` |  | `Pass.semanticTags.personNameComponents.middleName` | [#103](https://github.com/njausteve/ex_pass/issues/103) |
| 58 | `todo` |  | `Pass.semanticTags.personNameComponents.namePrefix` | [#104](https://github.com/njausteve/ex_pass/issues/104) |
| 59 | `todo` |  | `Pass.semanticTags.personNameComponents.nameSuffix` | [#105](https://github.com/njausteve/ex_pass/issues/105) |
| 60 | `todo` |  | `Pass.semanticTags.personNameComponents.nickname` | [#106](https://github.com/njausteve/ex_pass/issues/106) |
| 61 | `todo` |  | `Pass.semanticTags.personNameComponents.phoneticRepresentation` | [#107](https://github.com/njausteve/ex_pass/issues/107) |
| 62 | ✅ | `Pass.SemanticTags.Seat` | `Pass.semanticTags.seat.seatDescription` | [#109](https://github.com/njausteve/ex_pass/issues/109) |
| 63 | ✅ |  | `Pass.semanticTags.seat.seatIdentifier` | [#110](https://github.com/njausteve/ex_pass/issues/110) |
| 64 | ✅ |  | `Pass.semanticTags.seat.seatNumber` | [#111](https://github.com/njausteve/ex_pass/issues/111) |
| 65 | ✅ |  | `Pass.semanticTags.seat.seatRow` | [#112](https://github.com/njausteve/ex_pass/issues/112) |
| 66 | ✅ |  | `Pass.semanticTags.seat.seatSection` | [#113](https://github.com/njausteve/ex_pass/issues/113) |
| 67 | `todo` | `Pass.SemanticTags.WifiNetwork` | `Pass.semanticTags.wifiNetwork.password` |  |
| 68 | `todo` |  | `Pass.semanticTags.wifiNetwork.ssid` |  |
| 69 | `todo` | `Pass.SemanticTags` | `Pass.semanticTags.airlineCode` | [#21](https://github.com/njausteve/ex_pass/issues/21) |
| 70 | `todo` |  | `Pass.semanticTags.artistIDs` | [#22](https://github.com/njausteve/ex_pass/issues/22) |
| 71 | `todo` |  | `Pass.semanticTags.awayTeamAbbreviation` | [#24](https://github.com/njausteve/ex_pass/issues/24) |
| 72 | `todo` |  | `Pass.semanticTags.awayTeamLocation` | [#25](https://github.com/njausteve/ex_pass/issues/25) |
| 73 | `todo` |  | `Pass.semanticTags.awayTeamName` | [#26](https://github.com/njausteve/ex_pass/issues/26) |
| 74 | `todo` |  | `Pass.semanticTags.balance` | [#27](https://github.com/njausteve/ex_pass/issues/27) |
| 75 | `todo` |  | `Pass.semanticTags.boardingGroup` | [#28](https://github.com/njausteve/ex_pass/issues/28) |
| 76 | `todo` |  | `Pass.semanticTags.boardingSequenceNumber` | [#29](https://github.com/njausteve/ex_pass/issues/29) |
| 77 | `todo` |  | `Pass.semanticTags.carNumber` | [#30](https://github.com/njausteve/ex_pass/issues/30) |
| 78 | `todo` |  | `Pass.semanticTags.confirmationNumber` | [#31](https://github.com/njausteve/ex_pass/issues/31) |
| 79 | `todo` |  | `Pass.semanticTags.currentArrivalDate` | [#32](https://github.com/njausteve/ex_pass/issues/32) |
| 80 | `todo` |  | `Pass.semanticTags.currentBoardingDate` | [#33](https://github.com/njausteve/ex_pass/issues/33) |
| 81 | `todo` |  | `Pass.semanticTags.currentDepartureDate` | [#34](https://github.com/njausteve/ex_pass/issues/34) |
| 82 | `todo` |  | `Pass.semanticTags.departureAirportCode` | [#36](https://github.com/njausteve/ex_pass/issues/36) |
| 83 | `todo` |  | `Pass.semanticTags.departureAirportName` | [#37](https://github.com/njausteve/ex_pass/issues/37) |
| 84 | `todo` |  | `Pass.semanticTags.departureGate` | [#38](https://github.com/njausteve/ex_pass/issues/38) |
| 85 | `todo` |  | `Pass.semanticTags.departureLocation` | [#39](https://github.com/njausteve/ex_pass/issues/39) |
| 86 | `todo` |  | `Pass.semanticTags.departureLocationDescription` | [#40](https://github.com/njausteve/ex_pass/issues/40) |
| 87 | `todo` |  | `Pass.semanticTags.departurePlatform` | [#41](https://github.com/njausteve/ex_pass/issues/41) |
| 88 | `todo` |  | `Pass.semanticTags.departureStationName` | [#42](https://github.com/njausteve/ex_pass/issues/42) |
| 89 | `todo` |  | `Pass.semanticTags.departureTerminal` | [#43](https://github.com/njausteve/ex_pass/issues/43) |
| 90 | `todo` |  | `Pass.semanticTags.destinationAirportCode` | [#44](https://github.com/njausteve/ex_pass/issues/44) |
| 91 | `todo` |  | `Pass.semanticTags.destinationAirportName` | [#45](https://github.com/njausteve/ex_pass/issues/45) |
| 92 | `todo` |  | `Pass.semanticTags.destinationGate` |  |
| 93 | `todo` |  | `Pass.semanticTags.destinationLocation` |  |
| 94 | `todo` |  | `Pass.semanticTags.destinationLocationDescription` |  |
| 95 | `todo` |  | `Pass.semanticTags.destinationPlatform` |  |
| 96 | `todo` |  | `Pass.semanticTags.destinationStationName` |  |
| 97 | `todo` |  | `Pass.semanticTags.destinationTerminal` |  |
| 98 | `todo` |  | `Pass.semanticTags.duration` |  |
| 99 | `todo` |  | `Pass.semanticTags.eventEndDate` |  |
| 100 | `todo` |  | `Pass.semanticTags.eventName` |  |
| 101 | `todo` |  | `Pass.semanticTags.eventStartDate` |  |
| 102 | `todo` |  | `Pass.semanticTags.eventType` |  |
| 103 | `todo` |  | `Pass.semanticTags.flightCode` |  |
| 104 | `todo` |  | `Pass.semanticTags.flightNumber` |  |
| 105 | `todo` |  | `Pass.semanticTags.genre` |  |
| 106 | `todo` |  | `Pass.semanticTags.homeTeamAbbreviation` |  |
| 107 | `todo` |  | `Pass.semanticTags.homeTeamLocation` |  |
| 108 | `todo` |  | `Pass.semanticTags.homeTeamName` |  |
| 109 | `todo` |  | `Pass.semanticTags.leagueAbbreviation` |  |
| 110 | `todo` |  | `Pass.semanticTags.leagueName` |  |
| 111 | `todo` |  | `Pass.semanticTags.membershipProgramName` |  |
| 112 | `todo` |  | `Pass.semanticTags.membershipProgramNumber` |  |
| 113 | `todo` |  | `Pass.semanticTags.originalArrivalDate` |  |
| 114 | `todo` |  | `Pass.semanticTags.originalBoardingDate` |  |
| 115 | `todo` |  | `Pass.semanticTags.originalDepartureDate` |  |
| 116 | `todo` |  | `Pass.semanticTags.passengerName` |  |
| 117 | `todo` |  | `Pass.semanticTags.performerNames` |  |
| 118 | `todo` |  | `Pass.semanticTags.priorityStatus` |  |
| 119 | `todo` |  | `Pass.semanticTags.seats` |  |
| 120 | `todo` |  | `Pass.semanticTags.securityScreening` |  |
| 121 | `todo` |  | `Pass.semanticTags.silenceRequested` |  |
| 122 | `todo` |  | `Pass.semanticTags.sportName` |  |
| 123 | `todo` |  | `Pass.semanticTags.totalPrice` |  |
| 124 | `todo` |  | `Pass.semanticTags.transitProvider` |  |
| 125 | `todo` |  | `Pass.semanticTags.transitStatus` | [#46](https://github.com/njausteve/ex_pass/issues/46) |
| 126 | `todo` |  | `Pass.semanticTags.transitStatusReason` | [#47](https://github.com/njausteve/ex_pass/issues/47) |
| 127 | `todo` |  | `Pass.semanticTags.vehicleName` | [#48](https://github.com/njausteve/ex_pass/issues/48) |
| 128 | `todo` |  | `Pass.semanticTags.vehicleNumber` | [#49](https://github.com/njausteve/ex_pass/issues/49) |
| 129 | `todo` |  | `Pass.semanticTags.vehicleType` | [#50](https://github.com/njausteve/ex_pass/issues/50) |
| 130 | `todo` |  | `Pass.semanticTags.venueEntrance` | [#51](https://github.com/njausteve/ex_pass/issues/51) |
| 131 | `todo` |  | `Pass.semanticTags.venueLocation` | [#52](https://github.com/njausteve/ex_pass/issues/52) |
| 132 | `todo` |  | `Pass.semanticTags.venueName` | [#53](https://github.com/njausteve/ex_pass/issues/53) |
| 133 | `todo` |  | `Pass.semanticTags.venuePhoneNumber` | [#54](https://github.com/njausteve/ex_pass/issues/54) |
| 134 | `todo` |  | `Pass.semanticTags.venueRoom` | [#55](https://github.com/njausteve/ex_pass/issues/55) |
| 135 | `todo` |  | `Pass.semanticTags.wifiAccess` | [#64](https://github.com/njausteve/ex_pass/issues/64) |
| 136 | `todo` |  | Handle pk pass signing |  |
| 137 | `todo` |  | Handle pkpass asset |  |

## Contribution Guide

We welcome contributions to this project! To ensure a smooth process, please follow these guidelines:

### Getting Started

1. **Fork the repository**: Click the "Fork" button at the top right of this page to create a copy of the repository in your GitHub account.
2. **Clone your fork**: Use `git clone` to clone your forked repository to your local machine.

   ```sh
   git clone https://github.com/your-username/ex_pass.git
   ```

3. **Create a branch**: Create a new branch for your work.

   ```sh
   git checkout -b your-branch-name
   ```

### Making Changes

1. **Code Style**: Ensure your code adheres to the project's coding standards.
2. **Commit Messages**: We use conventional commits. Write clear and concise commit messages following the format:

* ```text
  type(scope): subject
  ```

  Examples:

  ```text
  feat(parser): add ability to parse new format
  fix(api): handle null response
  ```

3. **Testing**: Ensure ample testing on your changes to avoid breaking existing functionality.

   ```sh
   # Run tests
   ```

4. **Versioning**: We use semantic versioning. Make sure to update the version number appropriately if your changes introduce new features, bug fixes, or breaking changes.

### Submitting Changes

1. **Push your branch**: Push your changes to your forked repository.

   ```sh
   git push origin your-branch-name
   ```

2. **Open a Pull Request**: Go to the original repository and open a pull request. Provide a clear description of your changes and any related issues.

#### Pull Request Template

When opening a pull request, please use the provided pull request template to ensure all necessary information is included. This helps maintain consistency and provides reviewers with the context they need to understand your changes.

The pull request template includes sections for:

1. **Title**: Provide a succinct and descriptive title for the pull request.
2. **Type of Change**: Indicate the type of change (e.g., new feature, bug fix, documentation update).
3. **Description**: Provide a detailed explanation of the changes you have made, including the reasons behind these changes and any relevant context.
4. **Testing**: Detail the testing you have performed to ensure that these changes function as intended.
5. **Impact**: Discuss the impact of your changes on the project, including effects on performance, new dependencies, or changes in behavior.
6. **Additional Information**: Include any additional information that reviewers should be aware of.
7. **Checklist**: Ensure your code adheres to the project's coding and style guidelines, and that you have performed a self-review, commented your code, and made corresponding changes to the documentation.

By following this template, you help streamline the review process and improve the quality of the codebase.

### Code Review

1. **Address Feedback**: Be responsive to feedback from reviewers and make necessary changes.
2. **Merge**: Once your pull request is approved, it will be merged by a project maintainer.

Thank you for contributing!

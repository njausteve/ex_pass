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

| Object | Field | Issue No. | Status |
|--------|-------|-----------|--------|
| `Pass.PassFieldContent` | `Pass.PassFieldContent.attributedValue` | [#145](https://github.com/njausteve/ex_pass/issues/145) | ✅ |
|  | `Pass.PassFieldContent.changeMessage` | [#146](https://github.com/njausteve/ex_pass/issues/146) | ✅ |
|  | `Pass.PassFieldContent.currencyCode` | [#147](https://github.com/njausteve/ex_pass/issues/147) | ✅ |
|  | `Pass.PassFieldContent.dataDetectorTypes` | [#148](https://github.com/njausteve/ex_pass/issues/148) | ✅ |
|  | `Pass.PassFieldContent.dateStyle` | [#149](https://github.com/njausteve/ex_pass/issues/149) | ✅ |
|  | `Pass.PassFieldContent.ignoresTimeZone` | [#150](https://github.com/njausteve/ex_pass/issues/150) | ✅ |
|  | `Pass.PassFieldContent.isRelative` | [#151](https://github.com/njausteve/ex_pass/issues/151) | ✅ |
|  | `Pass.PassFieldContent.key` | [#152](https://github.com/njausteve/ex_pass/issues/152) | ✅ |
|  | `Pass.PassFieldContent.label` | [#159](https://github.com/njausteve/ex_pass/issues/159) | ✅ |
|  | `Pass.PassFieldContent.numberStyle` | [#154](https://github.com/njausteve/ex_pass/issues/154) | ✅ |
|  | `Pass.PassFieldContent.textAlignment` | [#155](https://github.com/njausteve/ex_pass/issues/155) | ✅ |
|  | `Pass.PassFieldContent.timeStyle` | [#156](https://github.com/njausteve/ex_pass/issues/156) | ✅ |
|  | `Pass.PassFieldContent.value` | [#157](https://github.com/njausteve/ex_pass/issues/157) | ✅ |
| `Pass.Barcodes` | `Pass.barcodes.altText` | [#56](https://github.com/njausteve/ex_pass/issues/56) | ✅ |
|  | `Pass.barcodes.format` | [#57](https://github.com/njausteve/ex_pass/issues/57) | ✅ |
|  | `Pass.barcodes.message` | [#58](https://github.com/njausteve/ex_pass/issues/58) | ✅ |
|  | `Pass.barcodes.messageEncoding` | [#59](https://github.com/njausteve/ex_pass/issues/59) | ✅ |
| `Pass.Beacons` | `Pass.beacons.major` | [#60](https://github.com/njausteve/ex_pass/issues/60) | ✅ |
|  | `Pass.beacons.minor` | [#61](https://github.com/njausteve/ex_pass/issues/61) | ✅ |
|  | `Pass.beacons.proximityUUID` | [#62](https://github.com/njausteve/ex_pass/issues/62) | ✅ |
|  | `Pass.beacons.relevantText` | [#63](https://github.com/njausteve/ex_pass/issues/63) | ✅ |
| `Pass.Locations` | `Pass.locations.altitude` | [#89](https://github.com/njausteve/ex_pass/issues/89) | ✅ |
|  | `Pass.locations.latitude` | [#90](https://github.com/njausteve/ex_pass/issues/90) | ✅ |
|  | `Pass.locations.longitude` | [#91](https://github.com/njausteve/ex_pass/issues/91) | ✅ |
|  | `Pass.locations.relevantText` | [#92](https://github.com/njausteve/ex_pass/issues/92) | ✅ |
| `Pass.NFC` | `Pass.nfc.encryptionPublicKey` | [#93](https://github.com/njausteve/ex_pass/issues/93) | `todo` |
|  | `Pass.nfc.message` | [#94](https://github.com/njausteve/ex_pass/issues/94) | `todo` |
|  | `Pass.nfc.requiresAuthentication` | [#95](https://github.com/njausteve/ex_pass/issues/95) | `todo` |
| `Pass.PassFields.AuxiliaryFields` | Inherits From `Pass.PassFieldContent` |  | `todo` |
|  | `Pass.PassFields.AuxiliaryFields.row` | [#64](https://github.com/njausteve/ex_pass/issues/64) | `todo` |
| `Pass.PassFields.SecondaryFields` | Inherits From `Pass.PassFieldContent` | [#69](https://github.com/njausteve/ex_pass/issues/69) | `todo` |
| `Pass.PassFields.PrimaryFields` | Inherits From `Pass.PassFieldContent` | [#68](https://github.com/njausteve/ex_pass/issues/68) | `todo` |
| `Pass.PassFields.HeaderFields` | Inherits From `Pass.PassFieldContent` | [#67](https://github.com/njausteve/ex_pass/issues/67) | `todo` |
| `Pass.PassFields.BackFields` | Inherits From `Pass.PassFieldContent` | [#66](https://github.com/njausteve/ex_pass/issues/66) | `todo` |
| `Pass.PassFields` | `Pass.PassFields.auxiliaryFields` | [#139](https://github.com/njausteve/ex_pass/issues/139) | `todo` |
|  | `Pass.PassFields.backFields` | [#140](https://github.com/njausteve/ex_pass/issues/140) | `todo` |
|  | `Pass.PassFields.headerFields` | [#141](https://github.com/njausteve/ex_pass/issues/141) | `todo` |
|  | `Pass.PassFields.primaryFields` | [#142](https://github.com/njausteve/ex_pass/issues/142) | `todo` |
|  | `Pass.PassFields.secondaryFields` | [#143](https://github.com/njausteve/ex_pass/issues/143) | `todo` |
| `Pass.BoardingPass` | Inherits From `Pass.PassFields` | [#75](https://github.com/njausteve/ex_pass/issues/75) | `todo` |
|  | `Pass.boardingPass.transitType` | [#144](https://github.com/njausteve/ex_pass/issues/144) | `todo` |
| `Pass.Coupon` | Inherits From `Pass.PassFields` | [#77](https://github.com/njausteve/ex_pass/issues/77) | `todo` |
|  | `Pass.coupon.couponCode` | [#78](https://github.com/njausteve/ex_pass/issues/78) | `todo` |
|  | `Pass.coupon.discountAmount` | [#79](https://github.com/njausteve/ex_pass/issues/79) | `todo` |
|  | `Pass.coupon.expirationDate` | [#80](https://github.com/njausteve/ex_pass/issues/80) | `todo` |
| `Pass.EventTicket` | Inherits From `Pass.PassFields` | [#81](https://github.com/njausteve/ex_pass/issues/81) | `todo` |
|  | `Pass.eventTicket.preferred_style_schemes` | [#84](https://github.com/njausteve/ex_pass/issues/84) | `todo` |
| `Pass.Generic` | Inherits From `Pass.PassFields` | [#88](https://github.com/njausteve/ex_pass/issues/88) | `todo` |
| `Pass.StoreCard` | Inherits From `Pass.PassFields` | [#96](https://github.com/njausteve/ex_pass/issues/96) | `todo` |
| `Pass.SemanticTags.CurrencyAmount` | `Pass.semanticTags.currencyAmount.amount` | [#115](https://github.com/njausteve/ex_pass/issues/115) | `todo` |
|  | `Pass.semanticTags.currencyAmount.currencyCode` | [#98](https://github.com/njausteve/ex_pass/issues/98) | `todo` |
| `Pass.SemanticTags.Location` | `Pass.semanticTags.location.latitude` | [#99](https://github.com/njausteve/ex_pass/issues/99) | `todo` |
|  | `Pass.semanticTags.location.longitude` | [#100](https://github.com/njausteve/ex_pass/issues/100) | `todo` |
| `Pass.SemanticTags.PersonNameComponents` | `Pass.semanticTags.personNameComponents.familyName` | [#101](https://github.com/njausteve/ex_pass/issues/101) | `todo` |
|  | `Pass.semanticTags.personNameComponents.givenName` | [#102](https://github.com/njausteve/ex_pass/issues/102) | `todo` |
|  | `Pass.semanticTags.personNameComponents.middleName` | [#103](https://github.com/njausteve/ex_pass/issues/103) | `todo` |
|  | `Pass.semanticTags.personNameComponents.namePrefix` | [#104](https://github.com/njausteve/ex_pass/issues/104) | `todo` |
|  | `Pass.semanticTags.personNameComponents.nameSuffix` | [#105](https://github.com/njausteve/ex_pass/issues/105) | `todo` |
|  | `Pass.semanticTags.personNameComponents.nickname` | [#106](https://github.com/njausteve/ex_pass/issues/106) | `todo` |
|  | `Pass.semanticTags.personNameComponents.phoneticRepresentation` | [#107](https://github.com/njausteve/ex_pass/issues/107) | `todo` |
| `Pass.SemanticTags.Seat` | `Pass.semanticTags.seat.seatDescription` | [#109](https://github.com/njausteve/ex_pass/issues/109) | `todo` |
|  | `Pass.semanticTags.seat.seatIdentifier` | [#110](https://github.com/njausteve/ex_pass/issues/110) | `todo` |
|  | `Pass.semanticTags.seat.seatNumber` | [#111](https://github.com/njausteve/ex_pass/issues/111) | `todo` |
|  | `Pass.semanticTags.seat.seatRow` | [#112](https://github.com/njausteve/ex_pass/issues/112) | `todo` |
|  | `Pass.semanticTags.seat.seatSection` | [#113](https://github.com/njausteve/ex_pass/issues/113) | `todo` |
|  | `Pass.semanticTags.seat.seatType` | [#114](https://github.com/njausteve/ex_pass/issues/114) | `todo` |
| `Pass.Locations` | `Pass.locations.altitude` |  | `todo` |
|  | `Pass.locations.latitude` |  | `todo` |
|  | `Pass.locations.longitude` | [#90](https://github.com/njausteve/ex_pass/issues/90) | `todo` |
|  | `Pass.locations.relevantText` | [#92](https://github.com/njausteve/ex_pass/issues/92) | `todo` |
| `Pass.NFC` | `Pass.nfc.encryptionPublicKey` | [#93](https://github.com/njausteve/ex_pass/issues/93) | `todo` |
|  | `Pass.nfc.message` | [#94](https://github.com/njausteve/ex_pass/issues/94) | `todo` |
|  | `Pass.nfc.requiresAuthentication` | [#95](https://github.com/njausteve/ex_pass/issues/95) | `todo` |
| `Pass.PassFields.AuxiliaryFields` | Inherits From `Pass.PassFieldContent` |  | `todo` |
|  | `Pass.PassFields.AuxiliaryFields.row` |  | `todo` |
| `Pass.PassFields.SecondaryFields` | Inherits From `Pass.PassFieldContent` | [#143](https://github.com/njausteve/ex_pass/issues/143) | `todo` |
|  | `Pass.PassFields.SecondaryFields.row` | [#143](https://github.com/njausteve/ex_pass/issues/143) | `todo` |
| `Pass.PassFields.HeaderFields` | Inherits From `Pass.PassFieldContent` | [#141](https://github.com/njausteve/ex_pass/issues/141) | `todo` |
| `Pass.PassFields.BackFields` | Inherits From `Pass.PassFieldContent` | [#140](https://github.com/njausteve/ex_pass/issues/140) | `todo` |
| `Pass.PassFields` | `Pass.PassFields.auxiliaryFields` | [#139](https://github.com/njausteve/ex_pass/issues/139) | `todo` |
|  | `Pass.PassFields.backFields` | [#140](https://github.com/njausteve/ex_pass/issues/140) | `todo` |
|  | `Pass.PassFields.headerFields` | [#141](https://github.com/njausteve/ex_pass/issues/141) | `todo` |
|  | `Pass.PassFields.primaryFields` | [#142](https://github.com/njausteve/ex_pass/issues/142) | `todo` |
|  | `Pass.PassFields.secondaryFields` | [#143](https://github.com/njausteve/ex_pass/issues/143) | `todo` |
| `Pass.BoardingPass` | Inherits From `Pass.PassFields` | [#144](https://github.com/njausteve/ex_pass/issues/144) | `todo` |
|  | `Pass.boardingPass.transitType` | [#144](https://github.com/njausteve/ex_pass/issues/144) | `todo` |
| `Pass.Coupon` | Inherits From `Pass.PassFields` |  | `todo` |
| `Pass.EventTicket` | Inherits From `Pass.PassFields` |  | `todo` |
| `Pass.Generic` | Inherits From `Pass.PassFields` |  | `todo` |
| `Pass.StoreCard` | Inherits From `Pass.PassFields` |  | `todo` |
| `Pass.SemanticTags.CurrencyAmount` | `Pass.semanticTags.currencyAmount.amount` |  | `todo` |
|  | `Pass.semanticTags.currencyAmount.currencyCode` | [#98](https://github.com/njausteve/ex_pass/issues/98) | `todo` |
| `Pass.SemanticTags.Location` | `Pass.semanticTags.location.latitude` | [#99](https://github.com/njausteve/ex_pass/issues/99) | `todo` |
|  | `Pass.semanticTags.location.longitude` | [#100](https://github.com/njausteve/ex_pass/issues/100) | `todo` |
| `Pass.SemanticTags.PersonNameComponents` | `Pass.semanticTags.personNameComponents.familyName` | [#101](https://github.com/njausteve/ex_pass/issues/101) | `todo` |
|  | `Pass.semanticTags.personNameComponents.givenName` | [#102](https://github.com/njausteve/ex_pass/issues/102) | `todo` |
|  | `Pass.semanticTags.personNameComponents.middleName` | [#103](https://github.com/njausteve/ex_pass/issues/103) | `todo` |
|  | `Pass.semanticTags.personNameComponents.namePrefix` | [#104](https://github.com/njausteve/ex_pass/issues/104) | `todo` |
|  | `Pass.semanticTags.personNameComponents.nameSuffix` | [#105](https://github.com/njausteve/ex_pass/issues/105) | `todo` |
|  | `Pass.semanticTags.personNameComponents.nickname` | [#106](https://github.com/njausteve/ex_pass/issues/106) | `todo` |
|  | `Pass.semanticTags.personNameComponents.phoneticRepresentation` | [#107](https://github.com/njausteve/ex_pass/issues/107) | `todo` |
| `Pass.SemanticTags.Seat` | `Pass.semanticTags.seat.seatDescription` | [#109](https://github.com/njausteve/ex_pass/issues/109) | `todo` |
|  | `Pass.semanticTags.seat.seatIdentifier` | [#110](https://github.com/njausteve/ex_pass/issues/110) | `todo` |
|  | `Pass.semanticTags.seat.seatNumber` | [#111](https://github.com/njausteve/ex_pass/issues/111) | `todo` |
|  | `Pass.semanticTags.seat.seatRow` | [#112](https://github.com/njausteve/ex_pass/issues/112) | `todo` |
|  | `Pass.semanticTags.seat.seatSection` | [#113](https://github.com/njausteve/ex_pass/issues/113) | `todo` |
|  | `Pass.semanticTags.seat.seatType` |  | `todo` |
| `Pass.SemanticTags.WifiNetwork` | `Pass.semanticTags.wifiNetwork.password` |  | `todo` |
|  | `Pass.semanticTags.wifiNetwork.ssid` |  | `todo` |
| `Pass.SemanticTags` | `Pass.semanticTags.airlineCode` | [#21](https://github.com/njausteve/ex_pass/issues/21) | `todo` |
|  | `Pass.semanticTags.artistIDs` | [#22](https://github.com/njausteve/ex_pass/issues/22) | `todo` |
|  | `Pass.semanticTags.awayTeamAbbreviation` | [#24](https://github.com/njausteve/ex_pass/issues/24) | `todo` |
|  | `Pass.semanticTags.awayTeamLocation` | [#25](https://github.com/njausteve/ex_pass/issues/25) | `todo` |
|  | `Pass.semanticTags.awayTeamName` | [#26](https://github.com/njausteve/ex_pass/issues/26) | `todo` |
|  | `Pass.semanticTags.balance` | [#27](https://github.com/njausteve/ex_pass/issues/27) | `todo` |
|  | `Pass.semanticTags.boardingGroup` | [#28](https://github.com/njausteve/ex_pass/issues/28) | `todo` |
|  | `Pass.semanticTags.boardingSequenceNumber` | [#29](https://github.com/njausteve/ex_pass/issues/29) | `todo` |
|  | `Pass.semanticTags.carNumber` | [#30](https://github.com/njausteve/ex_pass/issues/30) | `todo` |
|  | `Pass.semanticTags.confirmationNumber` | [#31](https://github.com/njausteve/ex_pass/issues/31) | `todo` |
|  | `Pass.semanticTags.currentArrivalDate` | [#32](https://github.com/njausteve/ex_pass/issues/32) | `todo` |
|  | `Pass.semanticTags.currentBoardingDate` | [#33](https://github.com/njausteve/ex_pass/issues/33) | `todo` |
|  | `Pass.semanticTags.currentDepartureDate` | [#34](https://github.com/njausteve/ex_pass/issues/34) | `todo` |
|  | `Pass.semanticTags.departureAirportCode` | [#36](https://github.com/njausteve/ex_pass/issues/36) | `todo` |
|  | `Pass.semanticTags.departureAirportName` | [#37](https://github.com/njausteve/ex_pass/issues/37) | `todo` |
|  | `Pass.semanticTags.departureGate` | [#38](https://github.com/njausteve/ex_pass/issues/38) | `todo` |
|  | `Pass.semanticTags.departureLocation` | [#39](https://github.com/njausteve/ex_pass/issues/39) | `todo` |
|  | `Pass.semanticTags.departureLocationDescription` | [#40](https://github.com/njausteve/ex_pass/issues/40) | `todo` |
|  | `Pass.semanticTags.departurePlatform` | [#41](https://github.com/njausteve/ex_pass/issues/41) | `todo` |
|  | `Pass.semanticTags.departureStationName` | [#42](https://github.com/njausteve/ex_pass/issues/42) | `todo` |
|  | `Pass.semanticTags.departureTerminal` | [#43](https://github.com/njausteve/ex_pass/issues/43) | `todo` |
|  | `Pass.semanticTags.destinationAirportCode` | [#44](https://github.com/njausteve/ex_pass/issues/44) | `todo` |
|  | `Pass.semanticTags.destinationAirportName` | [#45](https://github.com/njausteve/ex_pass/issues/45) | `todo` |
|  | `Pass.semanticTags.destinationGate` |  | `todo` |
|  | `Pass.semanticTags.destinationLocation` |  | `todo` |
|  | `Pass.semanticTags.destinationLocationDescription` |  | `todo` |
|  | `Pass.semanticTags.destinationPlatform` |  | `todo` |
|  | `Pass.semanticTags.destinationStationName` |  | `todo` |
|  | `Pass.semanticTags.destinationTerminal` |  | `todo` |
|  | `Pass.semanticTags.duration` |  | `todo` |
|  | `Pass.semanticTags.eventEndDate` |  | `todo` |
|  | `Pass.semanticTags.eventName` |  | `todo` |
|  | `Pass.semanticTags.eventStartDate` |  | `todo` |
|  | `Pass.semanticTags.eventType` |  | `todo` |
|  | `Pass.semanticTags.flightCode` |  | `todo` |
|  | `Pass.semanticTags.flightNumber` |  | `todo` |
|  | `Pass.semanticTags.genre` |  | `todo` |
|  | `Pass.semanticTags.homeTeamAbbreviation` |  | `todo` |
|  | `Pass.semanticTags.homeTeamLocation` |  | `todo` |
|  | `Pass.semanticTags.homeTeamName` |  | `todo` |
|  | `Pass.semanticTags.leagueAbbreviation` |  | `todo` |
|  | `Pass.semanticTags.leagueName` |  | `todo` |
|  | `Pass.semanticTags.membershipProgramName` |  | `todo` |
|  | `Pass.semanticTags.membershipProgramNumber` |  | `todo` |
|  | `Pass.semanticTags.originalArrivalDate` |  | `todo` |
|  | `Pass.semanticTags.originalBoardingDate` |  | `todo` |
|  | `Pass.semanticTags.originalDepartureDate` |  | `todo` |
|  | `Pass.semanticTags.passengerName` |  | `todo` |
|  | `Pass.semanticTags.performerNames` |  | `todo` |
|  | `Pass.semanticTags.priorityStatus` |  | `todo` |
|  | `Pass.semanticTags.seats` |  | `todo` |
|  | `Pass.semanticTags.securityScreening` |  | `todo` |
|  | `Pass.semanticTags.silenceRequested` |  | `todo` |
|  | `Pass.semanticTags.sportName` |  | `todo` |
|  | `Pass.semanticTags.totalPrice` |  | `todo` |
|  | `Pass.semanticTags.transitProvider` |  | `todo` |
|  | `Pass.semanticTags.transitStatus` | [#46](https://github.com/njausteve/ex_pass/issues/46) | `todo` |
|  | `Pass.semanticTags.transitStatusReason` | [#47](https://github.com/njausteve/ex_pass/issues/47) | `todo` |
|  | `Pass.semanticTags.vehicleName` | [#48](https://github.com/njausteve/ex_pass/issues/48) | `todo` |
|  | `Pass.semanticTags.vehicleNumber` | [#49](https://github.com/njausteve/ex_pass/issues/49) | `todo` |
|  | `Pass.semanticTags.vehicleType` | [#50](https://github.com/njausteve/ex_pass/issues/50) | `todo` |
|  | `Pass.semanticTags.venueEntrance` | [#51](https://github.com/njausteve/ex_pass/issues/51) | `todo` |
|  | `Pass.semanticTags.venueLocation` | [#52](https://github.com/njausteve/ex_pass/issues/52) | `todo` |
|  | `Pass.semanticTags.venueName` | [#53](https://github.com/njausteve/ex_pass/issues/53) | `todo` |
|  | `Pass.semanticTags.venuePhoneNumber` | [#54](https://github.com/njausteve/ex_pass/issues/54) | `todo` |
|  | `Pass.semanticTags.venueRoom` | [#55](https://github.com/njausteve/ex_pass/issues/55) | `todo` |
|  | `Pass.semanticTags.wifiAccess` | [#64](https://github.com/njausteve/ex_pass/issues/64) | `todo` |
|  | Handle pk pass signing |  | `todo` |
|  | Handle pkpass asset |  | `todo` |

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

   ```
   type(scope): subject
   ```

   Examples:

   ```
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

# Development

## Build

> $ flutter packages get<br/>
> $ flutter build apk<br/>
> $ flutter build ios<br/>


## Adding new text message

1. Add new text to lib/l10n/messages.dart
2. Extract new text to arb file.
> $ flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/messages.dart

## Localization

1. Add localized text to arb file.  (lib/l10n/intl_*.arb)
2. Convert arb file to dart.
> $ flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/messages.dart lib/l10n/intl_messages.arb lib/l10n/intl_ja.arb


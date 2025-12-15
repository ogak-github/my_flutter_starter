// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Session)
const sessionProvider = SessionProvider._();

final class SessionProvider
    extends $AsyncNotifierProvider<Session, SessionData> {
  const SessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionHash();

  @$internal
  @override
  Session create() => Session();
}

String _$sessionHash() => r'04946115a2f2389e26d77a5f132a0378a7e772ee';

abstract class _$Session extends $AsyncNotifier<SessionData> {
  FutureOr<SessionData> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<SessionData>, SessionData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SessionData>, SessionData>,
              AsyncValue<SessionData>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

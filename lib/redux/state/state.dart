import 'package:flutter/material.dart' show ThemeMode;
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:xmux/modules/rpc/clients/news.pb.dart';
import 'package:xmux/modules/rpc/clients/user.pb.dart';

import 'query.dart';

export 'query.dart';

part 'state.g.dart';
part 'user.dart';

/// Main state for app.
@immutable
@JsonSerializable()
class MainAppState {
  /// User state for all information of current user.
  @JsonKey(nullable: false)
  final User user;

  /// Query state stores all query information.
  @JsonKey(nullable: false)
  final QueryState queryState;

  /// Settings state include ePaymentPassword, etc.
  @JsonKey(nullable: false)
  final SettingState settingState;

  /// Global UI state include drawerIsOpen, etc.
  @JsonKey(ignore: true)
  final UIState uiState;

  MainAppState(this.user, this.queryState, this.settingState, {UIState uiState})
      : this.uiState = uiState ?? UIState();

  /// Init MainAppState as default.
  MainAppState.def()
      : this.user = User.def(),
        this.queryState = QueryState(),
        this.settingState = SettingState.def(),
        this.uiState = UIState();

  factory MainAppState.fromJson(Map<String, dynamic> json) =>
      _$MainAppStateFromJson(json);

  Map<String, dynamic> toJson() => _$MainAppStateToJson(this);
}

/// Settings state include ePaymentPassword, etc.
@JsonSerializable()
class SettingState {
  @JsonKey(defaultValue: ThemeMode.system)
  final ThemeMode themeMode;

  /// Enable gaussian blur background for dialogs.
  @JsonKey(defaultValue: true)
  final bool enableBlur;

  /// Enable functions under development.
  @JsonKey(defaultValue: false)
  final bool enableFunctionsUnderDev;

  SettingState(
    this.themeMode,
    this.enableBlur,
    this.enableFunctionsUnderDev,
  );

  SettingState.def()
      : themeMode = ThemeMode.system,
        enableBlur = true,
        enableFunctionsUnderDev = false;

  factory SettingState.fromJson(Map<String, dynamic> json) =>
      _$SettingStateFromJson(json);

  Map<String, dynamic> toJson() => _$SettingStateToJson(this);

  SettingState copyWith({
    ThemeMode themeMode,
    bool enableBlur,
    bool enableFunctionsUnderDev,
  }) =>
      SettingState(
        themeMode ?? this.themeMode,
        enableBlur ?? this.enableBlur,
        enableFunctionsUnderDev ?? this.enableFunctionsUnderDev,
      );
}

/// State for application UI.
/// This state will not be persisted.
class UIState {
  /// Drawer is open.
  final bool drawerIsOpen;

  /// Override [WidgetsApp.showPerformanceOverlayOverride].
  final bool showPerformanceOverlay;

  /// Override [MaterialApp.showSemanticsDebugger]
  final bool showSemanticsDebugger;

  /// Homepage sliders.
  final List<Slider> homeSliders;

  /// Announcements.
  final List<Announcement> announcements;

  UIState({
    bool drawerIsOpen,
    bool showPerformanceOverlay,
    bool showSemanticsDebugger,
    List<Slider> homeSliders,
    List<Announcement> announcements,
  })  : drawerIsOpen = drawerIsOpen ?? false,
        showPerformanceOverlay = showPerformanceOverlay ?? false,
        showSemanticsDebugger = showSemanticsDebugger ?? false,
        homeSliders = homeSliders ?? List.unmodifiable([]),
        announcements = announcements ?? List.unmodifiable([]);

  UIState copyWith({
    bool drawerIsOpen,
    bool showPerformanceOverlay,
    bool showSemanticsDebugger,
    List<Slider> homeSliders,
    List<Announcement> announcements,
  }) =>
      UIState(
        drawerIsOpen: drawerIsOpen ?? this.drawerIsOpen,
        showPerformanceOverlay:
            showPerformanceOverlay ?? this.showPerformanceOverlay,
        showSemanticsDebugger:
            showSemanticsDebugger ?? this.showSemanticsDebugger,
        homeSliders: homeSliders ?? this.homeSliders,
        announcements: announcements ?? this.announcements,
      );
}

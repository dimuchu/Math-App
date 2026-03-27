# AGENTS.md

This file provides guidance to Codex (Codex.ai/code) when working with code in this repository.

## Product

**MentalMath** — тренажёр устного счёта для взрослых (IT, финансы, консалтинг, подготовка к собеседованиям). Минималистичный, профессиональный инструмент без игровой мишуры. iPhone-first.

Ключевая ценность: адаптивная система, которая выявляет слабые зоны пользователя и целенаправленно их прокачивает. Это не генератор случайных примеров — это инструмент с измеримым прогрессом.

Язык интерфейса: **английский**.

## Documentation Map

| Файл | Назначение |
|------|------------|
| [`PRD.md`](PRD.md) | **Product Requirements Document.** Полное описание продукта: механики, фичи, приоритеты MVP/Post-MVP, архитектура, монетизация, открытые вопросы. Главный источник истины о том, ЧТО мы строим. |
| [`design.md`](design.md) | **UI/UX Design System.** Цвета, типографика, отступы, компоненты (MMNumpad, MMProblemView, MMSkillBar, MMStreakBadge, MMTimerView, MMResultCard), макеты экранов, анимации, хаптики. Главный источник истины о том, КАК это выглядит. |
| [`Docs/iOS Developer Guide.md`](Docs/iOS%20Developer%20Guide.md) | **Agent prompt.** Профиль iOS-разработчика, заточенный под этот проект. Описывает компетенции, поведение и подход к разработке MentalMath. |
| [`Docs/CLAUDE_CODE_SYSTEM_PROMPT.md`](Docs/CLAUDE_CODE_SYSTEM_PROMPT.md) | **Исходный системный промпт.** Использовался для генерации PRD. Исторический артефакт, не используется в разработке. |

### Как использовать документацию

- **Требования к фиче** → смотри `PRD.md` (разделы 2–12, таблица приоритетов)
- **Визуальная реализация** → смотри `design.md` (токены, компоненты, макеты)
- **Приоритеты** → смотри `PRD.md` раздел "Таблица приоритетов" (MVP vs Post-MVP)
- **Открытые вопросы** → смотри `PRD.md` раздел "Открытые вопросы" (часть уже решена)

## Tech Stack

- **Language:** Swift 6 (strict concurrency, typed throws)
- **UI Framework:** SwiftUI (iOS 18+)
- **Architecture:** MVVM
- **Persistence:** SwiftData (сессии, профиль, навыки) + UserDefaults (настройки)
- **IAP:** StoreKit 2 (Post-MVP)
- **External dependencies:** нет
- **Bundle ID:** math.Math-App
- **Deployment Targets:** iOS 26.4, macOS 26.3, visionOS 26.4
- **Primary platform:** iPhone (iPad — архитектурная готовность)

## Project Structure (Target)

```
Math App/
├── App/                    # Entry point (@main App, WindowGroup)
├── Models/                 # Domain models (Problem, Session, UserProfile, SkillLevel)
├── Domain/                 # Business logic
│   ├── ProblemGenerator/   # Protocol + adaptive task generation
│   ├── DiagnosticEngine/   # Initial skill assessment (10–15 problems)
│   ├── AdaptiveEngine/     # Skill rating updates, difficulty adjustment, decay
│   └── ScoreCalculator/    # Session results and statistics
├── ViewModels/             # MVVM presentation layer
├── Views/                  # SwiftUI views
│   ├── Onboarding/         # 2–3 page onboarding + diagnostic
│   ├── Training/           # Training screen (Practice & Time Attack)
│   ├── Statistics/         # Stats, skill levels, session history
│   ├── Settings/           # App settings (Form/List, native controls)
│   ├── Paywall/            # Pro unlock screen (Post-MVP)
│   └── Components/         # Reusable: MMNumpad, MMProblemView, MMFeedbackView,
│                           # MMSkillBar, MMStreakBadge, MMTimerView, MMResultCard
├── Services/
│   ├── Storage/            # StorageService protocol + SwiftData implementation
│   ├── IAP/                # StoreKit 2 (Post-MVP)
│   └── Notifications/      # Push notifications (Post-MVP)
└── Resources/              # Assets, String Catalogs
```

## Build Commands

```bash
# Open in Xcode
open "Math App.xcodeproj"

# Build from command line
xcodebuild -project "Math App.xcodeproj" -scheme "Math App" -configuration Debug build

# Build for release
xcodebuild -project "Math App.xcodeproj" -scheme "Math App" -configuration Release build
```

## Build Settings of Note

- Default actor isolation: MainActor
- Approachable Concurrency: enabled (Swift async/await ready)
- App Sandbox: enabled (macOS), User File Access: read-only
- String Catalogs: enabled for localization
- File-system-synchronized groups (no manual pbxproj edits needed)

## Key Domain Concepts

- **Skill Rating:** для каждой связки «операция + диапазон чисел» хранится рейтинг, обновляемый после каждого ответа. Ошибки весят больше, чем медленные правильные ответы. Есть decay при неактивности.
- **Adaptive Generation:** ~70% задач из слабых зон, ~30% из сильных. При достижении плато — автоматическое усложнение.
- **Diagnostic:** 10–15 задач от простых к сложным, покрывают все 4 операции и диапазоны. Формируют начальный профиль навыков.
- **Streak:** считается по календарным дням, минимум 3 задачи в любой сессии для засчитывания.
- **Division:** только задачи с целым ответом (без остатка).
- **Subtraction:** отрицательные ответы разрешены (например, 21 − 37).

## Development Guidelines

- No test targets configured yet — tests for domain layer (generators, adaptive engine, scoring) are a priority
- No linting or formatting tools configured
- Reference `design.md` for all visual decisions (colors, spacing, typography, component specs)
- Reference `PRD.md` for all feature decisions and priorities
- MVP features first, Post-MVP features later (see priority table in PRD.md)

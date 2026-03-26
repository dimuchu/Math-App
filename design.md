# MentalMath — UI/UX Design System

Авторитетный источник визуальных спецификаций для реализации. Все решения по UI должны опираться на этот документ.

**Визуальный ориентир:** Linear, Arc browser, Things 3 — premium minimal aesthetic.

---

## 1. Философия дизайна

- **Минимализм:** каждый элемент на экране должен оправдывать своё присутствие. Нет декоративных элементов без функции.
- **Фокус на контенте:** пример — главный герой экрана тренировки. Всё остальное — вторично.
- **Флоу-состояние:** UI не должен прерывать процесс решения. Никаких модалок, поп-апов, подтверждений во время тренировки.
- **Одноручность:** все интерактивные элементы доступны большому пальцу. Критично для тренировочного экрана.
- **Взрослый тон:** без мультяшности, радуг, конфетти. Чистый, профессиональный инструмент.
- **Прогресс без шума:** прогресс виден, но не кричит. Сдержанные индикаторы, не геймифицированные шкалы.

---

## 2. Цветовая система

Все цвета задаются как Design Tokens. Формат: `light` / `dark`.

### Background

| Token | Light | Dark | Назначение |
|-------|-------|------|------------|
| `bg.primary` | `#FFFFFF` | `#000000` | Основной фон экрана |
| `bg.secondary` | `#F5F5F7` | `#1C1C1E` | Карточки, секции, grouped background |
| `bg.tertiary` | `#E8E8ED` | `#2C2C2E` | Вложенные элементы, выделенные зоны |

### Text

| Token | Light | Dark | Назначение |
|-------|-------|------|------------|
| `text.primary` | `#000000` | `#FFFFFF` | Основной текст, заголовки |
| `text.secondary` | `#6E6E73` | `#98989D` | Подписи, второстепенный текст |
| `text.tertiary` | `#AEAEB2` | `#636366` | Плейсхолдеры, неактивные элементы |

### Semantic

| Token | Value | Назначение |
|-------|-------|------------|
| `semantic.success` | `#34C759` | Правильный ответ, позитивные метрики |
| `semantic.error` | `#FF3B30` | Ошибка, негативные метрики |
| `semantic.accent` | `#007AFF` | Кнопки действий, активные элементы, ссылки |
| `semantic.streak` | `#FF9500` | Стрики, flame icon, streak badge |

### Numpad

| Token | Light | Dark | Назначение |
|-------|-------|------|------------|
| `numpad.bg` | `#F5F5F7` | `#1C1C1E` | Фон кнопки цифры |
| `numpad.pressed` | `#E8E8ED` | `#2C2C2E` | Нажатое состояние |
| `numpad.delete` | `#FF3B30` | `#FF453A` | Кнопка удаления |
| `numpad.submit` | `#007AFF` | `#0A84FF` | Кнопка подтверждения ответа |

---

## 3. Типографика

Шрифт: **SF Pro** (системный). Варианты: SF Pro Rounded для чисел и заголовков, SF Pro Mono для таймера.

### Специальные стили

| Token | Font | Size | Weight | Назначение |
|-------|------|------|--------|------------|
| `display` | SF Pro Rounded | 56pt | Bold | Число-пример на экране тренировки |
| `numpad` | SF Pro Rounded | 28pt | Medium | Цифры на кнопках нампада |
| `timer` | SF Pro Mono | 32pt | Medium | Таймер (monospaced, без jitter при смене цифр) |
| `statLarge` | SF Pro Rounded | 44pt | Bold | Hero-число на экране результатов |
| `operator` | SF Pro Rounded | 40pt | Regular | Знак операции (+, −, ×, ÷) |

### Стандартная шкала

| Token | Size | Weight | Назначение |
|-------|------|--------|------------|
| `title1` | 28pt | Bold | Заголовки экранов |
| `title2` | 22pt | Semibold | Подзаголовки, заголовки секций |
| `body` | 17pt | Regular | Основной текст |
| `callout` | 16pt | Regular | Описания, пояснения |
| `caption` | 12pt | Regular | Метки, мелкий текст |

---

## 4. Сетка и отступы

**Base grid:** 4pt. Все размеры кратны 4.

### Spacing tokens

| Token | Value | Применение |
|-------|-------|------------|
| `space.xs` | 4pt | Минимальный зазор, иконка-текст |
| `space.sm` | 8pt | Зазор между элементами в группе |
| `space.md` | 12pt | Внутренний padding компонентов |
| `space.lg` | 16pt | Горизонтальный padding экрана, отступ между секциями |
| `space.xl` | 24pt | Разделение крупных блоков |
| `space.xxl` | 32pt | Отступ между экранными зонами |
| `space.xxxl` | 48pt | Крупные разрывы, top safe area offset |

### Геометрия

| Параметр | Значение |
|----------|----------|
| Горизонтальный padding экрана | 16pt |
| Corner radius карточек | 12pt |
| Corner radius кнопок нампада | 12pt |
| Corner radius кнопок действий | 10pt |
| Размер кнопки нампада (min) | 64×48pt |
| Размер кнопки нампада (рекомендуемый) | 72×52pt |
| Gap между кнопками нампада | 8pt |

### Правило одноручности

На экране тренировки все интерактивные элементы располагаются **ниже 50% высоты экрана**. Верхняя половина — только информация (прогресс, таймер, пример).

---

## 5. Компоненты

### MMNumpad

Кастомная цифровая клавиатура, оптимизированная под одноручный ввод.

```
┌─────────────────────────────────┐
│  [1]  [2]  [3]  │  [⌫ delete]  │
│  [4]  [5]  [6]  │  [−  minus]  │
│  [7]  [8]  [9]  │  [✓ submit]  │
│       [0]       │              │
└─────────────────────────────────┘
```

- **Layout:** 3 колонки цифр + 1 колонка действий
- Цифры 0–9: фон `numpad.bg`, текст `text.primary`, шрифт `numpad` (28pt)
- Delete (⌫): фон `numpad.delete`, иконка `delete.left` SF Symbol
- Minus (−): фон `numpad.bg`, переключает знак ответа
- Submit (✓): фон `numpad.submit`, текст белый, отправляет ответ
- Gap между кнопками: 8pt
- Кнопка `0` занимает ширину 2 колонок
- Press state: scale 0.95 за 0.1s + цвет `numpad.pressed`

### MMProblemView

Отображение текущего примера.

- Формат: `A op B` — три элемента в ряд по центру
- Операнды: шрифт `display` (56pt)
- Оператор: шрифт `operator` (40pt), цвет `text.secondary`
- Выравнивание: по центру экрана (горизонталь и вертикаль верхней зоны)
- Переход к следующему: slide+fade, 0.25s, easeInOut
- Ответ пользователя отображается под примером, шрифт `statLarge` (44pt), цвет `text.primary`

### MMFeedbackView

Мгновенная обратная связь после ответа. Без модалок.

- **Правильный ответ:** кратковременная зелёная подсветка фона (`semantic.success` с opacity 0.15), длительность 0.3s
- **Ошибка:** красная подсветка фона (`semantic.error` с opacity 0.15), показ правильного ответа рядом, длительность 1.0s
- Overlay покрывает зону примера, не весь экран

### MMSkillBar

Горизонтальная полоска прогресса по навыку.

- Высота: 6pt
- Corner radius: 3pt (полностью скруглена)
- Фон: `bg.tertiary`
- Заполнение: gradient от `semantic.accent` к `semantic.success`
- Диапазон значений: 0.0–1.0
- Подпись слева: название навыка (caption), подпись справа: процент (caption)

### MMStreakBadge

Бейдж текущего стрика на главном экране.

- Иконка: `flame.fill` SF Symbol, цвет `semantic.streak`
- Число: шрифт `title2`, цвет `text.primary`
- Подпись: "day streak" / "days streak", шрифт `caption`, цвет `text.secondary`
- Layout: горизонтальный стек (иконка + число + подпись)
- Анимация flame: pulse 2.0s loop (scale 1.0 → 1.1 → 1.0)

### MMTimerView

Таймер обратного отсчёта для Time Attack.

- Шрифт: `timer` (32pt SF Pro Mono Medium) — monospaced, без дёргания при смене цифр
- Формат: `M:SS` (например, `1:30`)
- Цвет: `text.primary` по умолчанию
- При оставшемся времени < 10s: цвет плавно переходит в `semantic.error`
- Позиция: верхняя зона экрана тренировки

### MMResultCard

Экран результатов после завершения сессии.

- **Hero stat:** крупное число по центру, шрифт `statLarge` (44pt). Для Practice — % правильных, для Time Attack — количество решённых
- **Stats grid:** 2×2 сетка метрик (решено, ошибки, среднее время, streak/рекорд), каждая метрика — число (`title1`) + подпись (`caption`)
- **Action buttons:** "Try Again" (accent, primary) + "Home" (secondary), расположены внизу
- Corner radius карточки: 12pt
- Padding: 16pt

### MMOnboardingPage

Полноэкранная страница онбординга.

- Layout: вертикальный стек по центру
- SF Symbol иконка: 64pt, цвет `semantic.accent`
- Заголовок: шрифт `title1`
- Описание: шрифт `body`, цвет `text.secondary`, multiline по центру
- Навигация: точки-индикаторы внизу (PageTabViewStyle)
- "Skip" кнопка: правый верхний угол, шрифт `callout`, цвет `text.secondary`

### Settings

Стандартный нативный стиль настроек.

- Используется `Form` / `List` со стилем `.grouped` (InsetGroupedListStyle)
- Секции с заголовками
- Стандартные SwiftUI контролы: Toggle, Picker, Stepper
- Без кастомных компонентов — максимально нативный вид

---

## 6. Макеты экранов

### Home (Главный экран)

```
┌──────────────────────────────┐
│  [Tab: Home]  [Stats]  [⚙]  │  ← TabView bottom bar
├──────────────────────────────┤
│                              │
│     🔥 7 days streak         │  ← MMStreakBadge, центр
│                              │
│  ┌────────────────────────┐  │
│  │  Practice              │  │  ← Карточка режима
│  │  Train at your pace    │  │
│  │  [Start →]             │  │
│  └────────────────────────┘  │
│                              │
│  ┌────────────────────────┐  │
│  │  Time Attack           │  │  ← Карточка режима
│  │  Race against time     │  │
│  │  [Start →]             │  │
│  └────────────────────────┘  │
│                              │
│  Your Skills                 │  ← Заголовок секции
│  Addition      ████░░  72%  │  ← MMSkillBar
│  Subtraction   ███░░░  58%  │
│  Multiplication██░░░░  35%  │
│  Division      █░░░░░  20%  │
│                              │
└──────────────────────────────┘
```

- **Navigation:** TabView с тремя табами — Home, Statistics, Settings
- **Streak badge:** центрирован вверху контента
- **Режимы:** 2 карточки с corner radius 12pt, фон `bg.secondary`
- **Skill bars:** секция с заголовком, каждый навык — MMSkillBar

### Training (Экран тренировки)

```
┌──────────────────────────────┐
│  ✕                   3/10    │  ← Close + прогресс (или таймер)
│                              │
│                              │
│         24 × 7               │  ← MMProblemView
│                              │
│          168                 │  ← Введённый ответ
│                              │
├──────────────────────────────┤
│                              │
│   [1]  [2]  [3]  │  [⌫]     │
│   [4]  [5]  [6]  │  [−]     │  ← MMNumpad
│   [7]  [8]  [9]  │  [✓]     │
│        [0]       │          │
│                              │
└──────────────────────────────┘
```

- **Без навбара.** Immersive, полноэкранный. Кнопка закрытия (✕) — левый верхний угол.
- **Top zone:** прогресс (Practice: `3/10`) или таймер (Time Attack: MMTimerView)
- **Center zone:** MMProblemView + введённый ответ
- **Bottom zone:** MMNumpad — занимает нижнюю часть, доступен большому пальцу
- **Feedback:** MMFeedbackView overlay поверх center zone

### Diagnostic (Диагностика)

Аналогичен Training с отличиями:
- Вместо прогресса `3/10` — progress bar (горизонтальная полоска, заполняется по мере прохождения)
- Перед стартом — экран с текстом: "Let's find your level. Solve a few problems and we'll assess your skills."
- После завершения — экран результатов диагностики (не MMResultCard, а специальный экран с breakdown по навыкам)

### Results (Результаты сессии)

```
┌──────────────────────────────┐
│                              │
│           85%                │  ← Hero stat (statLarge)
│       Accuracy               │
│                              │
│  ┌──────────┬──────────┐     │
│  │  10      │  2       │     │  ← Stats grid
│  │  Solved  │  Errors  │     │
│  ├──────────┼──────────┤     │
│  │  3.2s    │  5 🔥    │     │
│  │  Avg time│  Streak  │     │
│  └──────────┴──────────┘     │
│                              │
│  🏆 New Record!              │  ← Опционально
│                              │
│  [    Try Again    ]         │  ← Primary button (accent)
│  [      Home       ]         │  ← Secondary button
│                              │
└──────────────────────────────┘
```

### Statistics (Статистика)

```
┌──────────────────────────────┐
│  Statistics                  │
├──────────────────────────────┤
│                              │
│  1,247     92%      7 🔥     │  ← 3 ключевые метрики
│  Solved    Accuracy Streak   │
│                              │
│  Skill Levels                │
│  Addition      ████░░  72%  │  ← MMSkillBar (подробнее)
│  Subtraction   ███░░░  58%  │
│  ...                         │
│                              │
│  Recent Sessions             │  ← История сессий (List)
│  ┌────────────────────────┐  │
│  │ Today · Practice · 85% │  │
│  │ Yesterday · Time · 12  │  │
│  │ Mar 24 · Practice · 90%│  │
│  └────────────────────────┘  │
│                              │
└──────────────────────────────┘
```

- **3 hero метрики:** горизонтальный ряд, каждая — число (`title1`) + подпись (`caption`)
- **Skill Levels:** секция с MMSkillBar для каждого навыка (операция + диапазон)
- **История сессий:** List, каждая строка — дата, режим, ключевая метрика

### Settings (Настройки)

```
┌──────────────────────────────┐
│  Settings                    │
├──────────────────────────────┤
│                              │
│  TRAINING                    │
│  Operations     + − × ÷      │  ← Multi-select
│  Difficulty     Medium       │  ← Picker
│                              │
│  APPEARANCE                  │
│  Theme          System    >  │  ← Picker (Light/Dark/System)
│                              │
│  FEEDBACK                    │
│  Sound          [toggle]     │
│  Haptics        [toggle]     │
│                              │
│  ABOUT                       │
│  Version        1.0.0        │
│  Rate App                 >  │
│                              │
└──────────────────────────────┘
```

- Стиль: `Form` с `InsetGroupedListStyle`
- Секции: Training, Appearance, Feedback, About
- Нативные контролы SwiftUI

### Onboarding

```
┌──────────────────────────────┐
│                      Skip    │
│                              │
│                              │
│          🧮                   │  ← SF Symbol, 64pt
│                              │
│    Train Your Mental         │
│         Math                 │  ← title1
│                              │
│   Quick, focused practice    │
│   to sharpen your mental     │  ← body, text.secondary
│   arithmetic skills          │
│                              │
│                              │
│         ● ○ ○                │  ← Page indicators
│                              │
│    [    Continue    ]        │  ← Primary button
│                              │
└──────────────────────────────┘
```

- **Формат:** PageTabViewStyle, 2–3 страницы
- **Страница 1:** Ценность приложения (что и зачем)
- **Страница 2:** "Let's find your level" → переход к диагностике
- **Skip:** правый верхний угол, всегда доступен

---

## 7. Анимации

| Анимация | Параметры | Trigger |
|----------|-----------|---------|
| Переход между задачами | slide + fade, 0.25s, easeInOut | Следующий пример |
| Правильный ответ | flash зелёный overlay, 0.3s | Correct answer |
| Ошибка | flash красный overlay + показ ответа, 1.0s | Wrong answer |
| Score bounce | spring(response: 0.2), scale 1.0→1.2→1.0 | Обновление счёта |
| Numpad press | scale 0.95, 0.1s, easeOut | Нажатие кнопки |
| Streak flame | pulse scale 1.0→1.1→1.0, 2.0s, linear, repeat forever | Всегда (на home) |
| New record | spring(response: 0.3) + confetti-like particles (сдержанно) | Побитие рекорда |
| Skill bar fill | ease-in 0.5s | Появление на экране |
| Screen transitions | default SwiftUI navigation transitions | Переход между экранами |
| Timer countdown | нет анимации (только цвет при <10s, transition 1.0s) | Каждую секунду |

**Принципы анимаций:**
- Все анимации используют SwiftUI `.animation()` или `withAnimation {}`
- Предпочтение spring анимациям для интерактивных элементов
- Длительность < 0.5s для действий пользователя (не блокировать ввод)
- Анимация ошибки (1.0s) — единственная, которая задерживает переход

---

## 8. Хаптики

Реализация через `UIImpactFeedbackGenerator`, `UINotificationFeedbackGenerator`.

| Событие | Тип хаптика | UIKit API |
|---------|-------------|-----------|
| Нажатие кнопки нампада | Light impact | `UIImpactFeedbackGenerator(style: .light)` |
| Правильный ответ | Success notification | `UINotificationFeedbackGenerator().success` |
| Неправильный ответ | Error notification | `UINotificationFeedbackGenerator().error` |
| Новый рекорд | Heavy impact + Success | `UIImpactFeedbackGenerator(style: .heavy)` → `UINotificationFeedbackGenerator().success` |
| Таймер < 10s (каждую секунду) | Soft impact | `UIImpactFeedbackGenerator(style: .soft)` |
| Delete (⌫) | Rigid impact | `UIImpactFeedbackGenerator(style: .rigid)` |

**Принципы:**
- Хаптики управляются через `HapticService` (централизованно)
- Пользователь может отключить хаптики в настройках
- На macOS и visionOS хаптики отключены (проверка через `#if os(iOS)`)

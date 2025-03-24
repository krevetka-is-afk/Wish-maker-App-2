# WishMaker App

WishMaker - это iOS приложение, которое позволяет создавать и управлять вашими желаниями, планировать их выполнение и отслеживать прогресс. Приложение предлагает интуитивно понятный интерфейс с возможностью настройки цветовой темы и интеграцией с календарем iOS.

## Основные функции

### 1. Создание желаний
- Нажмите кнопку "Add Wish" для создания нового желания
- Введите название и описание желания
- Установите дату начала и окончания
- Максимальное количество желаний: 10

### 2. Управление желаниями
- Просмотр списка всех желаний
- Редактирование существующих желаний (нажмите на желание для редактирования)
- Удаление желаний (свайп влево и нажмите "Delete")
- Добавление желаний в календарь iOS (свайп влево и нажмите "Add to Calendar")

### 3. Планирование
- Переход к календарю через кнопку "Schedule Wish"
- Просмотр всех запланированных желаний
- Добавление новых событий в календарь
- Выбор желания из сохраненного списка при создании события

### 4. Настройка внешнего вида
- Настройка цвета фона с помощью RGB-слайдеров
- Автоматическая адаптация цветов текста и кнопок под выбранный фон
- Скрытие/показ слайдеров для экономии места

## Как использовать приложение

### Создание желания
1. Нажмите кнопку "Add Wish"
2. Введите название желания
3. Добавьте описание (необязательно)
4. Установите дату начала и окончания
5. Нажмите "Save"

### Редактирование желания
1. Нажмите на желание в списке
2. Измените нужные поля
3. Нажмите "Save" для сохранения изменений
4. Для скрытия клавиатуры:
   - Нажмите "Done" на клавиатуре
   - Нажмите на пустое место на экране
   - Нажмите кнопку Return/Enter

### Добавление в календарь
1. Проведите пальцем влево по желанию
2. Нажмите "Add to Calendar"
3. При первом использовании предоставьте доступ к календарю
4. Желание будет добавлено в ваш календарь iOS

### Настройка цвета
1. Нажмите кнопку "Hide/Show Sliders" для отображения слайдеров
2. Используйте слайдеры для настройки RGB-компонентов
3. Цвет автоматически применяется ко всем экранам приложения

## Особенности
- Автоматическое сохранение всех желаний
- Интеграция с календарем iOS
- Адаптивный дизайн
- Поддержка темной/светлой темы
- Удобная навигация между экранами

## Требования
- iOS 13.0 или выше
- Доступ к календарю (опционально)

## Установка
1. Клонируйте репозиторий
2. Откройте проект в Xcode
3. Выберите целевое устройство
4. Нажмите "Run"

## Разработка
Приложение разработано с использованием:
- Swift
- UIKit
- EventKit
- UserDefaults для хранения данных
- Архитектура MVVM

---  

## Answers for questions :  
### Question: What issues prevent us from using storyboards in real projects?
Основные проблемы при использовании сторибордов в реальных проектах:
1. **Конфликты при слиянии**: Storyboard — это XML, и его сложнее мержить в командной работе. В процессе столкнулся с некоорректным мерджем.. 2 часа убил на откаты.
2. **Проблемы с производительностью**: Сториборды загружаются сразу, это замедлит запуск приложения, особенно если сториборд большой.
3. **Масштабируемость**: Сториборды неудобны для поддержки больших проектов, поскольку вся логика смешивается в одном проекте.
4. **Отсутствие гибкости и кода**: Ограниченные возможности кастомизации и анимации.

---

### Question: What does the code on lines 25 and 29 do?
```swift
25. title.translatesAutoresizingMaskIntoConstraints = false
29. view.addSubview(title)
```
- **Line 25**: `title.translatesAutoresizingMaskIntoConstraints = false` указывает, что автоматически генерируемые ограничения для `title` не должны использоваться. Как я понял это нужно для установки кастомных значений верстки.
- **Line 29**: `view.addSubview(title)` добавляет элемент `title` (UILabel) в иерархию представлений, делает его видимым на экране.

---

### Question: What is a safe area layout guide?
Safe Area Layout Guide — это область экрана, которая должна быть всегда свободной от элементов интерфейса. safe area layout guide гарантирует, что контент не будет перекрыт системными элементами.

---

### Question: What is `[weak self]` and why is it important?
`[weak self]` используется в замыканиях closures для предотвращения сильной ссылки на `self`, чтобы избежать цикла удержания (retain cycle). Без него замыкание и `self` будут удерживать друг друга, что наверняка вызывет утечку памяти. По сути `[weak self]` гарантирует, что `self` освободится, когда больше не будет использоваться.

---

### Question: What does `clipsToBounds` mean?
Свойство `clipsToBounds` определяет, будут ли дочерние представления, выходящие за границы родительского представления, обрезаны. Если `clipsToBounds` установлено в `true`, части дочерних представлений, выходящие за границы, не будут отображаться.

---

### Question: What is the `valueChanged` type? What is `Void` and what is `Double`?
- **`valueChanged`** — это свойство, которое, имеет тип замыкания `((Double) -> Void)?`, представляющее собой функцию обратного вызова.

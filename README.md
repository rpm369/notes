# 📚 Lessons Learned While Building This Project

This project was much more than a note-taking application. It served as a practical exercise in applying layered architecture, repository patterns, service orchestration, MVVM, state management, and software design principles.

The following are some key lessons and architectural guidelines I learned throughout the development process.

---

# Repository Layer Guidelines

The Repository layer should focus exclusively on data access and persistence concerns.

### Keep Repositories Lean

Avoid creating repository methods for every conceivable operation. A repository should only expose methods that directly interact with the data source or require specialized database queries.

### Prefer Empty Collections Over Null

When returning collections, return an empty list rather than `null`.

```dart
List<Note> notes = [];
```

An empty collection already represents the absence of data while maintaining a valid state.

Use `null` only when there is no alternative way to represent a missing value.

Example:

```dart
Future<Note?> getNoteById(int id);
```

A note either exists or it does not, making `null` a meaningful state in this scenario.

### Pass Only Required Data

Repository and service methods should receive the minimum amount of information necessary to perform their operation.

Prefer:

```dart
deleteNote(int noteId);
```

Over:

```dart
deleteNote(NoteModel note);
```

Reducing unnecessary coupling keeps APIs cleaner and easier to maintain.

### Prefer Exceptions Over Boolean Success Flags

Avoid returning `bool` values to indicate operation success.

Prefer:

```dart
Future<void> saveNote();
```

and throw exceptions when failures occur.

Exception-based flows are generally more expressive and provide richer debugging information than simple success/failure flags.

---

# Service Layer Guidelines

The Service layer acts as the application's business logic and orchestration layer.

### Services Are Application APIs

Services expose meaningful operations to the presentation layer while coordinating repositories and external integrations.

Examples:

* Data persistence
* Notifications
* Device sensors
* Third-party packages
* Background services

### Services Should Communicate Through Services

If one service requires functionality from another domain, it should interact with the other service rather than directly accessing its repository.

Good:

```text
NoteService → NotificationService
```

Avoid:

```text
NoteService → NotificationRepository
```

This prevents business logic from becoming scattered across the application and keeps responsibilities properly isolated.

### Not Every Service Needs a Repository

For every repository there is typically a corresponding service.

However, not every service requires a repository.

Examples include:

* Notification services
* Validation utilities
* Device integration helpers
* Sensor managers

If a feature performs simple operations without managing business rules or data persistence, it can often remain a utility instead of becoming a full service.

---

# ViewModel Guidelines

The ViewModel layer marks the beginning of the presentation layer.

Its responsibility is to:

* Manage UI state
* Aggregate data from services
* Transform data into UI-friendly structures
* Handle user actions
* Communicate errors to the interface

### Design ViewModels Around Screens

ViewModels should be driven by user interfaces rather than services.

A practical process:

### Step 1: Identify Screens

Create ViewModels based on logical screens or user flows.

Examples:

```text
HomeViewModel
EditorViewModel
TrashViewModel
```

### Step 2: Identify State

Determine all state required by the screen.

Examples:

```dart
bool isLoading;
String? errorMessage;
Set<int> expandedTiles;
```

This includes both business data and UI-specific state.

### Step 3: Implement User Actions

Add methods that represent actions users can perform.

Examples:

```dart
createNote()
deleteNote()
restoreNote()
moveToTrash()
```

The ViewModel should coordinate services and update UI state accordingly.

### Bundle Models Inside the ViewModel

UI widgets should pass primitive values whenever possible.

Instead of constructing complex models in the UI, let the ViewModel assemble domain objects before forwarding them to services.

This keeps the presentation layer lightweight and reduces duplication.

### Centralize Error Handling

UI components should not contain business-level exception handling.

Exceptions should be captured and managed inside the ViewModel.

Common approaches include:

#### Option 1: State-Based Errors

```dart
String? errorMessage;
```

The UI reacts to state changes and displays feedback.

#### Option 2: Result-Based Responses

```dart
Future<String?> saveNote();
```

The ViewModel returns a message that the UI can display.

Both approaches keep error handling responsibilities within the presentation layer rather than scattering them throughout widgets.

---

# Architectural Takeaways

Throughout this project, several principles consistently proved valuable:

* Keep layers focused on their responsibilities.
* Pass only the data required to perform an operation.
* Prefer exceptions over boolean success flags.
* Return empty collections instead of nullable collections.
* Design ViewModels around screens, not services.
* Keep UI logic out of widgets whenever possible.
* Let Services orchestrate business workflows.
* Let Repositories focus purely on data access.
* Favor maintainability and clarity over premature abstraction.

Building this application reinforced that good architecture is not about adding more layers—it is about giving each layer a clear responsibility and keeping those responsibilities separated.

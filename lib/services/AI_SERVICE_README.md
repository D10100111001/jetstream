# AI Service Architecture

## 🎯 Design Pattern: Function-Owned Models

Each function creates its own `GenerativeModel` with specific configuration.

---

## 📋 Available Methods

### **Structured Output (JSON Mode)**

#### `processFlightLog(String log) → AIFlightExtraction`
- **Purpose**: Extract structured flight data from natural language
- **Model**: `gemini-1.5-flash` with JSON mode
- **Schema**: `AIFlightExtraction` (generated)
- **Returns**: Type-safe flight extraction object

```dart
final extraction = await aiService.processFlightLog(
  "Flew Delta from JFK to LAX. Great crew!"
);
print(extraction.airline);  // "Delta" (String)
print(extraction.rating);   // 4 (int)
```

---

### **Text Output (Plain Text)**

#### `generateInsights(List<Map> flights) → String`
- **Purpose**: Generate personalized travel insights
- **Model**: `gemini-1.5-flash` with temperature 0.7
- **Returns**: Natural language insights text

```dart
final insights = await aiService.generateInsights(flightHistory);
// "You've flown primarily on Delta and United..."
```

#### `generateFlightNarrative(Map flightData) → String`
- **Purpose**: Create engaging flight narrative
- **Model**: `gemini-1.5-flash` with temperature 0.8, max 150 tokens
- **Returns**: Brief 2-3 sentence narrative

```dart
final narrative = await aiService.generateFlightNarrative(flightData);
// "Sarah had a wonderful experience on Delta..."
```

---

## 🔧 Factory Methods

### `_createStructuredModel({required Schema schema, String model})`
Creates a model for JSON structured output with schema validation.

### `_createTextModel({String model, double? temperature, int? maxOutputTokens})`
Creates a model for plain text output with optional creativity and length controls.

---

## 🎨 Quick Reference

| Method | Output Type | Model | Temperature | Schema |
|--------|-------------|-------|-------------|---------|
| `processFlightLog` | `AIFlightExtraction` | flash | default | AIFlightExtraction |
| `generateInsights` | `String` | flash | 0.7 | none |
| `generateFlightNarrative` | `String` | flash | 0.8 | none |

---

## 💡 Adding New Functions

**Structured Output:**
```dart
Future<YourModel> extractData(String input) async {
  final model = _createStructuredModel(
    schema: YourSchema.generate(),
  );
  // ... use model
}
```

**Text Output:**
```dart
Future<String> generateText(String input) async {
  final model = _createTextModel(
    temperature: 0.7,
  );
  // ... use model
}
```

---

## 📚 Full Documentation

See `/AI_SERVICE_PATTERNS.md` for comprehensive guide.


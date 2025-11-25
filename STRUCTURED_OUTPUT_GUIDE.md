# 🏗️ Structured Output Guide

## Overview

This project uses **type-safe structured output** with JSON schema validation for AI responses - similar to Zod in TypeScript. This ensures reliable, validated, and type-safe data from AI.

## 🎯 Architecture

### **Before (No Structure)**
```dart
// ❌ Untyped, error-prone
final response = await ai.processFlightLog(input);
final airline = response['airline'];  // Could be anything!
```

### **After (Structured Output)**
```dart
// ✅ Type-safe, validated
final extraction = await ai.processFlightLog(input);
final airline = extraction.airline;  // Guaranteed String!
```

---

## 📦 Tech Stack

| Package | Purpose | Like Zod? |
|---------|---------|-----------|
| `freezed` | Immutable data classes with unions | Similar to type unions |
| `json_annotation` | JSON serialization | Built-in feature |
| `json_serializable` | Code generation for JSON | Automated validation |
| Gemini JSON Mode | Structured AI responses | Schema enforcement |

---

## 🔧 How It Works

### **1. Define Schema Model**

```dart
@freezed
class AIFlightExtraction with _$AIFlightExtraction {
  const factory AIFlightExtraction({
    required String airline,
    required String flightNumber,
    required String origin,
    required String destination,
    @Default('neutral') String sentiment,
    @Default(3) int rating,
    @Default([]) List<String> tags,
    // ... more fields
  }) = _AIFlightExtraction;

  factory AIFlightExtraction.fromJson(Map<String, dynamic> json) =>
      _$AIFlightExtractionFromJson(json);
}
```

**Benefits:**
- ✅ **Immutable** - Can't be accidentally modified
- ✅ **Type-safe** - Compile-time guarantees
- ✅ **Default values** - Never null where not expected
- ✅ **CopyWith** - Easy updates
- ✅ **Equality** - Value equality built-in

### **2. Define JSON Schema for Gemini**

```dart
Schema.object(
  properties: {
    'airline': Schema.string(
      description: 'The airline name (e.g., Delta, United)',
    ),
    'rating': Schema.integer(
      description: 'Overall rating from 1-5',
    ),
    'sentiment': Schema.enumString(
      enumValues: ['positive', 'neutral', 'negative'],
      description: 'Overall sentiment',
    ),
    // ... more properties
  },
  requiredProperties: ['airline', 'flightNumber', 'origin', 'destination'],
)
```

**Benefits:**
- ✅ **Schema validation** - AI must follow structure
- ✅ **Type constraints** - Enums, ranges, patterns
- ✅ **Required fields** - Never missing critical data
- ✅ **Descriptions** - Better AI understanding

### **3. Use Structured Model**

```dart
// AI returns validated, type-safe object
final extraction = await aiService.processFlightLog(userInput);

// Access with full type safety
print(extraction.airline);        // String
print(extraction.rating);         // int (1-5)
print(extraction.sentiment);      // 'positive' | 'neutral' | 'negative'
print(extraction.tags);           // List<String>

// Immutable updates
final updated = extraction.copyWith(
  rating: 5,
  sentiment: 'positive',
);
```

---

## 🆚 Comparison with Traditional Approach

### **Traditional (Untyped Map)**

```dart
// ❌ Problems:
final Map<String, dynamic> data = await ai.process(input);

// No type safety
final airline = data['airline'];  // dynamic - could be anything!

// Typos cause runtime errors
final airlin = data['airlin'];    // null - no compile error!

// No validation
final rating = data['rating'];    // Could be 100, -5, or "five"!

// Nullability unclear
final tags = data['tags'] ?? [];  // Always need null checks

// Hard to refactor
// Can't rename fields safely
```

### **Structured Output (Type-Safe)**

```dart
// ✅ Benefits:
final AIFlightExtraction data = await ai.processFlightLog(input);

// Full type safety
final String airline = data.airline;  // Guaranteed String!

// Compile-time error prevention
final airlin = data.airlin;  // ❌ Compile error - caught immediately!

// Built-in validation
final int rating = data.rating;  // Guaranteed 1-5 from schema

// Clear nullability
final List<String> tags = data.tags;  // Never null, defaults to []

// Safe refactoring
// IDE can rename all references
```

---

## 🛠️ Development Workflow

### **Adding New Fields**

1. **Update the model**:
```dart
@freezed
class AIFlightExtraction with _$AIFlightExtraction {
  const factory AIFlightExtraction({
    // ... existing fields
    String? newField,  // Add new field
  }) = _AIFlightExtraction;
}
```

2. **Update the schema**:
```dart
'newField': Schema.string(
  description: 'Description of new field',
  nullable: true,
),
```

3. **Regenerate code**:
```bash
dart run build_runner build --delete-conflicting-outputs
```

4. **Use the new field**:
```dart
final value = extraction.newField;  // Fully typed!
```

### **Watch Mode (Development)**

```bash
# Auto-regenerate on file changes
dart run build_runner watch --delete-conflicting-outputs
```

---

## 📋 Schema Features

### **Data Types**

```dart
// String
Schema.string(description: 'A text value')

// Integer
Schema.integer(description: 'A whole number')

// Number (float)
Schema.number(description: 'A decimal number')

// Boolean
Schema.boolean(description: 'True or false')

// Array
Schema.array(
  items: Schema.string(description: 'Array item'),
  description: 'A list of items',
)

// Enum
Schema.enumString(
  enumValues: ['option1', 'option2', 'option3'],
  description: 'One of the specified values',
)

// Object
Schema.object(
  properties: {...},
  requiredProperties: [...],
)
```

### **Validation Constraints**

```dart
// String patterns
Schema.string(
  pattern: r'^[A-Z]{3}$',  // Must be 3 uppercase letters
)

// Number ranges
Schema.integer(
  minimum: 1,
  maximum: 5,
)

// Required vs Optional
Schema.string(nullable: false)  // Required
Schema.string(nullable: true)   // Optional
```

---

## 🎨 Best Practices

### **✅ DO**

1. **Use descriptive field names**
```dart
String flightNumber;  // ✅ Clear
String fn;            // ❌ Unclear
```

2. **Provide helpful descriptions**
```dart
Schema.string(
  description: 'Origin airport IATA code (3 letters, e.g., JFK)',
)
```

3. **Set sensible defaults**
```dart
@Default('neutral') String sentiment;
@Default([]) List<String> tags;
@Default(3) int rating;
```

4. **Use enums for fixed values**
```dart
@Default('neutral') String sentiment;  // Limited to: positive, neutral, negative
```

5. **Make required fields non-nullable**
```dart
required String airline;     // ✅ Must be provided
String? aircraftType;        // ✅ Optional
```

### **❌ DON'T**

1. **Don't use dynamic types**
```dart
dynamic data;  // ❌ No type safety
AIFlightExtraction data;  // ✅ Type-safe
```

2. **Don't skip code generation**
```dart
// ❌ Manual JSON parsing
final airline = json['airline'] as String;

// ✅ Generated parsing
final extraction = AIFlightExtraction.fromJson(json);
```

3. **Don't ignore null safety**
```dart
String? maybeAirline;
print(maybeAirline.length);  // ❌ Could crash!
print(maybeAirline?.length ?? 0);  // ✅ Safe
```

---

## 🧪 Testing

### **Unit Test Example**

```dart
test('AIFlightExtraction parses correctly', () {
  final json = {
    'airline': 'Delta',
    'flightNumber': 'DL1234',
    'origin': 'JFK',
    'destination': 'LAX',
    'rating': 5,
    'sentiment': 'positive',
    'tags': ['On Time', 'Great Service'],
    'highlights': ['Friendly crew'],
    'issues': [],
  };

  final extraction = AIFlightExtraction.fromJson(json);

  expect(extraction.airline, 'Delta');
  expect(extraction.rating, 5);
  expect(extraction.sentiment, 'positive');
  expect(extraction.tags.length, 2);
});

test('AIFlightExtraction handles defaults', () {
  final json = {
    'airline': 'Delta',
    'flightNumber': 'DL1234',
    'origin': 'JFK',
    'destination': 'LAX',
    'rating': 3,
  };

  final extraction = AIFlightExtraction.fromJson(json);

  expect(extraction.sentiment, 'neutral');  // Default value
  expect(extraction.tags, []);              // Default value
  expect(extraction.highlights, []);        // Default value
});
```

---

## 🔄 Migration Guide

### **From Untyped to Structured**

**Before:**
```dart
Future<Map<String, dynamic>> processFlightLog(String log) async {
  final response = await _model.generateContent([Content.text(prompt)]);
  return jsonDecode(response.text!);
}

// Usage
final data = await aiService.processFlightLog(input);
final airline = data['airline'];  // dynamic
```

**After:**
```dart
Future<AIFlightExtraction> processFlightLog(String log) async {
  final response = await _jsonModel.generateContent([Content.text(prompt)]);
  final json = jsonDecode(response.text!);
  return AIFlightExtraction.fromJson(json);
}

// Usage
final extraction = await aiService.processFlightLog(input);
final airline = extraction.airline;  // String
```

---

## 📚 Additional Resources

- [Freezed Documentation](https://pub.dev/packages/freezed)
- [JSON Serializable Guide](https://pub.dev/packages/json_serializable)
- [Gemini API Structured Output](https://ai.google.dev/gemini-api/docs/json-mode)
- [Dart Code Generation](https://dart.dev/tools/build_runner)

---

## 🚀 Commands Reference

```bash
# Generate code once
dart run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenerate)
dart run build_runner watch --delete-conflicting-outputs

# Clean generated files
dart run build_runner clean

# Analyze code
flutter analyze

# Run tests
flutter test
```

---

**Result: Type-safe, validated, production-ready AI responses! 🎉**


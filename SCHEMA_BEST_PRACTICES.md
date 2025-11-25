# 🏆 Schema Best Practices - Single Source of Truth

## The Problem with Hardcoded Schemas

### ❌ **Anti-Pattern: Dual Maintenance**

```dart
// Model definition
@freezed
class Flight {
  const factory Flight({
    required String airline,
    required int rating,
  }) = _Flight;
}

// Separate hardcoded schema (EASY TO GET OUT OF SYNC!)
final schema = Schema.object(
  properties: {
    'airline': Schema.string(...),
    'rating': Schema.integer(...),
  },
);
```

**Problems:**
1. 🔴 **Duplicate definitions** - Same fields in two places
2. 🔴 **Manual sync required** - Easy to forget
3. 🔴 **Drift over time** - Model and schema diverge
4. 🔴 **No compile-time safety** - Mismatches discovered at runtime
5. 🔴 **More code to maintain** - Doubled effort

---

## ✅ **Best Practice: Generated Schema**

### **Principle: Single Source of Truth**

```dart
// 1️⃣ Define model ONCE
@freezed
class AIFlightExtraction {
  const factory AIFlightExtraction({
    /// Airline name
    /// Schema: string, required
    required String airline,
    
    /// Overall rating from 1-5
    /// Schema: integer, required, min: 1, max: 5
    @Default(3) int rating,
  }) = _AIFlightExtraction;
}

// 2️⃣ Generate schema from model
final schema = SchemaGenerator.generateFlightExtractionSchema();

// ✅ Model and schema ALWAYS in sync!
```

---

## 🎯 Architecture

### **Single Source of Truth Flow**

```
┌─────────────────────────────────┐
│   AIFlightExtraction Model      │  ← SINGLE SOURCE
│   (Freezed + Annotations)       │
└──────────────┬──────────────────┘
               │
      ┌────────┴────────┐
      │                 │
      ▼                 ▼
┌──────────┐    ┌──────────────┐
│  Dart    │    │    JSON      │
│  Types   │    │   Schema     │
│ (Freezed)│    │ (Generated)  │
└──────────┘    └──────────────┘
```

### **Benefits**

| Aspect | Hardcoded | Generated |
|--------|-----------|-----------|
| **Definitions** | Dual ❌ | Single ✅ |
| **Sync** | Manual ❌ | Automatic ✅ |
| **Safety** | Runtime ❌ | Compile-time ✅ |
| **Maintainability** | Low ❌ | High ✅ |
| **Refactoring** | Risky ❌ | Safe ✅ |

---

## 📝 How It Works

### **Step 1: Annotate Your Model**

```dart
@freezed
class AIFlightExtraction with _$AIFlightExtraction {
  const factory AIFlightExtraction({
    /// Airline name (e.g., "Delta", "United")
    /// Schema: string, required
    required String airline,

    /// Flight number (e.g., "DL1234")
    /// Schema: string, required
    required String flightNumber,

    /// Overall sentiment: "positive", "neutral", or "negative"
    /// Schema: enum, required, default: "neutral"
    @Default('neutral') String sentiment,

    /// Overall rating from 1-5
    /// Schema: integer, required, min: 1, max: 5, default: 3
    @Default(3) int rating,
  }) = _AIFlightExtraction;
}
```

**Annotations document:**
- Field purpose
- Schema type
- Constraints (min/max, enum values, patterns)
- Required vs optional
- Default values

### **Step 2: Schema Generator Reads Model**

```dart
// utils/schema_generator.dart
class SchemaGenerator {
  static Schema generateFlightExtractionSchema() {
    return Schema.object(
      properties: _flightExtractionProperties(),
      requiredProperties: _flightExtractionRequiredFields(),
    );
  }

  // Properties derived from model structure
  static Map<String, Schema> _flightExtractionProperties() {
    return {
      'airline': _stringField(
        description: 'The airline name (e.g., Delta, United)',
      ),
      'rating': _integerField(
        description: 'Overall rating from 1-5',
        minimum: 1,
        maximum: 5,
      ),
      // ... derived from model annotations
    };
  }
}
```

### **Step 3: Use Generated Schema**

```dart
// services/ai_service.dart
AiService() {
  _jsonModel = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: apiKey,
    generationConfig: GenerationConfig(
      responseMimeType: 'application/json',
      responseSchema: SchemaGenerator.generateFlightExtractionSchema(),
      //               ↑
      //            Generated, not hardcoded!
    ),
  );
}
```

---

## 🔄 Workflow: Adding a New Field

### **With Hardcoded Schema (Manual)**

```dart
// Step 1: Update model
@freezed
class AIFlightExtraction {
  const factory AIFlightExtraction({
    required String airline,
    String? seatClass,  // ← New field added
  }) = _AIFlightExtraction;
}

// Step 2: Update schema (EASY TO FORGET!)
final schema = Schema.object(
  properties: {
    'airline': Schema.string(...),
    'seatClass': Schema.string(...),  // ← Must manually add
  },
);

// Step 3: Regenerate Freezed
// Step 4: Test
// Step 5: Realize you forgot to add to schema
// Step 6: Debug why AI responses are missing the field
// Step 7: Fix schema
// Step 8: Test again
```

### **With Generated Schema (Automatic)**

```dart
// Step 1: Update model with annotation
@freezed
class AIFlightExtraction {
  const factory AIFlightExtraction({
    /// Airline name
    /// Schema: string, required
    required String airline,
    
    /// Seat class (e.g., "Economy", "Business")
    /// Schema: enum, nullable
    String? seatClass,  // ← New field with schema annotation
  }) = _AIFlightExtraction;
}

// Step 2: Regenerate
// dart run build_runner build

// ✅ Schema automatically updated!
// ✅ No manual sync needed!
// ✅ Compiler ensures consistency!
```

---

## 🚀 Future Enhancement: Full Code Generation

### **Current State**

```dart
// Semi-manual: Schema generator reads model structure
// But still needs manual property definitions
static Map<String, Schema> _flightExtractionProperties() {
  return {
    'airline': _stringField(...),  // Manual
    'rating': _integerField(...),  // Manual
  };
}
```

### **Future: Fully Automated**

```dart
// With build_runner + custom generator:

@GenerateSchema()  // ← Annotation triggers code generation
@freezed
class AIFlightExtraction {
  const factory AIFlightExtraction({
    @SchemaString(pattern: r'^[A-Z]{3}$')
    required String origin,
    
    @SchemaInteger(min: 1, max: 5)
    @Default(3) int rating,
    
    @SchemaEnum(['positive', 'neutral', 'negative'])
    @Default('neutral') String sentiment,
  }) = _AIFlightExtraction;
}

// Generated file: ai_flight_extraction.schema.dart
class AIFlightExtractionSchema {
  static Schema get schema => _$generateSchema();
  // ↑ Fully generated from annotations!
}
```

**Packages to explore:**
- `json_schema` - JSON Schema generation
- Custom `build_runner` generator
- `dart_code_metrics` - Code analysis

---

## 📋 Checklist: Is Your Schema Well-Designed?

### ✅ **Good Practices**

- [ ] Model is the single source of truth
- [ ] Schema is generated, not hardcoded
- [ ] Fields have descriptive comments
- [ ] Schema constraints match Dart types
- [ ] Required fields are marked `required`
- [ ] Optional fields are nullable (`String?`)
- [ ] Default values are explicit (`@Default(...)`)
- [ ] Enums use typed constraints
- [ ] Documentation includes examples
- [ ] Tests verify schema compliance

### ❌ **Anti-Patterns to Avoid**

- [ ] Hardcoding schema separately from model
- [ ] Missing field documentation
- [ ] Inconsistent required/optional between model and schema
- [ ] No default values for optional fields
- [ ] Using `dynamic` types
- [ ] Loose typing (e.g., `String` instead of enum)
- [ ] No validation constraints
- [ ] Duplicate field definitions

---

## 🧪 Testing

### **Test Schema Generation**

```dart
test('Schema matches model structure', () {
  final schema = SchemaGenerator.generateFlightExtractionSchema();
  
  // Verify required fields
  final required = schema.requiredProperties;
  expect(required, contains('airline'));
  expect(required, contains('rating'));
  
  // Verify optional fields
  expect(required, isNot(contains('aircraftType')));
  expect(required, isNot(contains('seatNumber')));
});

test('Model can parse schema-compliant JSON', () {
  final json = {
    'airline': 'Delta',
    'flightNumber': 'DL1234',
    'origin': 'JFK',
    'destination': 'LAX',
    'rating': 5,
    'sentiment': 'positive',
    'tags': ['Great Service'],
    'highlights': ['Friendly crew'],
    'issues': [],
  };
  
  // Should not throw
  final extraction = AIFlightExtraction.fromJson(json);
  
  expect(extraction.airline, 'Delta');
  expect(extraction.rating, 5);
  expect(extraction.sentiment, 'positive');
});
```

---

## 🎓 Key Takeaways

1. **Single Source of Truth**
   - Define your model once
   - Generate everything else

2. **Documentation as Code**
   - Comments in model become schema descriptions
   - Type annotations drive validation

3. **Fail Fast**
   - Compile-time errors > runtime errors
   - Schema mismatches caught early

4. **Maintainability**
   - One place to update
   - Automatic propagation
   - Safe refactoring

5. **Scalability**
   - Add fields easily
   - Consistent patterns
   - Future-proof design

---

## 📚 Related Patterns

### **Comparison with Other Ecosystems**

| Ecosystem | Pattern | Similar To |
|-----------|---------|------------|
| **TypeScript** | Zod schema → types | Our approach (reversed) |
| **Go** | Struct tags → JSON | Similar annotations |
| **Rust** | Serde derives | Code generation |
| **Python** | Pydantic models | Type + validation |
| **Dart** | Freezed + Schema Gen | Best of all! |

---

## 🔗 Resources

- [Freezed Package](https://pub.dev/packages/freezed)
- [JSON Serializable](https://pub.dev/packages/json_serializable)
- [Build Runner](https://pub.dev/packages/build_runner)
- [Gemini Structured Output](https://ai.google.dev/gemini-api/docs/json-mode)

---

**Remember: Your model is the source of truth. Everything else should be derived from it!** 🎯


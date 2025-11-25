# 🎯 AI Service Architecture Patterns

## Overview

Each function in `AiService` **owns its own GenerativeModel** with specific configuration. This provides maximum flexibility and clarity about what each function needs.

---

## 🏗️ Architecture Principles

### **1. Function-Level Models**
✅ Each function creates its own model
✅ Model configuration matches function requirements
✅ Clear separation of concerns

### **2. Explicit Schema Requirements**
✅ Structured output functions specify their schema
✅ Text output functions use plain text mode
✅ No global model state

### **3. Flexibility**
✅ Different functions can use different models (flash vs pro)
✅ Different temperature settings per use case
✅ Different output formats (JSON vs text)

---

## 📋 Pattern Comparison

### ❌ **Anti-Pattern: Shared Models**

```dart
class AiService {
  late final GenerativeModel _model;  // Shared by all methods
  late final GenerativeModel _jsonModel;  // All JSON methods share
  
  AiService() {
    _model = GenerativeModel(...);  // One config for everything
    _jsonModel = GenerativeModel(...);  // One schema for everything
  }
  
  Future<String> methodA() async {
    return await _model.generateContent(...);  // Uses global model
  }
  
  Future<Map> methodB() async {
    return await _jsonModel.generateContent(...);  // Uses global model
  }
}
```

**Problems:**
- 🔴 All methods share same config
- 🔴 Can't customize per function
- 🔴 Schema must work for all use cases
- 🔴 Temperature fixed globally
- 🔴 Model choice fixed globally

---

### ✅ **Best Practice: Function-Owned Models**

```dart
class AiService {
  final String _apiKey;
  
  AiService({String? apiKey}) : _apiKey = apiKey ?? '';
  
  // Helper: Create structured output model
  GenerativeModel _createStructuredModel({
    required Schema schema,
    String model = 'gemini-1.5-flash',
  }) { /* ... */ }
  
  // Helper: Create text output model
  GenerativeModel _createTextModel({
    String model = 'gemini-1.5-flash',
    double? temperature,
  }) { /* ... */ }
  
  // Each function owns its model
  Future<AIFlightExtraction> processFlightLog(String log) async {
    final model = _createStructuredModel(
      schema: SchemaGenerator.generateFlightExtractionSchema(),
      model: 'gemini-1.5-flash',
    );
    return await model.generateContent(...);
  }
  
  Future<String> generateInsights(List flights) async {
    final model = _createTextModel(
      model: 'gemini-1.5-flash',
      temperature: 0.7,  // Creative
    );
    return await model.generateContent(...);
  }
}
```

**Benefits:**
- ✅ Each function controls its config
- ✅ Custom schema per function
- ✅ Custom temperature per use case
- ✅ Can use different models
- ✅ Clear requirements in code

---

## 🎨 Usage Patterns

### **Pattern 1: Structured Output (JSON Mode)**

**When to use:**
- Need type-safe parsed data
- Complex data extraction
- Multiple related fields
- Validation required

**Example:**

```dart
/// Extract flight data with structured output
/// Model: gemini-1.5-flash with JSON mode
/// Schema: AIFlightExtraction
Future<AIFlightExtraction> processFlightLog(String log) async {
  // 1. Create model with specific schema
  final model = _createStructuredModel(
    schema: SchemaGenerator.generateFlightExtractionSchema(),
    model: 'gemini-1.5-flash',
  );
  
  // 2. Generate with structured output
  final response = await model.generateContent([Content.text(prompt)]);
  
  // 3. Parse into type-safe object
  final json = jsonDecode(response.text!);
  return AIFlightExtraction.fromJson(json);
}
```

**Key characteristics:**
- ✅ Returns strongly-typed object
- ✅ Schema validates output
- ✅ Fast model (flash) for simple extraction
- ✅ Deterministic output format

---

### **Pattern 2: Creative Text Output**

**When to use:**
- Need natural language response
- Creative/conversational output
- Narrative summaries
- Recommendations

**Example:**

```dart
/// Generate insights with creative text
/// Model: gemini-1.5-flash, temperature 0.7
/// Output: Plain text
Future<String> generateInsights(List<Map<String, dynamic>> flights) async {
  // 1. Create model for creative text
  final model = _createTextModel(
    model: 'gemini-1.5-flash',
    temperature: 0.7,  // More creative
  );
  
  // 2. Generate creative text
  final response = await model.generateContent([Content.text(prompt)]);
  
  // 3. Return text directly
  return response.text ?? fallback;
}
```

**Key characteristics:**
- ✅ Returns plain string
- ✅ Higher temperature for creativity
- ✅ No schema constraints
- ✅ Natural language output

---

### **Pattern 3: Short Creative Text**

**When to use:**
- Short narratives
- Summaries
- Descriptions
- Token efficiency matters

**Example:**

```dart
/// Generate narrative with token limit
/// Model: gemini-1.5-flash, temperature 0.8, max 150 tokens
/// Output: Plain text (short)
Future<String> generateFlightNarrative(Map<String, dynamic> data) async {
  // 1. Create model with token limit
  final model = _createTextModel(
    model: 'gemini-1.5-flash',
    temperature: 0.8,  // Very creative
    maxOutputTokens: 150,  // Keep it short
  );
  
  // 2. Generate brief narrative
  final response = await model.generateContent([Content.text(prompt)]);
  
  // 3. Return brief text
  return response.text ?? fallback;
}
```

**Key characteristics:**
- ✅ Token-limited for cost efficiency
- ✅ Very creative (high temperature)
- ✅ Concise output
- ✅ Fast generation

---

## 🔧 Model Configuration Guide

### **Choosing the Right Model**

| Use Case | Model | Reason |
|----------|-------|--------|
| **Simple extraction** | `gemini-1.5-flash` | Fast, cheap, accurate |
| **Complex reasoning** | `gemini-1.5-pro` | Smarter, more capable |
| **Long context** | `gemini-1.5-pro` | Larger context window |
| **Speed critical** | `gemini-1.5-flash` | Fastest response |
| **Cost critical** | `gemini-1.5-flash` | Most economical |

### **Temperature Settings**

| Temperature | Use Case | Output Style |
|-------------|----------|--------------|
| **0.0** | Data extraction | Deterministic, factual |
| **0.3-0.5** | Q&A, summaries | Balanced |
| **0.7** | Insights, analysis | Creative but grounded |
| **0.8-1.0** | Narratives, stories | Very creative |

### **Token Limits**

| Max Tokens | Use Case | Example |
|------------|----------|---------|
| **50-150** | Short responses | Titles, summaries |
| **150-500** | Medium responses | Paragraphs, insights |
| **500-2000** | Long responses | Articles, detailed analysis |
| **No limit** | Unknown length | Let model decide |

---

## 📊 Decision Tree

```
Need AI processing?
│
├─ Need structured data?
│  ├─ YES → Use _createStructuredModel()
│  │       ├─ Define schema
│  │       ├─ Choose model (flash/pro)
│  │       └─ Parse to type-safe object
│  │
│  └─ NO → Use _createTextModel()
│          ├─ Creative output?
│          │  ├─ YES → temperature 0.7-1.0
│          │  └─ NO → temperature 0.0-0.3
│          ├─ Short output?
│          │  ├─ YES → set maxOutputTokens
│          │  └─ NO → no limit
│          └─ Return text directly
```

---

## 💡 Real-World Examples

### **Example 1: Flight Extraction (Structured)**

```dart
/// Extract structured flight data
/// WHY: Need type-safe, validated flight information
/// MODEL: gemini-1.5-flash (fast, accurate for extraction)
/// SCHEMA: AIFlightExtraction (custom generated schema)
/// TEMPERATURE: Not set (default, deterministic)
Future<AIFlightExtraction> processFlightLog(String log) async {
  final model = _createStructuredModel(
    schema: SchemaGenerator.generateFlightExtractionSchema(),
    model: 'gemini-1.5-flash',
  );
  
  final response = await model.generateContent([Content.text(prompt)]);
  return AIFlightExtraction.fromJson(jsonDecode(response.text!));
}
```

### **Example 2: Travel Insights (Creative Text)**

```dart
/// Generate travel insights and recommendations
/// WHY: Need natural, conversational insights
/// MODEL: gemini-1.5-flash (fast enough, good quality)
/// SCHEMA: None (plain text)
/// TEMPERATURE: 0.7 (creative but grounded)
Future<String> generateInsights(List flights) async {
  final model = _createTextModel(
    model: 'gemini-1.5-flash',
    temperature: 0.7,
  );
  
  final response = await model.generateContent([Content.text(prompt)]);
  return response.text ?? fallback;
}
```

### **Example 3: Flight Narrative (Short Creative)**

```dart
/// Generate brief flight narrative
/// WHY: Need engaging 2-3 sentence summary
/// MODEL: gemini-1.5-flash (fast)
/// SCHEMA: None (plain text)
/// TEMPERATURE: 0.8 (very creative for storytelling)
/// MAX TOKENS: 150 (keep it brief)
Future<String> generateFlightNarrative(Map data) async {
  final model = _createTextModel(
    model: 'gemini-1.5-flash',
    temperature: 0.8,
    maxOutputTokens: 150,
  );
  
  final response = await model.generateContent([Content.text(prompt)]);
  return response.text ?? fallback;
}
```

---

## 🎯 Adding New Functions

### **Template: Structured Output Function**

```dart
/// [Description of what this extracts]
/// Model: [model name] with JSON mode
/// Schema: [schema class name]
Future<YourModel> extractSomething(String input) async {
  // 1. Create structured model with custom schema
  final model = _createStructuredModel(
    schema: SchemaGenerator.generateYourSchema(),
    model: 'gemini-1.5-flash',  // or 'gemini-1.5-pro'
  );
  
  try {
    // 2. Create prompt
    final prompt = '''Your extraction prompt here''';
    
    // 3. Generate with model
    final response = await model.generateContent([Content.text(prompt)]);
    
    // 4. Parse to type-safe object
    final json = jsonDecode(response.text!);
    return YourModel.fromJson(json);
    
  } catch (e) {
    // 5. Handle errors with fallback
    if (kDebugMode) print('Error: $e');
    return _fallbackExtraction(input);
  }
}
```

### **Template: Text Output Function**

```dart
/// [Description of what this generates]
/// Model: [model name] with text output, temperature [value]
/// Output: Plain text
Future<String> generateSomething(SomeInput input) async {
  // 1. Create text model with appropriate settings
  final model = _createTextModel(
    model: 'gemini-1.5-flash',  // or 'gemini-1.5-pro'
    temperature: 0.7,  // adjust based on creativity needs
    maxOutputTokens: 500,  // optional: limit length
  );
  
  try {
    // 2. Create prompt
    final prompt = '''Your generation prompt here''';
    
    // 3. Generate with model
    final response = await model.generateContent([Content.text(prompt)]);
    
    // 4. Return text
    return response.text ?? 'Fallback text';
    
  } catch (e) {
    // 5. Handle errors
    if (kDebugMode) print('Error: $e');
    return 'Fallback text';
  }
}
```

---

## ✅ Best Practices

### **DO:**
- ✅ Create model at start of function
- ✅ Document model, schema, and temperature
- ✅ Choose appropriate model (flash vs pro)
- ✅ Set temperature based on use case
- ✅ Limit tokens for short outputs
- ✅ Provide fallback for errors
- ✅ Use structured output for data extraction
- ✅ Use text output for creative content

### **DON'T:**
- ❌ Share models between functions
- ❌ Use structured output for narratives
- ❌ Use text output for data extraction
- ❌ Set temperature for structured output
- ❌ Use pro model when flash suffices
- ❌ Ignore error handling
- ❌ Mix schemas between functions

---

## 🚀 Performance Considerations

### **Cost Optimization**

```dart
// ✅ Good: Use flash for simple tasks
final model = _createStructuredModel(
  schema: simpleSchema,
  model: 'gemini-1.5-flash',  // Cheap!
);

// ❌ Expensive: Using pro unnecessarily
final model = _createStructuredModel(
  schema: simpleSchema,
  model: 'gemini-1.5-pro',  // Overkill!
);
```

### **Speed Optimization**

```dart
// ✅ Fast: Flash model + token limit
final model = _createTextModel(
  model: 'gemini-1.5-flash',
  maxOutputTokens: 150,
);

// ❌ Slow: Pro model + no limit
final model = _createTextModel(
  model: 'gemini-1.5-pro',
  // No limit = slower
);
```

---

## 📚 Summary

**Key Takeaways:**

1. **Each function owns its model** - maximum flexibility
2. **Structured output for data** - type-safe extraction
3. **Text output for creativity** - narratives and insights
4. **Choose model wisely** - flash vs pro based on needs
5. **Set temperature appropriately** - 0.0 for facts, 0.7+ for creativity
6. **Limit tokens when possible** - faster and cheaper

**Result: Clean, flexible, maintainable AI service!** 🎉


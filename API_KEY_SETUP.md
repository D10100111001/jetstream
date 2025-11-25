# 🔐 API Key Setup Guide

## Quick Start

### 1️⃣ Get Your Gemini API Key

Visit: **https://makersuite.google.com/app/apikey**

1. Sign in with your Google account
2. Click **"Create API Key"**
3. Select or create a project
4. Copy your API key

### 2️⃣ Add Key to .env File

Open the `.env` file in your project root and replace `your_api_key_here` with your actual key:

```bash
# Before
GEMINI_API_KEY=your_api_key_here

# After (example - use your real key!)
GEMINI_API_KEY=AIzaSyBxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

### 3️⃣ Run the App

```bash
flutter run
```

That's it! The app will automatically load your API key from the `.env` file.

---

## 🔒 Security Best Practices

### ✅ What We've Configured

1. **`.env` file** - Stores your API key locally (NOT committed to git)
2. **`.env.example`** - Template file (safe to commit)
3. **`.gitignore`** - Ensures `.env` is never committed
4. **`flutter_dotenv`** - Securely loads environment variables at runtime

### ⚠️ Important Security Rules

1. **NEVER commit `.env` to git**
   - It's already in `.gitignore` ✅
   - Always check before pushing!

2. **NEVER hardcode API keys in source code**
   - Bad: `apiKey: 'AIzaSyB...'`
   - Good: `apiKey: dotenv.env['GEMINI_API_KEY']`

3. **Use `.env.example` for team sharing**
   - Share `.env.example` with your team
   - Each developer creates their own `.env`

4. **Rotate keys if exposed**
   - If you accidentally commit a key, revoke it immediately
   - Generate a new one from Google AI Studio

---

## 🛠️ Alternative Methods

### Method 1: .env File (Current - Best for Development)

```bash
# .env file
GEMINI_API_KEY=your_key_here
```

**Pros:**
- ✅ Easy to use
- ✅ Not committed to git
- ✅ Can have different keys per environment

**Cons:**
- ⚠️ Must manually share with team members

---

### Method 2: Command Line (Best for CI/CD)

```bash
flutter run --dart-define=GEMINI_API_KEY=your_key_here
```

Then in code:
```dart
const apiKey = String.fromEnvironment('GEMINI_API_KEY');
```

**Pros:**
- ✅ No files to manage
- ✅ Perfect for CI/CD pipelines

**Cons:**
- ⚠️ Must pass flag every time
- ⚠️ Key visible in process list

---

### Method 3: Build Configuration (Advanced)

Create separate config files per environment:

```
lib/config/
  ├── config.dart
  ├── dev.dart
  ├── staging.dart
  └── prod.dart
```

**Pros:**
- ✅ Multiple environments
- ✅ Type-safe configuration

**Cons:**
- ⚠️ More complex setup
- ⚠️ Still need to manage secrets

---

## 🚨 If API Key is Exposed

1. **Immediately revoke the key:**
   - Go to https://makersuite.google.com/app/apikey
   - Delete the exposed key

2. **Generate a new key:**
   - Create a new API key
   - Update your `.env` file

3. **Check git history:**
   - If committed, use `git filter-repo` to remove from history
   - Force push (be careful!)

4. **Notify your team:**
   - Let everyone know to update their keys

---

## 📝 Environment Variables Reference

Current variables in `.env`:

| Variable | Description | Required |
|----------|-------------|----------|
| `GEMINI_API_KEY` | Google Gemini AI API key | Yes |

---

## 🧪 Testing Without API Key

The app has fallback behavior if no API key is provided:
- AI features will show a warning
- Manual flight logging still works
- Firestore and Authentication work normally

---

## 💡 Pro Tips

1. **Use different keys for dev/prod**
   ```bash
   # .env.dev
   GEMINI_API_KEY=dev_key_here
   
   # .env.prod
   GEMINI_API_KEY=prod_key_here
   ```

2. **Set usage limits in Google Cloud Console**
   - Prevent unexpected charges
   - Get alerts for unusual usage

3. **Use environment-specific Firebase projects**
   - Dev: `jetstream-dev`
   - Prod: `jetstream-prod`

---

## 🆘 Troubleshooting

### "API key not configured" warning

**Solution:** Check that:
1. `.env` file exists in project root
2. `GEMINI_API_KEY=` is set to your actual key
3. No spaces around the `=` sign
4. No quotes around the key value

### API calls failing with "Invalid API key"

**Solution:**
1. Verify key in Google AI Studio
2. Check if key has been revoked
3. Ensure billing is enabled (if required)
4. Check API quotas

### .env file not loading

**Solution:**
1. Ensure file is named exactly `.env` (not `.env.txt`)
2. File must be in project root (next to `pubspec.yaml`)
3. Run `flutter clean` and `flutter pub get`
4. Restart the app

---

## 📚 Additional Resources

- [Google AI Studio](https://makersuite.google.com/)
- [Gemini API Documentation](https://ai.google.dev/docs)
- [Flutter Dotenv Package](https://pub.dev/packages/flutter_dotenv)
- [Flutter Environment Variables Guide](https://flutter.dev/docs/deployment/flavors)

---

**Remember: Keep your API keys secret and secure! 🔐**


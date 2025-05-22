<h1 align="center">📚 BookBuddy AI</h1>

<p align="center">
  <b>BookBuddy AI</b> is a smart, AI-powered Flutter app that connects you with over <b>20 million books</b>.<br>
  <i>Search, summarize, chat, and discover your next favorite read!</i>
</p>

<p align="center">
  <img src="./screenshot/Screenshot_20250522-111649.jpg" alt="BookBuddy Home" width="250"/>
  <img src="./screenshot/Screenshot_20250522-111707.jpg" alt="BookBuddy Search" width="250"/>
  <img src="./screenshot/Screenshot_20250522-111729.jpg" alt="BookBuddy Details" width="250"/>
  <img src="./screenshot/scrrenshot.jpeg" alt="BookBuddy Details" width="250"/>


</p>

---

## 🚀 Features

- 🔍 **Search Books** by title, author, or keywords
- 🤖 **Chat with Books** using AI (get insights, ask questions)
- 📑 **Chapter-wise AI Summaries** generated on demand
- 📌 **Favorites Page** to save and revisit your books
- 💬 **Chat Interface** for deep interaction with content
- 🌙 **Dark Mode Ready** *(adapts to system settings)*

---

## 📁 Folder Structure

```plaintext
lib/
 ├── main.dart
 ├── screen/
 │    └── home_page.dart
 └── provider/
      └── favorite_provider.dart
assets/
 ├── images/
 └── .env
```

---

## 🖼️ Screenshots

| Home | Favorite Page | Book Details | Removing Favorite | AI Chat Bot | Search Result |
|:----:|:--------------:|:------------:|:---------:|:--------------:|:--------------:|
| ![Home](./screenshot/Screenshot_20250522-111649.jpg) | ![Search](./screenshot/Screenshot_20250522-111707.jpg) | ![Details](./screenshot/Screenshot_20250522-111729.jpg) | ![Dark](./screenshot/Screenshot_20250522-111736.jpg) | ![Error](./screenshot/Screenshot_20250522-111821.jpg) | ![ Search Result](./screenshot/scrrenshot.jpeg) |

---

## 🛠️ Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/HAMZOO0/bookbuddy-ai.git
   cd bookbuddy-ai
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up API keys**  
   Create a `.env` file in the root directory for any required API keys (e.g., OpenAI, Google Books API).
   ``` 
   GEMINI_API_KEY = 'Add Your APi Key';
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

---

## 🌐 Tech Stack

| Tech         | Description                        |
|--------------|------------------------------------|
| Flutter      | Cross-platform UI toolkit          |
| Dart         | Primary language for Flutter       |
| REST APIs    | For book data and summaries        |
| Provider     | State management                   |
| OpenAI/LLMs  | For AI-powered chat & summaries    |


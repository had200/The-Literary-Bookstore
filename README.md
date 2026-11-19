# 📚 The Literary Bookstore

### *Home of Knowledge & Imagination*

\<p align="center">
&#x20; \<img src="[https://img.shields.io/badge/FLUTTER-02569B?style=for-the-badge&logo=flutter&logoColor=white](https://img.shields.io/badge/FLUTTER-02569B?style=for-the-badge\&logo=flutter\&logoColor=white)" alt="Flutter">
&#x20; \<img src="[https://img.shields.io/badge/DART-0175C2?style=for-the-badge&logo=dart&logoColor=white](https://img.shields.io/badge/DART-0175C2?style=for-the-badge\&logo=dart\&logoColor=white)" alt="Dart">
&#x20; \<img src="[https://img.shields.io/badge/PHP-777BB4?style=for-the-badge&logo=php&logoColor=white](https://img.shields.io/badge/PHP-777BB4?style=for-the-badge\&logo=php\&logoColor=white)" alt="PHP">
&#x20; \<img src="[https://img.shields.io/badge/MYSQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white](https://img.shields.io/badge/MYSQL-4479A1?style=for-the-badge\&logo=mysql\&logoColor=white)" alt="MySQL">
\</p>

\<p align="center">
&#x20; \<strong>A modern mobile bookstore application designed to make discovering, exploring, and managing books a delightful experience.\</strong>
\</p>

---

## ✦ Overview

**The Literary Bookstore** is a mobile bookstore application developed using Flutter and Dart, with a PHP backend and a MySQL database.

The application provides an intuitive environment where readers can explore a collection of books, browse categories, search for titles, discover book details, manage favorites, and organize their shopping cart.

It also includes an administrative interface that allows authorized administrators to manage books and users.

The project combines a clean user experience, database integration, and a structured client-server architecture.

## ✦ Application Preview

The following screenshots illustrate the main interfaces of the application.

> Add your actual screenshots to the `screenshots/` directory using the filenames below.

### 🏛️ Main Interface

\<p align="center">
&#x20; \<img src="screenshots/home.png" width="80%" alt="Home Screen">
\</p>

### 📖 Book Library

\<p align="center">
&#x20; \<img src="screenshots/library.png" width="80%" alt="Book Library">
\</p>

### 🔍 Book Details

\<p align="center">
&#x20; \<img src="screenshots/details.png" width="80%" alt="Book Details">
\</p>

### 🛒 Shopping Cart

\<p align="center">
&#x20; \<img src="screenshots/cart.png" width="80%" alt="Shopping Cart">
\</p>

### ♥ Favorites

\<p align="center">
&#x20; \<img src="screenshots/favorites.png" width="80%" alt="Favorites">
\</p>

### ⚙️ Administration Dashboard

\<p align="center">
&#x20; \<img src="screenshots/admin.png" width="80%" alt="Admin Dashboard">
\</p>

---

## ✦ Features

### 👤 User Experience

- Browse the bookstore catalog.
- Explore books by category.
- Search for books by title or relevant information.
- View detailed book information.
- Add books to favorites.
- Manage a shopping cart.
- Switch between light and dark themes.
- Access a personalized user profile.

### 🛠️ Administration

- Administrator authentication.
- Dedicated administration dashboard.
- Add new books.
- Edit existing book information.
- Delete books from the catalog.
- Manage registered users.

### 🎨 Interface and Design

- Modern and intuitive user interface.
- Responsive Flutter layouts.
- Light and dark themes.
- Organized navigation.
- Google Fonts integration.

---

## ✦ Technologies and Tools

| Technology     | Purpose                                    |
| -------------- | ------------------------------------------ |
| Flutter        | Cross-platform mobile development          |
| Dart           | Application programming language           |
| PHP            | Backend development and API                |
| MySQL          | Relational database management             |
| HTTP           | Communication between frontend and backend |
| Google Fonts   | Typography and interface design            |
| Android Studio | Development and Android emulation          |
| Git and GitHub | Version control and project hosting        |

---

## ✦ System Architecture

The application follows a client-server architecture.

```text
             ┌──────────────────────────┐
             │       FLUTTER APP        │
             │                          │
             │  User Interface          │
             │  Book Catalog            │
             │  Search and Categories  │
             │  Shopping Cart           │
             │  Favorites               │
             │  Admin Dashboard         │
             └────────────┬─────────────┘
                          │
                          │ HTTP Requests
                          │
             ┌────────────▼─────────────┐
             │       PHP BACKEND        │
             │                          │
             │  API Endpoints           │
             │  Request Processing      │
             │  Authentication          │
             │  Business Logic          │
             └────────────┬─────────────┘
                          │
                          │ SQL Queries
                          │
             ┌────────────▼─────────────┐
             │      MYSQL DATABASE      │
             │                          │
             │  Books                   │
             │  Users                   │
             │  Application Data        │
             └──────────────────────────┘
```

### Architecture Description

1. **Frontend:** Flutter provides the mobile interface and handles user interactions.
2. **Communication:** HTTP requests allow the Flutter application to communicate with the backend.
3. **Backend:** PHP processes requests and handles application operations.
4. **Database:** MySQL stores and manages the application's data.

---

## ✦ Installation and Setup

Follow these steps to run the project locally.

### 1. Clone the Repository

```bash
git clone https://github.com/had200/The-Literary-Bookstore.git
```

```bash
cd The-Literary-Bookstore
```

### 2. Configure Flutter

Make sure Flutter and Dart are installed.

Check your environment:

```bash
flutter doctor
```

Install the project dependencies:

```bash
flutter pub get
```

### 3. Configure the MySQL Database

- Start your MySQL server.
- Create the project database.
- Import the provided SQL script if available.
- Configure the database connection in the PHP backend.

**Important:** Never commit real database passwords or private credentials to GitHub.

### 4. Configure the PHP Backend

- Start your local PHP server or Apache server.
- Place the backend files in the appropriate server directory.
- Configure the database connection.
- Make sure the API is accessible from the device or emulator.

### 5. Configure the API Address

For an Android emulator, `10.0.2.2` refers to the host computer.

Use the appropriate API base URL in the Flutter application.

For example:

```dart
const String baseUrl = "http://10.0.2.2/YOUR_API_PATH";
```

Replace `YOUR_API_PATH` with the actual backend API directory.

### 6. Run the Application

```bash
flutter run
```

---

## ✦ Design Philosophy

The Literary Bookstore takes inspiration from the atmosphere of traditional libraries and the timeless charm of literature.

Its visual identity focuses on:

- Elegant typography.
- A refined color palette.
- Simple and intuitive navigation.
- A comfortable reading-oriented experience.
- A balance between classic literary aesthetics and modern mobile design.

The goal is to create an application that feels like entering a personal library: welcoming, organized, and full of possibilities.

---

## ✦ Future Improvements

Potential improvements include:

- Online payment integration.
- Persistent favorites and shopping cart.
- Order history and tracking.
- Book reviews and ratings.
- Personalized recommendations.
- Enhanced authentication and authorization.
- Improved API security and validation.

---

## ✦ Project Information

| Information             | Details                |
| ----------------------- | ---------------------- |
| Project                 | The Literary Bookstore |
| Type                    | Mobile Application     |
| Frontend                | Flutter and Dart       |
| Backend                 | PHP                    |
| Database                | MySQL                  |
| Communication           | HTTP                   |
| Development Environment | Android Studio         |

---

\<p align="center">
&#x20; \<strong>THE LITERARY BOOKSTORE\</strong>
&#x20; \<br>
&#x20; \<em>Home of Knowledge & Imagination\</em>
&#x20; \<br>\<br>
&#x20; 📚 Every book opens a new world.
\</p>

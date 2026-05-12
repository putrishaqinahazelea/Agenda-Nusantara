# Agenda Nusantara

Agenda Nusantara is a Flutter-based mobile todo list application that helps users manage important and regular tasks using a local SQLite database.

This project was developed for the **BNSP DIPA 2026 Mobile Application Programming Certification Test** at Politeknik Negeri Malang. :contentReference[oaicite:0]{index=0}

---

## Features

- User login authentication
- Add important tasks
- Add regular tasks
- View task list
- Mark tasks as completed
- Task completion statistics
- Task completion graph (7-day history)
- Change account password
- Local database storage using SQLite

---

## Technologies Used

- Flutter
- Dart
- SQLite (`sqflite`)
- Intl
- Path

---

## Database Structure

### Table: `users`

| Column | Type |
|--------|------|
| id | INTEGER |
| username | TEXT |
| password | TEXT |

Default account:

```text
Username : user
Password : user

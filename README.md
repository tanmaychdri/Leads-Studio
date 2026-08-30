# 🚀 LeadStudio

> A modern, cross-platform lead management and follow-up application built for photography studios.

LeadStudio helps photography studios manage client leads without the hassle of manually searching through large Excel spreadsheets.

The application connects with a user's Google Drive, works with their lead Excel file, and provides a modern graphical interface for managing clients, follow-ups, reminders, and lead status.

---

## ✨ Features

### 👥 Lead Management

* ➕ Add new leads
* ✏️ Edit existing leads
* 🗑️ Delete leads safely
* 👤 View detailed client information
* 🏷️ Manage lead statuses
* ⭐ Mark important clients as priority leads
* 📝 Add and manage client notes

---

### 📊 Smart Dashboard

Get an instant overview of your business leads.

* 📈 Active lead statistics
* 🔥 Leads requiring immediate attention
* 📅 Today's follow-ups
* 🔴 Overdue follow-ups
* 🗓️ Upcoming follow-ups
* ⭐ Priority clients
* 📊 Useful lead insights

---

### 🔔 Smart Follow-Up Reminders

Never forget to contact an important client.

LeadStudio can help identify:

* 🔴 Overdue follow-ups
* 🟠 Clients to contact today
* 🟡 Upcoming follow-ups
* ⚪ Leads without scheduled follow-ups

Features include:

* Scheduled notifications
* Follow-up reminders
* Overdue alerts
* Daily summaries
* Custom notification settings

---

### 📁 Excel Integration

LeadStudio is designed to work with existing client lead spreadsheets.

Features include:

* 📥 Import Excel files
* 📊 Parse `.xlsx` worksheets
* 🧠 Automatic header detection
* 🔄 Map spreadsheet columns to lead data
* ✏️ Update lead information
* 📤 Export updated data
* 🧩 Preserve custom fields where possible

---

### ☁️ Google Drive Integration

Connect your Google Drive and manage your lead spreadsheet directly through LeadStudio.

* 🔐 Google Authentication
* ☁️ Google Drive integration
* 📁 Excel file selection
* 📥 Download and cache files
* 📤 Upload updated files
* 🔄 Safe synchronization

---

### 💾 Offline-First Architecture

LeadStudio is designed to work even without an internet connection.

```text
User Action
     ↓
Local Database Updates Immediately
     ↓
UI Updates Immediately
     ↓
Changes Marked for Sync
     ↓
Google Drive Sync Later
```

This ensures that users can continue managing leads even when they don't have an internet connection.

---

### 🔄 Safe Synchronization

LeadStudio provides a synchronization system between:

```text
Google Drive Excel File
          ↕
    LeadStudio
          ↕
   Local Database
```

The synchronization system includes:

* 📤 Push synchronization
* 📥 Pull synchronization
* 🔍 Remote change detection
* ⚔️ Conflict detection
* 🛡️ Conflict resolution
* 📶 Offline recovery
* ☁️ Pending sync tracking

Data safety is a priority.

LeadStudio avoids blindly overwriting remote changes.

---

### 🔍 Advanced Search

Quickly find clients using:

* 👤 Client name
* 📞 Phone number
* ✉️ Email
* 📸 Event type
* 📝 Notes

---

### 🎯 Smart Filters

Filter leads by:

* Lead status
* Follow-up status
* Event type
* Date range
* Priority status

Example:

> Show all **Interested** clients with a **Wedding** event who need a follow-up **this week**.

---

### ⚡ Productivity Features

LeadStudio includes tools designed to make daily lead management faster.

* ⚡ Quick actions
* ⭐ Priority leads
* 🔍 Advanced search
* 🎯 Smart filters
* ↕️ Sorting
* ☑️ Multi-select
* 🔄 Bulk actions
* 📅 Bulk rescheduling
* 🏷️ Bulk status updates
* 📜 Lead activity history

---

## 🎨 Modern Glassmorphism UI

LeadStudio features a premium modern design system built around **Glassmorphism**.

The interface includes:

* 🌫️ Frosted glass surfaces
* ✨ Subtle background blur
* 🟣 Indigo and violet accents
* 🎨 Ambient gradients
* 🌙 Dark mode
* ☀️ Light mode
* 🪟 Responsive desktop layouts
* 📱 Mobile-first interfaces

The design prioritizes:

> **Premium UI + Readability + Performance**

---

## 📱 Supported Platforms

| Platform    | Support       |
| ----------- | ------------- |
| 🤖 Android  | ✅             |
| 🖥️ Windows | ✅             |
| 🍎 iOS      | ❌ Not Planned |
| 💻 macOS    | ❌ Not Planned |

---

## 🏗️ Architecture

LeadStudio follows a modern, scalable architecture.

```text
┌─────────────────────────────┐
│       Presentation Layer    │
│                             │
│  Screens • Widgets • UI     │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│      State Management       │
│                             │
│          Riverpod           │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│       Domain / Logic        │
│                             │
│ Services • Use Cases        │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│         Data Layer          │
│                             │
│ Database • Excel • Drive    │
└─────────────────────────────┘
```

---

## 🛠️ Tech Stack

LeadStudio is built using:

* **Flutter** — Cross-platform application development
* **Dart** — Application programming language
* **Riverpod** — State management
* **GoRouter** — Navigation and routing
* **Google Sign-In** — Authentication
* **Google Drive API** — Cloud file integration
* **Excel/XLSX Engine** — Spreadsheet parsing and writing
* **Local Database** — Offline-first data storage
* **Local Notifications** — Follow-up reminders

---

## 🔄 Application Workflow

### 1️⃣ Connect Google Account

```text
User
  ↓
Google Authentication
  ↓
Google Drive Access
```

### 2️⃣ Select Lead Spreadsheet

```text
Google Drive
      ↓
Select Excel File
      ↓
LeadStudio
```

### 3️⃣ Manage Leads

```text
Excel Data
     ↓
LeadStudio GUI
     ↓
Add / Edit / Delete Leads
```

### 4️⃣ Get Follow-Up Intelligence

```text
Lead Data
    ↓
Follow-Up Engine
    ↓
Overdue / Today / Upcoming
```

### 5️⃣ Receive Reminders

```text
Follow-Up Date
      ↓
Notification Engine
      ↓
Reminder
```

### 6️⃣ Synchronize Changes

```text
Local Database
      ↕
LeadStudio Sync Engine
      ↕
Google Drive Excel File
```

---

## 🚀 Getting Started

### Prerequisites

Make sure you have the following installed:

* Flutter SDK
* Dart SDK
* Android Studio or Android SDK
* Visual Studio with Windows Desktop Development tools
* A Google Cloud project configured for authentication and Google Drive API access

---

### Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/LeadStudio.git
```

```bash
cd LeadStudio
```

---

### Install Dependencies

```bash
flutter pub get
```

---

### Run on Android

```bash
flutter run
```

---

### Run on Windows

```bash
flutter run -d windows
```

---

## 🔐 Google API Setup

LeadStudio requires Google services for:

* Google Authentication
* Google Drive access
* Excel file synchronization

You will need to:

1. Create a project in Google Cloud Console.
2. Enable the Google Drive API.
3. Configure OAuth credentials.
4. Configure Android authentication.
5. Configure Windows/Desktop authentication.
6. Add the required credentials securely.

> ⚠️ Never commit API secrets, OAuth client secrets, or private credentials to GitHub.

Use environment variables or secure configuration files where appropriate.

---

## 🧪 Development Principles

LeadStudio follows these core principles:

### 💾 Local First

The application should remain usable without an internet connection.

### 🛡️ Data Safety

Never silently lose user data.

### 🔄 Safe Synchronization

Remote changes should be detected before overwriting cloud data.

### ⚡ Performance

The application should remain responsive on both Android and Windows.

### 🎨 Consistent Design

All screens follow a centralized Glassmorphism design system.

### 🧩 Maintainable Architecture

Business logic should remain separate from UI components.

---

## 🗺️ Roadmap

### ✅ Completed / Core Development

* [x] Project foundation
* [x] Responsive Android and Windows architecture
* [x] Google authentication
* [x] Google Drive integration
* [x] Excel engine
* [x] Local-first database
* [x] Lead CRUD
* [x] Dashboard
* [x] Follow-up intelligence
* [x] Smart notifications
* [x] Google Drive synchronization
* [x] Advanced search
* [x] Filters and sorting
* [x] Priority leads
* [x] Bulk actions
* [x] Activity history
* [x] Modern Glassmorphism UI

### 🚧 Planned

* [ ] Production testing
* [ ] Backup and restore system
* [ ] Advanced analytics
* [ ] Improved onboarding
* [ ] Android release build
* [ ] Windows installer
* [ ] Error reporting and diagnostics
* [ ] Performance optimization

---

## 🎯 Why LeadStudio?

Photography studios often manage leads using Excel spreadsheets.

As the number of clients grows, it becomes difficult to answer simple questions such as:

> Who should I contact today?

> Which clients are overdue for follow-up?

> Which leads are interested?

> Where is a specific client's information?

LeadStudio transforms a traditional spreadsheet workflow into a modern lead-management experience.

---

## 🌟 Project Vision

LeadStudio aims to provide a simple but powerful alternative to manually managing photography studio leads in spreadsheets.

The vision is:

> **Keep the simplicity of Excel while providing the power of a modern CRM.**

---

## 🤝 Contributing

Contributions, suggestions, and improvements are welcome.

If you'd like to contribute:

1. Fork the repository.
2. Create a feature branch.
3. Make your changes.
4. Test your implementation.
5. Submit a pull request.

---

## 📄 License

This project is currently intended for personal and development use.

A formal license will be added in the future.

---

## 👨‍💻 Author

Developed by **Tanmay Chaudhari**

---

# ⭐ If you like LeadStudio

Consider giving the repository a **star ⭐**!

---

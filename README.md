# <img src="./assets/images/app_logo.png" width=40>  MessengerApp 

MessengerApp is a real-time chat application that supports authentication, contacts management, private messaging, group chats, and voice/video calling. This project is modularly structured and follows clean architecture principles.

## ✨ Features Overview

### 1. 🔐 Authentication
- Email Login
- Google Login
- Signup
- Logout
- Relogin

### 2. 📇 Contacts (Liên hệ)
- Get contacts list (friend list)
- Search users (public group)
- Send friend request, get user friend request
- Get pending friend request list
- Accept friend request
- Cancel friend request / Dismiss friend request

### 3. 💬 Chat

#### 3.1. Direct Message
- Get all messages of a direct conversation between 2 users
- Send message to a user directly

#### 3.2. Group Chat
- Create group chat, add multiple users
- Get all messages of a group chat
- Send message to a group chat

#### 3.3. General Chat Functions
- Edit sent messages (within 5 minutes)
- Delete sent messages (within 5 minutes)
- Send images and files with conversion support

### 4. 👥 Group Management

#### 4.1. Group Manage
- Create or join group
- Get list of group members
- Edit member roles (admin, sub-admin, moderator, etc.)
- Configure group rules (is member mutable, is public, etc.)

#### 4.2. User Group Manage
- Get joined groups by a user
- Leave group

### 5. 📞 Call & Video Call

#### 5.1. Direct Call
- Voice call between 2 users

#### 5.2. Group Call
- Voice call in a group

#### 5.3. Direct Video Call
- Video call between 2 users

#### 5.4. Group Video Call
- Video call in a group

---

## 🛠 Tech Stack

- **Frontend**: Flutter (Cupertino & Material)
- **Backend**: FastAPI.
- **Database**: MongoDB / MySql
- **Authentication**: Firebase Auth
- **Real-time**: WebSockets

## 📁 Project Structure
- `lib/`: Flutter UI & MVVM viewmodels
- `backend/`: API and websocket server
- `docs/`: Diagrams and specs

## ✅ Current Status

Google Sheet Attach : https://docs.google.com/spreadsheets/d/1rc0E9quLdpvbrJyGz9bz1ikGm6KiIAYHxf8psEpdpmM/edit?usp=sharing

---

## 📌 Notes
- Messages can be edited/deleted only within 5 minutes.
- Friend request workflow is fully supported.
- Group rules can be customized per group.


# 🏢 Meeting Room Booking Application

A web-based Meeting Room Booking System that streamlines scheduling, managing, and coordinating meeting rooms within an organization. The application supports role-based access for both **Users and Administrators**, ensuring smooth collaboration and efficient resource utilization.

---

## 🚀 Features

### 👤 User Features
- Secure user authentication (Login / Logout)
- View available meeting rooms and time slots
- Create booking requests for meetings
- Accept or reject meeting invitations
- View personal booking history and status updates

### 🛠️ Admin Features
- Admin dashboard for complete system control
- Create, update, and manage meeting rooms
- Approve or reject booking requests
- Manage users and their roles
- Monitor all scheduled meetings and room utilization

### 📊 Dashboard
- Separate dashboards for **Users** and **Admins**
- Real-time booking status updates
- Clear visibility of room availability and schedules

---

## 🔐 Authentication & Authorization
- Role-based access control (User / Admin)
- Secure login system
- Protected routes based on user roles

---

## 📅 Core Functionality
- Meeting room creation and configuration
- Booking management system
- Invitation workflow (Accept / Reject)
- Conflict-free scheduling of rooms

---

## 🧱 Tech Stack (Example)
- Backend: Ruby on Rails / Node.js (customizable)
- Frontend: HTML, CSS, Bootstrap / React (optional)
- Database: PostgreSQL / MySQL
- Authentication: Devise / JWT

---

## 📌 Project Goal
To provide an efficient and organized platform for managing meeting room bookings, reducing scheduling conflicts, and improving workplace productivity.

---

## 📷 Screenshots
*(Add screenshots of dashboards, booking page, and admin panel here)*
### Room Booking Page
![Room Booking](https://github.com/sudhan670/clar/blob/main/new%20room.png)

### Booking Status Page
![Booking Status](https://github.com/sudhan670/clar/blob/main/accepted-rejected.png)

### Admin Panel
![Admin Dashboard](https://github.com/sudhan670/clar/blob/main/admin.png)
![Admin Details](https://github.com/sudhan670/clar/blob/main/admin%20details.png)
---

## ⚙️ Setup Instructions
```bash
# Clone the repository
git clone https://github.com/your-username/meeting-room-booking-app.git

# Install dependencies
bundle install / npm install

# Setup database
rails db:create db:migrate db:seed

# Run the server
rails server

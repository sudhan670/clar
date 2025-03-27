# Meeting Booking System

This project is a **Room Booking System** that allows users to book rooms, check booking statuses, and manage reservations through an admin panel.

## Prerequisites

- **Ruby Version:** 3.2.2
- **System Dependencies:**
  - Ubuntu
  - Windows Linux Subsystem (WSL)
- **Database:** SQLite3

## Setup and Installation

### 1. Clone the Repository
```sh
  git clone https://github.com/sudhan670/clar.git
  cd clar
```

### 2. Install Dependencies
```sh
  bundle install
```

### 3. Database Setup
```sh
  rails db:create
  rails db:migrate
```

### 4. Run the Application
```sh
  rails server
```

## Running Tests
To run the test suite, execute:
```sh
  rspec
```

## Features
- **User Dashboard:** Users can book rooms and view their booking status.
- **Booking Status:** Real-time updates on accepted or rejected requests.
- **Admin Panel:** Administrators can view all bookings and manage reservations.
- **SQLite3 Database:** Lightweight and easy-to-use database integration.

## Screenshots

### Room Booking Page
![Room Booking](https://github.com/sudhan670/clar/blob/main/new%20room.png)

### Booking Status Page
![Booking Status](https://github.com/sudhan670/clar/blob/main/accepted-rejected.png)

### Admin Panel
![Admin Dashboard](https://github.com/sudhan670/clar/blob/main/admin.png)
![Admin Details](https://github.com/sudhan670/clar/blob/main/admin%20details.png)

## Deployment
For deploying the application, consider using **Heroku** or **AWS**. Ensure that the database configurations align with the production environment.

## Contributing
If you'd like to contribute:
1. Fork the repository
2. Create a new branch (`git checkout -b feature-branch`)
3. Commit your changes (`git commit -m 'Add new feature'`)
4. Push to the branch (`git push origin feature-branch`)
5. Open a pull request

## License
This project is licensed under the **MIT License**.

## Contact
For further inquiries, reach out at [GitHub](https://github.com/sudhan670).


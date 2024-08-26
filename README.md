# Offer Listing Mobile App

This project is a lightweight mobile application that demonstrates full-stack development skills, including frontend and backend development, database management, and API integration.

## Architecture

The project follows a clean architecture approach and consists of two main components:

1. Mobile App (Flutter)
   - Uses clean architecture with layers: presentation, domain, and data
   - Implements BLoC pattern for state management

2. Backend (Express.js with MongoDB)
   - RESTful API for offer management
   - MongoDB for data storage

## Setup Instructions

### Prerequisites

- Docker and Docker Compose
- Flutter SDK (for local development)
- Node.js and npm (for local development)

### Running the Application

1. Clone the repository:
   ```
   git clone <repository-url>
   cd <project-directory>
   ```

2. Start the application using Docker Compose:
   ```
   docker-compose up --build
   ```

3. The backend API will be available at `http://localhost:3000`

4. The mobile app will be built and available as an APK in the `mobile_app/build/app/outputs/flutter-apk/` directory.

### Local Development

For local development without Docker:

1. Backend:
   ```
   cd backend
   npm install
   npm start
   ```

2. Mobile App:
   ```
   cd mobile_app
   flutter pub get
   flutter run
   ```

## Testing

- Backend: Run `npm test` in the `backend` directory
- Mobile App: Run `flutter test` in the `mobile_app` directory

## Assumptions and Limitations

- The mobile app is currently built for Android only
- The backend assumes a simple authentication mechanism (not implemented in this version)
- Error handling and input validation are basic and can be improved

## Future Improvements

- Implement user authentication and authorization
- Add more comprehensive error handling and input validation
- Implement caching mechanisms for better performance
- Add pagination for the offer listing
- Implement push notifications for new offers

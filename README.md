# Offer Listing Mobile App

This project is a lightweight application that demonstrates full-stack development skills, including frontend and backend development, database management, and API integration.

## Screenshots

Here are some screenshots of the application:

| Login Screen | Offer List | Offer Details | Create Offer | Menu | Purchase History | Create Account |
|--------------|------------|---------------| --------------|------|------------------| --------------- |
| ![Login Screen](screenshots/login_screen.jpg) | ![Offer List](screenshots/offer_list.jpg) | ![Offer Details](screenshots/offer_details.jpg) | ![Create Offer](screenshots/create_offer.jpg) | ![Menu](screenshots/menu.jpg) | ![Purchase History](screenshots/purchase_history.jpg) | ![Create Account](screenshots/create_account.jpg) |

## Architecture

The project follows a clean architecture approach and consists of three main components:

1. Mobile App (Flutter)
   - Uses clean architecture with layers: presentation, domain, and data
   - Implements BLoC pattern for state management

2. Web Frontend (Flutter Web)
   - Shares codebase with the mobile app
   - Served via Nginx in Docker

3. Backend (Express.js with MongoDB)
   - RESTful API for offer management
   - MongoDB for data storage

## Setup Instructions

### Prerequisites

- Docker and Docker Compose
- Flutter SDK (for local mobile app development)

### Running the Application

1. Clone the repository:
   ```
   git clone https://github.com/nguyenhuutukhtn/offer_list_clean_architecture.git
   cd offer_list_clean_architecture
   ```

2. Start the entire application stack using Docker Compose:
   ```
   docker-compose up --build
   ```

3. Access the application:
   - Web Frontend: Open `http://localhost:8080` in your browser
   - Backend API: Available at `http://localhost:3000`

4. To run the Flutter mobile app for local development:
   ```
   cd mobile_app
   flutter run --dart-define=API_URL=http://localhost:3000
   ```

## Testing

### Backend
To run tests for the backend:

1. Navigate to the `backend` directory:
   ```
   cd backend
   ```

2. Install dependencies if you haven't already:
   ```
   npm install
   ```
3. Run all tests:
   ```
   npm test
   ```
4. To run specific test suites:
- Unit tests: `npm run test:unit`
- Integration tests: `npm run test:integration`
- E2E tests: `npm run test:e2e`

5. To run tests with coverage:
   ```
   npm run test:coverage
   ```
   This will generate a coverage report in the `coverage` directory.

6. To view the coverage report in your browser:
   ```
   open coverage/lcov-report/index.html
   
This will open the HTML coverage report in your default web browser.

### Troubleshooting Backend Tests

- If you encounter any TypeScript-related errors, ensure your `tsconfig.json` is properly configured and includes Jest types:
```json
{
 "compilerOptions": {
   "types": ["jest", "node"]
 }
}
```


- If you're having issues with test environment setup, check your jest.config.ts file to ensure it's correctly configured for your project structure.
- If you're using MongoDB for integration tests, ensure you have a local MongoDB instance running on port 27017.

### Mobile/Web App
To run tests for the mobile app:

1. Navigate to the `mobile_app` directory:
   ```
   cd mobile_app

2. Run all tests:
   ```
   flutter test

3. To run tests with coverage and generate a coverage report:
   ```
   ./run_test_coverage.sh

   This script will:
   - Run all tests with coverage
   - Generate an HTML coverage report
   - Attempt to open the report in your default web browser

   If the report doesn't open automatically, you can find it at `coverage/html/index.html`.

   Note: Make sure the `run_test_coverage.sh` script is executable. If it's not, run:
   ```
   chmod +x run_test_coverage.sh

4. To run a specific test file:
   ```
   flutter test test/path/to/test_file.dart
5. To run integration tests:
   ```
   flutter test integration_test

### Troubleshooting Tests

- If you encounter any issues with test coverage, ensure you have `lcov` installed on your system.
  - For macOS: `brew install lcov`
  - For Ubuntu/Debian: `sudo apt-get install lcov`

- If tests are failing due to missing dependencies, run:
  ```
  flutter pub get

- If you're using Mockito and encounter issues with generated mocks, run:
  ```
  flutter pub run build_runner build

## Assumptions and Limitations

- The web frontend and mobile app share the same codebase
- The backend uses a simple authentication mechanism with Firebase
- The project is designed for local development and demonstration purposes
- Docker setup is optimized for development, not production deployment

## Future Improvements

- Implement more comprehensive error handling and input validation
- Add caching mechanisms for better performance
- Implement pagination for the offer listing
- Add push notifications for new offers
- Enhance the UI/UX design
- Implement more advanced authentication and authorization mechanisms
- Optimize Docker setup for production deployment

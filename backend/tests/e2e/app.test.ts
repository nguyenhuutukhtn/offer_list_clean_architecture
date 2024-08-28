import request from 'supertest';
import app from '../../app';
import mongoose from 'mongoose';

describe('E2E Tests', () => {
  beforeAll(async () => {
    // Connect to a test database
    await mongoose.connect('mongodb://localhost:27017/offerDB');
  });

  afterAll(async () => {
    // Disconnect from the test database
    await mongoose.connection.close();
  });

  describe('GET /api/offers', () => {
    it('should return all offers', async () => {
      const res = await request(app).get('/api/offers');
      expect(res.status).toBe(200);
      expect(Array.isArray(res.body)).toBeTruthy();
    });
  });

  // Add more E2E tests for other endpoints
});
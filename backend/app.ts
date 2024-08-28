import "reflect-metadata";
import express from 'express';
import mongoose from 'mongoose';
import { container } from './src/injection-container';
import { OfferController } from './src/presentation/controllers/offer.controller';
import { PurchaseController } from './src/presentation/controllers/purchase.controller';
import { offerRouter } from './src/presentation/routes/offer.routes';
import * as admin from 'firebase-admin';
import cors from 'cors';

const app = express();
const PORT = process.env.PORT || 3000;

const mongoUri = process.env.MONGODB_URI || 'mongodb://localhost:27017/offerDB';

// Enable CORS for all routes
app.use(cors());

app.use(express.json());

mongoose.connect(mongoUri, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
} as mongoose.ConnectOptions);

// Initialize Firebase Admin SDK
admin.initializeApp({
  projectId: 'offer-list-project',
  databaseURL: 'https://offer-list-project-default-rtdb.firebaseio.com',
  // Add other configuration options as needed
});

// Root route
app.get('/', (req, res) => {
  res.send('Welcome to the Offer API');
});

const offerController = container.get<OfferController>(OfferController);
const purchaseController = container.get<PurchaseController>(PurchaseController);
app.use('/api/offers', offerRouter(offerController, purchaseController));

// 404 handler
app.use((req, res) => {
  res.status(404).send('404 - Not Found');
});

// Error handler
app.use((err: Error, req: express.Request, res: express.Response, next: express.NextFunction) => {
  console.error(err.stack);
  res.status(500).send('500 - Internal Server Error');
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

export default app;



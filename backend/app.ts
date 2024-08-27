import express from 'express';
import mongoose from 'mongoose';
import { container } from './injection-container';
import { OfferController } from './presentation/controllers/offer.controller';
import { offerRouter } from './presentation/routes/offer.routes';

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

mongoose.connect('mongodb://mongodb:27017/offerdb', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
} as mongoose.ConnectOptions);

const offerController = container.get<OfferController>(OfferController);
app.use('/api/offers', offerRouter(offerController));

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

export default app;
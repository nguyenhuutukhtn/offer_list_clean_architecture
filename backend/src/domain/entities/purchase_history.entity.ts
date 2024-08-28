import { Offer } from "./offer.entity";

export class PurchaseHistory {
    constructor(
      public id: string,
      public userId: string,
      public offer: Offer,
      public purchaseDate: Date
    ) {}
  }
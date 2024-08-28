export class PurchaseHistory {
    constructor(
      public id: string,
      public userId: string,
      public offerId: string,
      public purchaseDate: Date
    ) {}
  }
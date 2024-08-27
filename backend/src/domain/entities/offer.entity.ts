export class Offer {
    constructor(
      public id: string,
      public title: string,
      public description: string,
      public discountPercentage: number,
      public originalPrice: number,
      public discountedPrice: number
    ) {}
  }
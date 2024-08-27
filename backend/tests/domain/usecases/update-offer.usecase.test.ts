describe('UpdateOfferUseCase', () => {
    let updateOfferUseCase: UpdateOfferUseCase;
    let mockOfferRepository: jest.Mocked<OfferRepository>;
  
    beforeEach(() => {
      mockOfferRepository = {
        getOffers: jest.fn(),
        createOffer: jest.fn(),
        updateOffer: jest.fn(),
        deleteOffer: jest.fn(),
      };
      updateOfferUseCase = new UpdateOfferUseCase(mockOfferRepository);
    });
  
    it('should update offer when input is valid', async () => {
      const offer = new Offer('1', 'Test Offer', 'Test Description', 10, 100, 90);
      mockOfferRepository.updateOffer.mockResolvedValue(offer);
  
      const result = await updateOfferUseCase.execute(offer);
  
      expect(result).toEqual(offer);
      expect(mockOfferRepository.updateOffer).toHaveBeenCalledWith(offer);
    });
  
    it('should throw ValidationError when title is empty', async () => {
      const offer = new Offer('1', '', 'Test Description', 10, 100, 90);
  
      await expect(updateOfferUseCase.execute(offer)).rejects.toThrow(ValidationError);
      expect(mockOfferRepository.updateOffer).not.toHaveBeenCalled();
    });
  
    // Add more tests for other validation cases
  });
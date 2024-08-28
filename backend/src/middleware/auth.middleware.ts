import { Request, Response, NextFunction } from 'express';
import * as admin from 'firebase-admin';

declare global {
  namespace Express {
    interface Request {
      user?: admin.auth.DecodedIdToken;
    }
  }
}

export const authMiddleware = async (req: Request, res: Response, next: NextFunction) => {
  const authHeader = req.headers.authorization;
  if (!authHeader) {
    return res.status(401).json({ message: 'No authorization header' });
  }

  const token = authHeader.split(' ')[1];
  try {
    const decodedToken = await admin.auth().verifyIdToken(token);
    req.user = decodedToken;
    next();
  } catch (error) {
    res.status(401).json({ message: 'Invalid token' });
  }
};
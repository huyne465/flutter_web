import express from 'express';
import { authController } from '~/controllers/authController';
import { authValidation } from '~/validations/authValidation';
import passport from '~/config/passport';

const authRoutes = express.Router();
authRoutes.post('/create-user', authValidation.createUser,authController.createUser);
authRoutes.post('/login', authValidation.loginUser, authController.loginUser);
authRoutes.get('/users', authController.getAllUsers);
authRoutes.get('/user/:id', authController.getUserById);


// Google OAuth routes
authRoutes.get('/google', 
  passport.authenticate('google', { 
    scope: ['profile', 'email'] 
  })
);

authRoutes.get('/google/callback',
  passport.authenticate('google', { 
    failureRedirect: '/api/auth/google/failure',
    successRedirect: '/api/auth/google/success'
  })
);

authRoutes.get('/google/success', authController.googleSuccess);
authRoutes.get('/google/failure', authController.googleFailure);


export { authRoutes };

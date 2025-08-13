import express from 'express';
import { authController } from '~/controllers/authController';
import { authValidation } from '~/validations/authValidation';

const authRoutes = express.Router();
authRoutes.post('/create-user', authValidation.createUser,authController.createUser);
authRoutes.post('/login', authValidation.loginUser, authController.loginUser);
authRoutes.get('/users', authController.getAllUsers);
authRoutes.get('/user/:id', authController.getUserById);

export { authRoutes };

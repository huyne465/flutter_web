import Joi from "joi";

const createUser = async (req, res, next) => {
    // Debug middleware
    console.log('Validation - Request body:', req.body)
    console.log('Validation - Content-Type:', req.headers['content-type'])
    
    const correctCondition = Joi.object({
        userName: Joi.string().min(3).max(30).required().trim().strict(),
        password: Joi.string().min(6).max(50).required().strict(),
        email: Joi.string().email().required().trim().strict(),
        displayName: Joi.string().min(3).max(50).trim().strict().optional(), // Thêm .optional()
        fullName: Joi.string().min(3).max(50).trim().strict().optional(), // Thêm .optional()
    });
    try {
        await correctCondition.validateAsync(req.body);
        next();
    } catch (error) {
       const errorMessage = new Error(error.message).message
    const customError = new Error(errorMessage)
    customError.statusCode = 422
    next(customError)
    }
}

const loginUser = async (req, res, next) => {
    const correctCondition = Joi.object({
        userName: Joi.string().min(3).max(30).required().trim().strict(),
        password: Joi.string().min(6).max(50).required().strict(),
    });
    try {
        await correctCondition.validateAsync(req.body);
        next();
    } catch (error) {
       const errorMessage = new Error(error.message).message
    const customError = new Error(errorMessage)
    customError.statusCode = 422
    next(customError)
    }
}

export const authValidation = {
    createUser,
    loginUser
}
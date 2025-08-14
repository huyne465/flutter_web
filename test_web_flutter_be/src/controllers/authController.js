import { authService } from "~/services/authService";

// Controller for handling authentication routes
const createUser = async (req, res) => {
  try {
    // Debug: log request body
    console.log('Request body:', req.body)
    console.log('Request headers:', req.headers)
    
    const { userName, password, email, displayName, fullName } = req.body;

    // Kiểm tra xem req.body có tồn tại không
    if (!req.body || Object.keys(req.body).length === 0) {
      return res.status(400).json({ 
        error: "Request body is empty", 
        success: false,
        message: "Please provide user data"
      });
    }

    const existingUserByUserName = await authService.findByUserName(userName);
    if (existingUserByUserName) {
      return res.status(400).json({ error: "Username already exists", success: false });
    }

    const existingUserByEmail = await authService.findByEmail(email);
    if (existingUserByEmail) {
      return res.status(400).json({ error: "Email already exists", success: false });
    }

    const newUser = await authService.createNew({
      userName,
      password,
      email,
      displayName: displayName || userName, // Default to userName if displayName is not provided
      fullName: fullName || userName, // Default to userName if fullName is not provided
    });

    return res.status(201).json({ data: newUser, success: true, message: "User created successfully" });
  } catch (error) {
    console.error("Error creating user:", error);
    return res.status(500).json({ error: error.message, success: false, message: "Failed to create user" });
  }
}

// Controller for handling user login
const loginUser = async (req, res) => {
    try {
        const { userName, password } = req.body;

        const user = await authService.findByUserName(userName);
        if (!user) {
            return res.status(404).json({ error: "User not found", success: false, message: "Invalid username or password" });
        }

        //check password
        const isPasswordValid = await user.comparePassword(password);
        if (!isPasswordValid) {
            return res.status(401).json({ error: "Invalid credentials", success: false, message: "Invalid username or password" });
        }
        
        //check if user's account is active
        if (!user.isActive) {
            return res.status(403).json({ error: "User is inactive", success: false, message: "User account is inactive" });
        }

        const {password: userPassword, ...userResponse} = user.toObject();

        res.status(200).json({
            data: userResponse,
            success: true,
            message: "Login successful"
        });
    } catch (error) {
        console.error("Login error:", error);
        return res.status(500).json({ error: error.message, success: false, message: "Failed to login user" });
    }
}

//controller for getting all users

const getAllUsers = async (req, res) => {
  try {
    const users = await authService.getAllUsers();
    return res.status(200).json({ data: users, success: true, message: "Lấy danh sách người dùng thành công!" });
  } catch (error) {
    console.error("Error retrieving users:", error);
    return res.status(500).json({ error: error.message, success: false, message: "Lấy danh sách người dùng thất bại!" });
  }
}


// Controller for getting user by ID
const getUserById = async (req, res) => {
  try {
    const { id } = req.params;
    const user = await authService.getDetails(id);
    
    if (!user) {
      return res.status(404).json({ error: "User not found", success: false, message: "Không tìm thấy người dùng!" });
    }

    return res.status(200).json({ data: user, success: true, message: "Lấy thông tin người dùng thành công!" });
  } catch (error) {
    console.error("Error retrieving user:", error);
    return res.status(500).json({ error: error.message, success: false, message: "Lấy thông tin người dùng thất bại!" });
  }
}



// Google OAuth Success
const googleSuccess = async (req, res) => {
  try {
    const user = req.user
    if (!user) {
      return res.status(401).json({
        success: false,
        message: 'Google authentication failed'
      })
    }

    // Generate JWT token
    const token = jwtUtils.generateJWT(user)

    // Remove sensitive data
    const { password, googleId, ...userResponse } = user.toObject()

    // Redirect to frontend with token
    res.redirect(`http://localhost:8080/auth/success?token=${token}&user=${encodeURIComponent(JSON.stringify(userResponse))}`)
    
  } catch (error) {
    console.error('Google auth success error:', error)
    res.redirect('http://localhost:8080/auth/error?message=Authentication failed')
  }
}

// Google OAuth Failure
const googleFailure = (req, res) => {
  res.redirect('http://localhost:8080/auth/error?message=Google authentication failed')
}


export const authController = {
  createUser,
  loginUser,
  getAllUsers,
  getUserById,
  googleSuccess,
  googleFailure
};



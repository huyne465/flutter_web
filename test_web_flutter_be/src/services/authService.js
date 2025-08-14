import User from "~/models/user"


// Tạo mới người dùng
const createNew = async (userData) => {
  try {
    const user = new User(userData)
    const savedUser = await user.save()
    // Loại bỏ password khỏi response
    const { password, ...userResponse } = savedUser.toObject()
    return userResponse
  } catch (error) {
    throw error
  }
}

// Lấy tất cả người dùng
const getAllUsers = async () => {
  try {
    return await User.find({}, { password: 0 }) // Loại bỏ password
  } catch (error) {
    throw error
  }
}

// Tìm người dùng theo username (KHÔNG loại bỏ password để login)
const findByUserName = async (userName) => {
  try {
    return await User.findOne({ userName }) // KHÔNG loại bỏ password để có thể login
  } catch (error) {
    throw error
  }
}

// Tìm người dùng theo email (KHÔNG loại bỏ password để login)
const findByEmail = async (email) => {
  try {
    return await User.findOne({ email }) // KHÔNG loại bỏ password để có thể login
  } catch (error) {
    throw error
  }
}

const getDetails = async (id) => {
  try {
    return await User.findById(id, { password: 0 }) // Loại bỏ password
  } catch (error) {
    throw error
  }
}


// Tìm user theo Google ID
const findByGoogleId = async (googleId) => {
  try {
    return await User.findOne({ googleId })
  } catch (error) {
    throw error
  }
}

// Tạo user từ Google profile
const createFromGoogle = async (googleProfile) => {
  try {
    const userData = {
      googleId: googleProfile.id,
      email: googleProfile.emails[0].value,
      displayName: googleProfile.displayName,
      fullName: `${googleProfile.name.givenName} ${googleProfile.name.familyName}`,
      avatar: googleProfile.photos[0]?.value,
      provider: 'google',
      isActive: true
    }

    const user = new User(userData)
    const savedUser = await user.save()
    
    // Loại bỏ password khỏi response (nếu có)
    const { password, ...userResponse } = savedUser.toObject()
    return userResponse
  } catch (error) {
    throw error
  }
}

export const authService = {
  createNew,
  getAllUsers,
  getDetails,
  findByUserName,
  findByEmail,
  findByGoogleId,
  createFromGoogle
}
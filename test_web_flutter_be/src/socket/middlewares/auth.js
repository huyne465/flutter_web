import { jwtUtils } from '~/utils/jwt'
import User from '~/models/user'

// Socket Authentication Middleware
export const socketAuth = async (socket, next) => {
  try {
    console.log('🔐 Socket Auth Middleware - Authenticating socket:', socket.id)
    
    // Lấy token từ handshake auth hoặc query
    const token = socket.handshake.auth?.token || socket.handshake.query?.token
    
    if (!token) {
      console.log('❌ No token provided for socket:', socket.id)
      return next(new Error('Authentication error: No token provided'))
    }

    // Verify JWT token
    const decoded = jwtUtils.verifyJWT(token)
    if (!decoded) {
      console.log('❌ Invalid token for socket:', socket.id)
      return next(new Error('Authentication error: Invalid token'))
    }

    // Lấy user từ database
    const user = await User.findById(decoded.id).select('-password')
    if (!user) {
      console.log('❌ User not found for socket:', socket.id)
      return next(new Error('Authentication error: User not found'))
    }

    if (!user.isActive) {
      console.log('❌ User inactive for socket:', socket.id)
      return next(new Error('Authentication error: User account is inactive'))
    }

    // Attach user to socket object
    socket.user = user
    socket.userId = user._id.toString()
    
    console.log('✅ Socket authenticated successfully:', socket.id, 'User:', user.userName)
    next()
    
  } catch (error) {
    console.error('❌ Socket auth error:', error.message)
    next(new Error('Authentication error: ' + error.message))
  }
}

// Optional: Guest access middleware (cho anonymous users)
export const socketGuestAuth = (socket, next) => {
  console.log('🔓 Socket Guest Access for:', socket.id)
  
  // Tạo guest user object
  socket.user = {
    _id: null,
    userName: `Guest_${socket.id.substring(0, 8)}`,
    displayName: 'Guest User',
    isGuest: true
  }
  socket.userId = socket.id
  
  next()
}

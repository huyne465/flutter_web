import { socketAuth, socketGuestAuth } from './middlewares/auth.js'
import { socketLogger } from './middlewares/logger.js'
import { socketRateLimit } from './middlewares/rateLimit.js'
import { chatHandlers } from './handlers/chat.js'
import { userHandlers } from './handlers/user.js'

export const initializeSocket = (io) => {
  // Apply global middlewares
  io.use(socketLogger)
  io.use(socketRateLimit)

  // Handle connections
  io.on('connection', (socket) => {
    console.log(`🔌 New socket connection: ${socket.id}`)

    // Handle authentication
    socket.on('authenticate', async (data) => {
      try {
        await socketAuth(socket, data)
        
        // After successful authentication, setup authenticated handlers
        chatHandlers(socket, io)
        userHandlers(socket, io)
        
        socket.emit('auth_success', {
          message: 'Authentication successful',
          user: {
            id: socket.user._id,
            userName: socket.user.userName,
            displayName: socket.user.displayName,
            email: socket.user.email
          }
        })

        console.log(`✅ User ${socket.user.userName} authenticated successfully`)
        
      } catch (error) {
        socket.emit('auth_error', { 
          message: error.message || 'Authentication failed' 
        })
        console.log(`❌ Authentication failed for socket ${socket.id}: ${error.message}`)
      }
    })

    // Handle guest access (limited functionality)
    socket.on('guest_access', async () => {
      try {
        await socketGuestAuth(socket)
        
        // Setup limited guest handlers (read-only chat, etc.)
        socket.emit('guest_access_granted', {
          message: 'Guest access granted',
          limitations: ['No chat sending', 'Read-only access']
        })

        console.log(`👤 Guest access granted for socket ${socket.id}`)
        
      } catch (error) {
        socket.emit('guest_access_denied', { 
          message: error.message || 'Guest access denied' 
        })
      }
    })

    // Handle disconnect
    socket.on('disconnect', (reason) => {
      console.log(`🔌 Socket ${socket.id} disconnected: ${reason}`)
      
      if (socket.user) {
        console.log(`👋 User ${socket.user.userName} disconnected`)
      }
    })

    // Handle errors
    socket.on('error', (error) => {
      console.error(`❌ Socket error for ${socket.id}:`, error)
    })
  })

  console.log('🚀 Socket.IO server initialized successfully')
}

// Lưu trữ các rooms và users (trong production nên dùng Redis)
const chatRooms = new Map()
const userSockets = new Map()

export const chatHandlers = (socket, io) => {
  
  // Join chat room
  socket.on('join_room', async (data) => {
    try {
      console.log(`📥 User ${socket.user.userName} joining room:`, data.roomId)
      
      const { roomId } = data
      if (!roomId) {
        return socket.emit('error', { type: 'INVALID_ROOM', message: 'Room ID is required' })
      }

      // Leave current rooms first
      Array.from(socket.rooms).forEach(room => {
        if (room !== socket.id) {
          socket.leave(room)
        }
      })

      // Join new room
      await socket.join(roomId)
      
      // Track user in room
      if (!chatRooms.has(roomId)) {
        chatRooms.set(roomId, new Set())
      }
      chatRooms.get(roomId).add(socket.userId)
      userSockets.set(socket.userId, socket.id)

      // Notify room about new user
      socket.to(roomId).emit('user_joined', {
        userId: socket.userId,
        userName: socket.user.userName,
        displayName: socket.user.displayName,
        timestamp: new Date().toISOString()
      })

      // Send room info to user
      const roomUsers = Array.from(chatRooms.get(roomId) || [])
      socket.emit('room_joined', {
        roomId,
        users: roomUsers,
        message: `Joined room ${roomId} successfully`
      })

      console.log(`✅ User ${socket.user.userName} joined room ${roomId}`)
      
    } catch (error) {
      console.error('❌ Error joining room:', error)
      socket.emit('error', { type: 'JOIN_ROOM_ERROR', message: error.message })
    }
  })

  // Send chat message
  socket.on('send_message', async (data) => {
    try {
      const { roomId, message, messageType = 'text' } = data
      
      if (!roomId || !message) {
        return socket.emit('error', { type: 'VALIDATION_ERROR', message: 'Room ID and message are required' })
      }

      const messageData = {
        id: `msg_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
        roomId,
        message,
        messageType,
        sender: {
          id: socket.userId,
          userName: socket.user.userName,
          displayName: socket.user.displayName,
          avatar: socket.user.avatar
        },
        timestamp: new Date().toISOString(),
        status: 'sent'
      }

      // Broadcast message to room
      io.to(roomId).emit('new_message', messageData)
      
      console.log(`💬 Message sent in room ${roomId} by ${socket.user.userName}`)
      
    } catch (error) {
      console.error('❌ Error sending message:', error)
      socket.emit('error', { type: 'SEND_MESSAGE_ERROR', message: error.message })
    }
  })

  // Typing indicators
  socket.on('typing_start', (data) => {
    socket.to(data.roomId).emit('user_typing', {
      userId: socket.userId,
      userName: socket.user.userName,
      isTyping: true
    })
  })

  socket.on('typing_stop', (data) => {
    socket.to(data.roomId).emit('user_typing', {
      userId: socket.userId,
      userName: socket.user.userName,
      isTyping: false
    })
  })

  // Leave room
  socket.on('leave_room', (data) => {
    const { roomId } = data
    socket.leave(roomId)
    
    // Remove user from room tracking
    if (chatRooms.has(roomId)) {
      chatRooms.get(roomId).delete(socket.userId)
      if (chatRooms.get(roomId).size === 0) {
        chatRooms.delete(roomId)
      }
    }

    socket.to(roomId).emit('user_left', {
      userId: socket.userId,
      userName: socket.user.userName,
      timestamp: new Date().toISOString()
    })

    console.log(`👋 User ${socket.user.userName} left room ${roomId}`)
  })

  // Handle disconnect
  socket.on('disconnect', () => {
    // Remove user from all rooms
    for (const [roomId, users] of chatRooms.entries()) {
      if (users.has(socket.userId)) {
        users.delete(socket.userId)
        socket.to(roomId).emit('user_left', {
          userId: socket.userId,
          userName: socket.user.userName,
          timestamp: new Date().toISOString()
        })
        
        if (users.size === 0) {
          chatRooms.delete(roomId)
        }
      }
    }
    
    userSockets.delete(socket.userId)
  })
}

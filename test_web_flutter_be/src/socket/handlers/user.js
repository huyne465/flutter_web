// Track online users
const onlineUsers = new Map()

export const userHandlers = (socket, io) => {
  
  // User comes online
  socket.on('user_online', () => {
    onlineUsers.set(socket.userId, {
      socketId: socket.id,
      userName: socket.user.userName,
      displayName: socket.user.displayName,
      status: 'online',
      lastSeen: new Date().toISOString()
    })

    // Broadcast user online status
    socket.broadcast.emit('user_status_changed', {
      userId: socket.userId,
      userName: socket.user.userName,
      status: 'online',
      timestamp: new Date().toISOString()
    })

    console.log(`🟢 User ${socket.user.userName} is now online`)
  })

  // Update user status
  socket.on('update_status', (data) => {
    const { status } = data // online, away, busy, offline
    
    if (onlineUsers.has(socket.userId)) {
      onlineUsers.get(socket.userId).status = status
      onlineUsers.get(socket.userId).lastSeen = new Date().toISOString()
    }

    socket.broadcast.emit('user_status_changed', {
      userId: socket.userId,
      userName: socket.user.userName,
      status,
      timestamp: new Date().toISOString()
    })

    console.log(`📊 User ${socket.user.userName} status updated to: ${status}`)
  })

  // Get online users
  socket.on('get_online_users', () => {
    const users = Array.from(onlineUsers.values()).map(user => ({
      userId: user.userId,
      userName: user.userName,
      displayName: user.displayName,
      status: user.status,
      lastSeen: user.lastSeen
    }))

    socket.emit('online_users_list', { users })
  })

  // Handle disconnect
  socket.on('disconnect', () => {
    if (onlineUsers.has(socket.userId)) {
      onlineUsers.delete(socket.userId)
      
      socket.broadcast.emit('user_status_changed', {
        userId: socket.userId,
        userName: socket.user.userName,
        status: 'offline',
        timestamp: new Date().toISOString()
      })

      console.log(`🔴 User ${socket.user.userName} went offline`)
    }
  })
}

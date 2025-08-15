// Socket Logging Middleware
export const socketLogger = (socket, next) => {
  const timestamp = new Date().toISOString()
  const userInfo = socket.user ? 
    `User: ${socket.user.userName} (${socket.user._id})` : 
    'Unauthenticated'
  
  console.log(`📡 [${timestamp}] Socket Connected: ${socket.id} | ${userInfo}`)
  
  // Log tất cả events từ client
  const originalEmit = socket.emit
  socket.emit = function(...args) {
    console.log(`📤 [${timestamp}] Socket ${socket.id} EMIT:`, args[0], args.slice(1))
    return originalEmit.apply(socket, args)
  }

  // Log khi socket disconnect
  socket.on('disconnect', (reason) => {
    console.log(`📡 [${new Date().toISOString()}] Socket Disconnected: ${socket.id} | Reason: ${reason} | ${userInfo}`)
  })

  next()
}

// Event-specific logger
export const logSocketEvent = (eventName) => {
  return (socket, next) => {
    socket.onAny((event, ...args) => {
      if (event === eventName) {
        console.log(`🎯 [${new Date().toISOString()}] Socket ${socket.id} Event: ${event}`, args)
      }
    })
    next()
  }
}

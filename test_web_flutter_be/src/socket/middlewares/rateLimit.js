// Socket Rate Limiting Middleware
const userEventCounts = new Map()
const RATE_LIMIT_WINDOW = 60 * 1000 // 1 minute
const MAX_EVENTS_PER_WINDOW = 100 // Max 100 events per minute

export const socketRateLimit = (socket, next) => {
  const userId = socket.userId || socket.id
  const now = Date.now()
  
  // Initialize user rate limit data
  if (!userEventCounts.has(userId)) {
    userEventCounts.set(userId, {
      count: 0,
      windowStart: now
    })
  }

  const userLimit = userEventCounts.get(userId)
  
  // Reset window if expired
  if (now - userLimit.windowStart > RATE_LIMIT_WINDOW) {
    userLimit.count = 0
    userLimit.windowStart = now
  }

  // Check rate limit on any event
  socket.onAny((event, ...args) => {
    userLimit.count++
    
    if (userLimit.count > MAX_EVENTS_PER_WINDOW) {
      console.log(`⚠️ Rate limit exceeded for socket ${socket.id} (${userId})`)
      socket.emit('error', {
        type: 'RATE_LIMIT_EXCEEDED',
        message: 'Too many events. Please slow down.',
        retryAfter: RATE_LIMIT_WINDOW - (now - userLimit.windowStart)
      })
      return false // Block the event
    }
  })

  next()
}

// Cleanup expired rate limit data
setInterval(() => {
  const now = Date.now()
  for (const [userId, data] of userEventCounts.entries()) {
    if (now - data.windowStart > RATE_LIMIT_WINDOW * 2) {
      userEventCounts.delete(userId)
    }
  }
}, RATE_LIMIT_WINDOW)

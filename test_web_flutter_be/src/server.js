
import express from 'express'
import { CONNECT_DB, CLOSE_DB } from '~/config/database'
import { env } from '~/config/config'
import { authRoutes } from '~/routes/v1/auth' // Ensure this path matches your project structure
import cors from 'cors'

const START_SERVER = () => {
  const app = express()

  const hostname = env.APP_HOST
  const port = env.APP_PORT

  // Cấu hình CORS trước tiên
const cors = require('cors');

// Allow requests from your Flutter web app
app.use(cors({
  origin: ['http://localhost:8080', 'http://127.0.0.1:8080'],
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: true
}));

  // Middleware để parse JSON
  app.use(express.json())
  app.use(express.urlencoded({ extended: true }))

  // Test route
  app.get('/api/auth/test', (req, res) => { 
    res.json({
      message: '✅ Connected to MongoDB successfully!',
      endpoints: {
        createUser: 'POST /api/auth/create-user',
        login: 'POST /api/auth/login',
        getUsers: 'GET /api/auth/users',
        getUser: 'GET /api/auth/user/:id'
      }
    })
  })

  // API Routes - đặt TRƯỚC error handling middleware
  app.use('/api/auth', authRoutes)

  // Error handling middleware - đặt CUỐI CÙNG
  app.use((error, req, res, next) => {
    const statusCode = error.statusCode || 500
    res.status(statusCode).json({
      success: false,
      message: error.message || 'Internal Server Error',
      stack: process.env.NODE_ENV === 'development' ? error.stack : undefined
    })
  })

  app.listen(port, hostname, () => {
    // eslint-disable-next-line no-console
    console.log(`🚀 Hello ${env.DATABASE_NAME}, Server is running at http://${hostname}:${port}/`)
  })

  // Xử lý khi tắt server
  process.on('SIGINT', async () => {
    console.log('🔄 Shutting down server...')
    await CLOSE_DB()
    process.exit(0)
  })
}

// Khởi chạy server sau khi kết nối database thành công
// IIFE - Immediately Invoked Function Expression
;(async () => {
  try {
    console.log('🔗 Connecting to MongoDB...')
    await CONNECT_DB()
    START_SERVER()
  } catch (error) {
    console.error('❌ Error connecting to MongoDB:', error)
    process.exit(1)
  }
})()

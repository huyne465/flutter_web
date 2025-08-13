
import mongoose from 'mongoose'
import { env } from '~/config/config'

export const MONGODB_URI = env.MONGODB_URI
export const DATABASE_NAME = env.DATABASE_NAME

// Biến để lưu Database instance sau khi kết nối thành công tới MongoDB
let DatabaseInstance = null

// Kết nối Database
export const CONNECT_DB = async () => {
  // Gọi kết nối tới MongoDB Atlas với Mongoose
  try {
    console.log('🔗 Connecting to MongoDB Atlas...')
    
    // Kết nối đến MongoDB bằng Mongoose
    await mongoose.connect(MONGODB_URI, {
      dbName: DATABASE_NAME
    })

    // Lưu lại Database instance sau khi kết nối thành công
    DatabaseInstance = mongoose.connection.db
    console.log('✅ Connected successfully to MongoDB!')
    
  } catch (error) {
    console.error('❌ Error connecting to MongoDB Atlas:', error)
    throw new Error(error)
  }
}

// Function GET_DB (không async) sẽ return về Database instance sau khi đã kết nối thành công tới MongoDB để sử dụng ở nhiều nơi khác nhau trong dự án.
// Lưu ý phải đảm bảo chỉ luôn gọi hàm GET_DB này sau khi đã kết nối thành công tới Database
export const GET_DB = () => {
  if (!DatabaseInstance) throw new Error('Must connect to Database first!')
  return DatabaseInstance
}

// Đóng kết nối database khi cần thiết
export const CLOSE_DB = async () => {
  console.log('🔄 Closing database connection...')
  await mongoose.connection.close()
}

import mongoose from 'mongoose' // Thay thế require
import bcrypt from 'bcryptjs' // Thay thế require

const userSchema = new mongoose.Schema({
  userName: {
    type: String,
    required: function() {
      return !this.googleId
    },
    unique: true,
    trim: true,
    sparse: true,
    minlength: 3,
    maxlength: 30
  },
  password: {
    type: String,
    required: function() {
      return !this.googleId
    },
    minlength: 6,
  },
  email: {
    type: String,
    required: true,
    unique: true
  },
  googleId: {
    type: String,
    unique: true,
    sparse: true
  },
  avatar: String,
  provider:{
    type: String,
    enum: ['google', 'local'],
    default: 'local'
  },
  userID: String,
  displayName: String,
  fullName: String,
  isActive: {
    type: Boolean,
    default: true
  }
}, {
  timestamps: true
});

userSchema.pre('save', async function(next) {
  if (this.password && this.isModified('password')) { // Thêm check password exists
    this.password = await bcrypt.hash(this.password, 12);
  }
  next();
});

userSchema.methods.comparePassword = async function(candidatePassword) {
  if (!this.password) return false; // Thêm check password exists
  return await bcrypt.compare(candidatePassword, this.password);
};

const User = mongoose.model('User', userSchema);

export { userSchema }
export default User;
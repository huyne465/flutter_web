import { required } from 'joi';

const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

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
  if (!this.isModified('password')) return next();
  this.password = await bcrypt.hash(this.password, 12);
  next();
});

userSchema.methods.comparePassword = async function(candidatePassword) {
  return await bcrypt.compare(candidatePassword, this.password);
};

const User = mongoose.model('User', userSchema);

export { userSchema }
export default User;


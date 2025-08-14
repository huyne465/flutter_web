import passport from 'passport'
import { Strategy as GoogleStrategy } from 'passport-google-oauth20'
import User from '~/models/user'
import { env } from '~/config/config'

// Google OAuth Strategy
passport.use(new GoogleStrategy({
  clientID: process.env.GOOGLE_CLIENT_ID,
  clientSecret: process.env.GOOGLE_CLIENT_SECRET,
  callbackURL: process.env.CALL_BACK
}, async (accessToken, refreshToken, profile, done) => {
  try {
    // Kiểm tra user đã tồn tại chưa
    let existingUser = await User.findOne({ googleId: profile.id })
    
    if (existingUser) {
      return done(null, existingUser)
    }

    // Kiểm tra email đã được sử dụng chưa
    existingUser = await User.findOne({ email: profile.emails[0].value })
    
    if (existingUser) {
      // Link Google account với account hiện có
      existingUser.googleId = profile.id
      existingUser.provider = 'google'
      existingUser.avatar = profile.photos[0]?.value
      await existingUser.save()
      return done(null, existingUser)
    }

    // Tạo user mới
    const newUser = new User({
      googleId: profile.id,
      email: profile.emails[0].value,
      displayName: profile.displayName,
      fullName: profile.name.givenName + ' ' + profile.name.familyName,
      avatar: profile.photos[0]?.value,
      provider: 'google',
      isActive: true
    })

    const savedUser = await newUser.save()
    return done(null, savedUser)
    
  } catch (error) {
    return done(error, null)
  }
}))

// Serialize user
passport.serializeUser((user, done) => {
  done(null, user._id)
})

// Deserialize user
passport.deserializeUser(async (id, done) => {
  try {
    const user = await User.findById(id)
    done(null, user)
  } catch (error) {
    done(error, null)
  }
})

export default passport
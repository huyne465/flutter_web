import jwt from 'jsonwebtoken'

const generateJWT = (user) => {
  const payload = {
    id: user._id,
    email: user.email,
    userName: user.userName,
    displayName: user.displayName,
    provider: user.provider
  }

  return jwt.sign(payload, process.env.JWT_SECRET, {
    expiresIn: '7d'
  })
}

const verifyJWT = (token) => {
  try {
    return jwt.verify(token, process.env.JWT_SECRET)
  } catch (error) {
    return null
  }
}

export const jwtUtils = {
  generateJWT,
  verifyJWT
}
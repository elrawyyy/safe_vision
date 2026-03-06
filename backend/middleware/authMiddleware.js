const jwt = require('jsonwebtoken');
const mongoose = require('mongoose');

const protect = async (req, res, next) => {
    let token;

    if (
        req.headers.authorization &&
        req.headers.authorization.startsWith('Bearer')
    ) {
        try {
            // Get token from header
            token = req.headers.authorization.split(' ')[1];

            // Verify token
            const decoded = jwt.verify(token, process.env.JWT_SECRET);

            // We stored the mongo _id in the token payload (`id` key in jwt)
            const tokenMongoId = new mongoose.Types.ObjectId(decoded.id);

            // Get user from the token by checking both admin and security collections
            let currentUser = await mongoose.connection.db.collection('admin').findOne({ _id: tokenMongoId });
            let currentRole = 'admin';

            if (!currentUser) {
                currentUser = await mongoose.connection.db.collection('security').findOne({ _id: tokenMongoId });
                currentRole = 'employee';
            }

            if (currentUser) {
                req.user = {
                    _id: currentUser._id,
                    id: currentUser.id,
                    role: currentRole
                };
                next();
            } else {
                res.status(401).json({ message: 'User associated with token no longer exists' });
            }
        } catch (error) {
            res.status(401).json({ message: 'Not authorized, token failed' });
        }
    }

    if (!token) {
        res.status(401).json({ message: 'Not authorized, no token' });
    }
};

// Optional: Middleware to check role (e.g., admin only)
const admin = (req, res, next) => {
    if (req.user && req.user.role === 'admin') {
        next();
    } else {
        res.status(403).json({ message: 'Not authorized as an admin' });
    }
};

module.exports = { protect, admin };

const jwt = require('jsonwebtoken');
const mongoose = require('mongoose');

// Generate JWT Token
const generateToken = (id) => {
    return jwt.sign({ id }, process.env.JWT_SECRET, {
        expiresIn: '30d',
    });
};

// @desc    Register a new user
// @route   POST /api/auth/register
// @access  Public
const registerUser = async (req, res) => {
    try {
        const { id, password, role } = req.body;

        // Determine target collection
        const targetRole = role === 'admin' ? 'admin' : 'security';
        const collection = mongoose.connection.db.collection(targetRole);

        // Check if user exists in the target collection
        const userExists = await collection.findOne({ id: String(id) });

        if (userExists) {
            return res.status(400).json({ message: 'User already exists' });
        }

        // Create user object matching existing schema
        const newUser = {
            id: String(id),
            password: String(password) // Plaintext
        };

        const result = await collection.insertOne(newUser);

        if (result.acknowledged) {
            res.status(201).json({
                _id: result.insertedId,
                id: newUser.id,
                role: role || 'employee',
                token: generateToken(result.insertedId),
            });
        } else {
            res.status(400).json({ message: 'Invalid user data' });
        }
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// @desc    Auth user & get token
// @route   POST /api/auth/login
// @access  Public
const loginUser = async (req, res) => {
    try {
        const { email, password } = req.body; // Flutter still sends {email: id, password: pass}
        const idToCheck = email; // Map it to the custom ID logic

        const adminCollection = mongoose.connection.db.collection('admin');
        const securityCollection = mongoose.connection.db.collection('security');

        // 1. Check admin collection
        let user = await adminCollection.findOne({ id: String(idToCheck) });
        let role = 'admin';

        // 2. If not found in admin, check security collection
        if (!user) {
            user = await securityCollection.findOne({ id: String(idToCheck) });
            role = 'employee';
        }

        // 3. Verify plaintext password
        if (user && user.password === String(password)) {
            res.json({
                _id: user._id,
                id: user.id,
                role: role,
                token: generateToken(user._id),
            });
        } else {
            res.status(401).json({ message: 'Invalid ID or password' });
        }
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

module.exports = {
    registerUser,
    loginUser,
};

require('dotenv').config({ path: '../.env' });
const mongoose = require('mongoose');
const User = require('../models/User');
const connectDB = require('../config/db');

// Fallback to local MongoDB for quick testing if .env isn't set up yet
const MONGO_URI = process.env.MONGODB_URI || 'mongodb://127.0.0.1:27017/safe_vision';

const seedUser = async () => {
    try {
        // Override mongoose connect behavior locally just for this script
        await mongoose.connect(MONGO_URI);
        console.log('Connected to Database for Seeding.');

        // Clear existing
        await User.deleteMany();

        const createdUser = await User.create({
            name: 'Admin Test',
            email: 'admin@test.com',
            password: 'password123',
            role: 'admin'
        });

        console.log('Seeded User Successfully:');
        console.log(`ID/Email: ${createdUser.email}`);
        console.log(`Password: password123`);
        console.log(`Role: ${createdUser.role}`);

        process.exit(0);
    } catch (error) {
        console.error('Error seeding user:', error);
        process.exit(1);
    }
};

seedUser();

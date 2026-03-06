const express = require('express');
const router = express.Router();
const { getUsers, getUserById, deleteUser } = require('../controllers/userController');
const { protect, admin } = require('../middleware/authMiddleware');

router.route('/')
    .get(protect, getUsers);

router.route('/:id')
    .get(protect, getUserById)
    // Optional: Add `admin` middleware here if only admins should delete users e.g. .delete(protect, admin, deleteUser)
    .delete(protect, deleteUser);

module.exports = router;

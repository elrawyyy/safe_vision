const mongoose = require('mongoose');

// @desc    Get all users
// @route   GET /api/users
// @access  Private
const getUsers = async (req, res) => {
    try {
        const adminCollection = mongoose.connection.db.collection('admin');
        const securityCollection = mongoose.connection.db.collection('security');

        const admins = await adminCollection.find({}).toArray();
        const security = await securityCollection.find({}).toArray();

        // Map to include role manually
        const mappedAdmins = admins.map(u => ({ ...u, role: 'admin' }));
        const mappedSecurity = security.map(u => ({ ...u, role: 'employee' }));

        const allUsers = [...mappedAdmins, ...mappedSecurity];
        // Strip passwords before returning
        const safeUsers = allUsers.map(({ password, ...rest }) => rest);

        res.json(safeUsers);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// @desc    Get user by ID
// @route   GET /api/users/:id
// @access  Private
const getUserById = async (req, res) => {
    try {
        const reqId = req.params.id;

        // First check by the custom `id` field
        let user = await mongoose.connection.db.collection('admin').findOne({ id: String(reqId) });
        let role = 'admin';

        if (!user) {
            user = await mongoose.connection.db.collection('security').findOne({ id: String(reqId) });
            role = 'employee';
        }

        // Fallback: check by Mongo _id if not found by custom id
        if (!user && mongoose.Types.ObjectId.isValid(reqId)) {
            const objId = new mongoose.Types.ObjectId(reqId);
            user = await mongoose.connection.db.collection('admin').findOne({ _id: objId });
            if (!user) {
                user = await mongoose.connection.db.collection('security').findOne({ _id: objId });
                role = 'employee';
            }
        }

        if (user) {
            const { password, ...safeUser } = user;
            safeUser.role = role;
            res.json(safeUser);
        } else {
            res.status(404).json({ message: 'User not found' });
        }
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

// @desc    Delete user
// @route   DELETE /api/users/:id
// @access  Private (Admin only logic can be applied via middleware)
const deleteUser = async (req, res) => {
    try {
        const reqId = req.params.id;
        let result = await mongoose.connection.db.collection('admin').deleteOne({ id: String(reqId) });

        if (result.deletedCount === 0) {
            result = await mongoose.connection.db.collection('security').deleteOne({ id: String(reqId) });
        }

        if (result.deletedCount === 0 && mongoose.Types.ObjectId.isValid(reqId)) {
            const objId = new mongoose.Types.ObjectId(reqId);
            result = await mongoose.connection.db.collection('admin').deleteOne({ _id: objId });
            if (result.deletedCount === 0) {
                result = await mongoose.connection.db.collection('security').deleteOne({ _id: objId });
            }
        }

        if (result.deletedCount > 0) {
            res.json({ message: 'User removed successfully' });
        } else {
            res.status(404).json({ message: 'User not found' });
        }
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};

module.exports = {
    getUsers,
    getUserById,
    deleteUser,
};

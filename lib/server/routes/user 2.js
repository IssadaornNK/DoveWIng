const express = require('express');
const router = express.Router();
const User = require('../models/User');
const auth = require('../middleware/auth');

// Route to get user email
router.get('/email', auth, async (req, res) => {
  try {
    const user = await User.findById(req.user.id).select('email');
    if (!user) {
      return res.status(404).json({ msg: 'User not found' });
    }
    res.json({ email: user.email });
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server Error');
  }
});

module.exports = router;

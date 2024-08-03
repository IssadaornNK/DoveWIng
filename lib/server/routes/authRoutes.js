module.exports = (connection, bcrypt, jwt, secretKey) => {
  const express = require("express");
  const router = express.Router();

  // Register a new user
  router.post("/Register", (req, res) => {
    const { Username, Email, Password } = req.body;

    if (!Username || !Email || !Password) {
      return res
        .status(400)
        .json({ message: "Username, Email, and Password are required" });
    }

    const hash = bcrypt.hashSync(Password, 10);

    connection.query(
      "INSERT INTO User (Username, Email, Password) VALUES (?, ?, ?)",
      [Username, Email, hash],
      (err, results) => {
        if (err) {
          return res
            .status(500)
            .json({ message: "Database error", error: err });
        }
        res.json({ id: results.InsertId, Username, Email });
      }
    );
  });

  // Login
  router.post("/Login", (req, res) => {
    const { Email, Password } = req.body;

    if (!Email || !Password) {
      return res
        .status(400)
        .json({ message: "Email and Password are required" });
    }

    connection.query(
      "SELECT * FROM User WHERE Email = ?",
      [Email],
      (err, results) => {
        if (err) {
          return res
            .status(500)
            .json({ message: "Database error", error: err });
        }
        if (results.length === 0) {
          return res.status(401).json({ message: "User not found" });
        }

        const user = results[0];
        if (!bcrypt.compareSync(Password, user.Password)) {
          return res.status(401).json({ message: "Incorrect password" });
        }

        const token = jwt.sign(
          { UserId: user.UserId, email: user.Email },
          secretKey,
          { expiresIn: "1h" }
        );
        res.json({ token });
        console.log(token);
      }
    );
  });

  return router;
};
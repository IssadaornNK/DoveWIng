require("dotenv").config();
const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
const mysql = require("mysql2");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

const app = express();
app.use(bodyParser.json());
app.use(cors());

const connection = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});

connection.connect((err) => {
  if (err) throw err;
  console.log("Connected to MySQL Database.");
});

// Secret key for JWT
const secretKey = process.env.JWT_SECRET;
if (!secretKey) {
  console.error("JWT_SECRET environment variable is not set.");
  process.exit(1);
}

// Fetch User Details
app.get("/user", (req, res) => {
  const authHeader = req.headers.authorization;
  if (!authHeader) {
    return res.status(401).json({ message: "Authorization header not found" });
  }

  const token = authHeader.split(' ')[1];
  jwt.verify(token, secretKey, (err, decoded) => {
    if (err) {
      return res.status(401).json({ message: "Invalid token" });
    }

    const email = decoded.email;
    connection.query(
      "SELECT Email FROM Register WHERE Email = ?",
      [email],
      (err, result) => {
        if (err) {
          return res.status(500).json({ message: "Database query error", error: err });
        }
        if (result.length > 0) {
          res.json({ email: result[0].Email });
        } else {
          res.status(404).json({ message: "User not found" });
        }
      }
    );
  });
});

// Login Endpoint
app.post("/login", (req, res) => {
  const { Email, Password } = req.body;
  connection.query(
    "SELECT * FROM Register WHERE Email = ?",
    [Email],
    (err, results) => {
      if (err) {
        return res.status(500).json({ message: "Database query error", error: err });
      }
      if (results.length > 0) {
        const user = results[0];
        bcrypt.compare(Password, user.Password, (err, isMatch) => {
          if (err) {
            return res.status(500).json({ message: "Error comparing passwords", error: err });
          }
          if (isMatch) {
            const token = jwt.sign({ email: user.Email }, secretKey, {
              expiresIn: "1h",
            });
            res.json({ token });
          } else {
            res.status(401).json({ message: "Invalid credentials" });
          }
        });
      } else {
        res.status(401).json({ message: "Invalid credentials" });
      }
    }
  );
});

// Import routes
const authRoutes = require("./routes/authRoutes")(
  connection,
  bcrypt,
  jwt,
  secretKey
);
app.use("/api/auth", authRoutes);

const PORT = process.env.DB_PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}.`);
});
require("dotenv").config();
const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
const mysql = require("mysql2");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

const app = express();
const path = require("path");

// app.use(express.static(path.join(__dirname, "build/web")));
app.use(bodyParser.json({ limit: "50mb" }));
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

// app.get('*', (req, res) => {
//   res.sendFile(path.join(__dirname, '../../web', 'index.html'));
// });

// Fetch User Details
app.get("/user", (req, res) => {
  const authHeader = req.headers.authorization;
  if (!authHeader) {
    return res.status(401).json({ message: "Authorization header not found" });
  }

  const token = authHeader.split(" ")[1];

  jwt.verify(token, secretKey, (err, decoded) => {
    if (err) {
      return res.status(401).json({ message: "Invalid token" });
    }

    const userId = decoded.UserId;
    connection.query(
      "SELECT Username FROM User WHERE UserId = ?",
      [userId],
      (err, result) => {
        if (err) {
          return res
            .status(500)
            .json({ message: "Database query error", error: err });
        }
        if (result.length > 0) {
          res.json({ username: result[0].Username, id: userId });
        } else {
          res.status(404).json({ message: "User not found" });
        }
      }
    );
  });
});

// Donations Endpoint
app.post("/donations", async (req, res) => {
  const { name, amount, type } = req.body;
  const authHeader = req.headers.authorization;
  if (!authHeader) {
    return res.status(401).json({ message: "Authorization header not found" });
  }

  const token = authHeader.split(" ")[1];

  jwt.verify(token, secretKey, (err, decoded) => {
    if (err) {
      console.error("Token verification error:", err);
      return res.status(401).json({ message: "Invalid token" });
    }
    console.log("Decoded token:", decoded);
    try {
      const userId = decoded.UserId;
      connection.query(
        "INSERT INTO Donation (name, date, amount, type, userId) VALUES (?, ?, ?, ?, ?)",
        [name, new Date(), amount, type, userId],
        (err, result) => {
          if (err) {
            console.error("Error inserting donation data:", err);
            res.status(500).json({
              message: "An error occurred while submitting the donation.",
            });
            return;
          }
          if (result && result.affectedRows === 1) {
            res
              .status(200)
              .json({ message: "Donation submitted successfully!" });
          } else {
            res
              .status(500)
              .json({ message: "Failed to insert donation data." });
          }
        }
      );
    } catch (err) {
      console.error(err);
      res
        .status(500)
        .json({ message: "Failed to submit donation.", error: err });
    }
  });
});

// Endpoint to fetch user donations
app.get("/user/donations", async (req, res) => {
  // const { donationId } = req.params;

  try {
    connection.query("SELECT * FROM Donation", (err, results) => {
      if (err) {
        console.error("Error fetching donations data:", err);
        res.status(500).json({
          message: "An error occurred while fetching the donations.",
        });
        return;
      }
      if (results.length > 0) {
        res.status(200).json(results);
      } else {
        res
          .status(404)
          .json({ message: "No donation found with the provided ID." });
      }
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Failed to fetch donations.", error: err });
  }
});

// PUT endpoint to update profile image
app.put("/user/profile-image", (req, res) => {
  const authHeader = req.headers.authorization;
  if (!authHeader) {
    return res.status(401).json({ message: "Authorization header not found" });
  }

  const token = authHeader.split(" ")[1];

  jwt.verify(token, secretKey, (err, decoded) => {
    if (err) {
      return res.status(401).json({ message: "Invalid token" });
    }

    const userId = decoded.UserId;
    const { profileImageUrl } = req.body;

    if (!profileImageUrl) {
      return res.status(400).json({ message: "Profile image URL is required" });
    }

    const sql = "UPDATE User SET ProfileImg = ? WHERE UserId = ?";
    const values = [profileImageUrl, userId];

    connection.query(sql, values, (err, result) => {
      if (err) {
        console.error("Error updating profile image:", err);
        return res.status(500).json({
          message: "An error occurred while updating the profile image.",
        });
      }

      if (result.affectedRows === 1) {
        res.status(200).json({ message: "Profile image updated successfully!" });
      } else {
        res.status(404).json({ message: "User not found" });
      }
    });
  });
});

// Import routes
const authRoutes = require("./routes/authRoutes")(
  connection,
  bcrypt,
  jwt,
  secretKey
);
app.use("/api/auth", authRoutes);

const PORT = process.env.DB_PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}.`);
});

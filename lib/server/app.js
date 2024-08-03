require("dotenv").config();
const moment = require("moment");
const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
const mysql = require("mysql2");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

const token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVc2VySWQiOjcsImVtYWlsIjoidXNlckBtYWlsLmNvbSIsImlhdCI6MTcyMjY4ODIzMSwiZXhwIjoxNzIyNjkxODMxfQ.byBevHaAmKxR3aO89HqOCVpEQ7v8WJyPFXmPtOLnwJM";

try {
  const decoded = jwt.verify(token, process.env.JWT_SECRET);
  console.log("Manually verified token:", decoded);
} catch (error) {
  console.error("Manual verification failed:", error);
}

const app = express();
const path = require("path");

// app.use(express.static(path.join(__dirname, "build/web")));
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

console.log("Secret key:", process.env.JWT_SECRET);

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
  const { name, details, amount, type, imgurl, isPayment } = req.body;
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
        "INSERT INTO Donation (name, details, date, amount, type, imgurl, userId, isPayment) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
        [name, details, new Date(), amount, type, imgurl, userId, isPayment],
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
        "SELECT * FROM Donation WHERE userId = ?",
        [userId],
        (err, results) => {
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
        }
      );
    } catch (err) {
      console.error(err);
      res
        .status(500)
        .json({ message: "Failed to fetch donations.", error: err });
    }
  });
});

// Payments Endpoint
app.post("/payments", async (req, res) => {
  const { paymentType, cardNumber, cardName, expiryDate, cvv, DonationId } =
    req.body;
  const [expiryMonth, expiryYear] = expiryDate.split("/");
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

    const userId = decoded.UserId;

    // Start transaction
    connection.beginTransaction((err) => {
      if (err) {
        console.error("Error starting transaction:", err);
        return res
          .status(500)
          .json({ message: "An error occurred while processing the payment." });
      }

      // Update Donation
      connection.query(
        "UPDATE Donation SET isPayment = 1 WHERE DonationId = ?",
        [DonationId],
        (err, result) => {
          if (err) {
            console.error("Error updating isPayment:", err);
            return connection.rollback(() => {
              res
                .status(500)
                .json({
                  message: "An error occurred while processing the payment.",
                });
            });
          }

          // Insert Payment
          connection.query(
            "INSERT INTO Payment (paymentType, cardNumber, cardName, expiryMonth, expiryYear, cvv, DonationId, userId) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
            [
              paymentType,
              cardNumber,
              cardName,
              parseInt(expiryMonth),
              parseInt(`20${expiryYear}`),
              cvv,
              DonationId,
              userId,
            ],
            (err, result) => {
              if (err) {
                console.error("Error inserting payment data:", err);
                return connection.rollback(() => {
                  res
                    .status(500)
                    .json({
                      message:
                        "An error occurred while processing the payment.",
                    });
                });
              }

              // Commit transaction
              connection.commit((err) => {
                if (err) {
                  console.error("Error committing transaction:", err);
                  return connection.rollback(() => {
                    res
                      .status(500)
                      .json({
                        message:
                          "An error occurred while processing the payment.",
                      });
                  });
                }
                res
                  .status(200)
                  .json({ message: "Payment processed successfully!" });
              });
            }
          );
        }
      );
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

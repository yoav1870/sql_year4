const mysql = require("mysql2/promise");
const { DatabaseError } = require("../utils/errors");

const pool = mysql.createPool({
  host: process.env.DB_HOST,
  port: Number(process.env.DB_PORT) || 3306,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: Number(process.env.DB_CONNECTION_LIMIT) || 10,
  queueLimit: 0,
  timezone: "Z",
  namedPlaceholders: false
});

const testDbConnection = async () => {
  try {
    const connection = await pool.getConnection();
    connection.release();
  } catch (error) {
    throw new DatabaseError("Database connection failed", error);
  }
};

const closeDbPool = async () => {
  await pool.end();
};

module.exports = {
  pool,
  testDbConnection,
  closeDbPool
};

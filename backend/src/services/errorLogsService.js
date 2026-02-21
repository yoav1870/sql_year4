const { pool } = require("../config/db");
const { DatabaseError } = require("../utils/errors");

const getErrorLogs = async () => {
  try {
    const [rows] = await pool.query(
      "SELECT id, error_message, CAST(json_input AS CHAR) AS json_input, created_at FROM error_log ORDER BY id DESC"
    );
    return rows;
  } catch (error) {
    throw new DatabaseError("Failed to fetch error logs", error);
  }
};

module.exports = {
  getErrorLogs
};


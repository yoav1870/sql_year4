const { pool } = require("../config/db");
const { DatabaseError } = require("../utils/errors");

const DEFAULT_RESULT = {
  inserted_rows: 0,
  failed_rows: 0,
  status: "UNKNOWN",
  failed_items: [],
  completed_items: []
};

const isInvalidJsonDbError = (error) =>
  error && (error.code === "ER_INVALID_JSON_TEXT" || Number(error.errno) === 3140);

const DEMO_CUSTOMER_THRESHOLD = 235;
const DEMO_SELLER_THRESHOLD = 31;

const normalizeStoredProcedureResult = (rawValue) => {
  if (!rawValue) return { ...DEFAULT_RESULT };

  let parsed = rawValue;
  if (typeof rawValue === "string") {
    parsed = JSON.parse(rawValue);
  }

  return {
    inserted_rows: Number(parsed.inserted_rows) || 0,
    failed_rows: Number(parsed.failed_rows) || 0,
    status: parsed.status || "UNKNOWN",
    failed_items: Array.isArray(parsed.failed_items) ? parsed.failed_items : [],
    completed_items: Array.isArray(parsed.completed_items) ? parsed.completed_items : []
  };
};

const extractJsonFromProcedureResponse = (rows) => {
  for (const resultSet of rows) {
    if (!Array.isArray(resultSet)) continue;
    for (const row of resultSet) {
      if (!row || typeof row !== "object") continue;
      const values = Object.values(row);
      for (const value of values) {
        if (typeof value === "string") {
          const trimmed = value.trim();
          if (trimmed.startsWith("{") || trimmed.startsWith("[")) return value;
        }
        if (value && typeof value === "object") return value;
      }
    }
  }
  return null;
};

const insertSalesFromJson = async (payload) => {
  try {
    const jsonPayload = typeof payload === "string" ? payload : JSON.stringify(payload);
    const [rows] = await pool.query("CALL p_insert_sales_from_json(?)", [jsonPayload]);
    const rawJson = extractJsonFromProcedureResponse(rows);
    return normalizeStoredProcedureResult(rawJson);
  } catch (error) {
    if (isInvalidJsonDbError(error)) {
      return {
        inserted_rows: 0,
        failed_rows: 0,
        status: error.message || "Invalid JSON text",
        failed_items: [],
        completed_items: []
      };
    }
    throw new DatabaseError("Failed to process sales JSON", error);
  }
};

const cleanupDemoData = async () => {
  try {
    const [rows] = await pool.query("CALL p_cleanup_demo_data(?, ?)", [
      DEMO_CUSTOMER_THRESHOLD,
      DEMO_SELLER_THRESHOLD
    ]);

    const summary = Array.isArray(rows) && Array.isArray(rows[0]) ? rows[0][0] : null;
    return {
      deleted_sales: Number(summary?.deleted_sales) || 0,
      deleted_customers: Number(summary?.deleted_customers) || 0,
      deleted_sellers: Number(summary?.deleted_sellers) || 0,
      deleted_error_logs: Number(summary?.deleted_error_logs) || 0,
      status: summary?.status || "Cleanup Completed"
    };
  } catch (error) {
    throw new DatabaseError("Failed to cleanup demo data", error);
  }
};

module.exports = {
  insertSalesFromJson,
  cleanupDemoData
};

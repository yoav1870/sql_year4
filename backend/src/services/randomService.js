const { pool } = require("../config/db");
const { DatabaseError } = require("../utils/errors");

const isRowArray = (value) => Array.isArray(value);

const generateRandomData = async (customers, sellers, sales) => {
  try {
    const [rows] = await pool.query("CALL p_generate_random_data(?, ?, ?)", [customers, sellers, sales]);
    const resultSets = (rows || []).filter(isRowArray);

    const insertedCustomers = resultSets[0] || [];
    const insertedSellers = resultSets[1] || [];
    const insertedSales = resultSets[2] || [];

    return {
      generated_customers: insertedCustomers.length,
      generated_sellers: insertedSellers.length,
      generated_sales: insertedSales.length,
      inserted_customers: insertedCustomers,
      inserted_sellers: insertedSellers,
      inserted_sales: insertedSales
    };
  } catch (error) {
    throw new DatabaseError("Failed to generate random data", error);
  }
};

module.exports = {
  generateRandomData
};

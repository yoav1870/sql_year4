const { pool } = require("../config/db");
const { DatabaseError } = require("../utils/errors");

const getTotalSalesPerSeller = async () => {
  try {
    const [rows] = await pool.query(
      "SELECT * FROM vw_total_sales_per_seller ORDER BY id_seller"
    );
    return rows;
  } catch (error) {
    throw new DatabaseError("Failed to fetch total sales per seller", error);
  }
};

const getSellerRanking = async () => {
  try {
    const [rows] = await pool.query(
      "SELECT * FROM vw_seller_ranking ORDER BY revenue_rank, id_seller"
    );
    return rows;
  } catch (error) {
    throw new DatabaseError("Failed to fetch seller ranking", error);
  }
};

const getAverageSalePerSeller = async () => {
  try {
    const [rows] = await pool.query(
      "SELECT * FROM vw_avg_sale_per_seller ORDER BY id_seller"
    );
    return rows;
  } catch (error) {
    throw new DatabaseError("Failed to fetch average sale per seller", error);
  }
};

module.exports = {
  getTotalSalesPerSeller,
  getSellerRanking,
  getAverageSalePerSeller
};

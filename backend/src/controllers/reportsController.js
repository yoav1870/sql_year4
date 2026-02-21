const asyncHandler = require("../utils/asyncHandler");
const {
  getTotalSalesPerSeller,
  getSellerRanking,
  getAverageSalePerSeller
} = require("../services/reportsService");

const totalSales = asyncHandler(async (_req, res) => {
  const rows = await getTotalSalesPerSeller();
  return res.status(200).json({
    success: true,
    data: rows
  });
});

const ranking = asyncHandler(async (_req, res) => {
  const rows = await getSellerRanking();
  return res.status(200).json({
    success: true,
    data: rows
  });
});

const averageSales = asyncHandler(async (_req, res) => {
  const rows = await getAverageSalePerSeller();
  return res.status(200).json({
    success: true,
    data: rows
  });
});

module.exports = {
  totalSales,
  ranking,
  averageSales
};

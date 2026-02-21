const asyncHandler = require("../utils/asyncHandler");
const { insertSalesFromJson, cleanupDemoData } = require("../services/salesService");

const insertSalesJson = asyncHandler(async (req, res) => {
  const result = await insertSalesFromJson(req.body);

  return res.status(200).json({
    success: true,
    data: {
      inserted_rows: result.inserted_rows,
      failed_rows: result.failed_rows,
      status: result.status,
      failed_items: result.failed_items,
      completed_items: result.completed_items
    }
  });
});

const cleanupSalesDemoData = asyncHandler(async (_req, res) => {
  const result = await cleanupDemoData();

  return res.status(200).json({
    success: true,
    data: result
  });
});

module.exports = {
  insertSalesJson,
  cleanupSalesDemoData
};

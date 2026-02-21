const asyncHandler = require("../utils/asyncHandler");
const { generateRandomData } = require("../services/randomService");

const createRandomData = asyncHandler(async (req, res) => {
  const { customers, sellers, sales } = req.body;
  const result = await generateRandomData(customers, sellers, sales);

  return res.status(200).json({
    success: true,
    data: result
  });
});

module.exports = {
  createRandomData
};

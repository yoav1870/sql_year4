const asyncHandler = require("../utils/asyncHandler");

const getHealth = asyncHandler(async (_req, res) => {
  return res.status(200).json({
    status: "OK"
  });
});

module.exports = {
  getHealth
};

const asyncHandler = require("../utils/asyncHandler");
const { getErrorLogs } = require("../services/errorLogsService");

const listErrorLogs = asyncHandler(async (_req, res) => {
  const rows = await getErrorLogs();
  return res.status(200).json({
    success: true,
    data: rows
  });
});

module.exports = {
  listErrorLogs
};


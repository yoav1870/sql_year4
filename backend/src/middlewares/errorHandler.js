const { AppError } = require("../utils/errors");
const logger = require("../utils/logger");

module.exports = (err, _req, res, _next) => {
  if (err instanceof SyntaxError && err.status === 400 && "body" in err) {
    return res.status(400).json({
      success: false,
      message: "Invalid JSON payload"
    });
  }

  if (err instanceof AppError) {
    if (err.statusCode >= 500) {
      logger.error(err.message, err.details || err);
    }

    return res.status(err.statusCode).json({
      success: false,
      message: err.message
    });
  }

  logger.error("Unhandled server error", err);
  return res.status(500).json({
    success: false,
    message: "Internal server error"
  });
};

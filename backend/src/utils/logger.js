const isProduction = process.env.NODE_ENV === "production";

const formatError = (error) => {
  if (!error) return "";
  if (error instanceof Error) {
    return isProduction ? error.message : `${error.message}\n${error.stack || ""}`;
  }
  return String(error);
};

const logger = {
  info: (message) => {
    console.info(`[INFO] ${new Date().toISOString()} ${message}`);
  },
  error: (message, error) => {
    console.error(`[ERROR] ${new Date().toISOString()} ${message} ${formatError(error)}`);
  }
};

module.exports = logger;

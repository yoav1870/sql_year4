require("dotenv").config();

const app = require("./src/app");
const { testDbConnection, closeDbPool } = require("./src/config/db");
const logger = require("./src/utils/logger");

const PORT = Number(process.env.PORT) || 3000;

const startServer = async () => {
  try {
    await testDbConnection();

    const server = app.listen(PORT, () => {
      logger.info(`Server running on port ${PORT}`);
    });

    const shutdown = async (signal) => {
      logger.info(`${signal} received. Shutting down gracefully...`);
      server.close(async () => {
        await closeDbPool();
        process.exit(0);
      });
    };

    process.on("SIGTERM", () => {
      shutdown("SIGTERM").catch((error) => {
        logger.error("Graceful shutdown failed", error);
        process.exit(1);
      });
    });

    process.on("SIGINT", () => {
      shutdown("SIGINT").catch((error) => {
        logger.error("Graceful shutdown failed", error);
        process.exit(1);
      });
    });
  } catch (error) {
    logger.error("Failed to start server", error);
    process.exit(1);
  }
};

startServer();

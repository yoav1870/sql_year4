const express = require("express");
const cors = require("cors");
const helmet = require("helmet");
const compression = require("compression");

const routes = require("./routes");
const notFound = require("./middlewares/notFound");
const errorHandler = require("./middlewares/errorHandler");

const app = express();

app.use(helmet());
app.use(compression());
app.use(
  cors({
    origin: process.env.CORS_ORIGIN || "*",
    methods: ["GET", "POST", "OPTIONS"],
    allowedHeaders: ["Content-Type", "Authorization"]
  })
);
app.use(
  express.json({
    limit: "1mb"
  })
);
app.use(
  express.text({
    type: "text/plain",
    limit: "1mb"
  })
);

app.use(routes);
app.use(notFound);
app.use(errorHandler);

module.exports = app;

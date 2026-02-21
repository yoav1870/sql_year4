const express = require("express");
const salesRoutes = require("./salesRoutes");
const healthRoutes = require("./healthRoutes");
const reportsRoutes = require("./reportsRoutes");
const randomRoutes = require("./randomRoutes");
const errorLogsRoutes = require("./errorLogsRoutes");

const router = express.Router();

router.use("/api/sales", salesRoutes);
router.use("/api/reports", reportsRoutes);
router.use("/api/random", randomRoutes);
router.use("/api/error-logs", errorLogsRoutes);
router.use("/health", healthRoutes);

module.exports = router;

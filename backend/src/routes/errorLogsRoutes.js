const express = require("express");
const { listErrorLogs } = require("../controllers/errorLogsController");

const router = express.Router();

router.get("/", listErrorLogs);

module.exports = router;


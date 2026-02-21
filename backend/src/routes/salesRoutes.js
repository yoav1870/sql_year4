const express = require("express");
const { insertSalesJson, cleanupSalesDemoData } = require("../controllers/salesController");

const router = express.Router();

router.post("/json", insertSalesJson);
router.post("/cleanup-demo", cleanupSalesDemoData);

module.exports = router;

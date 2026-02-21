const express = require("express");
const { totalSales, ranking, averageSales } = require("../controllers/reportsController");

const router = express.Router();

router.get("/total-sales", totalSales);
router.get("/ranking", ranking);
router.get("/average-sales", averageSales);

module.exports = router;

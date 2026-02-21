const express = require("express");
const { createRandomData } = require("../controllers/randomController");

const router = express.Router();

router.post("/", createRandomData);

module.exports = router;

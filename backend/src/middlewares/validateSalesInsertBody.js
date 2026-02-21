const { ValidationError } = require("../utils/errors");

const isIsoDate = (value) => /^\d{4}-\d{2}-\d{2}$/.test(value);

module.exports = (req, _res, next) => {
  const { sales } = req.body;

  if (!sales || typeof sales !== "object" || Array.isArray(sales)) {
    return next(new ValidationError("sales must be an object"));
  }

  const { CustomerFirstName, CustomerLastName, SellerID, purchases } = sales;

  if (!CustomerFirstName || typeof CustomerFirstName !== "string") {
    return next(new ValidationError("CustomerFirstName is required"));
  }

  if (!CustomerLastName || typeof CustomerLastName !== "string") {
    return next(new ValidationError("CustomerLastName is required"));
  }

  if (!Number.isInteger(SellerID)) {
    return next(new ValidationError("SellerID is required and must be an integer"));
  }

  if (!Array.isArray(purchases) || purchases.length === 0) {
    return next(new ValidationError("purchases is required and must be a non-empty array"));
  }

  const today = new Date();
  today.setHours(0, 0, 0, 0);

  for (let i = 0; i < purchases.length; i += 1) {
    const purchase = purchases[i];
    if (!purchase || typeof purchase !== "object" || Array.isArray(purchase)) {
      return next(new ValidationError(`purchases[${i}] must be an object`));
    }

    const { productId, quantity, saleDate } = purchase;

    if (!Number.isInteger(productId)) {
      return next(new ValidationError(`purchases[${i}].productId must be an integer`));
    }

    if (!Number.isInteger(quantity) || quantity <= 0) {
      return next(new ValidationError(`purchases[${i}].quantity must be an integer greater than 0`));
    }

    if (!saleDate || typeof saleDate !== "string" || !isIsoDate(saleDate)) {
      return next(new ValidationError(`purchases[${i}].saleDate must be in YYYY-MM-DD format`));
    }

    const parsedDate = new Date(`${saleDate}T00:00:00`);
    if (Number.isNaN(parsedDate.getTime())) {
      return next(new ValidationError(`purchases[${i}].saleDate is invalid`));
    }

    if (parsedDate > today) {
      return next(new ValidationError(`purchases[${i}].saleDate cannot be in the future`));
    }
  }

  return next();
};

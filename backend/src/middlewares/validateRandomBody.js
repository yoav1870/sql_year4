const { ValidationError } = require("../utils/errors");

module.exports = (req, _res, next) => {
  const { customers, sellers, sales } = req.body;
  const fields = [
    { name: "customers", value: customers },
    { name: "sellers", value: sellers },
    { name: "sales", value: sales }
  ];

  for (const field of fields) {
    if (!Number.isInteger(field.value)) {
      return next(new ValidationError(`${field.name} must be an integer`));
    }

    if (field.value <= 0) {
      return next(new ValidationError(`${field.name} must be greater than 0`));
    }

    if (field.value > 100000) {
      return next(new ValidationError(`${field.name} must be less than or equal to 100000`));
    }
  }

  return next();
};

import api from "./api";

export const generateRandomSalesData = async (customers, sellers, sales) => {
  const response = await api.post("/api/random", { customers, sellers, sales });
  return response.data;
};

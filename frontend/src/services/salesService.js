import api from "./api";

export const insertSalesJson = async (payload) => {
  const response = await api.post("/api/sales/json", payload, {
    headers: {
      "Content-Type": "text/plain"
    }
  });
  return response.data;
};

export const cleanupSalesDemoData = async () => {
  const response = await api.post("/api/sales/cleanup-demo");
  return response.data;
};

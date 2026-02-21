import api from "./api";

export const fetchTotalSalesReport = async () => {
  const response = await api.get("/api/reports/total-sales");
  return response.data;
};

export const fetchSellerRankingReport = async () => {
  const response = await api.get("/api/reports/ranking");
  return response.data;
};

export const fetchAverageSalesReport = async () => {
  const response = await api.get("/api/reports/average-sales");
  return response.data;
};

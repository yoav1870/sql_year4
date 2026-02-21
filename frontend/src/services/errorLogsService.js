import api from "./api";

export const fetchErrorLogs = async () => {
  const response = await api.get("/api/error-logs");
  return response.data;
};


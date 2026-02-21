import { useEffect, useState } from "react";
import Table from "../components/Table";
import LoadingIndicator from "../components/LoadingIndicator";
import AlertMessage from "../components/AlertMessage";
import {
  fetchAverageSalesReport,
  fetchSellerRankingReport,
  fetchTotalSalesReport
} from "../services/reportsService";

function ReportsPage() {
  const [loading, setLoading] = useState(false);
  const [errorMessage, setErrorMessage] = useState("");
  const [totalSales, setTotalSales] = useState([]);
  const [ranking, setRanking] = useState([]);
  const [averageSales, setAverageSales] = useState([]);

  useEffect(() => {
    const loadReports = async () => {
      setLoading(true);
      setErrorMessage("");
      try {
        const [totalResult, rankingResult, avgResult] = await Promise.all([
          fetchTotalSalesReport(),
          fetchSellerRankingReport(),
          fetchAverageSalesReport()
        ]);

        setTotalSales(totalResult.data || []);
        setRanking(rankingResult.data || []);
        setAverageSales(avgResult.data || []);
      } catch (error) {
        setErrorMessage(error.response?.data?.message || "Failed to load reports");
      } finally {
        setLoading(false);
      }
    };

    loadReports();
  }, []);

  return (
    <div>
      <h2>Reports</h2>
      <AlertMessage type="error" message={errorMessage} />
      {loading ? (
        <LoadingIndicator text="Loading reports..." />
      ) : (
        <>
          <Table
            title="Total Sales Per Seller"
            columns={[
              { key: "id_seller", label: "Seller ID" },
              { key: "first_name", label: "First Name" },
              { key: "last_name", label: "Last Name" },
              { key: "total_quantity", label: "Total Quantity" },
              { key: "total_revenue", label: "Total Revenue" }
            ]}
            rows={totalSales}
          />
          <Table
            title="Seller Ranking"
            columns={[
              { key: "id_seller", label: "Seller ID" },
              { key: "first_name", label: "First Name" },
              { key: "last_name", label: "Last Name" },
              { key: "total_revenue", label: "Total Revenue" },
              { key: "revenue_rank", label: "Ranking" }
            ]}
            rows={ranking}
          />
          <Table
            title="Average Sale Per Seller"
            columns={[
              { key: "id_seller", label: "Seller ID" },
              { key: "first_name", label: "First Name" },
              { key: "last_name", label: "Last Name" },
              { key: "avg_sale_amount", label: "Average Sale Amount" }
            ]}
            rows={averageSales}
          />
        </>
      )}
    </div>
  );
}

export default ReportsPage;

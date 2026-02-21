import { useState } from "react";
import AlertMessage from "../components/AlertMessage";
import LoadingIndicator from "../components/LoadingIndicator";
import Table from "../components/Table";
import { generateRandomSalesData } from "../services/randomService";

function RandomDataPage() {
  const [customers, setCustomers] = useState(10);
  const [sellers, setSellers] = useState(5);
  const [sales, setSales] = useState(20);
  const [loading, setLoading] = useState(false);
  const [errorMessage, setErrorMessage] = useState("");
  const [successMessage, setSuccessMessage] = useState("");
  const [result, setResult] = useState(null);

  const onSubmit = async (event) => {
    event.preventDefault();
    setLoading(true);
    setErrorMessage("");
    setSuccessMessage("");
    setResult(null);

    try {
      const response = await generateRandomSalesData(Number(customers), Number(sellers), Number(sales));
      setResult(response.data ?? null);
      setSuccessMessage("Random data generated successfully");
    } catch (error) {
      setErrorMessage(error.response?.data?.message || "Failed to generate random data");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div>
      <h2>Generate Random Data</h2>
      <form className="card form-card" onSubmit={onSubmit}>
        <label htmlFor="customers">Number of customers to generate</label>
        <input
          id="customers"
          type="number"
          min="1"
          value={customers}
          onChange={(event) => setCustomers(event.target.value)}
          required
        />
        <label htmlFor="sellers">Number of sellers to generate</label>
        <input
          id="sellers"
          type="number"
          min="1"
          value={sellers}
          onChange={(event) => setSellers(event.target.value)}
          required
        />
        <label htmlFor="sales">Number of sales to generate</label>
        <input
          id="sales"
          type="number"
          min="1"
          value={sales}
          onChange={(event) => setSales(event.target.value)}
          required
        />
        <button type="submit" disabled={loading}>
          Generate
        </button>
      </form>

      {loading && <LoadingIndicator text="Generating random data..." />}
      <AlertMessage type="error" message={errorMessage} />
      <AlertMessage type="success" message={successMessage} />
      {result && (
        <>
          <p className="card">
            Generated customers: <strong>{result.generated_customers ?? 0}</strong> | Generated sellers:{" "}
            <strong>{result.generated_sellers ?? 0}</strong> | Generated sales: <strong>{result.generated_sales ?? 0}</strong>
          </p>
          <Table
            title="Inserted Customers"
            columns={[
              { key: "customer_id", label: "Customer ID" },
              { key: "first_name", label: "First Name" },
              { key: "last_name", label: "Last Name" },
              { key: "city", label: "City" },
              { key: "country", label: "Country" }
            ]}
            rows={result.inserted_customers || []}
          />
          <Table
            title="Inserted Sellers"
            columns={[
              { key: "seller_id", label: "Seller ID" },
              { key: "first_name", label: "First Name" },
              { key: "last_name", label: "Last Name" },
              { key: "email", label: "Email" },
              { key: "created_at", label: "Created At" }
            ]}
            rows={result.inserted_sellers || []}
          />
          <Table
            title="Inserted Sales"
            columns={[
              { key: "sale_id", label: "Sale ID" },
              { key: "product_id", label: "Product ID" },
              { key: "customer_id", label: "Customer ID" },
              { key: "id_seller", label: "Seller ID" },
              { key: "sale_date", label: "Sale Date" },
              { key: "quantity", label: "Quantity" },
              { key: "sale_amount", label: "Sale Amount" }
            ]}
            rows={result.inserted_sales || []}
          />
        </>
      )}
    </div>
  );
}

export default RandomDataPage;

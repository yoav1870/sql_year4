import { useState } from "react";
import AlertMessage from "../components/AlertMessage";
import LoadingIndicator from "../components/LoadingIndicator";
import Table from "../components/Table";
import { cleanupSalesDemoData, insertSalesJson } from "../services/salesService";

const testCases = [
  {
    id: "valid",
    label: "Valid JSON",
    payload: {
      sales: {
        CustomerFirstName: "John",
        CustomerLastName: "Doe",
        SellerID: 1,
        purchases: [
          { productId: 101, quantity: 2, saleDate: "2024-12-01" },
          { productId: 102, quantity: 3, saleDate: "2024-12-05" }
        ]
      }
    }
  },
  {
    id: "invalid-seller",
    label: "Invalid Seller",
    payload: {
      sales: {
        CustomerFirstName: "Mike",
        CustomerLastName: "Smith",
        SellerID: 9999,
        purchases: [{ productId: 101, quantity: 2, saleDate: "2024-12-01" }]
      }
    }
  },
  {
    id: "invalid-product",
    label: "Invalid Product",
    payload: {
      sales: {
        CustomerFirstName: "Anna",
        CustomerLastName: "White",
        SellerID: 1,
        purchases: [{ productId: 9999, quantity: 2, saleDate: "2024-12-01" }]
      }
    }
  },
  {
    id: "invalid-quantity",
    label: "Invalid Quantity",
    payload: {
      sales: {
        CustomerFirstName: "Sara",
        CustomerLastName: "Blue",
        SellerID: 1,
        purchases: [{ productId: 101, quantity: -5, saleDate: "2024-12-01" }]
      }
    }
  },
  {
    id: "invalid-date",
    label: "Invalid Sale Date (null)",
    payload: {
      sales: {
        CustomerFirstName: "Tom",
        CustomerLastName: "Green",
        SellerID: 1,
        purchases: [{ productId: 101, quantity: 2, saleDate: null }]
      }
    }
  },
  {
    id: "mixed",
    label: "Mixed (1 valid, 2 invalid)",
    payload: {
      sales: {
        CustomerFirstName: "David",
        CustomerLastName: "Black",
        SellerID: 1,
        purchases: [
          { productId: 101, quantity: 2, saleDate: "2024-12-01" },
          { productId: 9999, quantity: 2, saleDate: "2024-12-01" },
          { productId: 102, quantity: -1, saleDate: "2024-12-01" }
        ]
      }
    }
  },
  {
    id: "missing-field",
    label: "Missing CustomerLastName",
    payload: {
      sales: {
        CustomerFirstName: "NoLastName",
        SellerID: 1,
        purchases: [{ productId: 101, quantity: 2, saleDate: "2024-12-01" }]
      }
    }
  },
  {
    id: "future-date",
    label: "Invalid Sale Date (future)",
    payload: {
      sales: {
        CustomerFirstName: "Future",
        CustomerLastName: "Date",
        SellerID: 1,
        purchases: [{ productId: 101, quantity: 1, saleDate: "2030-01-01" }]
      }
    }
  },
  {
    id: "invalid-json-syntax",
    label: "Invalid JSON Syntax",
    rawText: `{
  "sales": {
    "CustomerFirstName": "Broken",
    "CustomerLastName": "Json",
    "SellerID": 1,
    "purchases": [
      { "productId": 101, "quantity": 2, "saleDate": "2024-12-01" }
    ]
  }
`
  }
];

const toPrettyJson = (value) => JSON.stringify(value, null, 2);

function JsonInsertPage() {
  const [selectedCase, setSelectedCase] = useState(testCases[0].id);
  const [jsonText, setJsonText] = useState(toPrettyJson(testCases[0].payload));
  const [loading, setLoading] = useState(false);
  const [loadingText, setLoadingText] = useState("Inserting sales...");
  const [errorMessage, setErrorMessage] = useState("");
  const [successMessage, setSuccessMessage] = useState("");
  const [result, setResult] = useState(null);
  const [cleanupResult, setCleanupResult] = useState(null);

  const applySelectedCase = (caseId) => {
    const match = testCases.find((item) => item.id === caseId);
    if (!match) return;
    if (typeof match.rawText === "string") {
      setJsonText(match.rawText);
    } else {
    setJsonText(toPrettyJson(match.payload));
    }
    setErrorMessage("");
    setSuccessMessage("");
    setResult(null);
    setCleanupResult(null);
  };

  const onSubmit = async (event) => {
    event.preventDefault();
    setLoading(true);
    setLoadingText("Inserting sales...");
    setErrorMessage("");
    setSuccessMessage("");
    setResult(null);
    setCleanupResult(null);

    try {
      const response = await insertSalesJson(jsonText);
      setResult(response.data || null);
      setSuccessMessage("Insert completed");
      if (response.data?.inserted_rows === 0 && response.data?.failed_rows > 0) {
        setErrorMessage("Insert failed completely. Review failed items.");
      }
    } catch (error) {
      setErrorMessage(error.response?.data?.message || "Failed to insert sales JSON");
    } finally {
      setLoading(false);
    }
  };

  const onCleanup = async () => {
    setLoading(true);
    setLoadingText("Cleaning demo data...");
    setErrorMessage("");
    setSuccessMessage("");
    setResult(null);
    setCleanupResult(null);

    try {
      const response = await cleanupSalesDemoData();
      setCleanupResult(response.data || null);
      setSuccessMessage("Cleanup completed");
    } catch (error) {
      setErrorMessage(error.response?.data?.message || "Failed to cleanup demo data");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div>
      <h2>Insert JSON</h2>
      <form className="card form-card" onSubmit={onSubmit}>
        <label htmlFor="testCase">Test scenario</label>
        <select
          id="testCase"
          value={selectedCase}
          onChange={(event) => {
            const nextCase = event.target.value;
            setSelectedCase(nextCase);
            applySelectedCase(nextCase);
          }}
        >
          {testCases.map((testCase) => (
            <option key={testCase.id} value={testCase.id}>
              {testCase.label}
            </option>
          ))}
        </select>
        <label htmlFor="jsonPayload">Sales JSON payload</label>
        <textarea
          id="jsonPayload"
          value={jsonText}
          onChange={(event) => setJsonText(event.target.value)}
          rows={18}
          required
        />
        <div className="action-row">
          <button type="submit" disabled={loading}>
            Insert
          </button>
          <button type="button" onClick={onCleanup} disabled={loading}>
            Cleanup Demo Data
          </button>
        </div>
      </form>

      {loading && <LoadingIndicator text={loadingText} />}
      <AlertMessage type="error" message={errorMessage} />
      <AlertMessage type="success" message={successMessage} />

      {cleanupResult && (
        <div className="card result-summary">
          <p>
            Deleted sales: <strong>{cleanupResult.deleted_sales}</strong>
          </p>
          <p>
            Deleted customers: <strong>{cleanupResult.deleted_customers}</strong>
          </p>
          <p>
            Deleted sellers: <strong>{cleanupResult.deleted_sellers}</strong>
          </p>
          <p>
            Deleted error logs: <strong>{cleanupResult.deleted_error_logs}</strong>
          </p>
          <p>
            Status: <strong>{cleanupResult.status}</strong>
          </p>
        </div>
      )}

      {result && (
        <div className="card result-summary">
          <p>
            Inserted rows: <strong>{result.inserted_rows}</strong>
          </p>
          <p>
            Failed rows: <strong>{result.failed_rows}</strong>
          </p>
          <p>
            Status: <strong>{result.status}</strong>
          </p>
        </div>
      )}

      {result && (
        <Table
          title="Completed Items"
          columns={[
            { key: "productId", label: "Product ID" },
            { key: "quantity", label: "Quantity" },
            { key: "saleDate", label: "Sale Date" }
          ]}
          rows={Array.isArray(result.completed_items) ? result.completed_items : []}
        />
      )}

      {result && (
        <Table
          title="Failed Items"
          columns={[
            { key: "productId", label: "Product ID" },
            { key: "quantity", label: "Quantity" },
            { key: "saleDate", label: "Sale Date" },
            { key: "error", label: "Error" }
          ]}
          rows={Array.isArray(result.failed_items) ? result.failed_items : []}
        />
      )}
    </div>
  );
}

export default JsonInsertPage;

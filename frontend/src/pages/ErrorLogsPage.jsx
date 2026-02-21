import { useEffect, useState } from "react";
import Table from "../components/Table";
import LoadingIndicator from "../components/LoadingIndicator";
import AlertMessage from "../components/AlertMessage";
import { fetchErrorLogs } from "../services/errorLogsService";

function ErrorLogsPage() {
  const [loading, setLoading] = useState(false);
  const [errorMessage, setErrorMessage] = useState("");
  const [logs, setLogs] = useState([]);

  useEffect(() => {
    const loadErrorLogs = async () => {
      setLoading(true);
      setErrorMessage("");
      try {
        const response = await fetchErrorLogs();
        setLogs(response.data || []);
      } catch (error) {
        setErrorMessage(error.response?.data?.message || "Failed to load error logs");
      } finally {
        setLoading(false);
      }
    };

    loadErrorLogs();
  }, []);

  return (
    <div>
      <h2>Error Logs</h2>
      <AlertMessage type="error" message={errorMessage} />
      {loading ? (
        <LoadingIndicator text="Loading error logs..." />
      ) : (
        <Table
          title="Database Error Log"
          columns={[
            { key: "id", label: "ID" },
            { key: "error_message", label: "Error Message" },
            { key: "json_input", label: "JSON Input" },
            { key: "created_at", label: "Created At" }
          ]}
          rows={logs}
        />
      )}
    </div>
  );
}

export default ErrorLogsPage;


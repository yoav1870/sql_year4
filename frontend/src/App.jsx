import { Navigate, Route, Routes } from "react-router-dom";
import NavBar from "./components/NavBar";
import ReportsPage from "./pages/ReportsPage";
import RandomDataPage from "./pages/RandomDataPage";
import JsonInsertPage from "./pages/JsonInsertPage";
import ErrorLogsPage from "./pages/ErrorLogsPage";

function App() {
  return (
    <div className="app-container">
      <NavBar />
      <main className="main-content">
        <Routes>
          <Route path="/" element={<Navigate to="/reports" replace />} />
          <Route path="/reports" element={<ReportsPage />} />
          <Route path="/random-data" element={<RandomDataPage />} />
          <Route path="/insert-json" element={<JsonInsertPage />} />
          <Route path="/error-logs" element={<ErrorLogsPage />} />
        </Routes>
      </main>
    </div>
  );
}

export default App;

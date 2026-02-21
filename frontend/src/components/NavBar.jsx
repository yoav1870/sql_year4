import { NavLink } from "react-router-dom";

function NavBar() {
  return (
    <header className="top-nav">
      <h1>SALES System</h1>
      <nav>
        <NavLink
          to="/reports"
          className={({ isActive }) => (isActive ? "nav-link active" : "nav-link")}
        >
          Reports
        </NavLink>
        <NavLink
          to="/random-data"
          className={({ isActive }) => (isActive ? "nav-link active" : "nav-link")}
        >
          Generate Random Data
        </NavLink>
        <NavLink
          to="/insert-json"
          className={({ isActive }) => (isActive ? "nav-link active" : "nav-link")}
        >
          Insert JSON
        </NavLink>
        <NavLink
          to="/error-logs"
          className={({ isActive }) => (isActive ? "nav-link active" : "nav-link")}
        >
          Error Logs
        </NavLink>
      </nav>
    </header>
  );
}

export default NavBar;

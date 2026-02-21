function AlertMessage({ type = "error", message }) {
  if (!message) return null;
  return <p className={`alert-message ${type}`}>{message}</p>;
}

export default AlertMessage;

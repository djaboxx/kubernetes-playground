# Grafana Dashboards

## What is Grafana?
Grafana is an open-source platform for monitoring and observability. It provides dashboards and visualization tools for metrics collected by Prometheus.

## Setting Up Grafana

### Install Grafana
1. **Add the Grafana Helm repository**:
    ```sh
    helm repo add grafana https://grafana.github.io/helm-charts
    helm repo update
    ```
2. **Install Grafana**:
    ```sh
    helm install grafana grafana/grafana --namespace monitoring --create-namespace
    ```
3. **Access the Grafana UI**:
    ```sh
    kubectl port-forward svc/grafana -n monitoring 3000:80
    ```
    Open your browser and navigate to `http://localhost:3000`.

## Adding Data Sources
1. **Log in to Grafana**: Use the default credentials (username: `admin`, password: `prom-operator`).
2. **Add a new data source**:
    - Navigate to `Configuration` > `Data Sources`.
    - Click `Add data source`.
    - Select `Prometheus` from the list.
    - Configure the data source URL (e.g., `http://prometheus-server.monitoring.svc.cluster.local`).
    - Click `Save & Test` to verify the connection.

## Creating Dashboards
1. **Create a new dashboard**:
    - Navigate to `Create` > `Dashboard`.
    - Click `Add new panel`.
2. **Configure the panel**:
    - Select the `Prometheus` data source.
    - Enter a PromQL query to fetch the desired metrics (e.g., `node_cpu_seconds_total`).
    - Customize the visualization options (e.g., graph, table, gauge).
    - Click `Apply` to save the panel.
3. **Save the dashboard**:
    - Click `Save` at the top of the dashboard.
    - Enter a name for the dashboard and click `Save`.

## Links to Relevant External Documentation and Resources
- [Grafana Documentation](https://grafana.com/docs/)
- [Prometheus Data Source](https://grafana.com/docs/grafana/latest/datasources/prometheus/)
- [Creating Grafana Dashboards](https://grafana.com/docs/grafana/latest/dashboards/)

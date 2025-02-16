# Metrics Collection

## Exporters
Exporters are tools that collect metrics from various systems and expose them in a format that Prometheus can scrape. Some common exporters include:
- **Node Exporter**: Collects hardware and OS metrics from *NIX systems.
- **cAdvisor**: Collects container metrics.
- **Blackbox Exporter**: Probes endpoints over HTTP, HTTPS, DNS, TCP, ICMP, and gRPC.
- **MySQL Exporter**: Collects MySQL server metrics.
- **JMX Exporter**: Collects metrics from Java applications using JMX.

### Setting Up Node Exporter
1. **Install Node Exporter**:
    ```sh
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm repo update
    helm install node-exporter prometheus-community/prometheus-node-exporter --namespace monitoring --create-namespace
    ```
2. **Access Node Exporter Metrics**:
    ```sh
    kubectl port-forward svc/node-exporter -n monitoring 9100:9100
    ```
    Open your browser and navigate to `http://localhost:9100/metrics`.

## Instrumentation
Instrumentation is the process of adding code to an application to expose metrics in a format that Prometheus can scrape. This can be done using client libraries provided by Prometheus for various programming languages, such as Go, Java, Python, and Ruby.

### Example: Instrumenting a Python Application
1. **Install Prometheus Client Library**:
    ```sh
    pip install prometheus-client
    ```
2. **Add Instrumentation Code**:
    ```python
    from prometheus_client import start_http_server, Summary
    import random
    import time

    # Create a metric to track time spent and requests made.
    REQUEST_TIME = Summary('request_processing_seconds', 'Time spent processing request')

    # Decorate function with metric.
    @REQUEST_TIME.time()
    def process_request(t):
        """A dummy function that takes some time."""
        time.sleep(t)

    if __name__ == '__main__':
        # Start up the server to expose the metrics.
        start_http_server(8000)
        # Generate some requests.
        while True:
            process_request(random.random())
    ```
3. **Run the Application**:
    ```sh
    python your_application.py
    ```
    Open your browser and navigate to `http://localhost:8000/metrics` to see the exposed metrics.

## Links to Relevant External Documentation and Resources
- [Prometheus Exporters and Integrations](https://prometheus.io/docs/instrumenting/exporters/)
- [Prometheus Python Client](https://github.com/prometheus/client_python)
- [Prometheus Node Exporter](https://github.com/prometheus/node_exporter)

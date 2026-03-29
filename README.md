# WordPress Multi-Modal Fault Dataset (Prototype)

This repository contains a prototype dataset for cloud-native fault analysis, built on a WordPress application deployed in a Kubernetes environment.

The dataset is designed to support downstream tasks such as:

- anomaly detection
- failure diagnosis
- root cause analysis
- security incident detection

---

## 📌 Overview

We construct a unified pipeline to collect **multi-modal observability data** under controlled fault injection scenarios.

Two types of faults are included:

1. **Security faults**
   - Reproduction of known vulnerabilities (e.g., CVE-2019-17671)

2. **System faults**
   - Controlled failure injection using Chaos Mesh (e.g., pod-kill)

---

## 📂 Dataset Structure

WordPress/
 ├── CVE-2019-17671/
 │   ├── logs/                  # network traces (pcap)
 │   ├── artifacts/             # response headers, probe outputs
 │   ├── attack/                # attack scripts
 │   ├── metadata.json          # scenario description
 │   └── README.md
 │
 └── chaos-injection/
 ├── pod-kill/              # fault definitions (YAML)
 │   └── wp-vuln-podkill.yaml
 │
 └── runs/
 └── 2026-03-28_wp-vuln_podkill/
 ├── logs/          # container logs
 ├── events/        # Kubernetes events
 ├── describe/      # pod descriptions
 ├── manifest/      # deployment snapshots
 ├── alerts/        # Falco security alerts (JSON)
 ├── metrics/       # Prometheus/Grafana observations
 ├── screenshots/   # visualization results
 └── metadata.json  # run-level metadata

---

## ⚙️ Pipeline

The dataset is generated through the following pipeline:

1. **Application Deployment**
   - WordPress deployed on Kubernetes (Kind cluster)
   - Includes both vulnerable and fixed versions

2. **Fault Injection**
   - Security faults: CVE reproduction
   - System faults: Chaos Mesh (e.g., pod-kill)

3. **Observability Collection**
   Multi-modal signals are collected:
   - Logs (application / container)
   - Events (Kubernetes)
   - System state (describe / manifest)
   - Metrics (Prometheus + Grafana)
   - Alerts (Falco)

4. **Dataset Construction**
   - Data is organized into structured directories
   - Each run includes metadata for reproducibility

---

## 🔍 Multi-Modal Signals

This dataset includes the following modalities:

| Modality | Source                   | Description                            |
| -------- | ------------------------ | -------------------------------------- |
| Logs     | Kubernetes / application | Raw system and application logs        |
| Events   | Kubernetes API           | Structured lifecycle events            |
| Describe | kubectl describe         | System state snapshots                 |
| Metrics  | Prometheus + Grafana     | Resource usage and time-series signals |
| Alerts   | Falco                    | Runtime security events                |

---

## 🧪 Example Scenario: Pod Kill

- Fault: Pod termination via Chaos Mesh
- Effect:
  - Pod is killed and recreated
  - Metrics show discontinuity
  - Events record lifecycle changes
  - Logs capture runtime behavior
  - Falco generates security alerts

---

## 🧠 Design Principles

- **Realistic**: Built on real applications and Kubernetes environments
- **Reproducible**: Each run is fully described by metadata
- **Multi-modal**: Combines logs, metrics, events, and alerts
- **Extensible**: Easy to add new applications and fault types

---

## 🚀 Use Cases

This dataset can be used for:

- Log-based anomaly detection
- Multi-modal failure detection
- Root cause analysis
- Security incident detection
- Benchmarking ML / LLM-based systems

---

## ⚠️ Notes

- This is a prototype dataset for research exploration
- Some observability signals (e.g., metrics) are partially visual (screenshots)
- Falco alerts are collected in structured JSON format

---

## 📈 Future Work

- Add more applications (e.g., microservices systems)
- Expand fault types (network, resource, etc.)
- Improve labeling and ground truth alignment
- Release standardized benchmark tasks

---

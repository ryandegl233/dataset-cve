# CVE-2019-17671 Dataset Case

## Overview

This repository contains a reproducible dataset case for **CVE-2019-17671** using WordPress.

The goal of this case is to generate **multi-modal runtime traces** for vulnerability analysis.

The dataset includes:

- vulnerable and fixed WordPress instances
- attack scripts
- syscall traces collected by **sysdig**
- network traces collected by **tcpdump**
- ground-truth attack markers

---

## Environment

Platform:

- Ubuntu (VMware)
- Docker
- Kubernetes (kind)

Namespaces:

- `wp-vuln`
- `wp-fixed`

Deployment file:

- `wp-dual.yaml`

---

## Vulnerability

CVE:

```
CVE-2019-17671
```

Application:

```
WordPress
```

Vulnerable behavior:

The vulnerable version incorrectly accepts the query variable:

```
static
```

Attack payload:

```
GET /?static=1
```

---

## Attack Labeling Strategy

To precisely identify attack events across traces, two types of labels are used.

### Syscall-level markers

The attack scripts insert markers using `logger`:

```
ATTACK_START
ATTACK_STOP
```

These markers are visible in the syscall trace (`.scap`) captured by **sysdig**.

### Network-level markers

The attack request itself includes a unique HTTP header:

```
X-Attack-ID
```

Example:

```
X-Attack-ID: CVE-2019-17671-vuln-001
```

This allows the attack request to be directly identified in the network trace (`.pcap`).

---

## Data Collection

### Syscall Trace

Collected using:

```
sysdig
```

Output files:

```
logs/vuln.scap
logs/fixed.scap
```

These traces contain:

- process execution
- syscall activity
- logger markers

---

### Network Trace

Collected using:

```
tcpdump
```

Example command:

```
tcpdump -i lo port 8080 -w logs/vuln.pcap
```

Output files:

```
logs/vuln.pcap
logs/fixed.pcap
```

The attack request is observable in the pcap:

```
GET /?static=1
X-Attack-ID: ...
```

---

## Ground Truth Verification

Application-level verification is performed using a custom WordPress probe plugin:

```
qv-probe.php
```

The plugin adds response headers:

```
X-Static-PublicQv
X-Static-InQueryVars
```

Expected results:

### Vulnerable version

```
X-Static-PublicQv: 1
X-Static-InQueryVars: 1
```

### Fixed version

```
X-Static-PublicQv: 0
X-Static-InQueryVars: 0
```

---

## Repository Structure

```
CVE-2019-17671/
├── metadata.json
├── README.md
├── wp-dual.yaml
├── kind-config.yaml
├── qv-probe.php
├── attack_vuln_tagged.sh
├── attack_fixed_tagged.sh
├── artifacts/
│   ├── vuln_response_headers.txt
│   └── fixed_response_headers.txt
└── logs/
    ├── vuln.scap
    ├── fixed.scap
    ├── vuln.pcap
    └── fixed.pcap
```

---

## Purpose

This dataset case can support research tasks such as:

- vulnerability behavior analysis
- runtime anomaly detection
- syscall-level security monitoring
- network traffic analysis
- vulnerability patch verification

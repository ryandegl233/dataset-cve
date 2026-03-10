# CVE-2019-17671 Dataset Case

## Overview

This case reproduces **CVE-2019-17671** in WordPress and organizes the result as a fault-oriented dataset sample.

The dataset includes:

- a vulnerable WordPress instance
- a fixed WordPress instance
- attack scripts
- HTTP-level behavioral evidence
- syscall traces collected by sysdig
- network traces collected by tcpdump

---

## Environment

Platform:

- Ubuntu VM (VMware)
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

- **CVE-2019-17671**

Target application:

- **WordPress**

Vulnerable behavior:

- an unregistered query variable (`static`) is accepted and processed by the vulnerable version

Attack payload:

- `GET /?static=1`

---

## Ground Truth Signal

A custom probe plugin (`qv-probe.php`) is injected into both WordPress instances.

The probe returns two HTTP headers:

- `X-Static-PublicQv`
- `X-Static-InQueryVars`

### Vulnerable Version

Expected headers:

- `X-Static-PublicQv: 1`
- `X-Static-InQueryVars: 1`

### Fixed Version

Expected headers:

- `X-Static-PublicQv: 0`
- `X-Static-InQueryVars: 0`

This confirms that the vulnerable version accepts the `static` query variable, while the fixed version does not.

---

## Attack Scripts

The case includes two tagged attack scripts:

- `attack_vuln_tagged.sh`
- `attack_fixed_tagged.sh`

These scripts:

1. insert an attack-start marker using `logger`
2. send the HTTP request
3. save response headers
4. insert an attack-stop marker

Attack request examples:

- `http://localhost:8080/?static=1` for vulnerable
- `http://localhost:8082/?static=1` for fixed

---

## Runtime Evidence

### Application-Level Evidence

Captured response headers are stored in:

- `artifacts/vuln_response_headers.txt`
- `artifacts/fixed_response_headers.txt`

These files show the expected vulnerable/fixed behavior difference.

### Syscall-Level Evidence

System-call traces were collected using **sysdig**:

- `logs/vuln.scap`
- `logs/fixed.scap`

The traces contain runtime evidence such as:

- `curl` execution
- `logger` execution
- `apache2` activity

The attack marker is visible in the syscall trace through the `logger` process arguments, for example:

- `ATTACK_START vuln`
- `ATTACK_STOP vuln`

### Network-Level Evidence

Network traces were collected using **tcpdump**:

- `logs/vuln.pcap`
- `logs/fixed.pcap`

The vulnerable trace includes the attack request:

- `GET /?static=1 HTTP/1.1`

This confirms that the attack traffic is present at the network layer.

---

## Dataset Structure

```text
CVE-2019-17671/
├── metadata.json
├── README.md
├── kind-config.yaml
├── wp-dual.yaml
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

This sample is intended for fault-oriented dataset construction and can support downstream tasks such as:

- vulnerability behavior analysis
- runtime anomaly detection
- syscall-level security research
- network traffic analysis
- patch verification
- multi-modal security benchmark construction

---

## Status

I have completed:

- vulnerable/fixed deployment
- attack reproduction
- behavioral verification
- syscall trace collection
- network trace collection
- dataset artifact organization

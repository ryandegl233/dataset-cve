# CVE-2019-17671 Dataset Case

## Overview

This dataset sample reproduces **CVE-2019-17671**, a vulnerability in WordPress where unregistered query variables can be processed by the application.

The case includes both a **vulnerable version** and a **fixed version**, deployed in Kubernetes, and captures the runtime behavior using **sysdig**.

---

## Environment

Platform:

- Kubernetes (kind)
- Ubuntu VM (VMware)

Namespaces:

- wp-vuln
- wp-fixed

Deployment manifest:

wp-dual.yaml

---

## Vulnerability

CVE: **CVE-2019-17671**

The vulnerability allows unregistered query variables to be accepted by WordPress.

Example payload:

GET /?static=1

---

## Detection Signal

A probe plugin (`qv-probe.php`) is injected into WordPress to expose whether the query variable is accepted.

HTTP headers returned by the probe:

### Vulnerable

X-Static-PublicQv: 1  
X-Static-InQueryVars: 1

### Fixed

X-Static-PublicQv: 0  
X-Static-InQueryVars: 0

---

## Attack Scripts

attack_vuln_tagged.sh  
attack_fixed_tagged.sh

These scripts send HTTP requests to the WordPress service and log attack markers using `logger`.

Example payload:

curl http://localhost:8080/?static=1

---

## Artifacts

HTTP response headers captured during attack execution:

artifacts/vuln_response_headers.txt  
artifacts/fixed_response_headers.txt

These files contain the exact headers returned by the WordPress service during the attack.

---

## Runtime Logs

Dynamic system-call traces were collected using **sysdig**.

logs/vuln.scap  
logs/fixed.scap

These traces contain runtime system calls related to the attack execution, including:

- curl execution
- Apache request handling
- WordPress processing

---

## Dataset Structure

CVE-2019-17671/

metadata.json  
README.md  

wp-dual.yaml  
qv-probe.php  

attack_vuln_tagged.sh  
attack_fixed_tagged.sh  

artifacts/  
    vuln_response_headers.txt  
    fixed_response_headers.txt  

logs/  
    vuln.scap  
    fixed.scap  

---

## Purpose

This case is designed for **fault dataset construction** and can be used for:

- vulnerability detection research
- runtime anomaly detection
- syscall-level security analysis
- patch verification studies

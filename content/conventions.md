# Conventions Used in This Book

To make this documentation clear and consistent, we follow these conventions:

## Text Formatting

- `monospace` - Used for:
  - Command line instructions
  - File paths
  - Code snippets
  - Configuration values
- **Bold** - Used for:
  - UI elements
  - Important concepts
  - Key terms when first introduced
- *Italic* - Used for:
  - Emphasis
  - File names
  - Directory names

## Code Blocks

```yaml
# Configuration examples are shown like this
apiVersion: v1
kind: ConfigMap
metadata:
  name: example
```

## Command Line Examples

```bash
$ kubectl get pods        # Commands to run
> output text here       # Expected output
```

## Callouts

> **Note:** Important information or tips are highlighted in note blocks

> **Warning:** Critical information or potential pitfalls are highlighted in warning blocks

## External Links

External references are marked with an external link icon and open in a new tab.

## Version Information

- Version-specific information is clearly marked with the applicable Kubernetes version
- Default examples use the latest stable Kubernetes release
- Legacy versions are noted when relevant for compatibility
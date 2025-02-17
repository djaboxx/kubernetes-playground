name: Release
on:
  push:
    tags:
      - 'v[0-9]+.[0-9]+.[0-9]+*'

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
    - name: Validate semver tag
      run: |
        TAG=${GITHUB_REF#refs/tags/}
        if ! echo "$TAG" | grep -qE '^v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)(-((0|[1-9][0-9]*|[0-9]*[a-zA-Z-][0-9a-zA-Z-]*)(\.(0|[1-9][0-9]*|[0-9]*[a-zA-Z-][0-9a-zA-Z-]*))*))?(\+([0-9a-zA-Z-]+(\.[0-9a-zA-Z-]+)*))?$'; then
          echo "Invalid semantic version tag: $TAG"
          exit 1
        fi

  release:
    needs: validate
    runs-on: ubuntu-latest
    permissions:
      contents: write
      
    steps:
    - uses: actions/checkout@v4
      with:
        fetch-depth: 0
    
    - name: Generate changelog
      id: changelog
      run: |
        PREVIOUS_TAG=$(git describe --tags --abbrev=0 HEAD^ 2>/dev/null || echo "")
        if [ -z "$PREVIOUS_TAG" ]; then
          git log --pretty=format:"* %s" > CHANGELOG.txt
        else
          git log --pretty=format:"* %s" ${PREVIOUS_TAG}..HEAD > CHANGELOG.txt
        fi
        
    - name: Create Release
      uses: softprops/action-gh-release@v1
      with:
        body_path: CHANGELOG.txt
        generate_release_notes: true
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
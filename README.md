## build and push 
```
docker build -t ldbl/helm-concourse-gcp:2.6.2 .
docker push ldbl/helm-concourse-gcp:2.6.2
```
### Usage: 
#### Resource type helm 
```
resource_types:
- name: helm
  type: docker-image
  source:
    repository: ldbl/helm-concourse-gcp
    tag: 2.6.2
```

#### Publish helm chart 

```
  - name: deploy-chart
    plan:
    - get: app-image
      trigger: true
      passed:
      - build-image
    - get: chart-source
      trigger: true
    - task: build-chart
      file: chart-source/tasks/prep-chart.yaml
      params:
	bucket: {{bucket}}
        chart_name: {{chart_name}}
    - put: {{release_name}}
      params:
	chart: gcs-repo/{{chart_name}}
        override_values:
        - key: image.repository
          path: app-image/repository
        - key: image.digest
          path: app-image/digest
```

### For some reason I found it works with linkyard/concourse-helm-resource:2.6.2 but not with the latest version.


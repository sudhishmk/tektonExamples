1. Create Git personal access token with permissions to access the required repo.

2. Create a secret with username and PAT. Ensure that secret is created in same namespace where taskrun is executed.

   ```yaml
   kind: Secret
   apiVersion: v1
   metadata:
     name: basic-user-pass
   data:
     password: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
     username: xxxxxxxxxxxxxxxxxxxxx
   type: kubernetes.io/basic-auth
   ```

3. Create a new ServiceAccount with reference to secret or edit the existing Service account and add the reference. Ensure SA is also present in same namespace.

   ```yaml
   kind: ServiceAccount
   apiVersion: v1
   metadata:
     name: pipeline
   secrets:
     - name: pipeline-dockercfg-vxplf
     - name: basic-user-pass
   imagePullSecrets:
     - name: pipeline-dockercfg-vxplf
   ```

4. Create Taskrun with reference of the service account and task reference. I have used the git-clone task available in the artifactrepo (<https://artifacthub.io/packages/tekton-task/redhat-tekton-tasks/git-clone?modal=manifest>).

   ```yaml
   apiVersion: tekton.dev/v1
   kind: TaskRun
   metadata:
     name: gitcloneexample
   spec:
     params:
       - name: URL
         value: '[https://github.com/sudhishmk/kust_dc.git](https://github.com/sudhishmk/kust_dc.git)'
     serviceAccountName: pipeline
     taskRef:
       kind: Task
       name: git-clone
     timeout: 1h0m0s
     workspaces:
       - name: output
         persistentVolumeClaim:
           claimName: shared-workspace-pvc
```

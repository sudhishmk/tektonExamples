1. Create Git personal access token with permissions to access the required repo.

2. Copy `secret-basic-user-pass.example.yaml` to `secret-basic-user-pass.yaml`, replace the placeholder values with a username and a newly scoped token, and apply it in the same namespace as the TaskRun. The local secret file is ignored by Git. If a token from an earlier version of this repository was real, revoke it.

   ```yaml
   kind: Secret
   apiVersion: v1
   metadata:
     name: basic-user-pass
     annotations:
       tekton.dev/git-0: 'https://github.com'
   stringData:
     password: REPLACE_WITH_GIT_TOKEN
     username: REPLACE_WITH_GIT_USERNAME
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

# Example to Send Notification of aggregate status of tasks.

# Pre-requisite

    OpenShift
    Tekton installed (via Operator)
    oc and tkn CLI installed


# Update with "server-secret.yaml" with your smtp server details.
If you are using gmail as smtp server, generate APP password and use it as password in your secrets

# Sample Parameters for the Pipeline


    APP_NAME=quarkus-hello
    NAMESPACE=send-status-notification-demo
    GIT_REPO=https://github.com/tqvarnst/quarkus-tekton-example


# Install the secret, task and the pipeline

    oc new-project $NAMESPACE
    oc apply -f tkn/server-secret.yaml
    oc apply -f tkn/sendmail.yaml
    oc apply -f tkn/build-quarkus-s2i-finally.yaml

## To run the pipeline


    tkn pipeline start build-quarkus-s2i-finally \
        --workspace name=shared-workspace,volumeClaimTemplateFile=https://raw.githubusercontent.com/openshift/pipelines-tutorial/pipelines-1.5/01_pipeline/03_persistent_volume_claim.yaml \
        -p deployment-name=$APP_NAME \
        -p git-url=$GIT_REPO \
         -p IMAGE=image-registry.openshift-image-registry.svc:5000/$NAMESPACE/$APP_NAME \
        --use-param-defaults

## Output

On successfull completeion of all tasks, a mail with subject and body "succeded" would be send to recepients mail id

If any task fails, a mail with subject and body "failed" would be send to recepients mail id. You can pass a wrong value to GIT_REPO param to test failure scenario




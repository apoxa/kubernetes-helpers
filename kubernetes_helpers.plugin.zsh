# Default directory for downloads of binary files
zstyle ':k8sctl:binaries' path ${HOME}/.local/bin
zstyle ':k8sctl:binaries' os ${$(uname -s):l}
case "$(uname -m)" in
    x86_64)
        zstyle ':k8sctl:binaries' arch amd64
        ;;
    arm64)
        zstyle ':k8sctl:binaries' arch arm64
        ;;
esac

# clusterctl
clusterctl_download(){
    VERSION=$1
    zstyle -s ':k8sctl:binaries' path BIN_FOLDER
    zstyle -s ':k8sctl:binaries' os BIN_OS
    zstyle -s ':k8sctl:binaries' arch BIN_ARCH

    test -z "${VERSION}" && return
    test -d "${BIN_FOLDER}" || mkdir -p "${BIN_FOLDER}"

    if [ ! -f "${BIN_FOLDER}/clusterctl-${VERSION}" ]; then
        echo "downloading clusterctl-${VERSION}"
        curl -L --url "https://github.com/kubernetes-sigs/cluster-api/releases/download/${VERSION}/clusterctl-${BIN_OS}-${BIN_ARCH}" --output "${BIN_FOLDER}/clusterctl-${VERSION}"
        chmod +x "${BIN_FOLDER}/clusterctl-${VERSION}"
    else
        echo "clusterctl-${VERSION} already exists"
    fi

    clusterctl_switch "${VERSION}"
}

clusterctl_switch(){
    VERSION=$1
    zstyle -s ':k8sctl:binaries' path BIN_FOLDER
    echo "Switching to clusterctl-${VERSION}"
    ln -fs "${BIN_FOLDER}/clusterctl-${VERSION}" "${BIN_FOLDER}/clusterctl"

    # rebuild completion for current version and source it
    clusterctl completion zsh >! ${ZSH_CACHE_DIR}/_clusterctl_completion
    source "${ZSH_CACHE_DIR}/_clusterctl_completion"
}

# kubectl
kubectl_download(){
    VERSION=$1
    zstyle -s ':k8sctl:binaries' path BIN_FOLDER
    zstyle -s ':k8sctl:binaries' os BIN_OS
    zstyle -s ':k8sctl:binaries' arch BIN_ARCH

    test -z "${VERSION}" && return
    test -d "${BIN_FOLDER}" || mkdir -p "${BIN_FOLDER}"

    if [ ! -f "${BIN_FOLDER}/kubectl-${VERSION}" ]; then
        echo "downloading kubectl-$VERSION"
        curl -L --url "https://storage.googleapis.com/kubernetes-release/release/${VERSION}/bin/${BIN_OS}/${BIN_ARCH}/kubectl" --output "${BIN_FOLDER}/kubectl-${VERSION}"
        chmod +x "${BIN_FOLDER}/kubectl-${VERSION}"
    else
        echo "kubectl-${VERSION} already exists"
    fi

    kubectl_switch "${VERSION}"
}

kubectl_switch(){
    VERSION=$1
    zstyle -s ':k8sctl:binaries' path BIN_FOLDER
    echo "Switching to kubectl-$VERSION"
    ln -fs "${BIN_FOLDER}/kubectl-${VERSION}" "${BIN_FOLDER}/kubectl"

    # rebuild completion for current version and source it
    kubectl completion zsh >! ${ZSH_CACHE_DIR}/_kubectl_completion
    source "${ZSH_CACHE_DIR}/_kubectl_completion"
}

# kind
kind_download(){
    VERSION=$1
    zstyle -s ':k8sctl:binaries' path BIN_FOLDER
    zstyle -s ':k8sctl:binaries' os BIN_OS
    zstyle -s ':k8sctl:binaries' arch BIN_ARCH

    test -z "${VERSION}" && return
    test -d "${BIN_FOLDER}" || mkdir -p "${BIN_FOLDER}"

    if [ ! -f "${BIN_FOLDER}/kind-${VERSION}" ];
    then
        echo "downloading kind-${VERSION}"
        curl -L --url "https://github.com/kubernetes-sigs/kind/releases/download/${VERSION}/kind-${BIN_OS}-${BIN_ARCH}"  --output "${BIN_FOLDER}/kind-${VERSION}"
        chmod +x "${BIN_FOLDER}/kind-${VERSION}"
    else
        echo "kind-${VERSION} already exists"
    fi

    kind_switch "${VERSION}"
}

kind_switch(){
    VERSION=$1
    zstyle -s ':k8sctl:binaries' path BIN_FOLDER
    echo "Switching to kind-${VERSION}"
    ln -fs "${BIN_FOLDER}/kind-${VERSION}" "${BIN_FOLDER}/kind"

    # rebuild completion for current version and source it
    kind completion zsh >! ${ZSH_CACHE_DIR}/_kind_completion
    source "${ZSH_CACHE_DIR}/_kind_completion"
}

# kind kubeconfig (requires https://github.com/chrischdi/k8s-ctx-import)
kind_kubeconfig() {
    cluster=$1
    (( ! $+commands[k8s-ctx-import] )) && >&2 echo "k8s-ctx-import not installed" && return
    if [[ -z "$cluster" ]]; then
        echo "Getting kubeconfig of first cluster"
        cluster=$(kind get clusters | head -n 1)
    fi
    kind get kubeconfig --name=${cluster} | k8s-ctx-import
}

# kubebuilder
kubebuilder_download(){
    VERSION=$1
    zstyle -s ':k8sctl:binaries' path BIN_FOLDER
    zstyle -s ':k8sctl:binaries' os BIN_OS
    zstyle -s ':k8sctl:binaries' arch BIN_ARCH

    test -z "${VERSION}" && return
    test -d "${BIN_FOLDER}" || mkdir -p "${BIN_FOLDER}"

    if [ ! -f "${BIN_FOLDER}/kubebuilder-${VERSION}" ];
    then
        echo "downloading kubebuilder-${VERSION}"
        curl -L --url "https://github.com/kubernetes-sigs/kubebuilder/releases/download/${VERSION}/kubebuilder_${BIN_OS}_${BIN_ARCH}"  --output "${BIN_FOLDER}/kubebuilder-${VERSION}"
        chmod +x "${BIN_FOLDER}/kubebuilder-${VERSION}"
    else
        echo "kubebuilder-${VERSION} already exists"
    fi

    kubebuilder_switch "${VERSION}"
}

kubebuilder_switch(){
    VERSION=$1
    zstyle -s ':k8sctl:binaries' path BIN_FOLDER
    echo "Switching to kubebuilder-${VERSION}"
    ln -fs "${BIN_FOLDER}/kubebuilder-${VERSION}" "${BIN_FOLDER}/kubebuilder"

    # rebuild completion for current version and source it
    kubebuilder completion zsh >! ${ZSH_CACHE_DIR}/_kubebuilder_completion
    source "${ZSH_CACHE_DIR}/_kubebuilder_completion"
}

# Load completions on startup
for program in clusterctl kubectl kind; do
    [[ -f "${ZSH_CACHE_DIR}/_${program}_completion" ]] && source "${ZSH_CACHE_DIR}/_${program}_completion"
done

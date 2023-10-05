<article class="markdown-body entry-content container-lg" itemprop="text"><h1 tabindex="-1" id="user-content-kubeadm-installation-guide" dir="auto"><a class="heading-link" href="#kubeadm-installation-guide">Kubeadm Installation Guide<svg class="octicon octicon-link" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path d="m7.775 3.275 1.25-1.25a3.5 3.5 0 1 1 4.95 4.95l-2.5 2.5a3.5 3.5 0 0 1-4.95 0 .751.751 0 0 1 .018-1.042.751.751 0 0 1 1.042-.018 1.998 1.998 0 0 0 2.83 0l2.5-2.5a2.002 2.002 0 0 0-2.83-2.83l-1.25 1.25a.751.751 0 0 1-1.042-.018.751.751 0 0 1-.018-1.042Zm-4.69 9.64a1.998 1.998 0 0 0 2.83 0l1.25-1.25a.751.751 0 0 1 1.042.018.751.751 0 0 1 .018 1.042l-1.25 1.25a3.5 3.5 0 1 1-4.95-4.95l2.5-2.5a3.5 3.5 0 0 1 4.95 0 .751.751 0 0 1-.018 1.042.751.751 0 0 1-1.042.018 1.998 1.998 0 0 0-2.83 0l-2.5 2.5a1.998 1.998 0 0 0 0 2.83Z"></path></svg></a></h1>
<p dir="auto">This guide outlines the steps needed to set up a Kubernetes cluster using kubeadm.</p>
<h2 tabindex="-1" id="user-content-pre-requisites" dir="auto"><a class="heading-link" href="#pre-requisites">Pre-requisites<svg class="octicon octicon-link" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path d="m7.775 3.275 1.25-1.25a3.5 3.5 0 1 1 4.95 4.95l-2.5 2.5a3.5 3.5 0 0 1-4.95 0 .751.751 0 0 1 .018-1.042.751.751 0 0 1 1.042-.018 1.998 1.998 0 0 0 2.83 0l2.5-2.5a2.002 2.002 0 0 0-2.83-2.83l-1.25 1.25a.751.751 0 0 1-1.042-.018.751.751 0 0 1-.018-1.042Zm-4.69 9.64a1.998 1.998 0 0 0 2.83 0l1.25-1.25a.751.751 0 0 1 1.042.018.751.751 0 0 1 .018 1.042l-1.25 1.25a3.5 3.5 0 1 1-4.95-4.95l2.5-2.5a3.5 3.5 0 0 1 4.95 0 .751.751 0 0 1-.018 1.042.751.751 0 0 1-1.042.018 1.998 1.998 0 0 0-2.83 0l-2.5 2.5a1.998 1.998 0 0 0 0 2.83Z"></path></svg></a></h2>
<ul dir="auto">
<li>Ubuntu OS (Xenial or later)</li>
<li>sudo privileges</li>
<li>Internet access</li>
<li>t2.medium instance type or higher</li>
</ul>
<hr>
<h2 tabindex="-1" id="user-content-both-master--worker-node" dir="auto"><a class="heading-link" href="#both-master--worker-node">Both Master &amp; Worker Node<svg class="octicon octicon-link" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path d="m7.775 3.275 1.25-1.25a3.5 3.5 0 1 1 4.95 4.95l-2.5 2.5a3.5 3.5 0 0 1-4.95 0 .751.751 0 0 1 .018-1.042.751.751 0 0 1 1.042-.018 1.998 1.998 0 0 0 2.83 0l2.5-2.5a2.002 2.002 0 0 0-2.83-2.83l-1.25 1.25a.751.751 0 0 1-1.042-.018.751.751 0 0 1-.018-1.042Zm-4.69 9.64a1.998 1.998 0 0 0 2.83 0l1.25-1.25a.751.751 0 0 1 1.042.018.751.751 0 0 1 .018 1.042l-1.25 1.25a3.5 3.5 0 1 1-4.95-4.95l2.5-2.5a3.5 3.5 0 0 1 4.95 0 .751.751 0 0 1-.018 1.042.751.751 0 0 1-1.042.018 1.998 1.998 0 0 0-2.83 0l-2.5 2.5a1.998 1.998 0 0 0 0 2.83Z"></path></svg></a></h2>
<p dir="auto">Run the following commands on both the master and worker nodes to prepare them for kubeadm.</p>
<div class="highlight highlight-source-shell notranslate position-relative overflow-auto" dir="auto"><pre><span class="pl-c"><span class="pl-c">#</span> using 'sudo su' is not a good practice.</span>
sudo apt update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo apt install docker.io -y

sudo systemctl <span class="pl-c1">enable</span> --now docker <span class="pl-c"><span class="pl-c">#</span> enable and start in single command.</span>

<span class="pl-c"><span class="pl-c">#</span> Adding GPG keys.</span>
curl -fsSL <span class="pl-s"><span class="pl-pds">"</span>https://packages.cloud.google.com/apt/doc/apt-key.gpg<span class="pl-pds">"</span></span> <span class="pl-k">|</span> sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/kubernetes-archive-keyring.gpg

<span class="pl-c"><span class="pl-c">#</span> Add the repository to the sourcelist.</span>
<span class="pl-c1">echo</span> <span class="pl-s"><span class="pl-pds">'</span>deb https://packages.cloud.google.com/apt kubernetes-xenial main<span class="pl-pds">'</span></span> <span class="pl-k">|</span> sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update 
sudo apt install kubeadm=1.20.0-00 kubectl=1.20.0-00 kubelet=1.20.0-00 -y</pre><div class="zeroclipboard-container">
    <clipboard-copy aria-label="Copy" class="ClipboardButton btn btn-invisible js-clipboard-copy m-2 p-0 tooltipped-no-delay d-flex flex-justify-center flex-items-center" data-copy-feedback="Copied!" data-tooltip-direction="w" value="# using 'sudo su' is not a good practice.
sudo apt update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo apt install docker.io -y

sudo systemctl enable --now docker # enable and start in single command.

# Adding GPG keys.
curl -fsSL &quot;https://packages.cloud.google.com/apt/doc/apt-key.gpg&quot; | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/kubernetes-archive-keyring.gpg

# Add the repository to the sourcelist.
echo 'deb https://packages.cloud.google.com/apt kubernetes-xenial main' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update 
sudo apt install kubeadm=1.20.0-00 kubectl=1.20.0-00 kubelet=1.20.0-00 -y" tabindex="0" role="button">
      <svg aria-hidden="true" height="16" viewBox="0 0 16 16" version="1.1" width="16" data-view-component="true" class="octicon octicon-copy js-clipboard-copy-icon">
    <path d="M0 6.75C0 5.784.784 5 1.75 5h1.5a.75.75 0 0 1 0 1.5h-1.5a.25.25 0 0 0-.25.25v7.5c0 .138.112.25.25.25h7.5a.25.25 0 0 0 .25-.25v-1.5a.75.75 0 0 1 1.5 0v1.5A1.75 1.75 0 0 1 9.25 16h-7.5A1.75 1.75 0 0 1 0 14.25Z"></path><path d="M5 1.75C5 .784 5.784 0 6.75 0h7.5C15.216 0 16 .784 16 1.75v7.5A1.75 1.75 0 0 1 14.25 11h-7.5A1.75 1.75 0 0 1 5 9.25Zm1.75-.25a.25.25 0 0 0-.25.25v7.5c0 .138.112.25.25.25h7.5a.25.25 0 0 0 .25-.25v-7.5a.25.25 0 0 0-.25-.25Z"></path>
</svg>
      <svg aria-hidden="true" height="16" viewBox="0 0 16 16" version="1.1" width="16" data-view-component="true" class="octicon octicon-check js-clipboard-check-icon color-fg-success d-none">
    <path d="M13.78 4.22a.75.75 0 0 1 0 1.06l-7.25 7.25a.75.75 0 0 1-1.06 0L2.22 9.28a.751.751 0 0 1 .018-1.042.751.751 0 0 1 1.042-.018L6 10.94l6.72-6.72a.75.75 0 0 1 1.06 0Z"></path>
</svg>
    </clipboard-copy>
  </div></div>
<p dir="auto"><strong>Sample Command run on master node</strong></p>
<p dir="auto"><kbd><a target="_blank" rel="noopener noreferrer" href="https://user-images.githubusercontent.com/40052830/261847299-a4e7a4af-31fa-40cf-bb9e-64ba18999cb5.png"><img src="https://user-images.githubusercontent.com/40052830/261847299-a4e7a4af-31fa-40cf-bb9e-64ba18999cb5.png" alt="image" style="max-width: 100%;"></a></kbd></p>
<p dir="auto"><kbd><a target="_blank" rel="noopener noreferrer" href="https://user-images.githubusercontent.com/40052830/261847246-acf157b8-5c7b-44e7-91ef-b5437053be60.png"><img src="https://user-images.githubusercontent.com/40052830/261847246-acf157b8-5c7b-44e7-91ef-b5437053be60.png" alt="image" style="max-width: 100%;"></a></kbd></p>
<p dir="auto"><kbd><a target="_blank" rel="noopener noreferrer" href="https://user-images.githubusercontent.com/40052830/261847209-8f960aae-3706-43cd-bac8-1903fbe8196d.png"><img src="https://user-images.githubusercontent.com/40052830/261847209-8f960aae-3706-43cd-bac8-1903fbe8196d.png" alt="image" style="max-width: 100%;"></a></kbd></p>
<hr>
<h2 tabindex="-1" id="user-content-master-node" dir="auto"><a class="heading-link" href="#master-node">Master Node<svg class="octicon octicon-link" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path d="m7.775 3.275 1.25-1.25a3.5 3.5 0 1 1 4.95 4.95l-2.5 2.5a3.5 3.5 0 0 1-4.95 0 .751.751 0 0 1 .018-1.042.751.751 0 0 1 1.042-.018 1.998 1.998 0 0 0 2.83 0l2.5-2.5a2.002 2.002 0 0 0-2.83-2.83l-1.25 1.25a.751.751 0 0 1-1.042-.018.751.751 0 0 1-.018-1.042Zm-4.69 9.64a1.998 1.998 0 0 0 2.83 0l1.25-1.25a.751.751 0 0 1 1.042.018.751.751 0 0 1 .018 1.042l-1.25 1.25a3.5 3.5 0 1 1-4.95-4.95l2.5-2.5a3.5 3.5 0 0 1 4.95 0 .751.751 0 0 1-.018 1.042.751.751 0 0 1-1.042.018 1.998 1.998 0 0 0-2.83 0l-2.5 2.5a1.998 1.998 0 0 0 0 2.83Z"></path></svg></a></h2>
<ol dir="auto">
<li>
<p dir="auto">Initialize the Kubernetes master node.</p>
<div class="highlight highlight-source-shell notranslate position-relative overflow-auto" dir="auto"><pre>sudo kubeadm init</pre><div class="zeroclipboard-container">
    <clipboard-copy aria-label="Copy" class="ClipboardButton btn btn-invisible js-clipboard-copy m-2 p-0 tooltipped-no-delay d-flex flex-justify-center flex-items-center" data-copy-feedback="Copied!" data-tooltip-direction="w" value="sudo kubeadm init" tabindex="0" role="button">
      <svg aria-hidden="true" height="16" viewBox="0 0 16 16" version="1.1" width="16" data-view-component="true" class="octicon octicon-copy js-clipboard-copy-icon">
    <path d="M0 6.75C0 5.784.784 5 1.75 5h1.5a.75.75 0 0 1 0 1.5h-1.5a.25.25 0 0 0-.25.25v7.5c0 .138.112.25.25.25h7.5a.25.25 0 0 0 .25-.25v-1.5a.75.75 0 0 1 1.5 0v1.5A1.75 1.75 0 0 1 9.25 16h-7.5A1.75 1.75 0 0 1 0 14.25Z"></path><path d="M5 1.75C5 .784 5.784 0 6.75 0h7.5C15.216 0 16 .784 16 1.75v7.5A1.75 1.75 0 0 1 14.25 11h-7.5A1.75 1.75 0 0 1 5 9.25Zm1.75-.25a.25.25 0 0 0-.25.25v7.5c0 .138.112.25.25.25h7.5a.25.25 0 0 0 .25-.25v-7.5a.25.25 0 0 0-.25-.25Z"></path>
</svg>
      <svg aria-hidden="true" height="16" viewBox="0 0 16 16" version="1.1" width="16" data-view-component="true" class="octicon octicon-check js-clipboard-check-icon color-fg-success d-none">
    <path d="M13.78 4.22a.75.75 0 0 1 0 1.06l-7.25 7.25a.75.75 0 0 1-1.06 0L2.22 9.28a.751.751 0 0 1 .018-1.042.751.751 0 0 1 1.042-.018L6 10.94l6.72-6.72a.75.75 0 0 1 1.06 0Z"></path>
</svg>
    </clipboard-copy>
  </div></div>
<p dir="auto"><kbd><a target="_blank" rel="noopener noreferrer" href="https://user-images.githubusercontent.com/40052830/261847539-4fed3d68-eb41-423d-b83f-35c3cc11476e.png"><img src="https://user-images.githubusercontent.com/40052830/261847539-4fed3d68-eb41-423d-b83f-35c3cc11476e.png" alt="image" style="max-width: 100%;"></a></kbd></p>
<p dir="auto">After succesfully running, your Kubernetes control plane will be initialized successfully.</p>
<p dir="auto"><kbd><a target="_blank" rel="noopener noreferrer" href="https://user-images.githubusercontent.com/40052830/261847658-760276f4-9146-4bc1-aa92-48cc1c0b13f4.png"><img src="https://user-images.githubusercontent.com/40052830/261847658-760276f4-9146-4bc1-aa92-48cc1c0b13f4.png" alt="image" style="max-width: 100%;"></a></kbd></p>
</li>
<li>
<p dir="auto">Set up local kubeconfig (both for root user and normal user):</p>
<div class="highlight highlight-source-shell notranslate position-relative overflow-auto" dir="auto"><pre>mkdir -p <span class="pl-smi">$HOME</span>/.kube
sudo cp -i /etc/kubernetes/admin.conf <span class="pl-smi">$HOME</span>/.kube/config
sudo chown <span class="pl-s"><span class="pl-pds">$(</span>id -u<span class="pl-pds">)</span></span>:<span class="pl-s"><span class="pl-pds">$(</span>id -g<span class="pl-pds">)</span></span> <span class="pl-smi">$HOME</span>/.kube/config</pre><div class="zeroclipboard-container">
    <clipboard-copy aria-label="Copy" class="ClipboardButton btn btn-invisible js-clipboard-copy m-2 p-0 tooltipped-no-delay d-flex flex-justify-center flex-items-center" data-copy-feedback="Copied!" data-tooltip-direction="w" value="mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config" tabindex="0" role="button">
      <svg aria-hidden="true" height="16" viewBox="0 0 16 16" version="1.1" width="16" data-view-component="true" class="octicon octicon-copy js-clipboard-copy-icon">
    <path d="M0 6.75C0 5.784.784 5 1.75 5h1.5a.75.75 0 0 1 0 1.5h-1.5a.25.25 0 0 0-.25.25v7.5c0 .138.112.25.25.25h7.5a.25.25 0 0 0 .25-.25v-1.5a.75.75 0 0 1 1.5 0v1.5A1.75 1.75 0 0 1 9.25 16h-7.5A1.75 1.75 0 0 1 0 14.25Z"></path><path d="M5 1.75C5 .784 5.784 0 6.75 0h7.5C15.216 0 16 .784 16 1.75v7.5A1.75 1.75 0 0 1 14.25 11h-7.5A1.75 1.75 0 0 1 5 9.25Zm1.75-.25a.25.25 0 0 0-.25.25v7.5c0 .138.112.25.25.25h7.5a.25.25 0 0 0 .25-.25v-7.5a.25.25 0 0 0-.25-.25Z"></path>
</svg>
      <svg aria-hidden="true" height="16" viewBox="0 0 16 16" version="1.1" width="16" data-view-component="true" class="octicon octicon-check js-clipboard-check-icon color-fg-success d-none">
    <path d="M13.78 4.22a.75.75 0 0 1 0 1.06l-7.25 7.25a.75.75 0 0 1-1.06 0L2.22 9.28a.751.751 0 0 1 .018-1.042.751.751 0 0 1 1.042-.018L6 10.94l6.72-6.72a.75.75 0 0 1 1.06 0Z"></path>
</svg>
    </clipboard-copy>
  </div></div>
<p dir="auto"><kbd><a target="_blank" rel="noopener noreferrer" href="https://user-images.githubusercontent.com/40052830/261847772-f647adc1-0976-490e-b9c9-f6f96908d6fe.png"><img src="https://user-images.githubusercontent.com/40052830/261847772-f647adc1-0976-490e-b9c9-f6f96908d6fe.png" alt="image" style="max-width: 100%;"></a></kbd></p>
</li>
<li>
<p dir="auto">Apply Weave network:</p>
<div class="highlight highlight-source-shell notranslate position-relative overflow-auto" dir="auto"><pre>kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml</pre><div class="zeroclipboard-container">
    <clipboard-copy aria-label="Copy" class="ClipboardButton btn btn-invisible js-clipboard-copy m-2 p-0 tooltipped-no-delay d-flex flex-justify-center flex-items-center" data-copy-feedback="Copied!" data-tooltip-direction="w" value="kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml" tabindex="0" role="button">
      <svg aria-hidden="true" height="16" viewBox="0 0 16 16" version="1.1" width="16" data-view-component="true" class="octicon octicon-copy js-clipboard-copy-icon">
    <path d="M0 6.75C0 5.784.784 5 1.75 5h1.5a.75.75 0 0 1 0 1.5h-1.5a.25.25 0 0 0-.25.25v7.5c0 .138.112.25.25.25h7.5a.25.25 0 0 0 .25-.25v-1.5a.75.75 0 0 1 1.5 0v1.5A1.75 1.75 0 0 1 9.25 16h-7.5A1.75 1.75 0 0 1 0 14.25Z"></path><path d="M5 1.75C5 .784 5.784 0 6.75 0h7.5C15.216 0 16 .784 16 1.75v7.5A1.75 1.75 0 0 1 14.25 11h-7.5A1.75 1.75 0 0 1 5 9.25Zm1.75-.25a.25.25 0 0 0-.25.25v7.5c0 .138.112.25.25.25h7.5a.25.25 0 0 0 .25-.25v-7.5a.25.25 0 0 0-.25-.25Z"></path>
</svg>
      <svg aria-hidden="true" height="16" viewBox="0 0 16 16" version="1.1" width="16" data-view-component="true" class="octicon octicon-check js-clipboard-check-icon color-fg-success d-none">
    <path d="M13.78 4.22a.75.75 0 0 1 0 1.06l-7.25 7.25a.75.75 0 0 1-1.06 0L2.22 9.28a.751.751 0 0 1 .018-1.042.751.751 0 0 1 1.042-.018L6 10.94l6.72-6.72a.75.75 0 0 1 1.06 0Z"></path>
</svg>
    </clipboard-copy>
  </div></div>
<p dir="auto"><kbd><a target="_blank" rel="noopener noreferrer" href="https://user-images.githubusercontent.com/40052830/261847852-ec7b4684-7719-4d09-81d8-eee27b98972a.png"><img src="https://user-images.githubusercontent.com/40052830/261847852-ec7b4684-7719-4d09-81d8-eee27b98972a.png" alt="image" style="max-width: 100%;"></a></kbd></p>
</li>
<li>
<p dir="auto">Generate a token for worker nodes to join:</p>
<div class="highlight highlight-source-shell notranslate position-relative overflow-auto" dir="auto"><pre>sudo kubeadm token create --print-join-command</pre><div class="zeroclipboard-container">
    <clipboard-copy aria-label="Copy" class="ClipboardButton btn btn-invisible js-clipboard-copy m-2 p-0 tooltipped-no-delay d-flex flex-justify-center flex-items-center" data-copy-feedback="Copied!" data-tooltip-direction="w" value="sudo kubeadm token create --print-join-command" tabindex="0" role="button">
      <svg aria-hidden="true" height="16" viewBox="0 0 16 16" version="1.1" width="16" data-view-component="true" class="octicon octicon-copy js-clipboard-copy-icon">
    <path d="M0 6.75C0 5.784.784 5 1.75 5h1.5a.75.75 0 0 1 0 1.5h-1.5a.25.25 0 0 0-.25.25v7.5c0 .138.112.25.25.25h7.5a.25.25 0 0 0 .25-.25v-1.5a.75.75 0 0 1 1.5 0v1.5A1.75 1.75 0 0 1 9.25 16h-7.5A1.75 1.75 0 0 1 0 14.25Z"></path><path d="M5 1.75C5 .784 5.784 0 6.75 0h7.5C15.216 0 16 .784 16 1.75v7.5A1.75 1.75 0 0 1 14.25 11h-7.5A1.75 1.75 0 0 1 5 9.25Zm1.75-.25a.25.25 0 0 0-.25.25v7.5c0 .138.112.25.25.25h7.5a.25.25 0 0 0 .25-.25v-7.5a.25.25 0 0 0-.25-.25Z"></path>
</svg>
      <svg aria-hidden="true" height="16" viewBox="0 0 16 16" version="1.1" width="16" data-view-component="true" class="octicon octicon-check js-clipboard-check-icon color-fg-success d-none">
    <path d="M13.78 4.22a.75.75 0 0 1 0 1.06l-7.25 7.25a.75.75 0 0 1-1.06 0L2.22 9.28a.751.751 0 0 1 .018-1.042.751.751 0 0 1 1.042-.018L6 10.94l6.72-6.72a.75.75 0 0 1 1.06 0Z"></path>
</svg>
    </clipboard-copy>
  </div></div>
<p dir="auto"><kbd><a target="_blank" rel="noopener noreferrer" href="https://user-images.githubusercontent.com/40052830/261848054-0370839b-bbac-415c-9d5a-9ab52cd3108b.png"><img src="https://user-images.githubusercontent.com/40052830/261848054-0370839b-bbac-415c-9d5a-9ab52cd3108b.png" alt="image" style="max-width: 100%;"></a></kbd></p>
</li>
<li>
<p dir="auto">Expose port 6443 in the Security group for the Worker to connect to Master Node</p>
</li>
</ol>
<p dir="auto"><kbd><a target="_blank" rel="noopener noreferrer" href="https://user-images.githubusercontent.com/40052830/261848106-b3f5df01-acb0-419f-aa70-6d51819f4ec0.png"><img src="https://user-images.githubusercontent.com/40052830/261848106-b3f5df01-acb0-419f-aa70-6d51819f4ec0.png" alt="image" style="max-width: 100%;"></a></kbd></p>
<hr>
<h2 tabindex="-1" id="user-content-worker-node" dir="auto"><a class="heading-link" href="#worker-node">Worker Node<svg class="octicon octicon-link" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path d="m7.775 3.275 1.25-1.25a3.5 3.5 0 1 1 4.95 4.95l-2.5 2.5a3.5 3.5 0 0 1-4.95 0 .751.751 0 0 1 .018-1.042.751.751 0 0 1 1.042-.018 1.998 1.998 0 0 0 2.83 0l2.5-2.5a2.002 2.002 0 0 0-2.83-2.83l-1.25 1.25a.751.751 0 0 1-1.042-.018.751.751 0 0 1-.018-1.042Zm-4.69 9.64a1.998 1.998 0 0 0 2.83 0l1.25-1.25a.751.751 0 0 1 1.042.018.751.751 0 0 1 .018 1.042l-1.25 1.25a3.5 3.5 0 1 1-4.95-4.95l2.5-2.5a3.5 3.5 0 0 1 4.95 0 .751.751 0 0 1-.018 1.042.751.751 0 0 1-1.042.018 1.998 1.998 0 0 0-2.83 0l-2.5 2.5a1.998 1.998 0 0 0 0 2.83Z"></path></svg></a></h2>
<ol dir="auto">
<li>
<p dir="auto">Run the following commands on the worker node.</p>
<div class="highlight highlight-source-shell notranslate position-relative overflow-auto" dir="auto"><pre>sudo kubeadm reset pre-flight checks</pre><div class="zeroclipboard-container">
    <clipboard-copy aria-label="Copy" class="ClipboardButton btn btn-invisible js-clipboard-copy m-2 p-0 tooltipped-no-delay d-flex flex-justify-center flex-items-center" data-copy-feedback="Copied!" data-tooltip-direction="w" value="sudo kubeadm reset pre-flight checks" tabindex="0" role="button">
      <svg aria-hidden="true" height="16" viewBox="0 0 16 16" version="1.1" width="16" data-view-component="true" class="octicon octicon-copy js-clipboard-copy-icon">
    <path d="M0 6.75C0 5.784.784 5 1.75 5h1.5a.75.75 0 0 1 0 1.5h-1.5a.25.25 0 0 0-.25.25v7.5c0 .138.112.25.25.25h7.5a.25.25 0 0 0 .25-.25v-1.5a.75.75 0 0 1 1.5 0v1.5A1.75 1.75 0 0 1 9.25 16h-7.5A1.75 1.75 0 0 1 0 14.25Z"></path><path d="M5 1.75C5 .784 5.784 0 6.75 0h7.5C15.216 0 16 .784 16 1.75v7.5A1.75 1.75 0 0 1 14.25 11h-7.5A1.75 1.75 0 0 1 5 9.25Zm1.75-.25a.25.25 0 0 0-.25.25v7.5c0 .138.112.25.25.25h7.5a.25.25 0 0 0 .25-.25v-7.5a.25.25 0 0 0-.25-.25Z"></path>
</svg>
      <svg aria-hidden="true" height="16" viewBox="0 0 16 16" version="1.1" width="16" data-view-component="true" class="octicon octicon-check js-clipboard-check-icon color-fg-success d-none">
    <path d="M13.78 4.22a.75.75 0 0 1 0 1.06l-7.25 7.25a.75.75 0 0 1-1.06 0L2.22 9.28a.751.751 0 0 1 .018-1.042.751.751 0 0 1 1.042-.018L6 10.94l6.72-6.72a.75.75 0 0 1 1.06 0Z"></path>
</svg>
    </clipboard-copy>
  </div></div>
<p dir="auto"><kbd><a target="_blank" rel="noopener noreferrer" href="https://user-images.githubusercontent.com/40052830/261848231-3d29912b-f1a3-4e0b-a6ee-6c9cc5db49fb.png"><img src="https://user-images.githubusercontent.com/40052830/261848231-3d29912b-f1a3-4e0b-a6ee-6c9cc5db49fb.png" alt="image" style="max-width: 100%;"></a></kbd></p>
</li>
<li>
<p dir="auto">Paste the join command you got from the master node and append <code>--v=5</code> at the end.
<em>Make sure either you are working as sudo user or use <code>sudo</code> before the command</em></p>
<p dir="auto"><kbd><a target="_blank" rel="noopener noreferrer" href="https://user-images.githubusercontent.com/40052830/261848429-c41e3213-7474-43f9-9a7b-a75694be582a.png"><img src="https://user-images.githubusercontent.com/40052830/261848429-c41e3213-7474-43f9-9a7b-a75694be582a.png" alt="image" style="max-width: 100%;"></a></kbd></p>
<p dir="auto">After succesful join-&gt;
<kbd><a target="_blank" rel="noopener noreferrer" href="https://user-images.githubusercontent.com/40052830/261848460-c530b65a-4afd-4b1d-9748-421c216d64cd.png"><img src="https://user-images.githubusercontent.com/40052830/261848460-c530b65a-4afd-4b1d-9748-421c216d64cd.png" alt="image" style="max-width: 100%;"></a></kbd></p>
</li>
</ol>
<hr>
<h2 tabindex="-1" id="user-content-verify-cluster-connection" dir="auto"><a class="heading-link" href="#verify-cluster-connection">Verify Cluster Connection<svg class="octicon octicon-link" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path d="m7.775 3.275 1.25-1.25a3.5 3.5 0 1 1 4.95 4.95l-2.5 2.5a3.5 3.5 0 0 1-4.95 0 .751.751 0 0 1 .018-1.042.751.751 0 0 1 1.042-.018 1.998 1.998 0 0 0 2.83 0l2.5-2.5a2.002 2.002 0 0 0-2.83-2.83l-1.25 1.25a.751.751 0 0 1-1.042-.018.751.751 0 0 1-.018-1.042Zm-4.69 9.64a1.998 1.998 0 0 0 2.83 0l1.25-1.25a.751.751 0 0 1 1.042.018.751.751 0 0 1 .018 1.042l-1.25 1.25a3.5 3.5 0 1 1-4.95-4.95l2.5-2.5a3.5 3.5 0 0 1 4.95 0 .751.751 0 0 1-.018 1.042.751.751 0 0 1-1.042.018 1.998 1.998 0 0 0-2.83 0l-2.5 2.5a1.998 1.998 0 0 0 0 2.83Z"></path></svg></a></h2>
<p dir="auto">On Master Node:</p>
<div class="highlight highlight-source-shell notranslate position-relative overflow-auto" dir="auto"><pre>kubectl get nodes</pre><div class="zeroclipboard-container">
    <clipboard-copy aria-label="Copy" class="ClipboardButton btn btn-invisible js-clipboard-copy m-2 p-0 tooltipped-no-delay d-flex flex-justify-center flex-items-center" data-copy-feedback="Copied!" data-tooltip-direction="w" value="kubectl get nodes" tabindex="0" role="button">
      <svg aria-hidden="true" height="16" viewBox="0 0 16 16" version="1.1" width="16" data-view-component="true" class="octicon octicon-copy js-clipboard-copy-icon">
    <path d="M0 6.75C0 5.784.784 5 1.75 5h1.5a.75.75 0 0 1 0 1.5h-1.5a.25.25 0 0 0-.25.25v7.5c0 .138.112.25.25.25h7.5a.25.25 0 0 0 .25-.25v-1.5a.75.75 0 0 1 1.5 0v1.5A1.75 1.75 0 0 1 9.25 16h-7.5A1.75 1.75 0 0 1 0 14.25Z"></path><path d="M5 1.75C5 .784 5.784 0 6.75 0h7.5C15.216 0 16 .784 16 1.75v7.5A1.75 1.75 0 0 1 14.25 11h-7.5A1.75 1.75 0 0 1 5 9.25Zm1.75-.25a.25.25 0 0 0-.25.25v7.5c0 .138.112.25.25.25h7.5a.25.25 0 0 0 .25-.25v-7.5a.25.25 0 0 0-.25-.25Z"></path>
</svg>
      <svg aria-hidden="true" height="16" viewBox="0 0 16 16" version="1.1" width="16" data-view-component="true" class="octicon octicon-check js-clipboard-check-icon color-fg-success d-none">
    <path d="M13.78 4.22a.75.75 0 0 1 0 1.06l-7.25 7.25a.75.75 0 0 1-1.06 0L2.22 9.28a.751.751 0 0 1 .018-1.042.751.751 0 0 1 1.042-.018L6 10.94l6.72-6.72a.75.75 0 0 1 1.06 0Z"></path>
</svg>
    </clipboard-copy>
  </div></div>
<p dir="auto"><kbd><a target="_blank" rel="noopener noreferrer" href="https://user-images.githubusercontent.com/40052830/261848387-4ed4dcac-502a-4cc1-a63e-c9cbb0199428.png"><img src="https://user-images.githubusercontent.com/40052830/261848387-4ed4dcac-502a-4cc1-a63e-c9cbb0199428.png" alt="image" style="max-width: 100%;"></a></kbd></p>
<hr>
<h2 tabindex="-1" id="user-content-optional-labeling-nodes" dir="auto"><a class="heading-link" href="#optional-labeling-nodes">Optional: Labeling Nodes<svg class="octicon octicon-link" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path d="m7.775 3.275 1.25-1.25a3.5 3.5 0 1 1 4.95 4.95l-2.5 2.5a3.5 3.5 0 0 1-4.95 0 .751.751 0 0 1 .018-1.042.751.751 0 0 1 1.042-.018 1.998 1.998 0 0 0 2.83 0l2.5-2.5a2.002 2.002 0 0 0-2.83-2.83l-1.25 1.25a.751.751 0 0 1-1.042-.018.751.751 0 0 1-.018-1.042Zm-4.69 9.64a1.998 1.998 0 0 0 2.83 0l1.25-1.25a.751.751 0 0 1 1.042.018.751.751 0 0 1 .018 1.042l-1.25 1.25a3.5 3.5 0 1 1-4.95-4.95l2.5-2.5a3.5 3.5 0 0 1 4.95 0 .751.751 0 0 1-.018 1.042.751.751 0 0 1-1.042.018 1.998 1.998 0 0 0-2.83 0l-2.5 2.5a1.998 1.998 0 0 0 0 2.83Z"></path></svg></a></h2>
<p dir="auto">If you want to label worker nodes, you can use the following command:</p>
<div class="highlight highlight-source-shell notranslate position-relative overflow-auto" dir="auto"><pre>kubectl label node <span class="pl-k">&lt;</span>node-name<span class="pl-k">&gt;</span> node-role.kubernetes.io/worker=worker</pre><div class="zeroclipboard-container">
    <clipboard-copy aria-label="Copy" class="ClipboardButton btn btn-invisible js-clipboard-copy m-2 p-0 tooltipped-no-delay d-flex flex-justify-center flex-items-center" data-copy-feedback="Copied!" data-tooltip-direction="w" value="kubectl label node <node-name> node-role.kubernetes.io/worker=worker" tabindex="0" role="button">
      <svg aria-hidden="true" height="16" viewBox="0 0 16 16" version="1.1" width="16" data-view-component="true" class="octicon octicon-copy js-clipboard-copy-icon">
    <path d="M0 6.75C0 5.784.784 5 1.75 5h1.5a.75.75 0 0 1 0 1.5h-1.5a.25.25 0 0 0-.25.25v7.5c0 .138.112.25.25.25h7.5a.25.25 0 0 0 .25-.25v-1.5a.75.75 0 0 1 1.5 0v1.5A1.75 1.75 0 0 1 9.25 16h-7.5A1.75 1.75 0 0 1 0 14.25Z"></path><path d="M5 1.75C5 .784 5.784 0 6.75 0h7.5C15.216 0 16 .784 16 1.75v7.5A1.75 1.75 0 0 1 14.25 11h-7.5A1.75 1.75 0 0 1 5 9.25Zm1.75-.25a.25.25 0 0 0-.25.25v7.5c0 .138.112.25.25.25h7.5a.25.25 0 0 0 .25-.25v-7.5a.25.25 0 0 0-.25-.25Z"></path>
</svg>
      <svg aria-hidden="true" height="16" viewBox="0 0 16 16" version="1.1" width="16" data-view-component="true" class="octicon octicon-check js-clipboard-check-icon color-fg-success d-none">
    <path d="M13.78 4.22a.75.75 0 0 1 0 1.06l-7.25 7.25a.75.75 0 0 1-1.06 0L2.22 9.28a.751.751 0 0 1 .018-1.042.751.751 0 0 1 1.042-.018L6 10.94l6.72-6.72a.75.75 0 0 1 1.06 0Z"></path>
</svg>
    </clipboard-copy>
  </div></div>
<hr>
<h2 tabindex="-1" id="user-content-optional-test-a-demo-pod" dir="auto"><a class="heading-link" href="#optional-test-a-demo-pod">Optional: Test a demo Pod<svg class="octicon octicon-link" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path d="m7.775 3.275 1.25-1.25a3.5 3.5 0 1 1 4.95 4.95l-2.5 2.5a3.5 3.5 0 0 1-4.95 0 .751.751 0 0 1 .018-1.042.751.751 0 0 1 1.042-.018 1.998 1.998 0 0 0 2.83 0l2.5-2.5a2.002 2.002 0 0 0-2.83-2.83l-1.25 1.25a.751.751 0 0 1-1.042-.018.751.751 0 0 1-.018-1.042Zm-4.69 9.64a1.998 1.998 0 0 0 2.83 0l1.25-1.25a.751.751 0 0 1 1.042.018.751.751 0 0 1 .018 1.042l-1.25 1.25a3.5 3.5 0 1 1-4.95-4.95l2.5-2.5a3.5 3.5 0 0 1 4.95 0 .751.751 0 0 1-.018 1.042.751.751 0 0 1-1.042.018 1.998 1.998 0 0 0-2.83 0l-2.5 2.5a1.998 1.998 0 0 0 0 2.83Z"></path></svg></a></h2>
<p dir="auto">If you want to test a demo pod, you can use the following command:</p>
<div class="highlight highlight-source-shell notranslate position-relative overflow-auto" dir="auto"><pre>kubectl run hello-world-pod --image=busybox --restart=Never --command -- sh -c <span class="pl-s"><span class="pl-pds">"</span>echo 'Hello, World' &amp;&amp; sleep 3600<span class="pl-pds">"</span></span></pre><div class="zeroclipboard-container">
    <clipboard-copy aria-label="Copy" class="ClipboardButton btn btn-invisible js-clipboard-copy m-2 p-0 tooltipped-no-delay d-flex flex-justify-center flex-items-center" data-copy-feedback="Copied!" data-tooltip-direction="w" value="kubectl run hello-world-pod --image=busybox --restart=Never --command -- sh -c &quot;echo 'Hello, World' &amp;&amp; sleep 3600&quot;" tabindex="0" role="button">
      <svg aria-hidden="true" height="16" viewBox="0 0 16 16" version="1.1" width="16" data-view-component="true" class="octicon octicon-copy js-clipboard-copy-icon">
    <path d="M0 6.75C0 5.784.784 5 1.75 5h1.5a.75.75 0 0 1 0 1.5h-1.5a.25.25 0 0 0-.25.25v7.5c0 .138.112.25.25.25h7.5a.25.25 0 0 0 .25-.25v-1.5a.75.75 0 0 1 1.5 0v1.5A1.75 1.75 0 0 1 9.25 16h-7.5A1.75 1.75 0 0 1 0 14.25Z"></path><path d="M5 1.75C5 .784 5.784 0 6.75 0h7.5C15.216 0 16 .784 16 1.75v7.5A1.75 1.75 0 0 1 14.25 11h-7.5A1.75 1.75 0 0 1 5 9.25Zm1.75-.25a.25.25 0 0 0-.25.25v7.5c0 .138.112.25.25.25h7.5a.25.25 0 0 0 .25-.25v-7.5a.25.25 0 0 0-.25-.25Z"></path>
</svg>
      <svg aria-hidden="true" height="16" viewBox="0 0 16 16" version="1.1" width="16" data-view-component="true" class="octicon octicon-check js-clipboard-check-icon color-fg-success d-none">
    <path d="M13.78 4.22a.75.75 0 0 1 0 1.06l-7.25 7.25a.75.75 0 0 1-1.06 0L2.22 9.28a.751.751 0 0 1 .018-1.042.751.751 0 0 1 1.042-.018L6 10.94l6.72-6.72a.75.75 0 0 1 1.06 0Z"></path>
</svg>
    </clipboard-copy>
  </div></div>
<p dir="auto"><kbd><a target="_blank" rel="noopener noreferrer" href="https://user-images.githubusercontent.com/40052830/261848566-bace1884-bbba-4e2f-8fb2-83bbba819d08.png"><img src="https://user-images.githubusercontent.com/40052830/261848566-bace1884-bbba-4e2f-8fb2-83bbba819d08.png" alt="image" style="max-width: 100%;"></a></kbd></p>
</article>

<img width="540" alt="image" src="https://github.com/rootmeet/two-tier-flask-app/assets/145815260/a219c479-42ec-46af-9874-51e9816436d0">
<img width="469" alt="image" src="https://github.com/rootmeet/two-tier-flask-app/assets/145815260/8cfdbc95-d789-4892-975d-83693df77830">
kubectl apply -f two-tier-app-pod.yml
<img width="481" alt="image" src="https://github.com/rootmeet/two-tier-flask-app/assets/145815260/c27651dd-0070-4cfc-9b2c-64b85da6b3d6">
kubectl apply -f two-tier-app-deployment.yml
<img width="505" alt="image" src="https://github.com/rootmeet/two-tier-flask-app/assets/145815260/93aae8c2-3ef8-413f-847d-118df6030ad8">
<img width="430" alt="image" src="https://github.com/rootmeet/two-tier-flask-app/assets/145815260/91272220-3450-4b62-9878-4e66de22fcd2">
kubectl apply -f two-tier-app-svc.yml
<img width="473" alt="image" src="https://github.com/rootmeet/two-tier-flask-app/assets/145815260/05f17a86-204d-46c2-b7e2-1ce8d78d7573">
Add inpbound rule 30009
<img width="741" alt="image" src="https://github.com/rootmeet/two-tier-flask-app/assets/145815260/7fe1ae09-4da1-44ae-8a68-ba0e590b2b85">
Verify site <worker ip>:30009
<img width="305" alt="image" src="https://github.com/rootmeet/two-tier-flask-app/assets/145815260/6f552c10-878e-49f8-b169-1dc58302eeb2">
Create mysql pod
kubectl apply -f mysql-deployment.yml
<img width="471" alt="image" src="https://github.com/rootmeet/two-tier-flask-app/assets/145815260/d33a9d53-fda8-4377-91a5-666a78eadf9a">
Create mysql service
kubectl apply -f mysql-svc.yml
<img width="468" alt="image" src="https://github.com/rootmeet/two-tier-flask-app/assets/145815260/585985f6-72e3-4c85-90a7-01795b5dd170">
Create persistent volume for mysql
kubectl apply -f mysql-pv.yml
<img width="422" alt="image" src="https://github.com/rootmeet/two-tier-flask-app/assets/145815260/f993cae3-1816-4ff3-815e-be30c5a438c0">
Create persistent volume claim for mysql
kubectl apply -f mysql-pvc.yml
<img width="447" alt="image" src="https://github.com/rootmeet/two-tier-flask-app/assets/145815260/5ed0db7b-b99a-4198-b993-85acf80c50e9">
K8S Overview
<img width="480" alt="image" src="https://github.com/rootmeet/two-tier-flask-app/assets/145815260/01dc0130-2df7-4df9-a6cf-3a88f1ca7ecc">
Add internal ip address of mysql to flaskapp deployment
<img width="281" alt="image" src="https://github.com/rootmeet/two-tier-flask-app/assets/145815260/7ef21ea6-9b91-4e3e-8f02-052514b91891">
kubectl apply -f two-tier-app-deployment.yml
<img width="504" alt="image" src="https://github.com/rootmeet/two-tier-flask-app/assets/145815260/b18457d2-5834-44e1-bdfa-043f6b84667d">
<img width="312" alt="image" src="https://github.com/rootmeet/two-tier-flask-app/assets/145815260/a7c6f276-bf07-4549-a64b-8123dc7dc669">
Connect to mysql instance and create table messages
CREATE TABLE messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    message TEXT
);
<img width="437" alt="image" src="https://github.com/rootmeet/two-tier-flask-app/assets/145815260/072e7473-da5e-404e-92a4-23c11b3be5ae">
<img width="439" alt="image" src="https://github.com/rootmeet/two-tier-flask-app/assets/145815260/f3b7e111-28c0-4d84-8485-f48f4cc07018">

SetUp
First clone the code to your machine
git clone https://github.com/LondheShubham153/two-tier-flask-app.git
Move to k8s directory
cd two-tier-flask-app/k8s
Now, execute below commands one by one
kubectl apply -f twotier-deployment.yml
kubectl apply -f twotier-deployment-svc.yml
kubectl apply -f mysql-deployment.yml
kubectl apply -f mysql-deployment-svc.yml
kubectl apply -f persistent-volume.yml
kubectl apply -f persistent-volume-claim.yml














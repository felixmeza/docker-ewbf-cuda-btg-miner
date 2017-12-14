# nvidia-docker image for EWBF's CUDA Bitcoin Gold miner

This image build [EWBF's CUDA Bitcoin Gold miner] from EWBF's GitHub page.
It requires a CUDA compatible docker implementation so you should probably go
for [nvidia-docker].
It has also been tested successfully on [Mesos] 1.2.1.

## Build images

```
git clone https://github.com/EarthLab-Luxembourg/docker-ewbf-cuda-btg-miner
cd docker-ewbf-cuda-btg-miner
docker build -t ewbf-cuda-btg-miner .
```

## Publish it somewhere

```
docker tag ewbf-cuda-btg-miner docker.domain.com/mining/ewbf-cuda-btg-miner
docker push docker.domain.com/mining/ewbf-cuda-btg-miner
```

## Test it (using dockerhub published image)

```
nvidia-docker pull earthlablux/ewbf-cuda-btg-miner:latest
nvidia-docker run -it --rm earthlablux/ewbf-cuda-btg-miner /root/ewbf-btg-miner --help
```

An example command line to mine using goldenshow.io:
```
nvidia-docker run -it --rm --name ewbf-cuda-btg-miner earthlablux/ewbf-cuda-btg-miner /root/ewbf-btg-miner --server btg.goldenshow.io --user YOUR_WALLET_ADDRESS.worker --pass x --port 3857 --fee 0
```

Ouput will looks like:
```
+-------------------------------------------------+
|         EWBF's Zcash CUDA miner. 0.3.4b         |
+-------------------------------------------------+
INFO: Current pool: btg.goldenshow.io:3857
INFO: Selected pools: 1
INFO: Solver: Auto.
INFO: Devices: All.
INFO: Temperature limit: 90
INFO: Api: Listen on 0.0.0.0:4200
---------------------------------------------------
INFO: Target: 0050000000000000...
INFO: Detected new work: d31b
CUDA: Device: 0 GeForce GTX 1080, 8114 MB i:64
CUDA: Device: 0 Selected solver: 0
INFO 14:05:15: GPU0 Accepted share 40ms [A:1, R:0]
INFO 14:05:15: GPU0 Accepted share 40ms [A:2, R:0]
INFO 14:05:16: GPU0 Accepted share 41ms [A:3, R:0]
INFO 14:05:17: GPU0 Accepted share 40ms [A:4, R:0]
INFO 14:05:19: GPU0 Accepted share 40ms [A:5, R:0]
INFO 14:05:21: GPU0 Accepted share 40ms [A:6, R:0]
INFO 14:05:25: GPU0 Accepted share 39ms [A:7, R:0]
INFO 14:05:27: GPU0 Accepted share 40ms [A:8, R:0]
INFO 14:05:37: GPU0 Accepted share 40ms [A:9, R:0]
Temp: GPU0: 78C 
GPU0: 234 Sol/s 
Total speed: 234 Sol/s
```

Yes it's displaying it's a ZCash miner but it's not.

## Background job running forever

```
nvidia-docker run -dt --restart=unless-stopped -p 8484:42000 --name ewbf-cuda-btg-miner earthlablux/ewbf-cuda-btg-miner /root/ewbf-btg-miner --server btg.goldenshow.io --user YOUR_WALLET_ADDRESS.worker --pass x --port 3857 --fee 0 --api 0.0.0.0:42000
```

You can check the output using `docker logs ewbf-cuda-btg-miner -f` 
You are supposed to have an HTTP API available on host on port 8484 but it doesn't work for me.


## Use it with Mesos/Marathon

Edit `mesos_marathon.json` to replace Bitcoin Gold mining pool parameter, change application path as well as docker image address (if you dont want to use public docker image provided).
Then simply run (adapt application name here too):

```
curl -X PUT -u marathon\_username:marathon\_password --header 'Content-Type: application/json' "http://marathon.domain.com:8080/v2/apps/mining/ewbf-cuda-btg-miner?force=true" -d@./mesos\_marathon.json
```

You can check CUDA usage on the mesos slave (executor host) by running `nvidia-smi` there:

```
Wed Nov 15 15:07:41 2017       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 375.82                 Driver Version: 375.82                    |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  GeForce GTX 1080    Off  | 0000:82:00.0     Off |                  N/A |
| 52%   78C    P2   174W / 180W |    623MiB /  8114MiB |     99%      Default |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                       GPU Memory |
|  GPU       PID  Type  Process name                               Usage      |
|=============================================================================|
|    0      7860    C   /root/ewbf-btg-miner                           621MiB |
+-----------------------------------------------------------------------------+
```

[EWBF's CUDA Bitcoin Gold miner]: https://github.com/poolgold/ewbf-miner-btg-edition/releases
[nvidia-docker]: https://github.com/NVIDIA/nvidia-docker
[Mesos]: http://mesos.apache.org/documentation/latest/gpu-support/

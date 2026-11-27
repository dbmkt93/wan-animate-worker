# Wan 2.2 Animate (Kijai WanVideoWrapper) on Runpod worker-comfyui.
# Models are fetched at container start (fetch_models.sh) to keep the image small.
FROM runpod/worker-comfyui:5.10.0-base-cuda12.8.1

RUN apt-get update && apt-get install -y --no-install-recommends aria2 && rm -rf /var/lib/apt/lists/*

RUN cd /comfyui/custom_nodes && \
    git clone https://github.com/kijai/ComfyUI-WanVideoWrapper.git && git -C ComfyUI-WanVideoWrapper checkout a7439db30bed0c5b5fa437d77ae8a7bb220dfd00 && \
    git clone https://github.com/kijai/ComfyUI-WanAnimatePreprocess.git && git -C ComfyUI-WanAnimatePreprocess checkout 0e0b6a2a555625acf4d4aefb780e27d06937132f && \
    git clone https://github.com/kijai/ComfyUI-KJNodes.git && git -C ComfyUI-KJNodes checkout 3775437db9f8ab0cca54d1afc79d589a9a27feb7 && \
    git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git && git -C ComfyUI-VideoHelperSuite checkout 775ae691ecbab6a6d09a2c186f95d130cf8a10d3 && \
    for d in ComfyUI-WanVideoWrapper ComfyUI-WanAnimatePreprocess ComfyUI-KJNodes ComfyUI-VideoHelperSuite; do uv pip install --python /opt/venv/bin/python -r $d/requirements.txt; done && \
    uv pip uninstall --python /opt/venv/bin/python onnxruntime || true && \
    uv pip install --python /opt/venv/bin/python onnx onnxruntime-gpu color-matcher imageio-ffmpeg

# The stock handler only returns "images"; VHS_VideoCombine reports its mp4 under "gifs".
COPY patch_handler.py models.txt fetch_models.sh /
RUN python /patch_handler.py /handler.py && chmod +x /fetch_models.sh

CMD ["/bin/bash", "-c", "/fetch_models.sh && exec /start.sh"]

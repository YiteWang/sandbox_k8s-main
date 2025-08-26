#!/bin/bash
set -o errexit

USE_OFFICIAL_SOURCE=0
for arg in "$@"
do
    if [ "$arg" = "us" ]; then
        USE_OFFICIAL_SOURCE=1
    fi
done

rm -f ~/.condarc
conda create -n sandbox-runtime -y python=3.12

source activate sandbox-runtime

if [ $USE_OFFICIAL_SOURCE -eq 0 ]; then
    pip config set global.index-url https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple
else
    pip config set global.index-url https://pypi.org/simple
    pip config set global.trusted-host pypi.org
fi

pip install -r ./requirements.txt \
    --index-url https://pypi.org/simple \
    --trusted-host pypi.org

python - <<'PY'
import nltk
nltk.download('punkt')
nltk.download('stopwords')
PY

conda clean --all -y

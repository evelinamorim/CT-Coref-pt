#!/bin/bash

# only if intel option is on
#source /opt/intel/oneapi/compiler/latest/env/vars.sh
#source /opt/intel/oneapi/mkl/latest/env/vars.sh

export OUTPUT_DIR=/mnt/models/english/
export CACHE_DIR=/tmp/cache_models/
export DATA_DIR=/home/evelinamorim/CT-Coref-pt/Data/

export PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb:24

python run_coref.py \
        --output_dir=$OUTPUT_DIR \
        --cache_dir=$CACHE_DIR \
        --model_type=longformer \
	--tokenizer_class=longformer \
        --model_name_or_path=allenai/longformer-large-4096 \
        --tokenizer_name=allenai/longformer-large-4096 \
        --config_name=allenai/longformer-large-4096  \
        --train_file=$DATA_DIR/train.english.jsonlines \
        --predict_file=$DATA_DIR/dev.english.jsonlines \
        --do_train \
        --do_eval \
        --num_train_epochs=129 \
        --logging_steps=500 \
        --save_steps=3000 \
        --eval_steps=1000 \
        --max_seq_length=1024 \
        --train_file_cache=$DATA_DIR/train.english.4600.pkl \
        --predict_file_cache=$DATA_DIR/test.english.4600.pkl \
        --gradient_accumulation_steps=1 \
        --normalise_loss \
	--amp \
        --max_total_seq_len=1024 \
        --experiment_name="s2e_CT-model-english" \
        --warmup_steps=5600 \
        --adam_epsilon=1e-6 \
        --head_learning_rate=3e-5 \
        --learning_rate=1e-6 \
        --adam_beta2=0.98 \
        --weight_decay=0.01 \
        --dropout_prob=0.3 \
        --save_if_best \
        --top_lambda=0.4  \
        --tensorboard_dir=$OUTPUT_DIR/tb \
	    --t_sim=0.80 \
        --conll_path_for_eval=$DATA_DIR/dev.english.v4_gold_conll \
	--overwrite_output_dir

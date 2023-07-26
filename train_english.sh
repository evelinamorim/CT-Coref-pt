#!/bin/bash

# only if intel option is on
source /opt/intel/oneapi/compiler/latest/env/vars.sh
source /opt/intel/oneapi/mkl/latest/env/vars.sh

export OUTPUT_DIR=/home/evelinamorim/PycharmProjects/CT-Coref-pt/models/english/
export CACHE_DIR=/tmp/cache_models/
export DATA_DIR=/home/evelinamorim/PycharmProjects/CT-Coref-pt/Data/ontonotes-conll/

python run_coref.py \
        --output_dir=$OUTPUT_DIR \
        --cache_dir=$CACHE_DIR \
        --model_type=longformer \
        --model_name_or_path=allenai/longformer-base-4096 \
        --tokenizer_name=allenai/longformer-base-4096 \
        --tokenizer_class=longformer \
        --config_name=allenai/longformer-base-4096  \
        --train_file=$DATA_DIR/sample.jsonlines \
        --predict_file=$DATA_DIR/sample.jsonlines \
        --do_train \
        --do_eval \
        --num_train_epochs=1 \
        --logging_steps=100 \
        --save_steps=600 \
        --eval_steps=20 \
        --max_seq_length=600 \
        --train_file_cache=$DATA_DIR/sample.pkl \
        --predict_file_cache=$DATA_DIR/sample.pkl \
        --gradient_accumulation_steps=1 \
        --normalise_loss \
        --max_total_seq_len=128 \
        --experiment_name="s2e_CT-model" \
        --warmup_steps=1000 \
        --adam_epsilon=1e-6 \
        --head_learning_rate=3e-4 \
        --learning_rate=1e-5 \
        --adam_beta2=0.98 \
        --weight_decay=0.01 \
        --dropout_prob=0.3 \
        --ipex \
        --save_if_best \
        --top_lambda=0.4  \
        --tensorboard_dir=$OUTPUT_DIR/tb \
	    --t_sim=0.80 \
      --conll_path_for_eval=$DATA_DIR/sample.conll \
      --overwrite_output_dir
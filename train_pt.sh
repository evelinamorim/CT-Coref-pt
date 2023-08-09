#!/bin/bash

# only if intel option is on
source /opt/intel/oneapi/compiler/latest/env/vars.sh
source /opt/intel/oneapi/mkl/latest/env/vars.sh

export OUTPUT_DIR=/home/evelinamorim/PycharmProjects/CT-Coref-pt/models/pt/
export CACHE_DIR=/tmp/cache_models/
export DATA_DIR=/home/evelinamorim/PycharmProjects/CT-Coref-pt/Data/Corref-PT-v1.4/JSON/

python run_coref.py \
        --output_dir=$OUTPUT_DIR \
        --cache_dir=$CACHE_DIR \
        --model_type=bert \
        --model_name_or_path=neuralmind/bert-base-portuguese-cased \
        --tokenizer_name=neuralmind/bert-base-portuguese-cased \
        --config_name=neuralmind/bert-base-portuguese-cased  \
        --train_file=$DATA_DIR/Corref-PT-SemEval_noseg_train.jsonlines \
        --predict_file=$DATA_DIR/Corref-PT-SemEval_noseg_test.jsonlines \
        --do_train \
        --do_eval \
        --num_train_epochs=80 \
        --logging_steps=500 \
        --save_steps=3000 \
        --eval_steps=1000 \
        --tokenizer_class=bert \
        --max_seq_length=510 \
        --train_file_cache=$DATA_DIR/Corref-PT-SemEval_noseg_train.pkl \
        --predict_file_cache=$DATA_DIR/Corref-PT-SemEval_noseg_test.pkl \
        --gradient_accumulation_steps=1 \
        --normalise_loss \
        --max_total_seq_len=128 \
        --experiment_name="s2e_correfpt-train-model" \
        --warmup_steps=5600 \
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
        --conll_path_for_eval=$DATA_DIR/Corref-PT-SemEval_noseg_test.conll \
	    --t_sim=0.80 \
      --overwrite_output_dir

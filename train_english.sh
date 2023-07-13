#!/bin/bash

export OUTPUT_DIR=/home/evelinamorim/PycharmProjects/CT-Coref-pt/models/english/
export CACHE_DIR=/tmp/cache_models/
export DATA_DIR=/home/evelinamorim/PycharmProjects/CT-Coref-pt/Data/ontonotes-conll/

python run_coref.py \
        --output_dir=$OUTPUT_DIR \
        --cache_dir=$CACHE_DIR \
        --model_type=longformer \
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
        --max_seq_length=4096 \
        --train_file_cache=$DATA_DIR/train.english.4600.pkl \
        --predict_file_cache=$DATA_DIR/test.english.4600.pkl \
        --gradient_accumulation_steps=1 \
        --amp \
        --normalise_loss \
        --max_total_seq_len=4600 \
        --experiment_name="s2e_CT-model" \
        --warmup_steps=5600 \
        --adam_epsilon=1e-6 \
        --head_learning_rate=3e-4 \
        --learning_rate=1e-5 \
        --adam_beta2=0.98 \
        --weight_decay=0.01 \
        --dropout_prob=0.3 \
        --save_if_best \
        --top_lambda=0.4  \
        --tensorboard_dir=$OUTPUT_DIR/tb \
	    --t_sim=0.80 \
        --conll_path_for_eval=$DATA_DIR/dev.english.v4_gold_conll
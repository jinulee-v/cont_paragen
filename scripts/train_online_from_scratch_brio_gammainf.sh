base_model=$3
dataset=$4
model=${base_model}_${dataset}
seed=$1
timestamp=`date +%Y-%m-%d_%H-%M-%S`
output_dir=checkpoints/${timestamp}_${model}_BRIO_online_from_scratch_gammainf_seed${seed}

cd ..

if [ ! -d $output_dir ];then
    mkdir -p $output_dir
fi

CUDA_VISIBLE_DEVICES=$2 python train.py \
  --output_dir $output_dir \
  --overwrite_output_dir \
  --do_train \
  --do_eval \
  --num_train_epochs 5 \
  --per_device_train_batch_size 16 \
  --per_device_eval_batch_size 32 \
  --learning_rate 5e-5 \
  --evaluation_strategy steps \
  --eval_steps 500 \
  --save_strategy steps \
  --save_steps 500 \
  --logging_strategy steps \
  --logging_steps 100 \
  --metric_for_best_model bert_ibleu \
  --use_sacre False \
  --use_smoothing False \
  --load_best_model_at_end \
  --task paragen \
  --base_model $base_model \
  --train_data data/${dataset}_paragen_train.json \
  --dev_data data/${dataset}_paragen_dev.json \
  --loss_fn brio \
  --model_postfix ${model} \
  --num_beams 16 \
  --contrastive \
  --learning_mode online \
  --contrast_lambda 0.1 \
  --seed $seed | tee ${output_dir}/train.log

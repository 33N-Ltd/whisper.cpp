#!/usr/bin/env python3
import sys
from silero_vad import (load_silero_vad,read_audio,get_speech_timestamps,save_audio,collect_chunks)
model = load_silero_vad(onnx=True)
wav = read_audio(sys.argv[1], sampling_rate=16000)
speech_timestamps = get_speech_timestamps(wav, model, sampling_rate=16000)
save_audio(sys.argv[2],collect_chunks(speech_timestamps, wav), sampling_rate=16000)

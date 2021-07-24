# from numpy.core.shape_base import block
# import soundfile as sf
# import pyaudio
# import audioop
# import wave
# import numpy as np
# import matplotlib.pyplot as plt



# PATH = "/Users/alireza/Downloads/U+ _ にしな【Music Video】.wav"
# x, fs = sf.read(PATH)
# x = np.mean(x, axis=1)
# print(len(x))
# print(fs)
# print(x)
# num_channel = 1
# blk_len = 1024 * 2

# wf = wave.open(PATH, 'rb')
# CHUNK = int(wf.getframerate()/20)
# print("Converting to NumpyPad")
# x = np.pad(x, blk_len - np.remainder(len(x), blk_len))
# N = blk_len
# k = np.arange(0, 1025, 1)
# w = 2*np.pi*k/N

# # instantiate PyAudio (1)
# p = pyaudio.PyAudio()
# stream = p.open(format=p.get_format_from_width(wf.getsampwidth()),
#                 channels=wf.getnchannels(),
#                 rate=wf.getframerate(),
#                 output=True, frames_per_buffer = CHUNK)

# # read data
# data = wf.readframes(CHUNK)

# fig, ax = plt.subplots(figsize=(14,6))
# x = np.arange(0, 2 * CHUNK, 2)
# ax.set_ylim(-200, 200)
# ax.set_xlim(0, CHUNK) #make sure our x axis matched our chunk size
# line, = ax.plot(x, np.random.rand(CHUNK))

# while len(data) > 0:
#     y = np.random.random()
    
    
#     stream.write(data)
#     data = wf.readframes(CHUNK)
#     intBuffers = np.frombuffer(data, dtype='B')
#     # norm = np.linalg.norm(intBuffers)
#     # normal_array = intBuffers/norm
    
#     # print(normal_array)
#     # print(audioop.rms(normal_array, 2))
#     blockLinearRms= np.log10(np.sqrt(np.mean(intBuffers**2)))
#     blockLogRms = 20 * np.log10(blockLinearRms)
#     print(blockLinearRms)

#     # line.set_ydata(data)
#     # fig.canvas.draw()
#     # fig.canvas.flush_events()
#     # plt.pause(0.01)

# plt.show()
# # stop stream (4)
# stream.stop_stream()
# stream.close()

# # close PyAudio (5)
# p.terminate()
    
#     # print(idx)
# # # print(data)
# # for item in data:
# #     print(item)
# # rms = [np.sqrt(np.mean(block**2)) for block in
# #        sf.blocks(PATH, blocksize=1024, overlap=512)]
# # print(rms)

import numpy as np
import soundfile as sf
wav_path = "/Users/alireza/Downloads/U+ _ にしな【Music Video】.wav"
audio_blk = sf.blocks(wav_path, blocksize=1024, overlap=512)
rms = [np.sqrt(np.mean(block**2)) for block in audio_blk]
data, samplerate = sf.read(wav_path)

# my_audio = sf.SoundFile(wav_path)
# print(my_audio.name)
with sf.SoundFile(wav_path) as my_audio:
    for block in my_audio.blocks(blocksize=1024):
        print(np.sqrt(np.mean(block**2)))
    assert not my_audio.closed

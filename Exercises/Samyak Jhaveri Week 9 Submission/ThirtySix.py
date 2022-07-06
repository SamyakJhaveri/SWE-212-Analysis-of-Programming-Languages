"""
Style #36 Dense Shallow Out of Control
Exercise 36.4
Completed on: 29th May 2022
"""

from keras.models import Sequential
from keras.layers import Dense
import numpy as np
import sys, os, string, random

characters = string.printable
char_indices = dict((c, i) for i, c in enumerate(characters))
indices_char = dict((i, c) for i, c in enumerate(characters))

INPUT_VOCAB_SIZE = len(characters)
BATCH_SIZE = 200

def encode_one_hot(line):
    x = np.zeros((len(line), INPUT_VOCAB_SIZE))
    for i, c in enumerate(line):
        if c in characters:
            index = char_indices[c]
        else:
            index = char_indices[' ']
        x[i][index] = 1 
    return x

def decode_one_hot(x):
    s = []
    for onehot in x:
        one_index = np.argmax(onehot) 
        s.append(indices_char[one_index]) 
    return ''.join(s)
    
def build_model():
    # Normalize characters using a dense layer
    model = Sequential()
    dense_layer = Dense(INPUT_VOCAB_SIZE, 
                        input_shape=(INPUT_VOCAB_SIZE,),
                        activation='softmax')
    model.add(dense_layer)
    return model

def input_generator(nsamples):
    def generate_line():
        inline = []; outline = []
        leet_map = {'a':'4', 'b':'8', 'c':'<', 'd':')', 'e':'3', 'f':'f', 'g':'6', 
                'h':'#', 'i':'|', 'j':']', 'k':'k', 'l':'1', 'm':'m', 'n':'^',
                'o':'0', 'p':'9', 'q':'&', 'r':'r', 's':'5', 't':'+', 'u':'u',
                'v':'v', 'w':'w', 'x':'x', 'y':'y', 'z':'7'}
        for _ in range(nsamples):
            c = random.choice(characters) 
            expected = c.lower() if c in string.ascii_letters else ' ' 
            leet_expected = leet_map[expected] if expected in leet_map else expected
            inline.append(c); outline.append(leet_expected)
        return ''.join(inline), ''.join(outline)

    while True:
        input_data, l_expected = generate_line()
        data_in = encode_one_hot(input_data)
        data_out = encode_one_hot(l_expected)
        yield data_in, data_out

def train(model):
    model.compile(loss='categorical_crossentropy',
                  optimizer='adam',
                  metrics=['accuracy'])
    input_gen = input_generator(BATCH_SIZE)
    validation_gen = input_generator(BATCH_SIZE)
    model.fit_generator(input_gen,
                epochs = 50, workers=1,
                steps_per_epoch = 20,
                validation_data = validation_gen,
                validation_steps = 10)

model = build_model()
model.summary()
train(model)

input("Network has been trained. Press <Enter> to run program.")
# fp = '../pride-and-prejudice.txt'
count = 0
with open(sys.argv[1]) as f:
    for line in f:
        if line.isspace(): continue
        batch = encode_one_hot(line)
        preds = model.predict(batch)
        normal = decode_one_hot(preds)
        print(normal)
        count += 1
print("Count:", count)
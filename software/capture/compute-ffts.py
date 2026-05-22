#!/usr/bin/env python3

import sys
import numpy.fft as fft
import numpy as np

import json

def read_file(file):
    chunks = []

    with open(file, "r") as f: 
        lines = f.readlines()

        samples = []
        for i, line in enumerate(lines):
            t = float(line.split(" ")[0])
            y = int(line.split(" ")[1])
            samples.append((t, y))
                
            if len(samples) == 1000:
                chunks.append(samples)
                samples = []

    return chunks
            

def do_fft(file):
    notches = file.split("/")[2].split("-")[0]
    height = file.split("/")[2].split("-")[1].split(".dat")[0]
    if height == "limit": height = "14"
    
    chunks = read_file(file)
    chunk = chunks[int(len(chunks)/2)]
    y = np.array(list(map(lambda x: [x, 0], np.transpose(np.array(chunk))[1])))
    
    _fft = np.transpose(np.abs(fft.fft2(y)))[0]
    _fft = _fft[20:int(len(_fft)/2)]
    
    jobj = {
        "xl": "frequency (Hz)",
        "yl": "amplitude (arbitrary units)",
        "data": [ {
            "x": list(map(int, 2 * (np.arange(0, len(_fft)) + 20))),
            "y": list(map(float, _fft))
        } ],
        "logy": 10,
        "title": f"{notches} notches, lip height = {height}mm",
    }
    
    print(json.dumps(jobj, indent=4))
    
    

files = []

for arg in sys.argv[1:]:
    files.append(arg)

do_fft(files[0])

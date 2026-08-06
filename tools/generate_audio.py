"""Genera la banda sonora y los impactos originales de Big Nose Joe."""
from pathlib import Path
import wave
import numpy as np

RATE = 22050
OUT = Path(__file__).parents[1] / "assets" / "audio"
RNG = np.random.default_rng(7046)


def env(length, attack=.01, release=.18):
    n = max(1, int(length * RATE))
    a = min(n, max(1, int(attack * RATE)))
    r = min(n, max(1, int(release * RATE)))
    result = np.ones(n)
    result[:a] = np.linspace(0, 1, a)
    result[-r:] = np.linspace(1, 0, r)
    return result


def tone(freq, length, shape="soft"):
    t = np.arange(int(length * RATE)) / RATE
    phase = 2 * np.pi * freq * t
    if shape == "square":
        raw = np.tanh(2.2 * (np.sin(phase) + .28 * np.sin(phase * 2)))
    else:
        raw = np.sin(phase) + .22 * np.sin(phase * 2) + .08 * np.sin(phase * 3)
    return raw * env(length)


def noise(length, decay=12):
    n = int(length * RATE)
    return RNG.normal(0, 1, n) * np.exp(-np.arange(n) / RATE * decay)


def add(dst, src, start, gain=1.0, pan=0.0):
    pos = int(start * RATE)
    end = min(len(dst), pos + len(src))
    if end <= pos:
        return
    src = src[:end-pos] * gain
    dst[pos:end, 0] += src * np.sqrt((1-pan) * .5)
    dst[pos:end, 1] += src * np.sqrt((1+pan) * .5)


def save(name, audio):
    OUT.mkdir(parents=True, exist_ok=True)
    peak = max(.01, float(np.max(np.abs(audio))))
    pcm = np.int16(np.clip(audio / max(1.0, peak * 1.02), -1, 1) * 32767)
    if pcm.ndim == 1:
        pcm = np.column_stack((pcm, pcm))
    with wave.open(str(OUT / name), "wb") as handle:
        handle.setnchannels(2)
        handle.setsampwidth(2)
        handle.setframerate(RATE)
        handle.writeframes(pcm.tobytes())


def music():
    duration, beat = 32.0, .5
    mix = np.zeros((int(duration * RATE), 2))
    chords = [(146.83, 174.61, 220.00), (116.54, 146.83, 174.61),
              (130.81, 164.81, 196.00), (110.00, 138.59, 164.81)]
    for bar in range(16):
        start = bar * 2.0
        chord = chords[bar % 4]
        for i, note in enumerate(chord):
            add(mix, tone(note, 2.3), start, .075, (i-1)*.45)
        bass = chord[0] / 2
        for b in (0, 1.0, 1.5):
            add(mix, tone(bass, .42, "square"), start+b, .16, -.1)
        for b in (0, 1.0):
            kick = noise(.22, 19) + tone(48, .24)[:int(.22*RATE)]
            add(mix, kick, start+b, .22)
        for b in (.5, 1.5):
            add(mix, noise(.16, 26), start+b, .11, .15)
        for b in np.arange(0, 2, .25):
            hat = noise(.045, 55)
            add(mix, hat, start+float(b), .027, (-.65 if int(b*4)%2 else .65))
        if bar % 2:
            melody = [chord[2]*2, chord[1]*2, chord[0]*2, chord[1]*2]
            for i, note in enumerate(melody):
                add(mix, tone(note, .28), start+i*.5, .055, .3)
    # Respiración nasal ambiental que une el bucle.
    breath = RNG.normal(0, 1, len(mix))
    breath = np.convolve(breath, np.ones(90)/90, mode="same")
    breath *= .025 * (1 + np.sin(np.arange(len(mix))/RATE*np.pi/2))
    mix[:, 0] += breath
    mix[:, 1] += np.roll(breath, 180)
    fade = np.minimum(1, np.arange(len(mix))/(RATE*.08))
    mix *= fade[:, None]
    save("nasal_shift_loop.wav", mix)


def sfx():
    punch = noise(.18, 23) * .45 + tone(82, .18) * .6
    save("punch.wav", punch)
    elephant = noise(.65, 7) * .75 + tone(38, .65, "square") * .7
    save("elephant_hit.wav", elephant)
    cannon = np.concatenate((noise(.15, 22), tone(54, .5, "square")))
    save("cannon_fire.wav", cannon)
    t = np.arange(int(1.5*RATE))/RATE
    beam = np.sin(2*np.pi*(170 + 520*t*t)*t) * env(1.5, .32, .32)
    beam += noise(1.5, 2.4) * env(1.5, .04, .42) * .25
    save("kamehameha.wav", beam)
    inhale = noise(1.1, 1.5) * np.linspace(.05, 1, int(1.1*RATE))
    inhale += tone(62, 1.1) * .18
    save("joe_inhale.wav", inhale)
    splat = noise(.45, 10) * .36 + tone(115, .45) * .28
    save("mucus_splat.wav", splat)
    save("rock_crack.wav", noise(.3, 18) * .6)
    save("save_stamp.wav", tone(523.25, .12)*.22 + np.pad(tone(783.99, .16)*.22, (int(.07*RATE), 0))[:int(.12*RATE)])
    alarm = tone(82, 1.8, "square") * np.repeat([1, .22, 1, .22, 1, .15], int(1.8*RATE/6)+1)[:int(1.8*RATE)]
    save("overdose.wav", alarm)


if __name__ == "__main__":
    music()
    sfx()
